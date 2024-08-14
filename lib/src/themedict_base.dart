import 'themes/BIP39_french.dart';
import 'themes/BIP39.dart';
import 'themes/copy_left.dart';
import 'themes/cute_pets.dart';
import 'themes/farm_animals.dart';
import 'themes/finances.dart';
import 'themes/medieval_fantasy.dart';
import 'themes/sci-fi.dart';
import 'themes/tourism.dart';
import 'package:quiver/iterables.dart';

class ThemeDict {
  /// Helper class which helps to extract theme information from
  /// stored json files.

  String fillSeqKey = "FILLING_ORDER";
  String naturalSeqKey = "NATURAL_ORDER";
  String leadsKW = "LEADS";
  String ledKW = "LED_BY";
  String totalsKW = "TOTAL_LIST";
  String imageKW = "IMAGE";
  String mappingKW = "MAPPING";
  String bitsKW = "BIT_LENGTH";
  String none = "NONE";

  String defaultTheme = "";

  Map<String, dynamic> innerDict = Map<String, dynamic>();

  ThemeDict.EmptyDict(String theme) {
    defaultTheme = theme;
  }

  /// The [ThemeDict] constructor creates an object based on provieded [theme].
  /// Returns [ThemeDict] object based on specific [theme].
  ThemeDict(String theme) {
    defaultTheme = theme;
    switch (defaultTheme) {
      case "BIP39":
        {
          innerDict = BIP39;
        }
      case "BIP39_french":
        {
          innerDict = BIP39_french;
        }
      case "copy_left":
        {
          innerDict = copy_left;
        }
      case "cute_pets":
        {
          innerDict = cute_pets;
        }
      case "farm_animals":
        {
          innerDict = farm_animals;
        }
      case "finances":
        {
          innerDict = finances;
        }
      case "medieval_fantasy":
        {
          innerDict = medieval_fantasy;
        }
      case "sci-fi":
        {
          innerDict = sci_fi;
        }
      case "tourism":
        {
          innerDict = tourism;
        }
    }
  }

  /// Constructor creates a ThemeDict object using the provided
  /// [theme] string and the [dict] map.
  ThemeDict._private(String theme, Map<String, dynamic> dict) {
    defaultTheme = theme;
    innerDict = dict;
  }

  /// The [getItem] method  returns item from inner dictionary of ThemeDict class
  ///  based on [key].
  ThemeDict getItem(String key) {
    if (innerDict[key] != null) {
      return ThemeDict._private(defaultTheme, innerDict[key]);
    }
    return ThemeDict.EmptyDict(defaultTheme);
  }

  /// The [setItem] method sets specific [item] of inner dictionary to [value].
  void setItem(String item, Map<String, dynamic> value) {
    innerDict[item] = value;
  }

  /// The [fillingOrder] method returns list of words in which represent filing
  ///  order for specific theme from inner dictionary based on [fillSeqKey].
  List<String> fillingOrder() {
    List<String> temp = [];
    innerDict.forEach((key, value) {
      if (key == fillSeqKey) {
        temp.addAll(List<String>.from(innerDict[key]));
      } else {
        if (value is Map) {
          if (value[fillSeqKey] != null) {
            temp.addAll(List<String>.from(value[fillSeqKey]));
          }
        }
      }
    });
    return temp;
  }

  /// The [naturalOrder] method returns list of words which correspond to key
  ///   [naturalSeqKey] from inner dictionary.
  List<String> naturalOrder() {
    List<String> temp = [];
    innerDict.forEach((key, value) {
      if (key == naturalSeqKey) {
        temp.addAll(List<String>.from(innerDict[key]));
      } else {
        if (value is Map && value[naturalSeqKey] != null) {
          temp.addAll(List<String>.from(value[naturalSeqKey]));
        }
      }
    });
    return temp;
  }

  /// The [leads] method returns list of words which correspond to key
  ///   [leadsKW] from inner dictionary.
  List<String> leads() {
    List<String> temp = [];
    innerDict.forEach((key, value) {
      if (key == leadsKW) {
        temp.addAll(List<String>.from(innerDict[key]));
      } else {
        if (value is Map && value[leadsKW] != null) {
          temp.addAll(List<String>.from(value[leadsKW]));
        }
      }
    });
    return temp;
  }

  /// The [totalWords] method returns list of words which correspond to key
  ///   [totalsKW] from inner dictionary.
  List<String> totalWords() {
    List<String> temp = [];
    innerDict.forEach((key, value) {
      if (key == totalsKW) {
        temp.addAll(List<String>.from(innerDict[key]));
      } else {
        if (value is Map && value[totalsKW] != null) {
          temp.addAll(List<String>.from(value[totalsKW]));
        }
      }
    });
    if (temp.isEmpty) {
      temp.add(" ");
    }
    return temp;
  }

