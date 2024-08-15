import 'dart:collection';


class MnemonicTheme<K extends String, V> extends MapBase<K, dynamic> {
  static String fillSequenceKey = "FILLING_ORDER";

  static String naturalSequenceKey = "NATURAL_ORDER";
  static String leadsKeyword = "LEADS";
  static String ledKeyword = "LED_BY";
  static String totalsKeyword = "TOTAL_LIST";
  static String imageKeyword = "IMAGE";
  static String mappingKeyword = "MAPPING";
  static String bitsKeyword = "BIT_LENGTH";
  final Map<K, dynamic> _internalMap;

  MnemonicTheme({required Map<K, V> theme}) : _internalMap = theme;

  List<String> get fillingOrder {
    List<String> fillingOrderList = [];

    if (_internalMap[fillSequenceKey] != null) {
      fillingOrderList = _internalMap[fillSequenceKey];
    }

    return fillingOrderList;
  }

  List get image {
    List image;

    if (_internalMap.containsKey(imageKeyword)) {
      image = _internalMap[imageKeyword];
    } else {
      image = [];
    }

    return image;
  }

  @override
  Iterable<K> get keys => _internalMap.keys;

  List<String> get leads {
    List<String> ledList;

    if (_internalMap.containsKey(leadsKeyword)) {
      ledList = _internalMap[leadsKeyword];
    } else {
      ledList = [];
    }

    return ledList;
  }

  String get ledBy {
    var ledBy_ = _internalMap[ledKeyword] ? _internalMap[ledKeyword] : '';
    return ledBy_.toString();
  }

  MnemonicTheme get mapping {
    MnemonicTheme mapping;

    if (_internalMap.containsKey(mappingKeyword)) {
      mapping = _internalMap[mappingKeyword];
    } else {
      mapping = MnemonicTheme(theme: {});
    }

    return mapping;
  }

  List<int> get naturalMap {
    List<int> result = [];
    var fillingWords_ = fillingOrder;
    for (String word in fillingWords_) {
      result.add(naturalIndex(word));
    }
    return result;
  }

  List<String> get naturalOrder {
    List<String> naturalOrder_;

    if (_internalMap.containsKey(naturalSequenceKey)) {
      naturalOrder_ = _internalMap[naturalSequenceKey];
    } else {
      naturalOrder_ = [];
    }

    return naturalOrder_;
  }

  @override
  dynamic operator [](dynamic key) {
    if (_internalMap[key] == null) {
      return MnemonicTheme(theme: <K, dynamic>{});
    } else if (_internalMap[key] is Map<K, dynamic>) {
      return MnemonicTheme(theme: _internalMap[key]);
    } else {
      return _internalMap[key];
    }
  }

  @override
  void operator []=(K key, dynamic value) {
    if (value is Map<K, dynamic>) {
      _internalMap[key] = MnemonicTheme(theme: value);
    } else {
      _internalMap[key] = value;
    }
  }

  List<String> assembleSentence(String dataBits) {
    int bitIndex = 0;
    List<String> fillingOrderList = fillingOrder;
    List<String> currentSentence = List.filled(fillingOrderList.length, "");

    for (var syntacticKey in fillingOrderList) {
      int bitLength = _internalMap[syntacticKey].bitLength();

      // Integer from substring of zeroes and ones representing index of
      // current word within its list
      int wordIndex = int.parse(
        dataBits.substring(bitIndex, bitIndex + bitLength),
        radix: 2,
      );
      bitIndex += bitLength;

      var listOfWords = getLeadList(syntacticKey, currentSentence);
      var syntacticOrder = naturalIndex(syntacticKey);

      currentSentence[syntacticOrder] = listOfWords[wordIndex];
    }
    return currentSentence;
  }

  /// Returns the number of bits which correspond to bits keyword in the
  /// theme type.
  int bitLength() {
    if (_internalMap[bitsKeyword] == null) {
      return 0;
    } else {
      return _internalMap[bitsKeyword];
    }
  }

  /// Returns list of bit lengths for each phrase in default theme. Each
  /// phrase in default theme is retrieved using [fillSequenceKey] as key
  /// for inner dictionary.
  List<int> bitsFillSequence() {
    List<int> result = [];
    var filingWords = fillingOrder;

    for (String word in filingWords) {
      result.add(_internalMap[word].bitLength());
    }

    return result;
  }

  /// Returns number of bits dedicated for each phrase in theme type.
  int bitsPerPhrase() {
    var filingWords = fillingOrder;
    int sum = 0;

    for (String word in filingWords) {
      sum += _internalMap[word].bitLength() as int;
    }

    return sum;
  }

  /// Removes all entries from the [MnemonicTheme].
  ///
  /// After this, the [MnemonicTheme] is empty.
  @override
  void clear() {
    _internalMap.clear();
  }

  /// Returns the index of the word in the natural speech sentence of
  /// a given [syntacticWord].
  int fillIndex(String syntacticWord) {
    List<String> fillingWords_ = fillingOrder;
    return fillingWords_.indexOf(syntacticWord);
  }

