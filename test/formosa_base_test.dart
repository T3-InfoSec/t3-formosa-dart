import 'package:t3_formosa/formosa.dart';
import 'package:test/test.dart';

void main() async {
  final bip39 = Formosa(formosaTheme: FormosaTheme.bip39);
  final bip39French = Formosa(formosaTheme: FormosaTheme.bip39French);
  final cutePets = Formosa(formosaTheme: FormosaTheme.cutePets);
  final medievalFantasy = Formosa(formosaTheme: FormosaTheme.medievalFantasy);
  final sciFi = Formosa(formosaTheme: FormosaTheme.sciFi);

  test('Check does isBip39Theme function returns expected value.', () {
    expect(bip39.isBip39Theme(), true);
    expect(medievalFantasy.isBip39Theme(), false);
    expect(cutePets.isBip39Theme(), false);
    expect(sciFi.isBip39Theme(), false);
  });

  test('Check does detectTheme function finds appropriate theme.', () {
    expect(bip39.detectTheme(['ability']), 'bip39');
    expect(bip39.detectTheme(['aboutir']), 'bip39_french');
    expect(medievalFantasy.detectTheme(['acidic']), 'medieval_fantasy');
    expect(cutePets.detectTheme(['feeder']), 'cute_pets');
    expect(sciFi.detectTheme(['4d']), 'sci_fi');
  });

  test('Check does toFormosa function returns appropriate set of words.', () {
    expect(bip39.toFormosa([0xAA, 0xAA, 0xAA, 0xAA]), 'primary fetch primary');
    expect(bip39.toFormosa([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]), 'zoo zoo zoo zoo zoo zebra');
    expect(sciFi.toFormosa([33, 254, 255, 33, 255, 56, 18, 51]),
        'cyborg buy li-fi welder skeptic death_star sniper warn_about deuterium hover automaton habitat');
    expect(
        bip39French.toFormosa([33, 254, 255, 33, 255, 56, 18, 51]), 'bourse véloce recevoir vorace inexact barbier');
  });

  test('Check does formatFormosa function returns appropriate format.', () {
    expect(bip39.formatFormosa(bip39.toFormosa([0xAA, 0xAA, 0xAA, 0xAA])), 'primfetcprim');
    expect(bip39.formatFormosa(bip39.toFormosa([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])),
        'zoo-zoo-zoo-zoo-zoo-zebr');
  });

  test('Check does to_entropy function returns good value.', () {
    List<int> randomEntropy = [33, 255, 255, 33, 255, 56, 18, 51];
    expect(bip39.toEntropy(bip39.toFormosa(randomEntropy)), randomEntropy);
  });

  test('Check expandPassword returns the expanded password. bip29 divisible by 4', () {
    String password = "pfpzcbrodjengjrenjhnjrthlhnthnjn";
    String expandedPassword = bip39.expandPassword(password);
    expect(expandedPassword, isNot(equals(password)));
  });

  test('Check expandPassword returns the expanded password.', () {
    String password = "pfpzcnthnjn";
    String expandedPassword = bip39.expandPassword(password);
    expect(expandedPassword, equals(password));
  });

  test('Check expandWord returns the correct expanded word.', () {
    String word = "primary";
    String expandedWord = bip39.expandWord(word);
    expect(expandedWord, "primary");
  });

  test('Check expand returns the correct expanded mnemonic.', () {
    String mnemonic = "primary fetch primary";
    String expandedMnemonic = bip39.expand(mnemonic);
    expect(expandedMnemonic, equals(mnemonic));
  });

  test('Check expandWord handles word expansion correctly in sciFi theme.', () {
    String word = "cyborg";
    String expandedWord = sciFi.expandWord(word);
    expect(expandedWord, isNotEmpty);
  });

  test('Check expand handles mnemonic expansion in cutePets theme.', () {
    String mnemonic = "feeder pet toy";
    String expandedMnemonic = cutePets.expand(mnemonic);
    print(expandedMnemonic);
    expect(expandedMnemonic.split(" ").length, equals(3));
  });

  test('Check expandPassword handles edge cases for bip39 theme.', () {
    String password = "";
    String expandedPassword = bip39.expandPassword(password);
    expect(expandedPassword, equals(password));
  });
  test('Check formatFormosa handles BIP39 formatting correctly.', () {
    String bip39Formatted = bip39.formatFormosa('ability about above');
    expect(bip39Formatted, equals('abilabouabov'));
    String shortWordFormatted = bip39.formatFormosa('arm zoo');
    expect(shortWordFormatted, equals('arm-zoo-'));
  });

  test('Check formatFormosa handles non-BIP39 formatting (Sci-Fi theme).', () {
    String sciFiFormatted = sciFi.formatFormosa('cyborg laser plasma');
    expect(sciFiFormatted, equals('cylapl'));

    String shortWordSciFiFormatted = sciFi.formatFormosa('4d');
    expect(shortWordSciFiFormatted, equals('4d'));
  });

  test('Check formatFormosa works when input is a list.', () {
    String bip39FormattedFromList = bip39.formatFormosa(['ability', 'about', 'above']);
    expect(bip39FormattedFromList, equals('abilabouabov'));
  });

  test('Check formatFormosa with empty input.', () {
    String emptyFormatted = bip39.formatFormosa('');
    expect(emptyFormatted, equals(''));

    String emptyListFormatted = bip39.formatFormosa([]);
    expect(emptyListFormatted, equals(''));
  });
}
