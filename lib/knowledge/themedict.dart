import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';
import 'package:quiver/iterables.dart';


//Global variables
String FILL_SEQUENCE_KEY    = "FILLING_ORDER";
String NATURAL_SEQUENCE_KEY = "NATURAL_ORDER";
String LEADS_KW             = "LEADS";
String LED_KW               = "LED_BY";
String TOTALS_KW            = "TOTAL_LIST";
String IMAGE_KW             = "IMAGE";
String MAPPING_KW           = "MAPPING";
String BITS_KW              = "BIT_LENGTH";
String NONE                 = "NONE";
//End of global variables


class ThemeDict {  
    // Helper class which has lots of helper functions to extract theme information from
    // stored json files.

    //name of used theme
    String  default_theme ="";

    //variable used to store all information from theme json
    Map<String, dynamic>  inner_dict = Map<String, dynamic>();

    ThemeDict.EmptyDict(String theme){
      default_theme = theme;
    }

    ThemeDict(String theme) {
    /*Creates instance of ThemeDict.
    Note: Inner dictionary is not loaded with theme data.
  
    [theme] (String)             : Specific theme which is used. 

    Returns:
      ThemeDict - Instance of ThemeDict class with defined default theme.
    */  
    try{ 
        default_theme=theme; 
      } catch (exception){
        print(exception.toString());
      }
    }  

    ThemeDict._private(String theme, Map<String, dynamic> dict){
    /*Creates instance of ThemeDict. This private constructor is used when we
    want to create ThemeDict class with subset of inner dictionary.
  
    [theme] (String)             : Specific theme which is used.
    [dict]  (Map<String,dynamic) : Subset of inner dictionary.

    Returns:
      ThemeDict - Instance of ThemeDict class with subset of received dictionary..
    */  
      this.default_theme = theme;
      this.inner_dict = dict;
    }

    Future<void> storeJsonValues() async {
    /*Stores theme json for later use.
    
    None.

    Returns:
      Future<void> - Future since loadString function returns Future.
    */  
    ///This function should be called after initializing constructor. 
    ///We can't progress with other stuff if we didn't load wanted theme 
    await rootBundle.loadString('themes/' + default_theme +'.json').then((value) {
      inner_dict   = jsonDecode(value);
    });  
    }

    ThemeDict getItem(String key) {
    /*Gets item from internal directory.
      
    [Key] (String) : Key value for internal dictionary.

    Returns:
      ThemeDict - Instance of ThemeDict class made from value which corresponds to given key.
    */ 
      if (inner_dict[key] != null){
        return  ThemeDict._private(default_theme, inner_dict[key]);
      }
      return ThemeDict.EmptyDict(default_theme);
    }

    void setItem(String item, Map<String, dynamic> value){
    /*Sets current value of inner dictionary to specific value.
  
    [item] (String)               : Specific key for inner dictionary.
    [value]  (Map<String,dynamic) : Subset of inner dictionary.

    Returns:
      None.
    */
      inner_dict[item] = value;
    }

    List<String> filling_order() {
    /*Returns list of words in which represent filing order for specific theme
    from inner dictionary.  ([FILL_SEQUENCE_KEY])
  
    None.

    Returns:
      List<String> - List of words in which represent filing order for specific theme.
    */ 
      List<String> temp = [];
      inner_dict.forEach((key, value) {
        if (key == FILL_SEQUENCE_KEY)
            temp.addAll(List<String>.from(inner_dict[key]));
        else 
          {
            if (value.runtimeType.toString().contains("Map")){
                if (value[FILL_SEQUENCE_KEY]!=null)
                    temp.addAll(List<String>.from(value[FILL_SEQUENCE_KEY]));
            }
          }
        }
      );
      return temp;
    }

