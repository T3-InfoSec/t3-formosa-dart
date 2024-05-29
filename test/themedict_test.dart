import 'package:GreatWall/knowledge/mnemonic.dart';
import 'package:flutter_test/flutter_test.dart'; 
import 'package:GreatWall/knowledge/themedict.dart';
import 'package:tuple/tuple.dart';

final bip39            = Mnemonic("BIP39");
final medieval_fantasy = Mnemonic("medieval_fantasy");
final cute_pets        = Mnemonic("cute_pets");
final sci_fi           = Mnemonic("sci-fi"); 


void setUpAll() async {
  //Loads theme files to Mnemonic objects.
  TestWidgetsFlutterBinding.ensureInitialized(); 
  await sci_fi.words_dictionary.storeJsonValues();
  await bip39.words_dictionary.storeJsonValues();
  await medieval_fantasy.words_dictionary.storeJsonValues();
  await cute_pets.words_dictionary.storeJsonValues();
}


void main()  async {
    //preparing test enviroment
    setUpAll();


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


    group('getRelationIndexes', () {
    test('Test getRelationIndexes with strings.', () {
      expect(medieval_fantasy.words_dictionary.getRelationIndexes(Tuple2("VERB", "borrow")), Tuple2(1,4));
    });

    test('Test getRelationIndexes with tuples.', () { 
      expect(medieval_fantasy.words_dictionary.getRelationIndexes(Tuple2(Tuple2('VERB', 'SUBJECT'), Tuple2('borrow', 'wizard'))), Tuple2(0,63));
    }); 
  });

  test('Test getNaturalIndexes with set of sentences.', () {
      expect(medieval_fantasy.words_dictionary.getNaturalIndexes(["fisherman", "ask_for", "bronze", "chains", "spy", "roof"]), [23, 1, 4, 10, 58, 24]);
      expect(medieval_fantasy.words_dictionary.getNaturalIndexes(["rider", "reach", "rusty", "gun", "guard", "cave"]),[48, 21, 20, 26, 22, 6]);
    }); 



   test('Test get_filling_indexes with set of sentences.', () {
      expect(medieval_fantasy.words_dictionary.get_filling_indexes(["fisherman", "ask_for", "bronze", "chains", "spy", "roof"]), [1, 23, 10, 4, 58, 24]);
      expect(medieval_fantasy.words_dictionary.get_filling_indexes(["rider", "reach", "rusty", "gun", "guard", "cave"]), [21, 48, 26, 20, 22, 6]);
    });  

    test('Test get_phrase_amount with set of words.', () {
      expect(medieval_fantasy.words_dictionary.get_phrase_amount(["viscount", "borrow", "nickel", "boots", "astronomer", "monastery", "fisherman", "ask_for", "bronze", "chains", "spy", "roof", "rider", "reach", "rusty", "gun", "guard", "cave", "ventriloquist", "hide", "stimulating", "milk", "inventor", "circus", "wizard", "borrow", "wild", "flask", "tutor", "oracle"]),
      5);
      expect(medieval_fantasy.words_dictionary.get_phrase_amount(["vi", "bo", "ni", "bo", "as", "mo", "fi", "as", "br", "ch", "sp", "ro", "ri", "re", "ru", "gu", "gu", "ca", "ve", "hi", "st", "mi", "in", "ci", "wi", "bo", "wi", "fl", "tu", "or"]),
      5);
    });

    test('Test get_sentences with set of words.', () {
      var result = [["vi", "bo", "ni", "bo", "as", "mo"], ["fi", "as", "br", "ch", "sp", "ro"], ["ri", "re", "ru", "gu", "gu", "ca"], ["ve", "hi", "st", "mi", "in", "ci"], ["wi", "bo", "wi", "fl", "tu", "or"]];
      expect(medieval_fantasy.words_dictionary.get_sentences("vi  bo  ni  bo  as  mo  fi  as  br  ch  sp  ro  ri  re  ru  gu  gu  ca  ve  hi  st  mi  in  ci  wi  bo  wi  fl  tu  or"),
              result);
      expect(medieval_fantasy.words_dictionary.get_sentences(["vi", "bo", "ni", "bo", "as", "mo", "fi", "as", "br", "ch", "sp", "ro", "ri", "re", "ru", "gu", "gu", "ca", "ve", "hi", "st", "mi", "in", "ci", "wi", "bo", "wi", "fl", "tu", "or"]),
              result);
      });
 
    test('Test get_phrase_indexes with list of words.', () {
      var result = [4, 62, 4, 19, 4, 15, 1, 23, 10, 4, 58, 24, 21, 48, 26, 20, 22, 6, 13, 61, 38, 26, 23, 3, 4, 63, 24, 30, 59, 18];
      expect(medieval_fantasy.words_dictionary.get_phrase_indexes(["viscount", "borrow", "nickel", "boots", "astronomer", "monastery", "fisherman", "ask_for", "bronze", "chains", "spy", "roof", "rider", "reach", "rusty", "gun", "guard", "cave", "ventriloquist", "hide", "stimulating", "milk", "inventor", "circus", "wizard", "borrow", "wild", "flask", "tutor", "oracle"]),
              result);
      });
    test('Test get_phrase_indexes with string.', () {
      var result = [4, 62, 4, 19, 4, 15, 1, 23, 10, 4, 58, 24, 21, 48, 26, 20, 22, 6, 13, 61, 38, 26, 23, 3, 4, 63, 24, 30, 59, 18];
      expect(medieval_fantasy.words_dictionary.get_phrase_indexes( "viscount borrow nickel boots astronomer monastery fisherman ask_for bronze chains spy roof rider reach rusty gun guard cave ventriloquist hide stimulating milk inventor circus wizard borrow wild flask tutor oracle"),
              result);
      });

    test('Test get_led_by_index with various strings.', () {
       expect(medieval_fantasy.words_dictionary.get_led_by_index("SUBJECT"), 1);
       expect(medieval_fantasy.words_dictionary.get_led_by_index("WILDCARD"), 0);
       expect(medieval_fantasy.words_dictionary.get_led_by_index("ADJECTIVE"),3);

      });

    test('Test get_lead_list with various strings.', () {
       expect(medieval_fantasy.words_dictionary.get_lead_list("SUBJECT", ["","borrow","","","",""]), contains("actor"));
       expect(bip39.words_dictionary.get_lead_list("WORDS", [""]), containsAll(["speed", "thing"]));
    });

    test('Test assemble_sentence with various data bits.', () {
      expect(medieval_fantasy.words_dictionary.assemble_sentence("000010110001110101010100011011001"), ["gardener", "ask_for", "rusty", "stylus", "brewer", "square"]);
      expect(medieval_fantasy.words_dictionary.assemble_sentence("110110001101110000001110100111011"), ["blacksmith", "trust", "bronze", "sword", "mercenary", "temple"]);
    });

    test('Test assemble_sentence with various data bits.', () {
      expect(medieval_fantasy.words_dictionary.get_sentences_from_bits("010000000001001110111010100101010111000100000110100001001000010101"),["acolyte", "create", "indigenous", "milk", "ninja", "farm", "duke", "unveil", "bended", "handcuffs", "general", "portal"]);
      expect(medieval_fantasy.words_dictionary.get_sentences_from_bits("000110011101110011100111001110110000111111001000011000100101001110"), ["dancer", "bet", "spicy", "strawberry", "senator", "pyramid", "valkyrie", "bet", "oak", "lyre", "duke", "library"]);
      expect(bip39.words_dictionary.get_sentences_from_bits("000111100111011110010110110111000110001111011001011110010101100101"), ["bunker", "royal", "require", "sibling", "nurse", "protect"]);
      expect(cute_pets.words_dictionary.get_sentences_from_bits("101001100010001101110100101100100"), ["aware", "service_dog", "rescue", "bulky", "trainer", "box"]);
    });
    //work in progress
}