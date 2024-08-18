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
    expect(bip39.toFormosa([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]),
        'zoo zoo zoo zoo zoo zebra');
    expect(sciFi.toFormosa([33, 254, 255, 33, 255, 56, 18, 51]),
        'cyborg buy li-fi welder skeptic death_star sniper warn_about deuterium hover automaton habitat');
    expect(bip39French.toFormosa([33, 254, 255, 33, 255, 56, 18, 51]),
        'bourse véloce recevoir vorace inexact barbier');
  });

  test('Check does formatFormosa function returns appropriate format.', () {
    expect(bip39.formatFormosa(bip39.toFormosa([0xAA, 0xAA, 0xAA, 0xAA])),
        'primfetcprim');
    expect(
        bip39.formatFormosa(
            bip39.toFormosa([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])),
        'zoo-zoo-zoo-zoo-zoo-zebr');
  });

  test('Check does to_entropy function returns good value.', () {
    List<int> randomEntropy = [33, 255, 255, 33, 255, 56, 18, 51];
    expect(bip39.toEntropy(bip39.toFormosa(randomEntropy)), randomEntropy);
  });
}
