import 'package:GreatWall/knowledge/mnemonic.dart';
import 'package:flutter_test/flutter_test.dart'; 
import 'package:GreatWall/knowledge/themedict.dart';
import 'package:tuple/tuple.dart';
void main()  async {
    TestWidgetsFlutterBinding.ensureInitialized();
    

    final bip39            = Mnemonic("BIP39");
    final medieval_fantasy = Mnemonic("medieval_fantasy");
    final cute_pets        = Mnemonic("cute_pets");
    final sci_fi           = Mnemonic("sci-fi"); 

    await sci_fi.words_dictionary.storeJsonValues();
    await bip39.words_dictionary.storeJsonValues();
    await medieval_fantasy.words_dictionary.storeJsonValues();
    await cute_pets.words_dictionary.storeJsonValues();

     test('Check does storeJsonValues method works as expected', (){
      expect(bip39.words_dictionary.inner_dict[FILL_SEQUENCE_KEY], ['WORDS']);
      expect(bip39.words_dictionary.inner_dict[NATURAL_SEQUENCE_KEY],  ['WORDS']);
    });

    test('Check does is_bip39_theme function returns expected value.', () {
      expect(bip39.is_bip39_theme(), true);
      expect(medieval_fantasy.is_bip39_theme(),false);
      expect(cute_pets.is_bip39_theme(),false);
    }); 

     test('Check does filling_order function returns correct value for BIP39 and mediaval fantasy themes.', (){
      List<String> result = ["WORDS"];
      expect(bip39.words_dictionary.filling_order(), result);
      List<String> result2 = ["VERB", "SUBJECT", "OBJECT", "ADJECTIVE", "WILDCARD", "PLACE"];
      expect(medieval_fantasy.words_dictionary.filling_order(), result2);
    });

    test('Check does filling_order function returns correct value for BIP39.', (){
        List<String> result = ["WORDS"];
        expect(bip39.words_dictionary.natural_order(), result);
      });

    test('Check does filling_order function returns correct value for BIP39.', (){
        List<String> result = ["WORDS"];
        expect(bip39.words_dictionary.natural_order(), result);
      });

    test('Check does total_words function returns correct value for cute_pets theme.', (){
        expect((bip39.words_dictionary.getItem("WORDS")).inner_dict[TOTALS_KW], bip39.words_dictionary.total_words());
      });
      
    test('Check does bit_length function returns correct value for cute_pets theme.', (){
       var words = bip39.words_dictionary.getItem("WORDS");
         expect(words.bit_length(), 11);
      });


    test('Check does get_led_by_mapping function returns correct mapping.', (){
      expect(medieval_fantasy.words_dictionary.get_led_by_mapping("SUBJECT").inner_dict["advise_about"], 
                contains("acolyte"));
      expect(cute_pets.words_dictionary.get_led_by_mapping("SUBJECT").inner_dict["adopt"], 
                contains("abyssinian_cat"));  
    });

    test('Check does bits_per_phrase function returns correct sum of bit lenghts.', (){
      expect(bip39.words_dictionary.bits_per_phrase(), 11);
      expect(medieval_fantasy.words_dictionary.bits_per_phrase(), 33); 
      });
     
    test('Check does words_per_phrase function returns correct number of phrases.', (){
      expect(bip39.words_dictionary.words_per_phrase(), 1);
      expect(medieval_fantasy.words_dictionary.words_per_phrase(), 6); 
      });


    test('Check does wordlist function returns correct words.', (){
      expect(bip39.words_dictionary.wordlist(), contains("alpha"));
      expect(bip39.words_dictionary.wordlist(), contains("abuse")); 
      });
     
    test('Check does restriction_sequence function returns correct words.', (){
      expect(medieval_fantasy.words_dictionary.restriction_sequence()[0].item1, "VERB");
      expect(medieval_fantasy.words_dictionary.restriction_sequence()[2].item2, "WILDCARD"); 
      }); 


    test('Check does natural_index function returns correct words.', (){
      expect(medieval_fantasy.words_dictionary.natural_index("VERB"),1);
      expect(medieval_fantasy.words_dictionary.natural_index("SUBJECT"), 0); 
      expect(medieval_fantasy.words_dictionary.natural_index("WILDCARD"), 4); 
      expect(bip39.words_dictionary.natural_index("WORDS"), 0); 
      }); 


    test('Check does natural_map function returns correct words.', (){
      expect(medieval_fantasy.words_dictionary.natural_map(),[1, 0, 3, 2, 4, 5]); 
      }); 

    test('Check does filling_map function returns correct words.', (){
      expect(medieval_fantasy.words_dictionary.filling_map(),[1, 0, 3, 2, 4, 5]); 
      expect(cute_pets.words_dictionary.filling_map(), [2, 1, 0, 4, 3, 5]);
      });

    test('Check does restriction_indexes function returns correct words.', (){
      expect(medieval_fantasy.words_dictionary.restriction_indexes(),[Tuple2(1,0),Tuple2(0, 3),Tuple2(0, 4),Tuple2(3, 2),Tuple2(4, 5)]); 
      expect(cute_pets.words_dictionary.restriction_indexes(), [Tuple2(2, 1), Tuple2(1, 0), Tuple2(1, 4), Tuple2(4, 3), Tuple2(4, 5)]);
      });
    
    test('Check does prime_syntactic_leads function returns correct words.', (){
      expect(medieval_fantasy.words_dictionary.prime_syntactic_leads(), ["VERB"]); 
      expect(cute_pets.words_dictionary.prime_syntactic_leads(), ["VERB"]);
      expect(bip39.words_dictionary.prime_syntactic_leads(), ["WORDS"]);
      });

    test('Check does restriction_pairs function returns correct words.', (){
      expect(medieval_fantasy.words_dictionary.restriction_pairs(['vi', 'bo', 'ni', 'bo', 'as', 'mo']), [Tuple2('bo', 'vi'), Tuple2('vi', 'bo'), Tuple2('vi', 'as'), Tuple2('bo', 'ni'), Tuple2('as', 'mo')]); 
      expect(bip39.words_dictionary.restriction_pairs(['vi']), []);  
      }); 


    //work in progress
    

 
    
}