import 'package:GreatWall/knowledge/mnemonic.dart';
import 'package:flutter_test/flutter_test.dart';  

void main()  async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final bip39            = Mnemonic("BIP39");
    final medieval_fantasy = Mnemonic("medieval_fantasy");
    final cute_pets        = Mnemonic("cute_pets");
    final sci_fi           = Mnemonic("sci-fi");  
    test('Check does is_bip39_theme function returns expected value.', () {
      expect(bip39.is_bip39_theme(), true);
      expect(medieval_fantasy.is_bip39_theme(),false);
      expect(cute_pets.is_bip39_theme(),false);
    }); 
    test('Check does detect_theme function finds appropriate theme.', () {
      expect(bip39.detect_theme(["ability"]), "BIP39"); 
    });

    test('Check does to_mnemonic function returns appropriate set of words.', () {
      expect(bip39.to_mnemonic([0xAA, 0xAA, 0xAA, 0xAA]), "primary fetch primary"); 
      expect(bip39.to_mnemonic([0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF]), "zoo zoo zoo zoo zoo zebra");
    });

    test('Check does format_mnemonic function returns appropriate format.', () {
      expect(bip39.format_mnemonic(bip39.to_mnemonic([0xAA, 0xAA, 0xAA, 0xAA])), "primfetcprim"); 
      expect(bip39.format_mnemonic(bip39.to_mnemonic([0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF])), "zoo-zoo-zoo-zoo-zoo-zebr");
    }); 
 
    



  
}