  /// The [image] method returns list of words which correspond to key
  ///   [imageKW] from inner dictionary.
  List<String> image() {
    List<String> temp = [];
    innerDict.forEach((key, value) {
      if (key == imageKW) {
        temp.addAll(List<String>.from(innerDict[key]));
      } else {
        if (value is Map && value[imageKW] != null) {
          temp.addAll(List<String>.from(value[imageKW]));
        }
      }
    });
    return temp;
  }

  /// The [mapping] method returns list of words which correspond to key
  ///   [mappingKW] from inner dictionary.
  ThemeDict mapping() {
    if (getItem(mappingKW).innerDict.isNotEmpty) {
      return ThemeDict._private(defaultTheme, getItem(mappingKW).innerDict);
    }
    return ThemeDict.EmptyDict(defaultTheme);
  }

  /// The [bitLength] method returns bit lenght which correspond to key
  /// [bitsKW] from inner dictionary.
  int bitLength() {
    if (innerDict[bitsKW] == null) {
      return 0;
    } else {
      return (innerDict[bitsKW]);
    }
  }

  /// The [ledBy] method returns bit lenght which correspond to key
  /// [ledKW] from inner dictionary.
  String ledBy() {
    var temp = innerDict[ledKW];
    return temp.toString();
  }

  /// The [getLedByMapping] method creates a ThemeDict pattern using the provided
  /// [ledByWord] string as key.
  ThemeDict getLedByMapping(String ledByWord) {
    ThemeDict temp = getItem(ledByWord);
    String ledByTemp = temp.ledBy();
    return getItem(ledByTemp).getItem(ledByWord).getItem(mappingKW);
  }

  /// The [bitsPerPhrase] method returns sum of bits for each phrase in default theme.
  int bitsPerPhrase() {
    var filingWords = fillingOrder();
    int sum = 0;
    // Sum bit lenght for each mapping defined by filing order.
    for (String word in filingWords) {
      sum += getItem(word).bitLength();
    }
    return sum;
  }

  /// The [bitsFillSequence] method returns list of bit lenghts for each phrase in default theme.
  /// Each phrase in default theme is retrieved using [fillSeqKey] as key for inner dictionary.
  List<int> bitsFillSequence() {
    List<int> result = [];
    var filingWords = fillingOrder();
    for (String word in filingWords) {
      result.add(getItem(word).bitLength());
    }
    return result;
  }

  /// The [wordsPerPhrase] method returns lenght of words which can be
  /// accessed by [fillSeqKey] in inner dictionary. If theme is malformed, 0 is returned.
  int wordsPerPhrase() {
    int wordsPerPhrase_ = fillingOrder().length;
    int wordsNaturalOrder_ = naturalOrder().length;

    if (wordsPerPhrase_ != wordsNaturalOrder_) {
      //Theme is malformed.
      return 0;
    }
    return wordsPerPhrase_;
  }

  /// The [wordList] method returns list of words used in default theme.
  List<String> wordList() {
    List<String> result = [];
    var filingWords_ = fillingOrder();
    //Iterate through all phrases in theme.
    for (String word in filingWords_) {
      result.addAll(getItem(word).totalWords());
    }
    // Removes duplicate words from list.
    return result.toSet().toList();
  }

  /// The [restrictionSequence] method returns list of restrictions used in default theme.
  List<(String, String)> restrictionSequence() {
    List<(String, String)> result = [];
    var filingWords_ = fillingOrder();
    for (String word in filingWords_) {
      var leadsBy_ = getItem(word).leads();
      for (String restrictionWord in leadsBy_) {
        result.add((word, restrictionWord));
      }
    }
    return result;
  }

  /// The [naturalIndex] method returnes sentence index in the
  ///  speech of a given [syntacticWord].
  int naturalIndex(String syntacticWord) {
    List<String> naturalWords_ = naturalOrder();
    return naturalWords_.indexOf(syntacticWord);
  }

  /// The [naturalMap] method returns list of indexes in filling order.
  List<int> naturalMap() {
    List<int> result = [];
    var fillingWords_ = fillingOrder();
    for (String word in fillingWords_) {
      result.add(naturalIndex(word));
    }
    return result;
  }

  /// The [fillIndex] method returns sentence index in the natural
  ///  speech of a given [syntacticWord].
  int fillIndex(String syntacticWord) {
    List<String> fillingWords_ = fillingOrder();
    return fillingWords_.indexOf(syntacticWord);
  }