  /// Returns the indexes of the sentence in natural speech of a given
  /// theme type.
  List<int> fillingMap() {
    List<int> result = [];
    var naturalWords_ = naturalOrder;
    for (String word in naturalWords_) {
      result.add(fillIndex(word));
    }
    return result;
  }

  List<int> getFillingIndexes(dynamic sentence) {
    if (sentence is String) sentence = sentence.split(' ');

    if ((sentence.length % wordsPerPhrase()) != 0) {
      throw ArgumentError(
        'The number of words in sentence must be $wordsPerPhrase(),'
        ' but it is ${sentence.length}',
      );
    }

    List<int> result = [];
    var wordNaturalIndexes_ = getNaturalIndexes(sentence);
    var naturalMap_ = naturalMap;
    for (int index in naturalMap_) {
      result.add(wordNaturalIndexes_[index]);
    }

    return result;
  }

  /// Returns a list of words led by [syntacticKey] the underline theme type.
  ///
  /// If [MnemonicTheme] doesn't have words with key [fillSequenceKey] then
  /// the list of the words defined in [sentence] will be used.
  List getLeadList(String syntacticKey, List sentence) {
    var leadList = [];
    var primeSyntacticList_ = primeSyntacticLeads();

    if (primeSyntacticList_.contains(syntacticKey)) {
      leadList = _internalMap[syntacticKey].totalWords();
    } else {
      var mapping = getLeadMapping(syntacticKey);
      var leadingWord_ = sentence[getLedByIndex(syntacticKey)];
      leadList = mapping[leadingWord_];
    }

    return leadList;
  }

  /// Returns instance of [MnemonicTheme] class that led by the [ledBy]
  /// leading word.
  MnemonicTheme getLeadMapping(String ledBy) {
    return _internalMap[_internalMap[ledBy].ledBy][ledBy].mapping;
  }

  /// Returns the natural index of the leading word [syntacticKey].
  int getLedByIndex(String syntacticKey) {
    return naturalIndex(_internalMap[syntacticKey].ledBy);
  }

  /// Returns a new class of [MnemonicTheme] for the mapping of the leading
  /// word [ledByWord] string as a key.
  MnemonicTheme getLedByMapping(String ledByWord) {
    String syntacticLeads_ = _internalMap[ledByWord].ledBy;
    return _internalMap[syntacticLeads_][ledByWord].mapping;
  }

