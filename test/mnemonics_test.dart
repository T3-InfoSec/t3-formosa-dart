import 'package:GreatWall/knowledge/mnemonic.dart'; 
import 'package:flutter_test/flutter_test.dart';  

void main()  async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final bip39            = Mnemonic("BIP39");
    final bip39french     = Mnemonic("BIP39_french");
    final medievalfantasy = Mnemonic("medievalfantasy");
    final cutepets        = Mnemonic("cutepets");
    final scifi           = Mnemonic("sci-fi");  
    test('Check does isBip39Theme function returns expected value.', () {
      expect(bip39.isBip39Theme(), true);
      expect(medievalfantasy.isBip39Theme(),false);
      expect(cutepets.isBip39Theme(),false);
      expect(scifi.isBip39Theme(), false);
    }); 
    test('Check does detectTheme function finds appropriate theme.', () {
      expect(bip39.detectTheme(["ability"]), "BIP39");
      expect(medievalfantasy.detectTheme(["acidic"]),"medievalfantasy");
      expect(cutepets.detectTheme(["feeder"]), "cutepets");
      expect(scifi.detectTheme(["4d"]),"sci-fi");
    });

    test('Check does toMnemonic function returns appropriate set of words.', () {
      expect(bip39.toMnemonic([0xAA, 0xAA, 0xAA, 0xAA]), "primary fetch primary"); 
      expect(bip39.toMnemonic([0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF]), "zoo zoo zoo zoo zoo zebra");
      expect(scifi.toMnemonic([33,254,255,33,255,56,18,51]), "cyborg buy li-fi welder skeptic death_star sniper warn_about deuterium hover automaton habitat");
      expect(bip39french.toMnemonic([33,254,255,33,255,56,18,51]), "bourse véloce recevoir vorace inexact barbier");
      
    });

    test('Check does formatMnemonic function returns appropriate format.', () {
      expect(bip39.formatMnemonic(bip39.toMnemonic([0xAA, 0xAA, 0xAA, 0xAA])), "primfetcprim"); 
      expect(bip39.formatMnemonic(bip39.toMnemonic([0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF])), "zoo-zoo-zoo-zoo-zoo-zebr");
   
    }); 

    test('Check does to_entropy function returns good value.', () {
      List<int> randomEntropy = [33,255,255,33,255,56,18,51];  
      expect(bip39.toEntropy(bip39.toMnemonic(randomEntropy)),randomEntropy);  
     }); 
  
}