    List<String> natural_order(){
    /*Returns list of words in natural speech from inner dictionary. 

    None.

    Returns:
      List<String> - List of words in natural speech.
    */
        List<String> temp = [];
        inner_dict.forEach((key, value) {
          if (key == NATURAL_SEQUENCE_KEY)
              temp.addAll(List<String>.from(inner_dict[key]));
          else 
            {
              if (value.runtimeType.toString().contains("Map")){
                  if (value[NATURAL_SEQUENCE_KEY]!=null)
                      temp.addAll(List<String>.from(value[NATURAL_SEQUENCE_KEY]));
              }
            }
          }
        );
        return temp;
    }

    List<String> leads(){
    /*Returns list of words which led inner dictionary.
    
    None.

    Returns:
      List<String> - List of words which led inner dictionary.
    */   
      List<String> temp = [];
      inner_dict.forEach((key, value) {
          if (key == LEADS_KW)
              temp.addAll(List<String>.from(inner_dict[key]));
          else 
            {
              if (value.runtimeType.toString().contains("Map")){
                  if (value[LEADS_KW]!=null)
                      temp.addAll(List<String>.from(value[LEADS_KW]));
              }
            }
          }
        );
        return temp;
    }
    
    List<String> total_words(){
    /*Returns list of total words from inner dictionary.
     
    None.

    Returns:
      List<String> - List of total words.
    */
      List<String> temp = [];
      inner_dict.forEach((key, value) {
          if (key == TOTALS_KW)
              temp.addAll(List<String>.from(inner_dict[key]));
          else 
            {
              if (value.runtimeType.toString().contains("Map")){ 
                  if (value[TOTALS_KW]!=null)
                      temp.addAll(List<String>.from(value[TOTALS_KW]));
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
    /*Returns list of total words from inner dictionary marked with [IMAGE_KW].
  
    None.

    Returns:
      List<String> - List of total words which are marked with [IMAGE_KW].
    */
      List<String> temp = [];
      inner_dict.forEach((key, value) {
          if (key == IMAGE_KW)
              temp.addAll(List<String>.from(inner_dict[key]));
          else 
            {
              if (value.runtimeType.toString().contains("Map")){
                  if (value[IMAGE_KW]!=null)
                      temp.addAll(List<String>.from(value[IMAGE_KW]));
              }
            }
          }
        );
        return temp;
    }
  
    ThemeDict mapping(){
    /*Returns ThemeDict from inner dictionary marked with [MAPPING_KW].
  
    None.

    Returns:
      ThemeDict - Instance of ThemeDict class with key equal to inner dictionary [MAPPING_KW].
    */   
      if (getItem(MAPPING_KW).inner_dict.isNotEmpty){  
        return ThemeDict._private(default_theme, getItem(MAPPING_KW).inner_dict);
      } 
      return ThemeDict.EmptyDict(default_theme);
    }

    int bit_length(){
    /*Returns number of bits to map the word of current dictionary.
  
    None.

    Returns:
      int - Number of bits for mapping.  
    */
      if (inner_dict[BITS_KW] == null) 
        return 0;
      else
        return (inner_dict[BITS_KW]);
    }

    String led_by(){
    /*Returns string which leds current mapping.
  
    None.

    Returns:
      String - String which leds current mapping.  
    */
      var temp = inner_dict[LED_KW];
      return temp.toString();
    }

    ThemeDict get_led_by_mapping(String led_by){
    /*Returns inner dict value (mapping) for key equal to leading word.
  
    [led_by] (String) : Leading word for specific theme.

    Returns:
      ThemeDict - Instance of ThemeDict class which is value defined by leading word. 
    */
      ThemeDict temp = getItem(led_by);
      String led_by_temp = temp.led_by(); 
      return getItem(led_by_temp).getItem(led_by).getItem(MAPPING_KW);
    }

    int bits_per_phrase(){ 
    /*Returns sum of bits for each phrase in default theme.
  
    None.

    Returns:
      int - Sum of bit lenghts for each phrase in filing order of theme. 
    */
    var filing_words = filling_order();
    int sum = 0; 
    /// Sum bit lenght for each mapping defined by filing order.
    for (String word in filing_words){
        sum += getItem(word).bit_length();
    }
    return sum; 
    }

    List<int> bits_fill_sequence(){
    /*Returns list of bit lenghts for each phrase in default theme.
  
    None.

    Returns:
      List<int> - List of bit lenghts for each phrase in filing order of theme. 
    */
    List<int> result = [];
    var filing_words = filling_order();
    for (String word in filing_words){
        result.add(getItem(word).bit_length());
    }
    return result;
    }

    int words_per_phrase(){
    /*Returns lenght of phrases in this theme.
  
    None.

    Returns:
      int - Lenght of phrases in default theme. 
    */
    int words_per_phrase    = filling_order().length;
    int words_natural_order = natural_order().length;

    if (words_per_phrase != words_natural_order){
      throw Exception("Theme is malformed.");
    }
    return words_per_phrase; 
    }

    List<String> wordlist(){
    /*Returns all words used in the theme.
  
    None.

    Returns:
      String<List> - All words used in the theme. 
    */
    List<String> result = [];
    var filing_words = filling_order();
    ///Iterate through all phrases in theme.
    for (String word in filing_words){
        result.addAll(getItem(word).total_words());
    }
    /// Removes duplicate words from list.
    return result.toSet().toList();
    }

    List<Tuple2<String, String>> restriction_sequence(){
    /*Returns list of restrictions used in this theme.
  
    None.

    Returns:
      List<Tuple2<String, String>> - List of restriction words in this theme in form of list of tuples. 
    */
    List<Tuple2<String, String>> result = [];
    var filing_words = filling_order();
    for (String word in filing_words){
        var leads_by = getItem(word).leads();
        for (String restriction_word in leads_by){
          result.add(Tuple2(word, restriction_word));
        } 
    }
    return result; 
    }

    int natural_index(String syntactic_word){
    /*Returns sentence index in the natural speech of a given syntactic word.
  
    [syntactic_word] (String) : Word given to find the index in the sentence.

    Returns:
      int - The index of the word given in the natural speech of the sentence.
    */
    List<String> natural_words = natural_order(); 
    return natural_words.indexOf(syntactic_word);
    }

    List<int> natural_map(){
    /*Returns list of indexes of the natural order in the filling order.
  
    None.

    Returns:
      List<int>  - List of indexes of natural order in the filing order.
    */
    List<int> result = [];
    var filling_words = filling_order();
    for (String word in filling_words){
        result.add(natural_index(word));
    }
    return result;
    }

    int fill_index(String syntactic_word){
    /*Returns index of syntactic word in the filling order.
  
    [syntactic_word] (String) : The word given to find the index in the filling order.

    Returns:
      int  - The index of the word given in the filling order.
    */
    List<String> filling_words = filling_order();
    return filling_words.indexOf(syntactic_word);
    }

    List<int> filling_map(){
    /*Returns list of indexes of the filling order in the natural order.
  
    None.

    Returns:
      List<int>  - List of indexes of filling order in the natural order.
    */
    List<int> result = [];
    var natural_words = natural_order();
    for (String word in natural_words){
        result.add(fill_index(word));
    }
    return result;
    }

    List<Tuple2<int,int>> restriction_indexes(){
    /*Returns list of tuples of indexes to the restriction sequence of the sentence in natural speech.
  
    None.

    Returns:
      List<Tuple2<int,int>>  - List of tuples containing index and word.
    */
    List<Tuple2<int,int>> result = []; 
    List<Tuple2<String, String>> restriction_seq = restriction_sequence();
    for (Tuple2<String,String> tuple in restriction_seq){
      result.add(Tuple2(natural_index(tuple.item1), natural_index(tuple.item2)));
    }
    return result;
    }

    List<String> prime_syntactic_leads(){
    /*Returns list of syntactic words which does not follow any other syntactic word.
  
    None.

    Returns:
      List<String>  - List of syntactic words which do not follow any other syntactic words.
    */
    List<String> result = [];
    List<String> filling_words = filling_order();
    for (String word in filling_words){
      if (getItem(word).led_by() == NONE){
        result.add(word);
      }
    }
    return result;
    }

  // normalize_mnemonic -- this method will be realocated to mnemonics class 
    
    List<Tuple2<String,String>> restriction_pairs(List<String> sentence){
    /*Returns list of pairs of restriction from a given sentence.
  
    [sentence] (List<String) : The list of words from a sentence of the mnemonic.

    Returns:
      List<Tuple2<String,String>>  - List of pairs of restriction from a given sentence.
    */
    List<Tuple2<int,int>> indexes = restriction_indexes();
    List<Tuple2<String,String>> result = [];
    for(Tuple2<int,int> element in indexes){
        result.add(Tuple2(sentence[element.item1],sentence[element.item2]));
    }
    return result; 
    }

    Tuple2<int, int> getRelationIndexes(Tuple2 relation) {
    /*Returns indexes from a given tuple of relation syntactic and mnemonic words
    If any word given only leads and not led, find the indexes in the total_words list.
    
    [relation] (Tuple2) : The relation given to find the index from the lists
                                It can be whether a tuple of syntactic leads and the mnemonic leads
                                or a tuple of tuples of syntactic leads and led and mnemonic leads and led
                                e.g. ("VERB", word_verb) or (("VERB", "SUBJECT"), (word_verb, word_subject))

    Returns:
       Tuple2<int,int>  - Tuple with the indexes found in the restriction relation.
    */
    var syntacticRelation = relation.item1;
    var mnemonicRelation  = relation.item2;

    //If argument is type of Tuple2<String, String>
    if (syntacticRelation is String && mnemonicRelation is String) {
      var syntLeads = syntacticRelation;
      var mnemoLeads = mnemonicRelation;
      var wordsList = getItem(syntLeads).total_words(); 
      var mnemoIndex = natural_index(syntacticRelation);
      var wordIndex = wordsList.indexOf(mnemoLeads);
      return Tuple2(mnemoIndex, wordIndex);
    }
    //If argument is Tuple2<Tuple2, Tuple2> 
    else {
      String syntLeads   = syntacticRelation.item1;
      String syntLed     = syntacticRelation.item2;
      String mnemoLeads  = mnemonicRelation.item1;
      String mnemoLed    = mnemonicRelation.item2;
      int mnemoIndex = natural_index(syntLed);
      var restrictionDict = getItem(syntLeads).getItem(syntLed).mapping();
      List<String> wordsList = List<String>.from(restrictionDict.inner_dict[mnemoLeads]);
      var wordIndex = wordsList.indexOf(mnemoLed);
      return Tuple2(mnemoIndex, wordIndex); 
    }
  }
 
    List<int> getNaturalIndexes(dynamic sentence) {
    /*Return the indexes of a sentence from the lists ordered as natural speech of this theme
    The sentence can be given as a list or a string and must be complete
    otherwise raises ArgumentError exception.
    
    [sentence] (Tuple or String) :  The words to be searched, must have complete sentences

    Returns:
       List<int>  - The list of indexes of the words in this theme lists and ordered as the mnemonic given.
    */ 
      if (sentence.runtimeType == String){
        sentence = sentence.toString().split(" ");
      }
      if (sentence.length != words_per_phrase()) {
        var errorMessage = 'The number of words in sentence must be $words_per_phrase(), but it is ${sentence.length}';
        throw ArgumentError(errorMessage);
      }

      List<int> wordIndexes = List.filled(sentence.length, 0);
      var restrictionSequence = restriction_sequence();
      var primeSyntacticLeads = prime_syntactic_leads();
      var wordRestrictionPairs = restriction_pairs(sentence);
      var eachRelation; 
      List<Tuple2> restrictionRelation = zip([restrictionSequence, wordRestrictionPairs])
      .map((tuple) => Tuple2(
            tuple[0],
            tuple[1], 
          ))
      .toList(); 


      for (var eachSyntacticLeads in primeSyntacticLeads) { 
        eachRelation = Tuple2(eachSyntacticLeads, sentence[natural_index(eachSyntacticLeads)]);  
        var mnemoIndex = getRelationIndexes(eachRelation).item1;
        var wordIndex = getRelationIndexes(eachRelation).item2; 
        wordIndexes[mnemoIndex] = wordIndex;
      }
     
      for (var eachRelation in restrictionRelation) { 
        var mnemoIndex = getRelationIndexes(eachRelation).item1; 
        var wordIndex = getRelationIndexes(eachRelation).item2; 
        wordIndexes[mnemoIndex] = wordIndex;
      }  
      return wordIndexes;
    }

    List<int> get_filling_indexes(dynamic sentence){
    /*Return the indexes of a sentence from the lists ordered as the filling order of this theme
    The sentence can be given as a list or a string and must be a complete sentence
    otherwise raises ValueError exception
    
    [sentence] (Tuple or String) :  The words to be searched, must have complete sentences

    Returns:
      List<int>  - The list of indexes of the words in this theme lists and ordered as the filling order.
    */
    if (sentence.runtimeType == String){
        sentence = sentence.toString().split(" ");
      }
    if (sentence.length != words_per_phrase()) {
      var errorMessage = 'The number of words in sentence must be $words_per_phrase(), but it is ${sentence.length}';
      throw ArgumentError(errorMessage);
    }

    List<int> result = [];

    var word_natural_indexes = getNaturalIndexes(sentence);
    var n_map = natural_map();
    for (int index in n_map){
      result.add(word_natural_indexes[index]);
    } 
    return result;
    }

    int get_phrase_amount(dynamic mnemonic){
    /*Returns how many phrases are in the given mnemonic.
    
    [sentence] (List<String> or String) :  The mnemonic to get the amount of phrases, it can be a string or a list of words.

    Returns:
      int - Returns the amount of phrases of the given mnemonic.
    */
    // split string into list of words
    if (mnemonic.runtimeType == String){
        mnemonic = mnemonic.toString().split("");
    } 

    //remove empty elements from spliting
    for (int i = mnemonic.length - 1; i >= 0; i--) { 
      if (mnemonic[i] == '') { 
        mnemonic.removeAt(i);
      }
    }
    
    var phrase_amount; 
    var mnemonic_size = mnemonic.length;
    var phrase_size   = words_per_phrase(); 
    try{
    phrase_amount = (mnemonic_size / phrase_size);
    } catch(exception){
      print(exception.toString());
    } 
    return phrase_amount.round();
    }

    List<List<String>> get_sentences(dynamic mnemonic){
    /*Splits to list the sentences from a given mnemonic
    
    [sentence] (List<String> or String) :  The mnemonic to get the amount of phrases, it can be a string or a list of words.

    Returns:
      List<List<String>> - Return a list of sentences with the lists of words from the mnemonic.
    */ 

    //normalize mnemonic
    if (mnemonic.runtimeType == String){
      mnemonic = mnemonic.toString().split(" ");
    }
    for (int i = mnemonic.length - 1; i >= 0; i--) { 
      if (mnemonic[i] == '') { 
        mnemonic.removeAt(i);
      }
    } 
    //prepare variables for generating list of sentences
    var phrase_size   = words_per_phrase();
    var phrase_amount = get_phrase_amount(mnemonic); 
    //generate sentence for specific mnemonic
    List<List<String>> sentences = List.generate(phrase_amount, (int eachPhrase) {
          int start = phrase_size * eachPhrase;
          int end = phrase_size * (eachPhrase + 1);
          return mnemonic.sublist(start, end);
    }); 
    return sentences;
    }

    List<int> get_phrase_indexes(dynamic mnemonic){
    /*Get the indexes of a given mnemonic from each sentence in it
    The mnemonic can be given as a list or a string and must have complete sentences
    otherwise raises ArgumentError exception.
    
    [mnemonic] (List<String> or String) :  The words to be searched, must have complete sentences.

    Returns:
      List<int> - Returns list of indexes of the words in this theme lists and ordered as the filling order
    */ 
    //normalize mnemonic
    if (mnemonic.runtimeType == String){
      mnemonic = mnemonic.toString().split(" ");
    }
    for (int i = mnemonic.length - 1; i >= 0; i--) { 
      if (mnemonic[i] == '') { 
        mnemonic.removeAt(i);
      }
    } 

    var sentences = get_sentences(mnemonic);
    List<int> indexes = [];

    for (dynamic each_phrase in sentences){
      for (int each_fill_index in get_filling_indexes(each_phrase)){
        indexes.add(each_fill_index);
      }
    } 
    return indexes;
    }

    ThemeDict get_lead_mapping(String syntactic_key){
    /*Returns ThemeDict class which is led by specific syntactic word.
    
    [syntactic_key] (String) :  Syntactic word to be led.

    Returns:
      ThemeDict - Returns instance of ThemeDict class with inner dictionary led by syntactic word.
    */ 
    return getItem(getItem(syntactic_key).led_by()).getItem(syntactic_key).mapping();
    }

    int get_led_by_index(String syntactic_key){
    /*Get the natural index of the leading word.
    
    [syntactic_key] (String) :  The leading word to get the natural index from.

    Returns:
        int - Returns natural index of the leading word.
    */    
    return natural_index(getItem(syntactic_key).led_by());
    }


    List get_lead_list(String syntactic_key, List sentence){
    /*Get the list of words led by the given syntactic word.
    
    [syntactic_key] (String)       : The leading word to get the natural index from.
    [sentence]      (List<String>) : The sentence to solve the leading when the desired list depends on the leading words.

    Returns:
        List<String> - Return the list led by a syntactic word.
    */ 
    var lead_list;
    var prime_syntactic_list = prime_syntactic_leads();  
    if (prime_syntactic_list.contains(syntactic_key)){  
        lead_list = getItem(syntactic_key).total_words();
    }
    else{  
        var mapping = get_lead_mapping(syntactic_key);  
        var leading_word = sentence[get_led_by_index(syntactic_key)];  
        lead_list = mapping.inner_dict[leading_word];
    }
    return lead_list; 
    }

    List<String> assemble_sentence(String data_bits){
    /*Build sentence using bits given following the dictionary filling order.
    
    [data_bits] (String) :  The information as bits from the entropy and checksum.
                            Each step from it represents an index to the list of led words.
 
    Returns:
        List<String> - Return resulting words ordered of sentence in natural language.
    */ 
    int bit_index = 0;
    List<String> current_sentence = List.empty(growable: true);

    var filling_order_list = filling_order(); 
    
    //populate empty list
    for (int i = 0; filling_order_list.length>i;i++){
      current_sentence.add(" ");
    }
    for (var syntactic_key in filling_order_list){
        int bit_length = getItem(syntactic_key).bit_length(); 
        //Integer from substring of zeroes and ones representing index of current word within its list
        int word_index = int.parse(data_bits.substring(bit_index, bit_index + bit_length), radix: 2);
  
        bit_index += bit_length;

        var list_of_words = get_lead_list(syntactic_key, current_sentence);
        var syntactic_order = natural_index(syntactic_key); 
        
        current_sentence[syntactic_order] = list_of_words[word_index];
    }
    return current_sentence;
    }

    List get_sentences_from_bits(String data_bits){
    /*Get the mnemonic sentences in the natural speech order from given string of bits.
    
    [data_bits] (String) :  The bits of the entropy and checksum to get the sentences from
 
    Returns:
        List<String> - Return a list of words forming the sentences of the mnemonic.
    */ 
    String data;
    int bits_per_phrase_ = bits_per_phrase();
    num phrases_amount = data_bits.length / bits_per_phrase_;

    List sentences = [];
    for (int phrase_index=0; phrases_amount>phrase_index; phrase_index++){
        int sentence_index = bits_per_phrase_ * phrase_index;
        data = data_bits.substring(sentence_index, sentence_index + bits_per_phrase_);
        sentences.addAll(assemble_sentence(data));
    }
    return sentences;
    }
 
}
 