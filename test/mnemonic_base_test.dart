import 'package:mnemonic/mnemonic.dart';
import 'package:test/test.dart';

void main() async {
  final bip39 = Formosa(theme: Theme.bip39);
  final bip39French = Formosa(theme: Theme.bip39French);
  final cutePets = Formosa(theme: Theme.cutePets);
  final medievalFantasy = Formosa(theme: Theme.medievalFantasy);
  final sciFi = Formosa(theme: Theme.sciFi);

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

  test('Check does toMnemonic function returns appropriate set of words.', () {
    expect(bip39.toMnemonic([0xAA, 0xAA, 0xAA, 0xAA]), 'primary fetch primary');
    expect(bip39.toMnemonic([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]),
        'zoo zoo zoo zoo zoo zebra');
    expect(sciFi.toMnemonic([33, 254, 255, 33, 255, 56, 18, 51]),
        'cyborg buy li-fi welder skeptic death_star sniper warn_about deuterium hover automaton habitat');
    expect(bip39French.toMnemonic([33, 254, 255, 33, 255, 56, 18, 51]),
        'bourse véloce recevoir vorace inexact barbier');
  });

  test('Check does formatMnemonic function returns appropriate format.', () {
    expect(bip39.formatMnemonic(bip39.toMnemonic([0xAA, 0xAA, 0xAA, 0xAA])),
        'primfetcprim');
    expect(
        bip39.formatMnemonic(
            bip39.toMnemonic([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])),
        'zoo-zoo-zoo-zoo-zoo-zebr');
  });

  test('Check does to_entropy function returns good value.', () {
    List<int> randomEntropy = [33, 255, 255, 33, 255, 56, 18, 51];
    expect(bip39.toEntropy(bip39.toMnemonic(randomEntropy)), randomEntropy);
  });
}