  /// Returns the indexes of a sentence from the lists ordered as natural
  /// speech of this theme. Throws [ArgumentError] if number of words in
  /// sentence is not correct.
  List<int> getNaturalIndexes(dynamic sentence) {
    if (sentence is String) sentence = sentence.split(' ');

    if (sentence.length != wordsPerPhrase()) {
      throw ArgumentError(
        'The number of words in sentence must be $wordsPerPhrase(),'
        ' but it is ${sentence.length}',
      );
    }

    List<int> wordIndexes = List.filled(sentence.length, 0);
    var restrictionSequence_ = restrictionSequence();
    var primeSyntacticLeads_ = primeSyntacticLeads();
    var restrictionPairs_ = restrictionPairs(sentence);

    List<(dynamic, dynamic)> restrictionRelation = [];
    for (int idx = 0; idx < restrictionSequence_.length; idx++) {
      restrictionRelation.add(
        (restrictionSequence_[idx], restrictionPairs_[idx]),
      );
    }

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

  /// Returns the amount of phrases in [mnemonic].
  int getPhraseAmount(dynamic mnemonic) {
    if (mnemonic is String) mnemonic = mnemonic.split(' ');

    var mnemonicSize_ = mnemonic.length;
    var phraseSize_ = wordsPerPhrase();

    var phraseAmount_ = (mnemonicSize_ / phraseSize_);

    return phraseAmount_.round();
  }

  /// Returns indexes of [mnemonic] from each sentence in it.
  List<int> getPhraseIndexes(dynamic mnemonic) {
    if (mnemonic is String) mnemonic = mnemonic.split(' ');

    List<int> indexes = [];
    List<List<String>> sentences = getSentences(mnemonic);

    for (dynamic eachPhrase in sentences) {
      for (int eachFillIndex in getFillingIndexes(eachPhrase)) {
        indexes.add(eachFillIndex);
      }
    }
    return indexes;
  }

  (int, int) getRelationIndexes((dynamic, dynamic) relation) {
    var syntacticRelation = relation.$1;
    var mnemonicRelation = relation.$2;

    // If argument is type of Record(String, String)
    if (syntacticRelation is String && mnemonicRelation is String) {
      var syntacticLeads_ = syntacticRelation;
      var mnemoLeads = mnemonicRelation;
      var wordsList = _internalMap[syntacticLeads_].totalWords();
      var mnemoIndex = naturalIndex(syntacticRelation);
      var wordIndex = wordsList.indexOf(mnemoLeads);

      return (mnemoIndex, wordIndex);
    }
    // If argument is (Record, Record)
    else {
      String syntacticLeads_ = syntacticRelation.$1;
      String syntacticLed_ = syntacticRelation.$2;
      String mnemoLeads = mnemonicRelation.$1;
      String mnemoLed = mnemonicRelation.$2;
      int mnemoIndex = naturalIndex(syntacticLed_);
      MnemonicTheme restrictionDict =
          _internalMap[syntacticLeads_][syntacticLed_].mapping;
      List<String> wordsList = List<String>.from(restrictionDict[mnemoLeads]);
      var wordIndex = wordsList.indexOf(mnemoLed);

      return (mnemoIndex, wordIndex);
    }
  }

  /// Returns list of sentences of given [mnemonic].
  List<List<String>> getSentences(dynamic mnemonic) {
    if (mnemonic is String) mnemonic = mnemonic.split(' ');

    // Prepare variables for generating list of sentences
    var phraseSize_ = wordsPerPhrase();
    var phraseAmount_ = getPhraseAmount(mnemonic);

    // Generate sentence for specific mnemonic
    List<List<String>> sentences = List.generate(
      phraseAmount_,
      (int eachPhrase) {
        int start = phraseSize_ * eachPhrase;
        int end = phraseSize_ * (eachPhrase + 1);
        return mnemonic.sublist(start, end);
      },
    );
    return sentences;
  }

  /// Returns mnemonic sentences in the natural speech order from [dataBits].
  List getSentencesFromBits(String dataBits) {
    String data;
    int bitsPerPhrase_ = bitsPerPhrase();
    int phrasesAmount = dataBits.length ~/ bitsPerPhrase_;

    List<String> sentences = [];
    for (int phraseIndex = 0; phrasesAmount > phraseIndex; phraseIndex++) {
      int sentenceIndex = bitsPerPhrase_ * phraseIndex;
      data = dataBits.substring(sentenceIndex, sentenceIndex + bitsPerPhrase_);
      sentences.addAll(assembleSentence(data));
    }

    return sentences;
  }

  /// Returns sentence index in the natural speech of a given [syntacticWord].
  int naturalIndex(String syntacticWord) {
    List<String> naturalWords_ = naturalOrder;
    return naturalWords_.indexOf(syntacticWord);
  }

  /// Creates and returns the list of syntactic words which does
  /// not follow any other syntactic word.
  List<String> primeSyntacticLeads() {
    List<String> result = [];
    List<String> fillingWords_ = fillingOrder;
    for (String word in fillingWords_) {
      if (_internalMap[word].ledBy == 'NONE') {
        result.add(word);
      }
    }
    return result;
  }

  @override
  V remove(Object? key) {
    return _internalMap.remove(key);
  }

  /// Creates and return the list of records for restriction sequence in
  /// natural speech which is defined by [leadsKeyword].
  List<(int, int)> restrictionIndexes() {
    List<(int, int)> result = [];
    List<(String, String)> restrictionSeq_ = restrictionSequence();
    for ((String, String) record in restrictionSeq_) {
      result.add((naturalIndex(record.$1), naturalIndex(record.$2)));
    }
    return result;
  }

  /// Creates and returns the list of restriction records
  /// from a given [sentence].
  List<(String, String)> restrictionPairs(List<String> sentence) {
    List<(int, int)> indexes = restrictionIndexes();
    List<(String, String)> result = [];
    for ((int, int) element in indexes) {
      result.add((sentence[element.$1], sentence[element.$2]));
    }
    return result;
  }

  /// Returns list of restrictions used in default theme.
  List<(String, String)> restrictionSequence() {
    List<(String, String)> result = [];
    var filingWords_ = fillingOrder;
    for (String word in filingWords_) {
      var leadsBy_ = _internalMap[word].leads;
      for (String restrictionWord in leadsBy_) {
        result.add((word, restrictionWord));
      }
    }
    return result;
  }

  /// Returns list of words which correspond to key [totalsKeyword]
  /// from current theme data.
  List<String> totalWords() {
    List<String> temp = [];
    _internalMap.forEach(
      (key, value) {
        if (key == totalsKeyword) {
          temp.addAll(List<String>.from(_internalMap[key]));
        } else {
          if (value is Map && value[totalsKeyword] != null) {
            temp.addAll(List<String>.from(value[totalsKeyword]));
          }
        }
      },
    );
    if (temp.isEmpty) {
      temp.add(' ');
    }
    return temp;
  }

  /// Returns list of words used in default theme.
  List<String> wordList() {
    List<String> result = [];
    var filingWords_ = fillingOrder;
    // Iterate through all phrases in theme.
    for (String word in filingWords_) {
      result.addAll(_internalMap[word].totalWords());
    }
    // Removes duplicate words from list.
    return result.toSet().toList();
  }

  /// The [wordsPerPhrase] method returns length of words which can be
  /// accessed by [fillSequenceKey] in inner dictionary. If theme is malformed, 0 is returned.
  int wordsPerPhrase() {
    int wordsPerPhrase_ = fillingOrder.length;
    int wordsNaturalOrder_ = naturalOrder.length;

    if (wordsPerPhrase_ != wordsNaturalOrder_) {
      // Theme is malformed.
      throw "Theme is malformed!";
    }

    return wordsPerPhrase_;
  }
}
