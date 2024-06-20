import 'package:mnemonic/src/themedict_base.dart';
import "package:unorm_dart/unorm_dart.dart" as unorm;
import 'package:binary/binary.dart';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

List<String> supportedThemes = [
                                "BIP39",
                                "BIP39_french",
                                "copy_left",
                                "cute_pets",
                                "farm_animals",
                                "finances",
                                "medieval_fantasy",
                                "sci-fi",
                                "tourism"
                                ];

class Mnemonic{ 
  /// Class provides abstraction for mnemonic which is created based on theme dictionary. 

 
  ThemeDict  wordsDictionary = ThemeDict.EmptyDict("");
  String     baseTheme = ""; 

    Mnemonic(String theme) {
    ///Makes object of Mnemonic class with defined theme.
    ///
    ///[theme] (String) : Name of the theme for internal dictionary.
    ///
    /// Returns:
    ///    Mnemonic - Instance of Mnemonic class.
  
        baseTheme = theme;
        wordsDictionary = ThemeDict(theme); 
    }

    bool isBip39Theme(){
    ///Checks is selected theme BIP39.
    ///
    /// None.
    ///
    ///Returns:
    /// bool - Returns a boolean is selected theme BIP39.
      return baseTheme == "BIP39";
    }

    List<String> findThemes() {  
    ///Return currently list of supported themes.
    /// 
    /// None.
    ///
    ///Returns:
    /// List<String> - The list the name of the themes found in the folder.  
    return supportedThemes;
    }
   
    String normalizeString(String txt){
    ///Normalize any given string to the normal from NFKD of Unicode.
    ///
    ///[txt] (String) : Text to be normalized.
    ///
    ///Returns:
    ///    String - Returns a normalized text.
    
    return unorm.nfkd(txt);
    } 

    String detectTheme(List code){
    /// Find which theme of a given mnemonic.
    /// Raise error when multiple themes are found,
    /// can be caused when there is many shared words between themes

    /// [code] (String or List of Strings) : Text to be normalized.

    /// Returns:
    ///     String - Returns theme name if theme is not ambigous and there is no multiple themes.
    ///              Returns info message if: 
    ///                                       - theme is ambigous 
    ///                                       - there is multiple themes found
     
    var possibleThemes = findThemes();
    List foundThemes = [];
    ThemeDict temp;
    for (String word in code){
      for (String theme in possibleThemes){
          temp = ThemeDict(theme);
          if (temp.wordList().contains(word)){
              foundThemes.add(theme);
          }
        }
      }     
    if (foundThemes.length>1){ 
      return "Theme is ambiguous.";
    }
    if (foundThemes.isEmpty){
      return "Didn't found appropriate theme.";
    }
    return foundThemes[0];
    } 

    String generate(int strength){
    ///Create a new mnemonic using a randomly generated entropy number
    ///  For BIP39 as defined, the entropy must be a multiple of 32 bits,
    ///  and its size must be between 128 and 256 bits,
    ///  but it can generate from 32 to 256 bits for any theme
    /// 
    /// [strength] (int) : The number os bits randomly generated as entropy. 
    /// 
    ///Returns:
    ///   String - Returns words that encodes the generated entropy.
    ///             If strength is not multiple of 32 it returns info message.
  
    if ( (strength % 32 != 0) && (strength > 256)){
        return("Strength should be below 256 and a multiple of 32, but it is$strength");
    }
    var rand = Random(); 
    double strength_ = strength/8; 
    return toMnemonic(rand.nextInt(strength_.toInt()));
    }
  
    String toMnemonic(dynamic data){
    ///Create a mnemonic in Formosa standard from an entropy value.
    ///
    ///[data] (List<int>) : Entropy that is desired to build mnemonic from. 
    ///
    ///Returns:
    ///    String - Return the built mnemonic in Formosa standard. 
    ///             Info message if:
    ///                             - input data is not correct
    ///                             - if input data is not multiple of 4 
    int leastMmultiple = 4; 

    if  (data is! String && data is! List<int>){ 
        throw "Input data is not byte or string.";
    } 

    if ((data.length) % leastMmultiple != 0){
        throw "Number of bytes should be multiple of$leastMmultiple but it is ${data.length}";
    }

    if (data is String){
          data = utf8.encode(data);
          int paddingLength = ((leastMmultiple - (data.length % leastMmultiple))) % leastMmultiple;
          List<int> padding = [];
          for (int i=0;paddingLength>i;i++){
            padding.add(32); 
          }
          data = data + padding;
    }

    var hashObject = sha256.convert(data); 
  
    String entropyBits = ""; 
    String binaryRepresentation;
    for (int data_ in data){
       binaryRepresentation = data_.toRadixString(2);
       if (binaryRepresentation.length<8){
        while (binaryRepresentation.length != 8){
          binaryRepresentation = '0$binaryRepresentation';
        }
       }
       entropyBits += binaryRepresentation;
    }     

    String checksumBits_ = "";  
    String checksumBits  = "";
    for (int data_ in hashObject.bytes){ 
       binaryRepresentation = data_.toRadixString(2);
       ///add leading zeros
       if (binaryRepresentation.length<8){
        while (binaryRepresentation.length != 8){
          binaryRepresentation = '0$binaryRepresentation';
        }
       } 
       checksumBits_ +=(binaryRepresentation);
    }
   
    double checksumLenght_ = data.length*8/32; 
    int checksumLenght  = checksumLenght_.toInt(); 
    for (int i=0; checksumLenght>i ; i++){
        checksumBits += checksumBits_.toBitList()[i].toString();
    }

    String dataBits = entropyBits + checksumBits;
 
    List sentences = wordsDictionary.getSentencesFromBits(dataBits);
    
    String mnemonic = sentences.join(" "); 
    return mnemonic; 
  }

