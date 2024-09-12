import 'package:t3_formosa/formosa.dart';
import 'package:test/test.dart';

void main() async {
  String fillSeqKey = 'FILLING_ORDER';
  String naturalSeqKey = 'NATURAL_ORDER';
  String totalList = 'TOTAL_LIST';

  Formosa bip39_ = Formosa(formosaTheme: FormosaTheme.bip39);
  Formosa medievalFantasy = Formosa(formosaTheme: FormosaTheme.medievalFantasy);
  Formosa cutePets = Formosa(formosaTheme: FormosaTheme.cutePets);

  test('Check does is_bip39_theme function returns expected value.', () {
    expect(bip39_.isBip39Theme(), true);
    expect(medievalFantasy.isBip39Theme(), false);
    expect(cutePets.isBip39Theme(), false);
  });

  test('Check does storeJsonValues method works as expected', () {
    expect(bip39_.formosaTheme.data[fillSeqKey], ['WORDS']);
    expect(bip39_.formosaTheme.data[naturalSeqKey], ['WORDS']);
  });

  test(
      'Check does fillingOrder function returns correct value for bip39_ and mediaval fantasy themes.',
      () {
    List<String> result = ['WORDS'];
    expect(bip39_.formosaTheme.data.fillingOrder, result);
    List<String> result2 = [
      'VERB',
      'SUBJECT',
      'OBJECT',
      'ADJECTIVE',
      'WILDCARD',
      'PLACE'
    ];
    expect(medievalFantasy.formosaTheme.data.fillingOrder, result2);
  });

  test(
      'Check does total_words function returns correct value for cutepets theme.',
      () {
    expect((bip39_.formosaTheme.data['WORDS'])[totalList],
        bip39_.formosaTheme.data.totalWords());
  });

  test(
      'Check does bitLength function returns correct value for cutepets theme.',
      () {
    var words = bip39_.formosaTheme.data['WORDS'];
    expect(words.bitLength(), 11);
  });

  test('Check does getLedByMapping function returns correct mapping.', () {
    expect(
        medievalFantasy.formosaTheme.data
            .getLedByMapping('SUBJECT')['advise_about'],
        contains('acolyte'));
    expect(cutePets.formosaTheme.data.getLedByMapping('SUBJECT')['adopt'],
        contains('abyssinian_cat'));
  });

  test('Check does bitsPerPhrase function returns correct sum of bit lengths.',
      () {
    expect(bip39_.formosaTheme.data.bitsPerPhrase(), 11);
    expect(medievalFantasy.formosaTheme.data.bitsPerPhrase(), 33);
  });

  test('Check does wordsPerPhrase function returns correct number of phrases.',
      () {
    expect(bip39_.formosaTheme.data.wordsPerPhrase(), 1);
    expect(medievalFantasy.formosaTheme.data.wordsPerPhrase(), 6);
  });

  test('Check does wordList function returns correct words.', () {
    expect(bip39_.formosaTheme.data.wordList(), contains('alpha'));
    expect(bip39_.formosaTheme.data.wordList(), contains('abuse'));
  });

  test('Check does restrictionSequence function returns correct words.', () {
    expect(
        medievalFantasy.formosaTheme.data.restrictionSequence()[0].$1, 'VERB');
    expect(medievalFantasy.formosaTheme.data.restrictionSequence()[2].$2,
        'WILDCARD');
  });

  test('Check does naturalIndex function returns correct words.', () {
    expect(medievalFantasy.formosaTheme.data.naturalIndex('VERB'), 1);
    expect(medievalFantasy.formosaTheme.data.naturalIndex('SUBJECT'), 0);
    expect(medievalFantasy.formosaTheme.data.naturalIndex('WILDCARD'), 4);
    expect(bip39_.formosaTheme.data.naturalIndex('WORDS'), 0);
  });

  test('Check does naturalMap function returns correct words.', () {
    expect(medievalFantasy.formosaTheme.data.naturalMap, [1, 0, 3, 2, 4, 5]);
  });

  test('Check does fillingMap function returns correct words.', () {
    expect(medievalFantasy.formosaTheme.data.fillingMap(), [1, 0, 3, 2, 4, 5]);
    expect(cutePets.formosaTheme.data.fillingMap(), [2, 1, 0, 4, 3, 5]);
  });

  test('Check does restrictionIndexes function returns correct words.', () {
    expect(medievalFantasy.formosaTheme.data.restrictionIndexes(),
        [(1, 0), (0, 3), (0, 4), (3, 2), (4, 5)]);
    expect(cutePets.formosaTheme.data.restrictionIndexes(),
        [(2, 1), (1, 0), (1, 4), (4, 3), (4, 5)]);
  });

  test('Check does primeSyntacticLeads function returns correct words.', () {
    expect(medievalFantasy.formosaTheme.data.primeSyntacticLeads(), ['VERB']);
    expect(cutePets.formosaTheme.data.primeSyntacticLeads(), ['VERB']);
    expect(bip39_.formosaTheme.data.primeSyntacticLeads(), ['WORDS']);
  });

  test('Check does restrictionPairs function returns correct words.', () {
    expect(
        medievalFantasy.formosaTheme.data
            .restrictionPairs(['vi', 'bo', 'ni', 'bo', 'as', 'mo']),
        [('bo', 'vi'), ('vi', 'bo'), ('vi', 'as'), ('bo', 'ni'), ('as', 'mo')]);
    expect(bip39_.formosaTheme.data.restrictionPairs(['vi']), []);
  });

  group('getRelationIndexes', () {
    test('Test getRelationIndexes with strings.', () {
      expect(
          medievalFantasy.formosaTheme.data
              .getRelationIndexes(('VERB', 'borrow')),
          (1, 4));
    });

    test('Test getRelationIndexes with tuples.', () {
      expect(
          medievalFantasy.formosaTheme.data
              .getRelationIndexes((('VERB', 'SUBJECT'), ('borrow', 'wizard'))),
          (0, 63));
    });
  });

  test('Test getNaturalIndexes with set of sentences.', () {
    expect(
        medievalFantasy.formosaTheme.data.getNaturalIndexes(
            ['fisherman', 'ask_for', 'bronze', 'chains', 'spy', 'roof']),
        [23, 1, 4, 10, 58, 24]);
    expect(
        medievalFantasy.formosaTheme.data.getNaturalIndexes(
            ['rider', 'reach', 'rusty', 'gun', 'guard', 'cave']),
        [48, 21, 20, 26, 22, 6]);
  });

  test('Test getFillingIndexes with set of sentences.', () {
    expect(
        medievalFantasy.formosaTheme.data.getFillingIndexes(
            ['fisherman', 'ask_for', 'bronze', 'chains', 'spy', 'roof']),
        [1, 23, 10, 4, 58, 24]);
    expect(
        medievalFantasy.formosaTheme.data.getFillingIndexes(
            ['rider', 'reach', 'rusty', 'gun', 'guard', 'cave']),
        [21, 48, 26, 20, 22, 6]);
  });

  test('Test getPhraseAmount with set of words.', () {
    expect(
        medievalFantasy.formosaTheme.data.getPhraseAmount([
          'viscount',
          'borrow',
          'nickel',
          'boots',
          'astronomer',
          'monastery',
          'fisherman',
          'ask_for',
          'bronze',
          'chains',
          'spy',
          'roof',
          'rider',
          'reach',
          'rusty',
          'gun',
          'guard',
          'cave',
          'ventriloquist',
          'hide',
          'stimulating',
          'milk',
          'inventor',
          'circus',
          'wizard',
          'borrow',
          'wild',
          'flask',
          'tutor',
          'oracle'
        ]),
        5);
    expect(
        medievalFantasy.formosaTheme.data.getPhraseAmount([
          'vi',
          'bo',
          'ni',
          'bo',
          'as',
          'mo',
          'fi',
          'as',
          'br',
          'ch',
          'sp',
          'ro',
          'ri',
          're',
          'ru',
          'gu',
          'gu',
          'ca',
          've',
          'hi',
          'st',
          'mi',
          'in',
          'ci',
          'wi',
          'bo',
          'wi',
          'fl',
          'tu',
          'or'
        ]),
        5);
  });

  test('Test getSentences with set of words.', () {
    var result = [
      ['vi', 'bo', 'ni', 'bo', 'as', 'mo'],
      ['fi', 'as', 'br', 'ch', 'sp', 'ro'],
      ['ri', 're', 'ru', 'gu', 'gu', 'ca'],
      ['ve', 'hi', 'st', 'mi', 'in', 'ci'],
      ['wi', 'bo', 'wi', 'fl', 'tu', 'or']
    ];
    expect(
        medievalFantasy.formosaTheme.data.getSentences(
          'vi bo ni bo as mo fi as br ch sp ro ri re ru gu gu ca ve hi st mi in ci wi bo wi fl tu or',
        ),
        result);
    expect(
        medievalFantasy.formosaTheme.data.getSentences([
          'vi',
          'bo',
          'ni',
          'bo',
          'as',
          'mo',
          'fi',
          'as',
          'br',
          'ch',
          'sp',
          'ro',
          'ri',
          're',
          'ru',
          'gu',
          'gu',
          'ca',
          've',
          'hi',
          'st',
          'mi',
          'in',
          'ci',
          'wi',
          'bo',
          'wi',
          'fl',
          'tu',
          'or'
        ]),
        result);
  });

  test('Test getPhraseIndexes with list of words.', () {
    var result = [
      4,
      62,
      4,
      19,
      4,
      15,
      1,
      23,
      10,
      4,
      58,
      24,
      21,
      48,
      26,
      20,
      22,
      6,
      13,
      61,
      38,
      26,
      23,
      3,
      4,
      63,
      24,
      30,
      59,
      18
    ];
    expect(
        medievalFantasy.formosaTheme.data.getPhraseIndexes([
          'viscount',
          'borrow',
          'nickel',
          'boots',
          'astronomer',
          'monastery',
          'fisherman',
          'ask_for',
          'bronze',
          'chains',
          'spy',
          'roof',
          'rider',
          'reach',
          'rusty',
          'gun',
          'guard',
          'cave',
          'ventriloquist',
          'hide',
          'stimulating',
          'milk',
          'inventor',
          'circus',
          'wizard',
          'borrow',
          'wild',
          'flask',
          'tutor',
          'oracle'
        ]),
        result);
  });
  test('Test getPhraseIndexes with string.', () {
    var result = [
      4,
      62,
      4,
      19,
      4,
      15,
      1,
      23,
      10,
      4,
      58,
      24,
      21,
      48,
      26,
      20,
      22,
      6,
      13,
      61,
      38,
      26,
      23,
      3,
      4,
      63,
      24,
      30,
      59,
      18
    ];
    expect(
        medievalFantasy.formosaTheme.data.getPhraseIndexes(
            'viscount borrow nickel boots astronomer monastery fisherman ask_for bronze chains spy roof rider reach rusty gun guard cave ventriloquist hide stimulating milk inventor circus wizard borrow wild flask tutor oracle'),
        result);
  });

  test('Test getLedByIndex with various strings.', () {
    expect(medievalFantasy.formosaTheme.data.getLedByIndex('SUBJECT'), 1);
    expect(medievalFantasy.formosaTheme.data.getLedByIndex('WILDCARD'), 0);
    expect(medievalFantasy.formosaTheme.data.getLedByIndex('ADJECTIVE'), 3);
  });

  test('Test getLeadList with various strings.', () {
    expect(
        medievalFantasy.formosaTheme.data
            .getLeadList('SUBJECT', ['', 'borrow', '', '', '', '']),
        contains('actor'));
    expect(bip39_.formosaTheme.data.getLeadList('WORDS', ['']),
        containsAll(['speed', 'thing']));
  });

  test('Test assembleSentence with various data bits.', () {
    expect(
        medievalFantasy.formosaTheme.data
            .assembleSentence('000010110001110101010100011011001'),
        ['gardener', 'ask_for', 'rusty', 'stylus', 'brewer', 'square']);
    expect(
        medievalFantasy.formosaTheme.data
            .assembleSentence('110110001101110000001110100111011'),
        ['blacksmith', 'trust', 'bronze', 'sword', 'mercenary', 'temple']);
  });

  test('Test assembleSentence with various data bits.', () {
    expect(
        medievalFantasy.formosaTheme.data.getSentencesFromBits(
            '010000000001001110111010100101010111000100000110100001001000010101'),
        [
          'acolyte',
          'create',
          'indigenous',
          'milk',
          'ninja',
          'farm',
          'duke',
          'unveil',
          'bended',
          'handcuffs',
          'general',
          'portal'
        ]);
    expect(
        medievalFantasy.formosaTheme.data.getSentencesFromBits(
            '000110011101110011100111001110110000111111001000011000100101001110'),
        [
          'dancer',
          'bet',
          'spicy',
          'strawberry',
          'senator',
          'pyramid',
          'valkyrie',
          'bet',
          'oak',
          'lyre',
          'duke',
          'library'
        ]);
    expect(
        bip39_.formosaTheme.data.getSentencesFromBits(
            '000111100111011110010110110111000110001111011001011110010101100101'),
        ['bunker', 'royal', 'require', 'sibling', 'nurse', 'protect']);
    expect(
        cutePets.formosaTheme.data
            .getSentencesFromBits('101001100010001101110100101100100'),
        ['aware', 'service_dog', 'rescue', 'bulky', 'trainer', 'box']);
  });
}
