import 'package:GreatWall/knowledge/themedict.dart';
import "package:unorm_dart/unorm_dart.dart" as unorm;
import 'package:binary/binary.dart';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

List<String> supported_themes = [
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
  // Class provides abstraction for mnemonic which is created based on theme dictionary. 

  //variables 
  ThemeDict  words_dictionary = ThemeDict.EmptyDict("");
  String     base_theme = ""; 

    Mnemonic(String theme) {
    /*Checks is selected theme BIP39.
    
    [theme] (String) : Name of the theme for internal dictionary.

    Returns:
        bool - Returns a boolean is selected theme BIP39.
    */ 
      try{
        base_theme = theme;
        words_dictionary = ThemeDict(theme);
      } catch (exception){
        print(exception.toString());
      }
    }

    bool is_bip39_theme(){
    /*Checks is selected theme BIP39.

    None.

    Returns:
        bool - Returns a boolean is selected theme BIP39.
    */ 
      return base_theme == "BIP39";
    }

    List<String> find_themes() {  
    /*Return currently list of supported themes.

    None.

    Returns:
        List<String> - The list the name of the themes found in the folder.
    */  
    return supported_themes;
    }
   
    String normalize_string(String txt){
    /*Normalize any given string to the normal from NFKD of Unicode.

    [txt] (String) : Text to be normalized.

    Returns:
        String - Returns a normalized text.
    */ 
    return unorm.nfkd(txt);
    } 

    String detect_theme(List code){
    /*Find which theme of a given mnemonic.
    Raise error when multiple themes are found,
    can be caused when there is many shared words between themes

    [code] (String or List of Strings) : Text to be normalized.

    Returns:
        String - Returns theme.
    */
    var possible_themes = find_themes();
    List found_themes = [];
    ThemeDict temp;
    for (String word in code){
      for (String theme in possible_themes){
          temp = ThemeDict(theme);
          if (temp.wordlist().contains(word)){
              found_themes.add(theme);
          }
        }
      }     
    if (found_themes.length>1){
      throw Exception("Theme ambiguous between: " + found_themes.toString());
    }
    if (found_themes.length==0){
      throw Exception("Didn't found appropriate theme.");
    }
    return found_themes[0];
    } 

    String generate(int strength){
    /*Create a new mnemonic using a randomly generated entropy number
      For BIP39 as defined, the entropy must be a multiple of 32 bits,
      and its size must be between 128 and 256 bits,
      but it can generate from 32 to 256 bits for any theme
    [strength] (int) : The number os bits randomly generated as entropy. 

    Returns:
        String - Returns words that encodes the generated entropy.
    */ 
    if ( (strength % 32 != 0) && (strength > 256)){
        throw Exception("Strength should be below 256 and a multiple of 32, but it is" +strength.toString());
    }
    var rand = Random(); 
    double strength_ = strength/8; 
    return to_mnemonic(rand.nextInt(strength_.toInt()));
    }
  
    String to_mnemonic(dynamic data){
    /*Create a mnemonic in Formosa standard from an entropy value.

    [data] (List<int>) : Entropy that is desired to build mnemonic from. 

    Returns:
        String - Return the built mnemonic in Formosa standard.
    */ 
    int least_multiple = 4; 

    if  (!(data is String) && !(data is List<int>)){ 
        throw Exception("Input data is not byte or string.");
    } 

    if ((data.length) % least_multiple != 0){
        throw Exception("Number of bytes should be multiple of" +least_multiple.toString() +" but it is " + data.length.toString());
    }

    if (data is String){
          data = utf8.encode(data);
          int padding_length = ((least_multiple - (data.length % least_multiple))) % least_multiple;
          List<int> padding = [];
          for (int i=0;padding_length>i;i++)
            padding.add(32); 
          data = data + padding;
    }

    var hash_object = sha256.convert(data); 
  
    String entropy_bits = ""; 
    String binary_representation;
    for (int data_ in data){
       binary_representation = data_.toRadixString(2);
       if (binary_representation.length<8){
        while (binary_representation.length != 8){
          binary_representation = '0'+binary_representation;
        }
       }
       entropy_bits += binary_representation;
    }     

    String checksum_bits_ = "";  
    String checksum_bits  = "";
    for (int data_ in hash_object.bytes){ 
       binary_representation = data_.toRadixString(2);
       //add leading zeros
       if (binary_representation.length<8){
        while (binary_representation.length != 8){
          binary_representation = '0'+binary_representation;
        }
       } 
       checksum_bits_ +=(binary_representation);
    }
   
    double checksum_lenght_ = data.length*8/32; 
    int checksum_lenght  = checksum_lenght_.toInt(); 
    for (int i=0; checksum_lenght>i ; i++){
        checksum_bits += checksum_bits_.toBitList()[i].toString();
    }

    String data_bits = entropy_bits + checksum_bits;
 
    List sentences = words_dictionary.get_sentences_from_bits(data_bits);
    
    String mnemonic = sentences.join(" "); 
    return mnemonic; 
  }

    String format_mnemonic(dynamic mnemonic) {
    /*Format the first line with the password using the first unique letters of each word
      followed by each phrase in new line

    [data] (String or List<String>) : The mnemonic to be formated. 

    Returns:
        String - Return mnemonic string with clearer format.
    */
    //normalize mnemonic
    if (mnemonic is String)
            mnemonic = mnemonic.split(" ");
      
    int n;
    if (is_bip39_theme()) {
      n=4;
    } else n = 2;

    String password = "";
    String word;
    //Concatenate the first n letters of each word in a single string
    //If the word in BIP39 has 3 letters finish with "-"
    for (String word_ in mnemonic){
      word = word_;
      if (n>word.length)
            word+="-";
        for (int i=0; n>i ; i++){
          password+=word[i];
        }
    }   
    return password;
    } 
  
    String expand_password(String password){
    /*Try to recover the mnemonic words from the password which are the first letters of each word.

    [password] (String) : The password containing the first letters of each word from the mnemonic. 

    Returns:
        String - Return the complete mnemonic recovered from the password.
                  When the word is not found just return the input.
                  Note the whole phrase can be missed depending on the position of the missed word.
    */
    //TODO
    return "";
    }  


    List<int> to_entropy(dynamic words){
    /*Extract an entropy and checksum values from mnemonic in Formosa standard.

    [words] (List<String> or String) : This is the mnemonic that is desired to extract entropy from. 

    Returns:
        List<int> - Returns a bytearray with the entropy and checksum values extracted from a mnemonic in a Formosa standard.
    */ 
    if (words is String){
          words = words.split(" ");
    }

    int words_size = words.length;
    var words_dict = words_dictionary;
    int phrase_amount = words_dict.get_phrase_amount(words);
    int phrase_size = words_dict.words_per_phrase();
    int bits_per_checksum_bit = 33;
    if ((words_size % phrase_size) != 0){
        throw Exception("The number of words must be a multiple of " + phrase_size.toString() +", but it is " + words_size.toString());
        
    }
    //Look up all the words in the list and construct the
    //concatenation of the original entropy and the checksum.

    //Determining strength of the password 
    int number_phrases = (words_size / words_dict.words_per_phrase()).toInt();
    int concat_len_bits = number_phrases * words_dict.bits_per_phrase();
    int checksum_length_bits = (concat_len_bits / bits_per_checksum_bit).toInt().round();
    int entropy_length_bits = concat_len_bits - checksum_length_bits; 
    var phrase_indexes = words_dict.get_phrase_indexes(words);
 
    List bits_fill_sequence = [];
    for (int i=0; phrase_amount>i ; i++){
      bits_fill_sequence+= words_dictionary.bits_fill_sequence();
    }

    String concat_bits  = ""; 
    for (int i=0; phrase_indexes.length>i ; i++){ 
      concat_bits+=(phrase_indexes[i].toRadixString(2).padLeft(bits_fill_sequence[i],'0'));
    } 
    List<int> entropy_ = List.filled((entropy_length_bits/8).toInt(), 0); 
    int bit_int;
 
    for (int entropy_id=0; (entropy_length_bits/8)>entropy_id; entropy_id+=1){
        entropy_[entropy_id] = 0 ;
         for (int i=0; 8>i ; i++){

        if (concat_bits[(entropy_id*8)+i] == '1'){
          bit_int = 1;
        }
        else bit_int = 0;   
         entropy_[entropy_id]  |= (bit_int << (8 - 1 - i));  
         }    
    } 
    List<int> entropy = List.filled((entropy_length_bits/8).toInt(), 0); 
    for (int entropy_id=0; (entropy_length_bits/8)>entropy_id; entropy_id+=1){
      entropy[entropy_id] = int.parse(entropy_[entropy_id].toString());
    } 
    return entropy;
    }
   
  


}
  