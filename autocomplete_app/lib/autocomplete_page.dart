import 'package:autocomplete/autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:t3_formosa/formosa.dart';

class AutocompletePage extends StatefulWidget {
  const AutocompletePage({super.key});

  @override
  State<AutocompletePage> createState() => _AutocompletePageState();
}

class _AutocompletePageState extends State<AutocompletePage> {
  final TextEditingController searchController = TextEditingController();
  FormosaAutocomplete _autocomplete = FormosaAutocomplete(theme: FormosaTheme.bip39);
  FormosaTheme _theme = FormosaTheme.bip39;
  String _previousSelection = '';
  List<String> _searchResults = [];
  List<String> _selectedWords = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autocomplete App'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: DropdownButton<FormosaTheme>(
            value: _theme,
            items: FormosaTheme.values.map<DropdownMenuItem<FormosaTheme>>((FormosaTheme value) {
              return DropdownMenuItem<FormosaTheme>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
            onChanged: (FormosaTheme? newValue) {
              setState(() {
                _theme = newValue ?? FormosaTheme.bip39;
                _autocomplete = FormosaAutocomplete(theme: _theme);
                _searchResults = [];
                searchController.clear();
                _selectedWords = [];
                _previousSelection = '';
              });
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Expanded(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: searchController,
                      onChanged: (String query) {
                        setState(() {
                          _previousSelection = _selectedWords.isNotEmpty ? _selectedWords.last : '';
                          _searchResults = _autocomplete.start(query, previousSelection: _previousSelection);
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        hintText: 'Type a word',
                      ),
                    ),
                    searchController.text.isEmpty
                        ? Container()
                        : Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                itemCount: _searchResults.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        _selectedWords.add(_searchResults[index]);
                                        _searchResults = [];
                                        searchController.clear();
                                      });
                                    },
                                    title: Text(_searchResults[index]),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 40)
                    .copyWith(bottom: 100),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  border: Border.all(color: Colors.blue.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _selectedWords
                      .map((String word) => Chip(
                            label: Text(word),
                            onDeleted: () {
                              setState(() {
                                _selectedWords.remove(word);
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
