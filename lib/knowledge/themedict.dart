import 'package:GreatWall/themes/BIP39_french.dart';
import 'package:GreatWall/themes/BIP39.dart'; 
import 'package:GreatWall/themes/copy_left.dart';
import 'package:GreatWall/themes/cute_pets.dart';
import 'package:GreatWall/themes/farm_animals.dart'; 
import 'package:GreatWall/themes/finances.dart';
import 'package:GreatWall/themes/medieval_fantasy.dart';
import 'package:GreatWall/themes/sci-fi.dart';
import 'package:GreatWall/themes/tourism.dart'; 
import 'package:quiver/iterables.dart'; 


 
class ThemeDict {  
    /// Helper class which has lots of helper functions to extract theme information from
    /// stored json files.
  
    String fillSeqKey           = "FILLING_ORDER";
    String naturalSeqKey        = "NATURAL_ORDER";
    String leadsKW              = "LEADS";
    String ledKW                = "LED_BY";
    String totalsKW             = "TOTAL_LIST";
    String imageKW              = "IMAGE";
    String mappingKW            = "MAPPING";
    String bitsKW               = "BIT_LENGTH";
    String none                 = "NONE"; 


    String  defaultTheme ="";
 
    Map<String, dynamic>  innerDict = Map<String, dynamic>();

    ThemeDict.EmptyDict(String theme){
      defaultTheme = theme;
    }

    ThemeDict(String theme) {
    ///Creates instance of ThemeDict.
    ///Note: Inner dictionary is not loaded with theme data.
    ///
    ///[theme] (String)             : Specific theme which is used. 
    /// 
    ///Returns:
    ///  ThemeDict - Instance of ThemeDict class with defined default theme.   
        defaultTheme=theme; 
        switch(defaultTheme){ 
            case "BIP39": {
            innerDict = BIP39;
            }
            case  "BIP39_french": {
              innerDict = BIP39_french;
            }
            case "copy_left": {
              innerDict = copy_left;
            }
            case "cute_pets": { 
              innerDict = cute_pets;
            }
            case "farm_animals": {
              innerDict = farm_animals;
            }
            case "finances":{ 
              innerDict = finances;
            }
            case "medieval_fantasy": {
              innerDict = medieval_fantasy;
            }
            case "sci-fi":{
              innerDict = sci_fi;
            }
            case "tourism":{
              innerDict = tourism;
            } 
        } 
    }  

    ThemeDict._private(String theme, Map<String, dynamic> dict){
    ///Creates instance of ThemeDict. This private constructor is used when we
    ///want to create ThemeDict class with subset of inner dictionary.
    ///
    ///[theme] (String)             : Specific theme which is used.
    ///[dict]  (Map<String,dynamic) : Subset of inner dictionary.
    ///
    ///Returns:
    ///  ThemeDict - Instance of ThemeDict class with subset of received dictionary.
 
      defaultTheme = theme;
      innerDict = dict;
    }
  
    ThemeDict getItem(String key) {
    ///Gets item from internal directory.
    ///
    ///[Key] (String) : Key value for internal dictionary.
    ///
    ///Returns:
    ///  ThemeDict - Instance of ThemeDict class made from value which corresponds to given key.
  
      if (innerDict[key] != null){
        return  ThemeDict._private(defaultTheme, innerDict[key]);
      }
      return ThemeDict.EmptyDict(defaultTheme);
    }

    void setItem(String item, Map<String, dynamic> value){
    ///Sets current value of inner dictionary to specific value.
    ///
    ///[item] (String)               : Specific key for inner dictionary.
    ///[value]  (Map<String,dynamic) : Subset of inner dictionary.
    ///
    ///Returns:
    ///  None. 
      innerDict[item] = value;
    }

    List<String> fillingOrder() {
    ///Returns list of words in which represent filing order for specific theme
    ///from inner dictionary.  ([fillSeqKey])
    ///
    ///None.
    ///
    ///Returns:
    /// List<String> - List of words in which represent filing order for specific theme.
   
      List<String> temp = [];
      innerDict.forEach((key, value) {
        if (key == fillSeqKey){ 
            temp.addAll(List<String>.from(innerDict[key]));
        }
        else 
          {
            if (value is Map){
                if (value[fillSeqKey]!=null){
                    temp.addAll(List<String>.from(value[fillSeqKey]));
                }
            }
          }
        }
      );
      return temp;
    }