    String formatMnemonic(dynamic mnemonic) {
    ///Format the first line with the password using the first unique letters of each word
    ///followed by each phrase in new line
    ///
    ///[data] (String or List<String>) : The mnemonic to be formated. 
    ///
    ///Returns:
    ///    String - Return mnemonic string with clearer format.
   
    if (mnemonic is String) {
      mnemonic = mnemonic.split(" ");
    }
      
    int n;
    if (isBip39Theme()) {
      n=4;
    } else {
      n = 2;
    }

    String password = "";
    String word;
    ///Concatenate the first n letters of each word in a single string
    ///If the word in BIP39 has 3 letters finish with "-"
    for (String word_ in mnemonic){
      word = word_;
      if (n>word.length) {
        word+="-";
      }
        for (int i=0; n>i ; i++){
          password+=word[i];
        }
    }   
    return password;
    } 
  
    String expandPassword(String password){
    ///Try to recover the mnemonic words from the password which are the first letters of each word.
    ///
    ///[password] (String) : The password containing the first letters of each word from the mnemonic. 
    ///
    ///Returns:
    ///    String - Return the complete mnemonic recovered from the password.
    ///              When the word is not found just return the input.
    ///              Note the whole phrase can be missed depending on the position of the missed word.
     
    return "";
    }  


    List<int> toEntropy(dynamic words){
    ///Extract an entropy and checksum values from mnemonic in Formosa standard.
    ///
    ///[words] (List<String> or String) : This is the mnemonic that is desired to extract entropy from. 
    ///
    ///Returns:
    ///    List<int> - Returns a bytearray with the entropy and checksum values extracted from a mnemonic in a Formosa standard.
    ///              - Returns empty list when:
    ///                                           - number of words doesn't have specific multiple
    if (words is String){
          words = words.split(" ");
    }

    int wordsSize = words.length;
    var wordsDict = wordsDictionary;
    int phraseAmount = wordsDict.getPhraseAmount(words);
    int phraseSize = wordsDict.wordsPerPhrase();
    int bitsPerChecksumBit = 33;
    if ((wordsSize % phraseSize) != 0){
      /// The number of words doesn't have good multiple.
        return [0];
        
    }
    //Look up all the words in the list and construct the
    //concatenation of the original entropy and the checksum.

    //Determining strength of the password 
    int numberPhrases = wordsSize ~/ wordsDict.wordsPerPhrase();
    int concatLenBits = numberPhrases * wordsDict.bitsPerPhrase();
    int checksumLengthBits = concatLenBits ~/ bitsPerChecksumBit.round();
    int entropyLengthBits = concatLenBits - checksumLengthBits; 
    var phraseIndexes = wordsDict.getPhraseIndexes(words);
 
    List bitsFillSequence = [];
    for (int i=0; phraseAmount>i ; i++){
      bitsFillSequence+= wordsDictionary.bitsFillSequence();
    }

    String concatBits  = ""; 
    for (int i=0; phraseIndexes.length>i ; i++){ 
      concatBits+=(phraseIndexes[i].toRadixString(2).padLeft(bitsFillSequence[i],'0'));
    } 
    List<int> entropy_ = List.filled(entropyLengthBits~/8, 0); 
    int bitInt;
 
    for (int entropyId=0; (entropyLengthBits/8)>entropyId; entropyId+=1){
        entropy_[entropyId] = 0 ;
         for (int i=0; 8>i ; i++){

        if (concatBits[(entropyId*8)+i] == '1'){
          bitInt = 1;
        }
        else {
          bitInt = 0;
        }   
         entropy_[entropyId]  |= (bitInt << (8 - 1 - i));  
         }    
    } 
    List<int> entropy = List.filled(entropyLengthBits~/8, 0); 
    for (int entropyId=0; (entropyLengthBits/8)>entropyId; entropyId+=1){
      entropy[entropyId] = int.parse(entropy_[entropyId].toString());
    } 
    return entropy;
    }
   
  


}
  