  /// The [fillingMap] method creates sentence index in the natural
  ///  speech of a given [naturalSeqKey].
  List<int> fillingMap() {
    List<int> result = [];
    var naturalWords_ = naturalOrder();
    for (String word in naturalWords_) {
      result.add(fillIndex(word));
    }
    return result;
  }

  /// The [restrictionIndexes] method creates a list of records for restriction sequence in
  /// natural speech which is defined by [leadsKW].
  List<(int, int)> restrictionIndexes() {
    List<(int, int)> result = [];
    List<(String, String)> restrictionSeq_ = restrictionSequence();
    for ((String, String) record in restrictionSeq_) {
      result.add((naturalIndex(record.$1), naturalIndex(record.$2)));
    }
    return result;
  }

  /// The [primeSyntacticLeads] method creates a list of syntactic words which does
  /// not follow any other syntactic word.
  List<String> primeSyntacticLeads() {
    List<String> result = [];
    List<String> fillingWords_ = fillingOrder();
    for (String word in fillingWords_) {
      if (getItem(word).ledBy() == none) {
        result.add(word);
      }
    }
    return result;
  }

  /// The [restrictionPairs] method creates a list of restriction records
  /// from a given [sentence].
  List<(String, String)> restrictionPairs(List<String> sentence) {
    List<(int, int)> indexes = restrictionIndexes();
    List<(String, String)> result = [];
    for ((int, int) element in indexes) {
      result.add((sentence[element.$1], sentence[element.$2]));
    }
    return result;
  }