    List<String> naturalOrder(){
    ///Returns list of words in natural speech from inner dictionary. 
    ///
    ///None.
    ///
    ///Returns:
    ///List<String> - List of words in natural speech. 
        List<String> temp = [];
        innerDict.forEach((key, value) {
          if (key == naturalSeqKey){
              temp.addAll(List<String>.from(innerDict[key]));
          }
          else 
            {
              if (value is Map && value[naturalSeqKey]!=null){
                      temp.addAll(List<String>.from(value[naturalSeqKey]));
              } 
            }
          }
        );
        return temp;
    }

    List<String> leads(){
    ///Returns list of words which led inner dictionary.
    ///
    ///None.
    ///
    ///Returns:
    ///List<String> - List of words which led inner dictionary.
      
      List<String> temp = [];
      innerDict.forEach((key, value) {
          if (key == leadsKW){
              temp.addAll(List<String>.from(innerDict[key]));
          }
          else 
            {
              if (value is Map && value[leadsKW]!=null){ 
                      temp.addAll(List<String>.from(value[leadsKW]));
              }
            }
          }
        );
        return temp;
    }
    
    List<String> totalWords(){
    ///Returns list of total words from inner dictionary.
    ///
    ///None.
    ///
    ///Returns:
    ///List<String> - List of total words.  
    
      List<String> temp = [];
      innerDict.forEach((key, value) {
          if (key == totalsKW){
              temp.addAll(List<String>.from(innerDict[key]));
          }
          else 
            {
              if (value is Map  && value[totalsKW]!=null){  
                      temp.addAll(List<String>.from(value[totalsKW]));
              }
            }
          }
        );
        if (temp.isEmpty){
          temp.add(" ");
        } 
        return temp;
    }

    List<String> image(){
    ///Returns list of total words from inner dictionary marked with [imageKW].
    ///
    ///None.
    ///
    ///Returns:
    /// List<String> - List of total words which are marked with [imageKW]. 
     
      List<String> temp = [];
      innerDict.forEach((key, value) {
          if (key == imageKW){
              temp.addAll(List<String>.from(innerDict[key]));
          }
          else 
            {
              if (value is Map && value[imageKW]!=null){ 
                      temp.addAll(List<String>.from(value[imageKW]));
              }
            }
          }
        );
        return temp;
    }
  
    ThemeDict mapping(){
    ///Returns ThemeDict from inner dictionary marked with [mappingKW].
    ///
    ///None.
    ///
    ///Returns:
    ///ThemeDict - Instance of ThemeDict class with key equal to inner dictionary [mappingKW].
      
      if (getItem(mappingKW).innerDict.isNotEmpty){  
        return ThemeDict._private(defaultTheme, getItem(mappingKW).innerDict);
      } 
      return ThemeDict.EmptyDict(defaultTheme);
    }

    int bitLength(){
    ///Returns number of bits to map the word of current dictionary.
    ///
    ///None.
    ///
    ///Returns:
    ///int - Number of bits for mapping.   
      if (innerDict[bitsKW] == null) {
        return 0;
      }
      else{
        return (innerDict[bitsKW]);
      }
    }

    String ledBy(){
    ///Returns string which leds current mapping.
    ///
    ///None.
    ///
    ///Returns:
    /// String - String which leds current mapping.   
      var temp = innerDict[ledKW];
      return temp.toString();
    }

    ThemeDict getLedByMapping(String ledByWord){
    ///Returns inner dict value (mapping) for key equal to leading word.
    ///
    ///[ledByWord] (String) : Leading word for specific theme.
    ///
    ///Returns:
    ///  ThemeDict - Instance of ThemeDict class which is value defined by leading word. 
  
      ThemeDict temp = getItem(ledByWord);
      String ledByTemp = temp.ledBy(); 
      return getItem(ledByTemp).getItem(ledByWord).getItem(mappingKW);
    }

