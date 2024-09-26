import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formosa_app/table_selector_desktop.dart';
import 'package:formosa_app/table_selector_mobile.dart';
import 'package:t3_formosa/formosa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedOrderIndex = 0;
  String _currentOrder = '';
  List<String> _nOrder = [];
  List<String> wordSource = [];
  FormosaTheme formosaTheme = FormosaTheme.formosaGLobal;
  int sentenceCount = 1;
  List<String> addedWordToSentence = [];
  late Formosa formosa;

  @override
  void initState() {
    super.initState();
    formosa = Formosa(formosaTheme: formosaTheme);
    setState(() {
      _nOrder = formosa.formosaTheme.data.naturalOrder;
      _currentOrder = _nOrder[_selectedOrderIndex];
      wordSource = _getListByOrder(_currentOrder); // Initialize wordSource
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: wordSource.isEmpty
            ? const SizedBox()
            : LayoutBuilder(builder: (context, constraints) {
                if (Platform.isAndroid || Platform.isIOS) {
                  return TableSelectorMobile(
                    wordSource: wordSource,
                    wLabel: '${_selectedOrderIndex + 1} of ${_nOrder.length} - ($_currentOrder)',
                    onWordSelected: (isValid, word) {
                      if (isValid) {
                        setState(() {
                          // Update the current order first
                          if (_selectedOrderIndex < _nOrder.length - 1) {
                            // Increment only if there's a next order
                            _selectedOrderIndex++;
                            _currentOrder = _nOrder[_selectedOrderIndex];
                            print('CURRENT ORDER $_currentOrder');
                            wordSource = _getListByOrder(_currentOrder);
                          } else {
                            // Process is done, show completion dialog
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) => const AlertDialog.adaptive(
                                title: Text("Done"),
                                content: Text('Process is completed!'),
                              ),
                            );
                          }
                          // Now add the word to the sentence after updating the index
                          addedWordToSentence.add(word);
                        });
                      }
                    },
                  );
                } else {
                  return SingleChildScrollView(
                    child: TableSelectorDesktop(
                      wordSource: wordSource,
                      onWordSelected: (bool isValid) {
                        if (isValid) {
                          setState(() {
                            // Update the current order first
                            if (_selectedOrderIndex < _nOrder.length - 1) {
                              _selectedOrderIndex++;
                              _currentOrder = _nOrder[_selectedOrderIndex];
                              wordSource = _getListByOrder(_currentOrder);
                            } else {
                              // Process is done, show completion dialog
                              showAdaptiveDialog(
                                context: context,
                                builder: (context) => const AlertDialog.adaptive(
                                  title: Text("Done"),
                                  content: Text('Process is completed!'),
                                ),
                              );
                            }
                            // Now add the word to the sentence after updating the index
                            // addedWordToSentence.add(word); // Uncomment this if needed
                          });
                        }
                      },
                    ),
                  );
                }
              }),
      ),
    );
  }

  List<String> _getListByOrder(String order) {
    return List.from(formosa.formosaTheme.data[order]["TOTAL_LIST"]);
  }
}
