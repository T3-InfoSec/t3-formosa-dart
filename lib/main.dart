import 'package:GreatWall/knowledge/mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

Mnemonic m = Mnemonic("cute_pets");
void main() async {
  
  runApp(const MyApp());
  await m.words_dictionary.storeJsonValues();
  // print(m.words_dictionary.inner_dict);
  print("");
  // print(m.words_dictionary.getItem("VERB").getItem("SUBJECT").mapping().inner_dict);
  // print(m.words_dictionary.get_sentences_from_bits("101001100010001101110100101100100"));
  m.find_themes();
  // print(m.words_dictionary.get_phrase_amount(["vi", "bo", "ni", "bo", "as", "mo", "fi", "as", "br", "ch", "sp", "ro", "ri", "re", "ru", "gu", "gu", "ca", "ve", "hi", "st", "mi", "in", "ci", "wi", "bo", "wi", "fl", "tu", "or"]));
  // print(m.words_dictionary.get_filling_indexes(["rider", "reach", "rusty", "gun", "guard", "cave"]));
  // print(m.words_dictionary.getRelationIndexes( Tuple2(Tuple2("VERB", "SUBJECT"), Tuple2("borrow", "wizard"))));
 
  // print(m.words_dictionary.total_words());
  // print("f");
  // print((m.words_dictionary.getItem("WORDS")).inner_dict["TOTAL_LIST"]);
  // var h = m.words_dictionary.getItem("WILDCARD"); 
  // print(h.inner_dict);
  // print(h.bit_length());
  // m.words_dictionary.setItem("OBJECT", h.inner_dict);
  // print(m.words_dictionary.inner_dict["OBJECT"]);
  // print(m.words_dictionary.filling_order());
  // print(m.words_dictionary.natural_order());
  // print(m.words_dictionary.total_words());
  // print(m.words_dictionary.leads());
  // print(m.words_dictionary.mapping());
  // print(m.words_dictionary.bit_length());
  // print(m.words_dictionary.led_by());
  // print(m.words_dictionary.led_by());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Center(child: Column(
              children: <Widget>[
                                SizedBox(height: 50,),
                                Image.asset('pictures/logo_big.jpg',
                                height: 400,
                                scale: 4,)
                                ]),
          
          ), 
      )
    );
  }
}
 