    int bitsPerPhrase(){ 
    ///Returns sum of bits for each phrase in default theme.
    ///
    ///None.
    ///
    ///Returns:
    /// int - Sum of bit lenghts for each phrase in filing order of theme.  
    var filingWords = fillingOrder();
    int sum = 0; 
    /// Sum bit lenght for each mapping defined by filing order.
    for (String word in filingWords){
        sum += getItem(word).bitLength();
    }
    return sum; 
    }

    List<int> bitsFillSequence(){
    ///Returns list of bit lenghts for each phrase in default theme.
    ///
    ///None.
    ///
    ///Returns:
    /// List<int> - List of bit lenghts for each phrase in filing order of theme. 
    
    List<int> result = [];
    var filingWords = fillingOrder();
    for (String word in filingWords){
        result.add(getItem(word).bitLength());
    }
    return result;
    }

    int wordsPerPhrase(){
    ///Returns lenght of phrases in this theme.
    ///
    ///None.
    ///
    ///Returns:
    /// int - Lenght of phrases in default theme. 
    ///       0 - if theme is malformed
    
    int wordsPerPhrase_    = fillingOrder().length;
    int wordsNaturalOrder_ = naturalOrder().length;

    if (wordsPerPhrase_ != wordsNaturalOrder_){
      ///Theme is malformed.
      return 0; 
    }
    return wordsPerPhrase_; 
    }

    List<String> wordList(){
    ///Returns all words used in the theme.
    ///
    ///None.
    ///
    ///Returns:
    ///  String<List> - All words used in the theme. 
    
    List<String> result = [];
    var filingWords_ = fillingOrder();
    ///Iterate through all phrases in theme.
    for (String word in filingWords_){
        result.addAll(getItem(word).totalWords());
    }
    /// Removes duplicate words from list.
    return result.toSet().toList();
    }

    List< (String,String)> restrictionSequence(){
    ///Returns list of restrictions used in this theme.
    ///
    ///None.
    ///
    ///Returns:
    /// List<(String,String)> - List of restriction words in this theme in form of list of records. 
     
    List<(String, String)> result = [];
    var filingWords_ = fillingOrder();
    for (String word in filingWords_){
        var leadsBy_ = getItem(word).leads();
        for (String restrictionWord in leadsBy_){
          result.add((word, restrictionWord));
        } 
    }
    return result; 
    }

    int naturalIndex(String syntacticWord){
    ///Returns sentence index in the natural speech of a given syntactic word.
    ///
    ///[syntacticWord] (String) : Word given to find the index in the sentence.
    ///
    ///Returns:
    ///  int - The index of the word given in the natural speech of the sentence.
    
    List<String> naturalWords_ = naturalOrder(); 
    return naturalWords_.indexOf(syntacticWord);
    }

    List<int> naturalMap(){
    ///Returns list of indexes of the natural order in the filling order.
    ///
    ///None.
    ///
    ///Returns:
    /// List<int>  - List of indexes of natural order in the filing order.
    
    List<int> result = [];
    var fillingWords_ = fillingOrder();
    for (String word in fillingWords_){
        result.add(naturalIndex(word));
    }
    return result;
    }

    int fillIndex(String syntacticWord){
    ///Returns index of syntactic word in the filling order.
    ///
    ///[syntacticWord] (String) : The word given to find the index in the filling order.
    ///
    ///Returns:
    /// int  - The index of the word given in the filling order.
     
    List<String> fillingWords_ = fillingOrder();
    return fillingWords_.indexOf(syntacticWord);
    }

    List<int> fillingMap(){
    ///Returns list of indexes of the filling order in the natural order.
    ///
    ///None.
    ///
    ///Returns:
    /// List<int>  - List of indexes of filling order in the natural order.
     
    List<int> result = [];
    var naturalWords_ = naturalOrder();
    for (String word in naturalWords_){
        result.add(fillIndex(word));
    }
    return result;
    }

    List<(int,int)> restrictionIndexes(){
    ///Returns list of records of indexes to the restriction sequence of the sentence in natural speech.
    ///
    ///None.
    ///
    ///Returns:
    /// List<(int,int)>  - List of records containing index and word.
 
    List<(int,int)> result = []; 
    List<(String, String)> restrictionSeq_ = restrictionSequence();
    for ((String,String) record in restrictionSeq_){
      result.add(  (naturalIndex(record.$1), naturalIndex(record.$2))  );
    }
    return result;
    }

