import 'package:mnemonic/themes/BIP39_french.dart';
import 'package:mnemonic/themes/BIP39.dart'; 
import 'package:mnemonic/themes/copy_left.dart';
import 'package:mnemonic/themes/cute_pets.dart';
import 'package:mnemonic/themes/farm_animals.dart'; 
import 'package:mnemonic/themes/finances.dart';
import 'package:mnemonic/themes/medieval_fantasy.dart';
import 'package:mnemonic/themes/sci-fi.dart';
import 'package:mnemonic/themes/tourism.dart'; 
import 'package:quiver/iterables.dart'; 

class ThemeDict {  
    /// Helper class which helps to extract theme information from
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
    /// Constructor of [ThemeDict] class. 
    ///
    /// The [ThemeDict] constructor creates an object based on provieded [theme].
    ///
    /// - Parameters:
    ///   - [theme]: A string which describes which theme is used.
    ///
    /// - Returns: A [ThemeDict] object containing which is based on specific [theme].
 
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
    /// Constructor of ThemeDict class.
    ///
    /// The [_private] constructor creates a ThemeDict object using the provided
    /// [theme] string and the [dict] map.
    ///
    /// - Parameters:
    ///   - [theme]: A string which is used to describe wanted theme.
    ///   - [dict] : Dictionary which stores information about theme.
    ///
    /// - Returns: A [ThemeDict] object with inner dictionary equal to [dict] and theme
    ///            selected to wanted [theme].  
      defaultTheme = theme;
      innerDict = dict;
    }
  
    ThemeDict getItem(String key) {
    /// Gets item from internal directory.
    ///
    /// The [getItem] method  returns item from inner dictionary of ThemeDict class
    ///  based on [key].
    ///
    /// - Parameters:
    ///   - [key]: A string used to access dictionary.
    ///
    /// - Returns: A [ThemeDict] class made from value which corresponds to given key  
      if (innerDict[key] != null){
        return  ThemeDict._private(defaultTheme, innerDict[key]);
      }
      return ThemeDict.EmptyDict(defaultTheme);
    }

    void setItem(String item, Map<String, dynamic> value){ 
    /// The [setItem] method sets specific [item] of inner dictionary to [value].
    ///
    /// - Parameters:
    ///   - [item]: A string used as key for inner dictionary.
    ///   - [value]:Value to be set of inner dictionary. 
    ///
    /// - Returns:  [None] 
      innerDict[item] = value;
    }

    List<String> fillingOrder() {
    /// Returns list of words in which represent filing order for specific theme
    ///from inner dictionary. 
    ///
    /// The [fillingOrder] method returns list of words in which represent filing
    ///  order for specific theme from inner dictionary.  [fillSeqKey]
    /// 
    /// - Parameters:
    ///   - [None] 
    ///
    /// - Returns: A words which represent filing order for specific theme. 
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
    /// Returns list of words in natural speech from inner dictionary. 
    ///
    /// The [naturalOrder] method returns list of words which correspond to key
    ///   [naturalSeqKey] from inner dictionary.
    ///
    /// - Parameters:
    ///   - [None] 
    ///
    /// - Returns: A words in natural speech.  
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
    /// Returns list of words which led inner dictionary.
    ///
    /// The [leads] method returns list of words which correspond to key
    ///   [leadsKW] from inner dictionary.
    ///
    /// - Parameters:
    ///   - [None] 
    ///
    /// - Returns: A words which led inner dictionary. 
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
    /// Returns list of total words from inner dictionary.
    ///
    /// The [totalWords] method returns list of words which correspond to key
    ///   [totalsKW] from inner dictionary.
    /// 
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: All total words.  
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
    /// Returns list of total words from inner dictionary marked with [imageKW].
    ///
    /// The [image] method returns list of words which correspond to key
    ///   [imageKW] from inner dictionary.
    ///
    /// - Parameters:
    ///   - [None]
    /// 
    /// - Returns: All words which are marked with [imageKW]. 
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
    /// Returns ThemeDict from inner dictionary marked with [mappingKW].
    ///
    /// The [mapping] method returns list of words which correspond to key
    ///   [mappingKW] from inner dictionary.
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: A [ThemeDict] object with key equal to inner dictionary [mappingKW].
      
      if (getItem(mappingKW).innerDict.isNotEmpty){  
        return ThemeDict._private(defaultTheme, getItem(mappingKW).innerDict);
      } 
      return ThemeDict.EmptyDict(defaultTheme);
    }

    int bitLength(){
    /// Returns number of bits to map the word of current dictionary.
    ///
    /// The [bitLength] method returns bit lenght which correspond to key 
    /// [bitsKW] from inner dictionary.
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: Number of bits for mapping.
      if (innerDict[bitsKW] == null) {
        return 0;
      }
      else{
        return (innerDict[bitsKW]);
      }
    }

    String ledBy(){
    /// Returns string which leds current mapping.
    ///
    /// The [ledBy] method returns bit lenght which correspond to key 
    /// [ledKW] from inner dictionary.
    ///
    /// - Parameters:
    ///   - [None] 
    ///
    /// - Returns: Word which leds current mapping 
      var temp = innerDict[ledKW];
      return temp.toString();
    }

    ThemeDict getLedByMapping(String ledByWord){
    /// Returns inner dictionary value (mapping) for key equal [ledByWord].
    ///
    /// The [getLedByMapping] method creates a ThemeDict pattern using the provided
    /// [ledByWord] string as key.
    ///
    /// - Parameters:
    ///   - [ledByWord]: A string used as key to retrieve information from inner dictionary.
    ///
    /// - Returns: A [ThemeDict] where which is value defined by [ledByWord].  
      ThemeDict temp = getItem(ledByWord);
      String ledByTemp = temp.ledBy(); 
      return getItem(ledByTemp).getItem(ledByWord).getItem(mappingKW);
    }

    int bitsPerPhrase(){ 
    /// Returns sum of bits for each phrase in default theme.
    ///
    /// The [bitsPerPhrase] method sums bits for each phrase in default theme.
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: A  sum of bit lenghts for each phrase in filing order of theme.   
    var filingWords = fillingOrder();
    int sum = 0; 
    // Sum bit lenght for each mapping defined by filing order.
    for (String word in filingWords){
        sum += getItem(word).bitLength();
    }
    return sum; 
    }

    List<int> bitsFillSequence(){
    /// Returns 
    ///
    /// The [bitsFillSequence] method creates list of bit lenghts for each phrase in default theme.
    /// Each phrase in default theme is retrieved using [fillSeqKey] as key for inner dictionary.
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: A list of bit lenghts for each phrase in filing order of theme.  
    List<int> result = [];
    var filingWords = fillingOrder();
    for (String word in filingWords){
        result.add(getItem(word).bitLength());
    }
    return result;
    }

    int wordsPerPhrase(){
    /// Returns lenght of phrases in this theme.
    ///
    /// The [wordsPerPhrase] method returns lenght of words which can be 
    /// accessed by [fillSeqKey] in inner dictionary.
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: Lenght of phrases in default theme.
    ///            If theme is malformed, 0 is returned.
    int wordsPerPhrase_    = fillingOrder().length;
    int wordsNaturalOrder_ = naturalOrder().length;

    if (wordsPerPhrase_ != wordsNaturalOrder_){
      //Theme is malformed.
      return 0; 
    }
    return wordsPerPhrase_; 
    }

    List<String> wordList(){
    /// Returns all words used in the theme.
    /// 
    /// The [wordList] method returns list of words used in default theme.
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: A list of words used in the theme.  
    
    List<String> result = [];
    var filingWords_ = fillingOrder();
    //Iterate through all phrases in theme.
    for (String word in filingWords_){
        result.addAll(getItem(word).totalWords());
    }
    // Removes duplicate words from list.
    return result.toSet().toList();
    }

    List< (String,String)> restrictionSequence(){
    /// Returns list of restrictions used in this theme.
    ///
    /// The [restrictionSequence] method creates a Blockies pattern using the provided
    /// hash string and the instance's size and color properties.
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: A restriction words in 
    ///             this theme in form of list of records. 
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
    /// Returns index of syntactic word in inner dictionary.
    ///
    /// The [naturalIndex] method creates sentence index in the natural 
    ///  speech of a given [syntacticWord].
    ///
    /// - Parameters:
    ///   - [syntacticWord]: A word given to find the index in the sentence.
    ///
    /// - Returns: Index of the word given in the natural speech of the sentence.
    List<String> naturalWords_ = naturalOrder(); 
    return naturalWords_.indexOf(syntacticWord);
    }

    List<int> naturalMap(){
    /// Returns list of indexes of the natural order in the filling order.
    ///
    /// The [naturalMap] method returns list of indexes in filling order.
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: List of indexes of natural order in the filing order. 
    List<int> result = [];
    var fillingWords_ = fillingOrder();
    for (String word in fillingWords_){
        result.add(naturalIndex(word));
    }
    return result;
    }

    int fillIndex(String syntacticWord){
    /// Returns index of syntactic word in the filling order.
    ///
    /// The [fillIndex] method creates sentence index in the natural 
    ///  speech of a given [syntacticWord].
    ///
    /// - Parameters:
    ///   - [syntacticWord]: The word given to find the index in the filling order.
    ///
    /// - Returns: The index of the word given in the filling order. 
    List<String> fillingWords_ = fillingOrder();
    return fillingWords_.indexOf(syntacticWord);
    }

    List<int> fillingMap(){
    /// Returns list of indexes of the filling order in the natural order.
    ///
    /// The [generatePattern] method creates sentence index in the natural 
    ///  speech of a given [naturalSeqKey]. 
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns:  List of indexes of filling order in the natural order. 
    List<int> result = [];
    var naturalWords_ = naturalOrder();
    for (String word in naturalWords_){
        result.add(fillIndex(word));
    }
    return result;
    }

    List<(int,int)> restrictionIndexes(){
    /// Creates list of records of indexes to the restriction sequence of the sentence in natural speech.
    ///
    /// The [restrictionIndexes] method creates a list of records for restriction sequence in 
    /// natural speech which is defined by [leadsKW].
    ///
    /// - Parameters:
    ///   - [None]
    ///
    /// - Returns: List of records containing index and word.
    List<(int,int)> result = []; 
    List<(String, String)> restrictionSeq_ = restrictionSequence();
    for ((String,String) record in restrictionSeq_){
      result.add(  (naturalIndex(record.$1), naturalIndex(record.$2))  );
    }
    return result;
    }

    List<String> primeSyntacticLeads(){
    /// Generates list of syntactic words which does not follow any other syntactic word.
    ///
    /// The [primeSyntacticLeads] method creates a list of syntactic words which does 
    /// not follow any other syntactic word.
    ///
    /// - Parameters:
    ///   - [None] 
    /// 
    /// - Returns: List of syntactic words which do not follow any other syntactic words. 
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
    /// Generates a list of pairs of restriction from a given sentence.
    ///
    /// The [restrictionPairs] method creates a list of restriction pairs from a 
    /// give [sentence].
    ///
    /// - Parameters:
    ///   - [sentence]: The list of words from a sentence of the mnemonic.
    ///
    /// - Returns: List of pairs of restriction from a given sentence.
    List<(int,int)> indexes = restrictionIndexes();
    List<(String,String)> result = [];
    for((int,int) element in indexes){
        result.add( (sentence[element.$1],sentence[element.$2]) );
    }
    return result; 
    }

    (int, int) getRelationIndexes((dynamic, dynamic) relation) {
    /// Returns indexes from a given record of relation syntactic and mnemonic words
    /// any word given only leads and not led, find the indexes in the total_words list.
    ///
    /// The [getRelationIndexes] method finds idexes from a given [relation] of relation syntactic and mnemonic
    /// words any word given only leads and not led.
    ///
    /// - Parameters:
    ///   - [relation]: The relation given to find the index from the lists
    ///                 It can be whether a record of syntactic leads and the mnemonic leads
    ///                 or a record of records of syntactic leads and led and mnemonic leads and led
    ///                 e.g. ("VERB", word_verb) or (("VERB", "SUBJECT"), (word_verb, word_subject))
    ///
    /// - Returns: Record with the indexes found in the restriction relation.
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
    /// Return the indexes of a sentence from the lists ordered as natural speech of this theme.
    /// The sentence can be given as a list or a string and must be complete
    /// otherwise raises ArgumentError exception.
    ///
    /// The [getNaturalIndexes] method generates indexes of a sentence from the lists ordered as 
    /// natural speech of this theme.
    ///
    /// - Parameters:
    ///   - [sentence]: The words to be searched.
    ///
    /// - Returns: The list of indexes of the words in this theme lists and ordered as the mnemonic given.
    /// 
    /// - Throws: 
    ///   - [ArgumentError] if number of words in sentence is not correct.
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
    /// Return the indexes of a sentence from the lists ordered as the filling order of this theme
    /// The sentence can be given as a list or a string and must be a complete sentence
    /// otherwise raises ValueError exception.
    ///
    /// The [getFillingIndexes] method creates indexes of a sentence from the lists ordered 
    ///  as the filling order of this theme.
    ///
    /// - Parameters:
    ///   - [sentence]: The words to be searched.
    ///
    /// - Returns: The list of indexes of the words in this theme lists and ordered as the filling order.
    /// 
    /// - Throws:
    ///   - [ArgumentError] if number of words in sentence is not enough.
    if (sentence is String){
        sentence = sentence.toString().split(" ");
      }
    if (sentence.length != wordsPerPhrase()) {
      var msg =  'The number of words in sentence must be $wordsPerPhrase(), but it is ${sentence.length}';
      throw ArgumentError(msg);
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
    /// Generates how many phrases are in the given mnemonic.
    ///
    /// The [getPhraseAmount] method caculates how many phrases are in [mnemonic].
    ///
    /// - Parameters:
    ///   - [mnemonic]: The mnemonic to get the amount of phrases, it can be a one or more words.
    ///
    /// - Returns: Returns the amount of phrases of the given mnemonic. 
    
    // split string into list of words
    if (mnemonic is String){
        mnemonic = mnemonic.toString().split("");
    } 

    //remove empty elements from spliting
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
    /// Splits to list the sentences from a given mnemonic.
    ///
    /// The [getSentences] method creates list of sentences of given [mnemonic].
    ///
    /// - Parameters:
    ///   - [mnemonic]: The mnemonic to get the amount of phrases, it can be a one or more words.
    ///
    /// - Returns: Return a list of sentences with the lists of words from the mnemonic. 
    
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
    /// Get the indexes of a given mnemonic from each sentence in it.
    ///
    /// The [getPhraseIndexes] method creates indexes of [mnemonic] from each sentence in it.
    ///
    /// - Parameters:
    ///   - [mnemonic]: The mnemonic to get the amount of phrases, it can be a one or more words.
    ///
    /// - Returns: Returns list of indexes of the words in this theme lists and ordered as the filling order
 
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
    /// Generates ThemeDict class which is led by specific syntactic word.
    ///
    /// The [getLeadMapping] method creates instance of [ThemeDict] class
    /// with inner dictionary led by syntactic word.
    ///
    /// - Parameters:
    ///   - [syntacticKey]: Syntactic word to be led.
    ///
    /// - Returns: A [ThemeDict]  object with inner dictionary led by syntactic word.    
    return getItem(getItem(syntacticKey).ledBy()).getItem(syntacticKey).mapping();
    }

    int getLedByIndex(String syntacticKey){
    /// Get the natural index of the leading word.
    ///
    /// The [getLedByIndex] method gets natural index of the [syntacticKey].
    ///
    /// - Parameters:
    ///   - [syntacticKey]: The leading word to get the natural index from.
    ///
    /// - Returns: Returns natural index of the leading word. 
    return naturalIndex(getItem(syntacticKey).ledBy());
    }


    List getLeadList(String syntacticKey, List sentence){
    /// Generates a pattern based on the given hash string.
    ///
    /// The [generatePattern] method creates a Blockies pattern using the provided
    /// hash string and the instance's size and color properties.
    ///
    /// - Parameters:
    ///   - [hash]: A string used as the seed to generate the pattern.
    ///
    /// - Returns: A [Blockies](https://pub.dev/packages/blockies) object containing
    ///   the generated pattern with the specified seed, size, color, background color,
    ///   and spot color. 

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
    /// Build sentence using bits given following the dictionary filling order.
    ///
    /// The [assembleSentence] method creates a sentence from [dataBits] following the
    /// dictionary filling order.
    ///
    /// - Parameters:
    ///   - [dataBits]: The information as bits from the entropy and checksum.
    ///                 Each step from it represents an index to the list of led words.
    ///
    /// - Returns: Return resulting words ordered of sentence in natural language.
    int bitIndex = 0;
    List<String> currentSentence = List.empty(growable: true);

    var fillingOrderList = fillingOrder(); 
    
   
    for (int i = 0; fillingOrderList.length>i;i++){
      currentSentence.add(" ");
    }
    for (var syntacticKey in fillingOrderList){
        int bitLength = getItem(syntacticKey).bitLength(); 
        //Integer from substring of zeroes and ones representing index of current word within its list
        int wordIndex = int.parse(dataBits.substring(bitIndex, bitIndex + bitLength), radix: 2);
  
        bitIndex += bitLength;

        var listOfWords = getLeadList(syntacticKey, currentSentence);
        var syntacticOrder = naturalIndex(syntacticKey); 
        
        currentSentence[syntacticOrder] = listOfWords[wordIndex];
    }
    return currentSentence;
    }

    List getSentencesFromBits(String dataBits){
    /// Get the mnemonic sentences in the natural speech order from given string of bits.
    ///
    /// The [getSentencesFromBits] method creates mnemonic sentences in the natural speech 
    /// order from [dataBits].
    ///
    /// - Parameters:
    ///   - [dataBits]: The bits of the entropy and checksum to get the sentences from.
    ///
    /// - Returns: Return a list of words forming the sentences of the mnemonic.
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
 