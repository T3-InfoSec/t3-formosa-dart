import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
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

    ThemeDict.EmptyDict(){}

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
        return  ThemeDict._private(default_theme, inner_dict[key]);
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
  
    List<String> mapping(){
    /*Returns list of total words from inner dictionary marked with [MAPPING_KW].
  
    None.

    Returns:
      List<String> - List of total words which are marked with [MAPPING_KW].
    */
      List<String> temp = [];
      inner_dict.forEach((key, value) {
          if (key == MAPPING_KW)
              temp.addAll(List<String>.from(inner_dict[key]));
          else 
            {
              if (value.runtimeType.toString().contains("Map")){
                  if (value[MAPPING_KW]!=null)
                      temp.addAll(List<String>.from(value[MAPPING_KW]));
              }
            }
          }
        );
        return temp;
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
    print(indexes);
    List<Tuple2<String,String>> result = [];
    for(Tuple2<int,int> element in indexes){
        result.add(Tuple2(sentence[element.item1],sentence[element.item2]));
    }
    return result; 
    }



// list of functionalities to be done
// get_relation_indexes, 
// get_natural_indexes, 
// get_filling_indexes, 
// get_phrase_amount,
// get_sentences,
// get_phrase_indexes,
// get_lead_mapping,
// get_led_by_index,
// get_lead_list,
// assemble_sentence,
// get_sentences_from_bits,

}
 