    List<String> primeSyntacticLeads(){
    ///Returns list of syntactic words which does not follow any other syntactic word.
    ///
    ///None.
    ///
    ///Returns:
    /// List<String>  - List of syntactic words which do not follow any other syntactic words.
    
    List<String> result = [];
    List<String> fillingWords_ = fillingOrder();
    for (String word in fillingWords_){
      if (getItem(word).ledBy() == none){
        result.add(word);
      }
    }
    return result;
    }
    
    List<(String,String)> restrictionPairs(List<String> sentence){
    ///Returns list of pairs of restriction from a given sentence.
    ///
    ///[sentence] (List<String) : The list of words from a sentence of the mnemonic.
    ///
    ///Returns:
    ///  List<(String,String)>  - List of pairs of restriction from a given sentence.
 
    List<(int,int)> indexes = restrictionIndexes();
    List<(String,String)> result = [];
    for((int,int) element in indexes){
        result.add( (sentence[element.$1],sentence[element.$2]) );
    }
    return result; 
    }

    (int, int) getRelationIndexes((dynamic, dynamic) relation) {
    ///Returns indexes from a given record of relation syntactic and mnemonic words
    ///f any word given only leads and not led, find the indexes in the total_words list.
    ///
    ///[relation] (Record) : The relation given to find the index from the lists
    ///                      It can be whether a record of syntactic leads and the mnemonic leads
    ///                       or a record of records of syntactic leads and led and mnemonic leads and led
    ///                      e.g. ("VERB", word_verb) or (("VERB", "SUBJECT"), (word_verb, word_subject))
    /// 
    ///Returns:
    ///   (int,int)  - Record with the indexes found in the restriction relation.
  
    var syntacticRelation = relation.$1;
    var mnemonicRelation  = relation.$2;

    //If argument is type of record(String, String)
    if (syntacticRelation is String && mnemonicRelation is String) {
      var syntLeads = syntacticRelation;
      var mnemoLeads = mnemonicRelation;
      var wordsList = getItem(syntLeads).totalWords(); 
      var mnemoIndex = naturalIndex(syntacticRelation);
      var wordIndex = wordsList.indexOf(mnemoLeads);
      return (mnemoIndex, wordIndex);
    }
    //If argument is record(record,record) 
    else {
      String syntLeads   = syntacticRelation.$1;
      String syntLed     = syntacticRelation.$2;
      String mnemoLeads  = mnemonicRelation.$1;
      String mnemoLed    = mnemonicRelation.$2;
      int mnemoIndex = naturalIndex(syntLed);
      var restrictionDict = getItem(syntLeads).getItem(syntLed).mapping();
      List<String> wordsList = List<String>.from(restrictionDict.innerDict[mnemoLeads]);
      var wordIndex = wordsList.indexOf(mnemoLed);
      return (mnemoIndex, wordIndex); 
    }
  }
 
    List<int> getNaturalIndexes(dynamic sentence) {
    ///Return the indexes of a sentence from the lists ordered as natural speech of this theme
    ///The sentence can be given as a list or a string and must be complete
    ///otherwise raises ArgumentError exception.
    ///
    ///[sentence] (Record or String) :  The words to be searched, must have complete sentences
    ///
    ///Returns:
    ///   List<int>  - The list of indexes of the words in this theme lists and ordered as the mnemonic given.
   
      if (sentence is String){
        sentence = sentence.toString().split(" ");
      }
      if (sentence.length != wordsPerPhrase()) {
        var errorMessage = 'The number of words in sentence must be $wordsPerPhrase(), but it is ${sentence.length}';
        throw ArgumentError(errorMessage);
      }

      List<int> wordIndexes = List.filled(sentence.length, 0);
      var restrictionsequence = restrictionSequence();
      var primeSyntacticLeads_ = primeSyntacticLeads();
      var wordRestrictionPairs = restrictionPairs(sentence);
       
 

      List<(dynamic , dynamic)> restrictionRelation = zip([restrictionsequence, wordRestrictionPairs])
      .map((record) =>  (
            record[0],
            record[1], 
          ))
      .toList(); 


      for (var eachSyntacticLeads in primeSyntacticLeads_) { 
        var eachRelation =  (eachSyntacticLeads, sentence[naturalIndex(eachSyntacticLeads)]);  
        var mnemoIndex = getRelationIndexes(eachRelation).$1;
        var wordIndex = getRelationIndexes(eachRelation).$2; 
        wordIndexes[mnemoIndex] = wordIndex;
      }
     
      for (var eachRelation in restrictionRelation) { 
        var mnemoIndex = getRelationIndexes(eachRelation).$1; 
        var wordIndex = getRelationIndexes(eachRelation).$2; 
        wordIndexes[mnemoIndex] = wordIndex;
      }  
      return wordIndexes;
    }

