import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class TableSelectorMobile extends StatefulWidget {
  const TableSelectorMobile({
    required this.wordSource,
    required this.onWordSelected,
    super.key,
  });

  final List<String> wordSource;
  final Function(bool, String) onWordSelected;

  @override
  State<TableSelectorMobile> createState() => _TableSelectorMobileState();
}

class _TableSelectorMobileState extends State<TableSelectorMobile> {
  
  static const platform = MethodChannel('com.example.formosa_app.volume_buttons');

  Future<void> _startListeningForVolumeTap() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onVolumeButtonPressed') {
        final button = call.arguments['button'];
        final pressType = call.arguments['pressType'];
        setState(() {
          String vBtn = button.toString().split('_').last;
          if (pressType == 'short') {
            _onDirectionTapped(vBtn);
          }
          if (pressType == 'long') {
            if (vBtn == 'up') {
              _goToNextPage();
            } else {
              _goToPreviousPage();
            }
          }
        });
      }
    });
  }

  List<String> rowCombinations = [
    'up-down',
    'down-up',
    'up-up',
    'down-down',
  ];

  List<String> columnCombinations = [
    'up-down-up-down',
    'down-up-down-up',
    'up-up-down-down',
    'down-down-up-up',
    'up-down-down-up',
    'down-up-up-down',
    'up-up-up-down',
    'down-down-down-up',
  ];

  List<String> wordsSource32 = [];
  int currentPage = 0;
  final int wordsPerPage = 32;

  bool isShowHighlight = true;
  String combinationInputHz = '';
  String combinationInputVt = '';
  bool capturingHorizontal = true;

  void _handleInput(String input) {
    if (capturingHorizontal) {
      combinationInputHz = _updateCombination(combinationInputHz, input);
      if (combinationInputHz.split('-').length == 4) {
        capturingHorizontal = false;
      }
    } else {
      combinationInputVt = _updateCombination(combinationInputVt, input);
      if (combinationInputVt.split('-').length == 2) {
        _finalizeCombination();
      }
    }
  }

  String _updateCombination(String existingCombination, String newInput) {
    if (existingCombination.isEmpty) {
      return newInput;
    }
    return "$existingCombination-$newInput";
  }

  void _finalizeCombination() {
    String combined = '$combinationInputHz~$combinationInputVt';

    setState(() {
      selectedCombination.add(combined);
    });

    // Find the matching word for the combination
    String? selectedWord;
    for (var wordEntry in wordsSource32) {
      List<String> parts = wordEntry.split('~');
      String hzCombination = parts[0];
      String vtCombination = parts[1];
      if (hzCombination == combinationInputHz && vtCombination == combinationInputVt) {
        selectedWord = parts[2]; // The word is the third part
        break;
      }
    }

    // Reset for next capturing session
    combinationInputHz = '';
    combinationInputVt = '';
    capturingHorizontal = true;

    final hzAndVt = selectedCombination.toList().join('~');
    final hzAndVtCount = hzAndVt.split('~').length;

    if (hzAndVtCount == 2) {
      Future.delayed(const Duration(seconds: 2), () {
        _randomizeCombinations();
        if (selectedWord != null) {
          widget.onWordSelected(true, selectedWord);
        }
        setState(() {
          selectedCombination.clear();
        });
      });
    }
  }

  void _onDirectionTapped(String direction) {
    _handleInput(direction);
  }

  Set<String> selectedCombination = {};

  @override
  void initState() {
    super.initState();
    _startListeningForVolumeTap();
    _updateWordsForPage(currentPage);
    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _updateWordsForPage(int page) {
    int start = page * wordsPerPage;
    int end = start + wordsPerPage;

    setState(() {
      wordsSource32 = widget.wordSource
          .sublist(
            start,
            end > widget.wordSource.length ? widget.wordSource.length : end,
          )
          .asMap()
          .entries
          .map((entry) {
        int index = entry.key;
        String word = entry.value;

        int rowIndex = index ~/ 8; // Determine the row index
        int colIndex = index % 8; // Determine the column index
        String combination = "${columnCombinations[colIndex]}~${rowCombinations[rowIndex]}";
        return "$combination~$word";
      }).toList();
    });
  }

  void _goToNextPage() {
    if ((currentPage + 1) * wordsPerPage < widget.wordSource.length) {
      setState(() {
        currentPage++;
        _updateWordsForPage(currentPage);
      });
      _longVibrate();
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        _updateWordsForPage(currentPage);
      });
      _longVibrate();
    }
  }

  Future<void> _longVibrate() async {
    if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      await Vibration.vibrate(duration: 1000);
    } else {
      Vibration.vibrate();
      await Future.delayed(const Duration(milliseconds: 500));
      await Vibration.vibrate();
    }
  }

  void _randomizeCombinations() {
    setState(() {
      rowCombinations.shuffle();
      columnCombinations.shuffle();
      _updateWordsForPage(currentPage); // Update grid after shuffling
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anti-Side-Channel Attack Table'),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onLongPress: _goToPreviousPage,
            onTap: () => _onDirectionTapped('down'),
            child: const FloatingActionButton.small(
              elevation: 0,
              onPressed: null,
              child: Icon(Icons.arrow_downward),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => _onDirectionTapped('up'),
            onLongPress: _goToNextPage,
            child: const FloatingActionButton.small(
              elevation: 0,
              onPressed: null,
              child: Icon(Icons.arrow_upward),
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              setState(() {
                isShowHighlight = !isShowHighlight;
              });
            },
            child: Row(
              children: [
                Text('${isShowHighlight ? 'Hide' : 'Show'} Highlight'),
                Checkbox.adaptive(
                  value: isShowHighlight,
                  onChanged: (v) {
                    isShowHighlight = v ?? false;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        left: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(2),
              9: FlexColumnWidth(2),
            },
            defaultColumnWidth: const FlexColumnWidth(5),
            children: [
              _buildHeaderRow(),
              ..._buildDataRows(),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        const SizedBox(),
        ...columnCombinations.map(
          (combination) {
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CombinationIcons(
                combinationString: combination,
                iconSize: 16,
                iconColor: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        ),
        const SizedBox(),
      ],
    );
  }

  List<TableRow> _buildDataRows() {
    List<TableRow> rows = [];

    for (int i = 0; i < rowCombinations.length; i++) {
      rows.add(
        TableRow(
          children: [
            // Left side panel (row combination)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: CombinationIcons(combinationString: rowCombinations[i], iconSize: 16),
            ),

            // Middle grid items (words)
            ...List.generate(8, (colIndex) {
              int wordIndex = i * 8 + colIndex;
              if (wordIndex < wordsSource32.length) {
                String combinedWord = wordsSource32[wordIndex];
                String hzCombination = combinedWord.split('~').first;
                String vtCombination = combinedWord.split('~')[1];
                String displayWord = combinedWord.split('~').last;

                String gridCombination = '$hzCombination~$vtCombination';

                bool isHighlighted = isShowHighlight && selectedCombination.contains(gridCombination);

                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isHighlighted ? Colors.green.withOpacity(0.4) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(bottom: 32),
                      child: GestureDetector(
                        onTap: () {
                          if (kDebugMode) {
                            print('Tapped: $displayWord');
                          }
                        },
                        child: Text(
                          displayWord,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isHighlighted ? Colors.white : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),

            // Right side panel (optional)
            const SizedBox(),
          ],
        ),
      );
    }

    return rows;
  }
}

class CombinationIcons extends StatelessWidget {
  const CombinationIcons({
    required this.combinationString,
    this.iconSize = 32,
    this.iconColor,
    super.key,
  });

  final String combinationString;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    List<String> upDowns = combinationString.split('-');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        upDowns.length,
        (index) {
          String ud = upDowns[index];

          switch (ud) {
            case 'up':
              return Icon(Icons.arrow_upward, size: iconSize, color: iconColor);
            case 'down':
              return Icon(Icons.arrow_downward, size: iconSize, color: iconColor);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
