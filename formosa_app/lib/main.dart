import 'package:flutter/material.dart';
import 'package:formosa_app/table_selector.dart';
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
  FormosaTheme formosaTheme = FormosaTheme.medievalFantasy;
  late Formosa formosa;
  @override
  void initState() {
    super.initState();
    formosa = Formosa(formosaTheme: formosaTheme);
    setState(() {
      _nOrder = formosa.formosaTheme.data.naturalOrder;
      _currentOrder = _nOrder[_selectedOrderIndex];
      List<String> initialTarget = _getListByOrder(_currentOrder);
      wordSource = initialTarget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Side Attack Table')),
        body: wordSource.isEmpty
            ? const SizedBox()
            : SingleChildScrollView(
                child: LabelGrid(
                  wordSource: wordSource,
                  onWordSelected: (bool isValid) {
                    if (isValid) {
                      setState(() {
                        if (_selectedOrderIndex + 1 < _nOrder.length) {
                          _selectedOrderIndex++;
                        } else {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) => const AlertDialog.adaptive(
                              title: Text("Done"),
                              content: Text('Process is completed!'),
                            ),
                          );
                          return;
                        }
                        _currentOrder = _nOrder[_selectedOrderIndex];

                        final nextTarget = _getListByOrder(_currentOrder);

                        wordSource = nextTarget;
                      });
                    }
                  },
                ),
              ),
      ),
    );
  }

  List<String> _getListByOrder(String order) {
    List<String> list = List.from(formosa.formosaTheme.data[order]["TOTAL_LIST"]);
    return list;
  }
}