    List<int> getFillingIndexes(dynamic sentence){
    ///Return the indexes of a sentence from the lists ordered as the filling order of this theme
    ///The sentence can be given as a list or a string and must be a complete sentence
    ///otherwise raises ValueError exception
    ///
    ///[sentence] (Record or String) :  The words to be searched, must have complete sentences
    ///
    ///Returns:
    ///  List<int>  - The list of indexes of the words in this theme lists and ordered as the filling order.
    
    if (sentence is String){
        sentence = sentence.toString().split(" ");
      }
    if (sentence.length != wordsPerPhrase()) {
      ///The number of words in sentence must be $wordsPerPhrase(), but it is ${sentence.length}'
      return [];
    }

    List<int> result = [];

    var wordNaturalIndexes_ = getNaturalIndexes(sentence);
    var nMap = naturalMap();
    for (int index in nMap){
      result.add(wordNaturalIndexes_[index]);
    } 
    return result;
    }

    int getPhraseAmount(dynamic mnemonic){
    ///Returns how many phrases are in the given mnemonic.
    ///
    ///[sentence] (List<String> or String) :  The mnemonic to get the amount of phrases, it can be a string or a list of words.
    ///
    ///Returns:
    ///  int - Returns the amount of phrases of the given mnemonic.
    
    /// split string into list of words
    if (mnemonic is String){
        mnemonic = mnemonic.toString().split("");
    } 

    ///remove empty elements from spliting
    for (int i = mnemonic.length - 1; i >= 0; i--) { 
      if (mnemonic[i] == '') { 
        mnemonic.removeAt(i);
      }
    }
    
     
    var mnemonicSize_ = mnemonic.length;
    var phraseSize_  = wordsPerPhrase(); 
   
    var phraseAmount_ = (mnemonicSize_ / phraseSize_);
    
    return phraseAmount_.round();
    }

    List<List<String>> getSentences(dynamic mnemonic){
    ///Splits to list the sentences from a given mnemonic
    ///
    ///[sentence] (List<String> or String) :  The mnemonic to get the amount of phrases, it can be a string or a list of words.
    ///
    ///Returns:
    /// List<List<String>> - Return a list of sentences with the lists of words from the mnemonic.
    

    //normalize mnemonic
    if (mnemonic is String){
      mnemonic = mnemonic.toString().split(" ");
    }
    for (int i = mnemonic.length - 1; i >= 0; i--) { 
      if (mnemonic[i] == '') { 
        mnemonic.removeAt(i);
      }
    } 
    //prepare variables for generating list of sentences
    var phraseSize_   = wordsPerPhrase();
    var phraseAmount_ = getPhraseAmount(mnemonic); 
    //generate sentence for specific mnemonic
    List<List<String>> sentences = List.generate(phraseAmount_, (int eachPhrase) {
          int start = phraseSize_ * eachPhrase;
          int end = phraseSize_ * (eachPhrase + 1);
          return mnemonic.sublist(start, end);
    }); 
    return sentences;
    }