  /// The [getRelationIndexes] method returns indexes from a given [relation]
  /// of relation syntactic and mnemonic words any word given only leads and not led,
  /// finds the indexes in the total_words list.
  (int, int) getRelationIndexes((dynamic, dynamic) relation) {
    var syntacticRelation = relation.$1;
    var mnemonicRelation = relation.$2;

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
      String syntLeads = syntacticRelation.$1;
      String syntLed = syntacticRelation.$2;
      String mnemoLeads = mnemonicRelation.$1;
      String mnemoLed = mnemonicRelation.$2;
      int mnemoIndex = naturalIndex(syntLed);
      var restrictionDict = getItem(syntLeads).getItem(syntLed).mapping();
      List<String> wordsList =
          List<String>.from(restrictionDict.innerDict[mnemoLeads]);
      var wordIndex = wordsList.indexOf(mnemoLed);
      return (mnemoIndex, wordIndex);
    }
  }

  /// The [getNaturalIndexes] method generates indexes of a sentence from the lists ordered as
  /// natural speech of this theme. Throws [ArgumentError] if number of words in sentence is not correct.
  List<int> getNaturalIndexes(dynamic sentence) {
    if (sentence is String) {
      sentence = sentence.toString().split(" ");
    }
    if (sentence.length != wordsPerPhrase()) {
      var errorMessage =
          'The number of words in sentence must be $wordsPerPhrase(), but it is ${sentence.length}';
      throw ArgumentError(errorMessage);
    }

    List<int> wordIndexes = List.filled(sentence.length, 0);
    var restrictionsequence = restrictionSequence();
    var primeSyntacticLeads_ = primeSyntacticLeads();
    var wordRestrictionPairs = restrictionPairs(sentence);

    List<(dynamic, dynamic)> restrictionRelation =
        zip([restrictionsequence, wordRestrictionPairs])
            .map((record) => (
                  record[0],
                  record[1],
                ))
            .toList();

    for (var eachSyntacticLeads in primeSyntacticLeads_) {
      var eachRelation =
          (eachSyntacticLeads, sentence[naturalIndex(eachSyntacticLeads)]);
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

  /// The [getFillingIndexes] method creates indexes of a sentence from the lists ordered
  ///  as the filling order of this theme. Throws [ArgumentError] if number of words in
  /// sentence is not enough.
  List<int> getFillingIndexes(dynamic sentence) {
    if (sentence is String) {
      sentence = sentence.toString().split(" ");
    }
    if (sentence.length != wordsPerPhrase()) {
      var msg =
          'The number of words in sentence must be $wordsPerPhrase(), but it is ${sentence.length}';
      throw ArgumentError(msg);
    }

    List<int> result = [];

    var wordNaturalIndexes_ = getNaturalIndexes(sentence);
    var nMap = naturalMap();
    for (int index in nMap) {
      result.add(wordNaturalIndexes_[index]);
    }
    return result;
  }

  /// The [getPhraseAmount] method returns amount of phrases in [mnemonic].
  int getPhraseAmount(dynamic mnemonic) {
    if (mnemonic is String) {
      mnemonic = mnemonic.toString().split("");
    }

    //remove empty elements from spliting
    for (int i = mnemonic.length - 1; i >= 0; i--) {
      if (mnemonic[i] == '') {
        mnemonic.removeAt(i);
      }
    }

    var mnemonicSize_ = mnemonic.length;
    var phraseSize_ = wordsPerPhrase();

    var phraseAmount_ = (mnemonicSize_ / phraseSize_);

    return phraseAmount_.round();
  }

  /// The [getSentences] method returns list of sentences of given [mnemonic].
  List<List<String>> getSentences(dynamic mnemonic) {
    if (mnemonic is String) {
      mnemonic = mnemonic.toString().split(" ");
    }
    for (int i = mnemonic.length - 1; i >= 0; i--) {
      if (mnemonic[i] == '') {
        mnemonic.removeAt(i);
      }
    }
    //prepare variables for generating list of sentences
    var phraseSize_ = wordsPerPhrase();
    var phraseAmount_ = getPhraseAmount(mnemonic);
    //generate sentence for specific mnemonic
    List<List<String>> sentences =
        List.generate(phraseAmount_, (int eachPhrase) {
      int start = phraseSize_ * eachPhrase;
      int end = phraseSize_ * (eachPhrase + 1);
      return mnemonic.sublist(start, end);
    });
    return sentences;
  }

  /// The [getPhraseIndexes] method returns indexes of [mnemonic] from each sentence in it.
  List<int> getPhraseIndexes(dynamic mnemonic) {
    if (mnemonic is String) {
      mnemonic = mnemonic.toString().split(" ");
    }
    for (int i = mnemonic.length - 1; i >= 0; i--) {
      if (mnemonic[i] == '') {
        mnemonic.removeAt(i);
      }
    }

    var sentences = getSentences(mnemonic);
    List<int> indexes = [];

    for (dynamic eachPhrase in sentences) {
      for (int eachFillIndex in getFillingIndexes(eachPhrase)) {
        indexes.add(eachFillIndex);
      }
    }
    return indexes;
  }

  /// The [getLeadMapping] method returns instance of [ThemeDict] class
  /// with inner dictionary led by [syntacticKey].
  ThemeDict getLeadMapping(String syntacticKey) {
    return getItem(getItem(syntacticKey).ledBy())
        .getItem(syntacticKey)
        .mapping();
  }

  /// The [getLedByIndex] method returns natural index of the [syntacticKey].
  int getLedByIndex(String syntacticKey) {
    return naturalIndex(getItem(syntacticKey).ledBy());
  }

  /// The [getLeadList] method returns a list of words led by [syntacticKey].
  /// If inner dictionary doesn't have words with key [fillSeqKey] then list of the words
  /// defined in [sentence] is used.
  List getLeadList(String syntacticKey, List sentence) {
    var leadList = [];
    var primeSyntacticList_ = primeSyntacticLeads();
    if (primeSyntacticList_.contains(syntacticKey)) {
      leadList = getItem(syntacticKey).totalWords();
    } else {
      var mapping = getLeadMapping(syntacticKey);
      var leadingWord_ = sentence[getLedByIndex(syntacticKey)];
      leadList = mapping.innerDict[leadingWord_];
    }
    return leadList;
  }

  /// The [assembleSentence] method returns a sentence from [dataBits] following the
  /// dictionary filling order.
  List<String> assembleSentence(String dataBits) {
    int bitIndex = 0;
    List<String> currentSentence = List.empty(growable: true);

    var fillingOrderList = fillingOrder();

    for (int i = 0; fillingOrderList.length > i; i++) {
      currentSentence.add(" ");
    }
    for (var syntacticKey in fillingOrderList) {
      int bitLength = getItem(syntacticKey).bitLength();
      //Integer from substring of zeroes and ones representing index of current word within its list
      int wordIndex = int.parse(
          dataBits.substring(bitIndex, bitIndex + bitLength),
          radix: 2);

      bitIndex += bitLength;

      var listOfWords = getLeadList(syntacticKey, currentSentence);
      var syntacticOrder = naturalIndex(syntacticKey);

      currentSentence[syntacticOrder] = listOfWords[wordIndex];
    }
    return currentSentence;
  }

  /// The [getSentencesFromBits] method returns mnemonic sentences in the natural speech
  /// order from [dataBits].
  List getSentencesFromBits(String dataBits) {
    String data;
    int bitsPerPhrase_ = bitsPerPhrase();
    num phrasesAmount = dataBits.length / bitsPerPhrase_;

    List sentences = [];
    for (int phraseIndex = 0; phrasesAmount > phraseIndex; phraseIndex++) {
      int sentenceIndex = bitsPerPhrase_ * phraseIndex;
      data = dataBits.substring(sentenceIndex, sentenceIndex + bitsPerPhrase_);
      sentences.addAll(assembleSentence(data));
    }
    return sentences;
  }
}