    List<int> getPhraseIndexes(dynamic mnemonic){
    ///Get the indexes of a given mnemonic from each sentence in it
    ///The mnemonic can be given as a list or a string and must have complete sentences
    ///otherwise raises ArgumentError exception.
    ///
    ///[mnemonic] (List<String> or String) :  The words to be searched, must have complete sentences.
    ///
    ///Returns:
    ///   List<int> - Returns list of indexes of the words in this theme lists and ordered as the filling order
 
    ///normalize mnemonic
    if (mnemonic is String){
      mnemonic = mnemonic.toString().split(" ");
    }
    for (int i = mnemonic.length - 1; i >= 0; i--) { 
      if (mnemonic[i] == '') { 
        mnemonic.removeAt(i);
      }
    } 

    var sentences = getSentences(mnemonic);
    List<int> indexes = [];

    for (dynamic eachPhrase in sentences){
      for (int eachFillIndex in getFillingIndexes(eachPhrase)){
        indexes.add(eachFillIndex);
      }
    } 
    return indexes;
    }

    ThemeDict getLeadMapping(String syntacticKey){
    ///Returns ThemeDict class which is led by specific syntactic word.
    ///
    ///[syntacticKey] (String) :  Syntactic word to be led.
    ///
    ///Returns:
    ///  ThemeDict - Returns instance of ThemeDict class with inner dictionary led by syntactic word.
    
    return getItem(getItem(syntacticKey).ledBy()).getItem(syntacticKey).mapping();
    }

    int getLedByIndex(String syntacticKey){
    ///Get the natural index of the leading word.
    ///
    ///[syntacticKey] (String) :  The leading word to get the natural index from.
    ///
    ///Returns:
    ///    int - Returns natural index of the leading word.
       
    return naturalIndex(getItem(syntacticKey).ledBy());
    }


    List getLeadList(String syntacticKey, List sentence){
    ///Get the list of words led by the given syntactic word.
    ///
    ///[syntacticKey] (String)       : The leading word to get the natural index from.
    ///[sentence]      (List<String>) : The sentence to solve the leading when the desired list depends on the leading words.
    ///
    ///Returns:
    ///    List<String> - Return the list led by a syntactic word.
    
    var leadList = [];
    var primeSyntacticList_ = primeSyntacticLeads();  
    if (primeSyntacticList_.contains(syntacticKey)){  
        leadList = getItem(syntacticKey).totalWords();
    }
    else{  
        var mapping = getLeadMapping(syntacticKey);  
        var leadingWord_ = sentence[getLedByIndex(syntacticKey)];  
        leadList = mapping.innerDict[leadingWord_];
    }
    return leadList; 
    }

    List<String> assembleSentence(String dataBits){
    ///Build sentence using bits given following the dictionary filling order.
    ///
    ///[dataBits] (String) :  The information as bits from the entropy and checksum.
    ///                         Each step from it represents an index to the list of led words.
    /// 
    ///Returns:
    ///    List<String> - Return resulting words ordered of sentence in natural language.
  
    int bitIndex = 0;
    List<String> currentSentence = List.empty(growable: true);

    var fillingOrderList = fillingOrder(); 
    
   
    for (int i = 0; fillingOrderList.length>i;i++){
      currentSentence.add(" ");
    }
    for (var syntacticKey in fillingOrderList){
        int bitLength = getItem(syntacticKey).bitLength(); 
        ///Integer from substring of zeroes and ones representing index of current word within its list
        int wordIndex = int.parse(dataBits.substring(bitIndex, bitIndex + bitLength), radix: 2);
  
        bitIndex += bitLength;

        var listOfWords = getLeadList(syntacticKey, currentSentence);
        var syntacticOrder = naturalIndex(syntacticKey); 
        
        currentSentence[syntacticOrder] = listOfWords[wordIndex];
    }
    return currentSentence;
    }

    List getSentencesFromBits(String dataBits){
    ///Get the mnemonic sentences in the natural speech order from given string of bits.
    ///
    ///[dataBits] (String) :  The bits of the entropy and checksum to get the sentences from
    ///
    ///Returns:
    ///List<String> - Return a list of words forming the sentences of the mnemonic.
      
    String data;
    int bitsPerPhrase_ = bitsPerPhrase();
    num phrasesAmount = dataBits.length / bitsPerPhrase_;

    List sentences = [];
    for (int phraseIndex=0; phrasesAmount>phraseIndex; phraseIndex++){
        int sentenceIndex = bitsPerPhrase_ * phraseIndex;
        data = dataBits.substring(sentenceIndex, sentenceIndex + bitsPerPhrase_);
        sentences.addAll(assembleSentence(data));
    }
    return sentences;
    }
 
}
 