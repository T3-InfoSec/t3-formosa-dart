import 'package:autocomplete/autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutocompletePage extends StatefulWidget {
  const AutocompletePage({super.key});

  @override
  State<AutocompletePage> createState() => _AutocompletePageState();
}

class _AutocompletePageState extends State<AutocompletePage> {
  Offset _suggestionOffset = Offset.zero;
  bool isErrorMessageVisible = false;
  bool showSuggestions = false;
  List<String> _suggestions = [];
  int selectedIndex = -1;
  List<String> _selectedWords = [];
  //
  final TextEditingController _controller = TextEditingController();
  FocusNode _textfieldFocusNode = FocusNode();
  FocusNode _mainFocus = FocusNode();

  //

  void _updateSuggestionPosition() {
    if (_controller.selection.baseOffset == -1) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final caretPosition = _controller.selection.baseOffset;
    final textStyle = DefaultTextStyle.of(context).style.merge(TextStyle(fontSize: 16));
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: _controller.text.substring(0, caretPosition), style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final caretOffset = textPainter.size.width;
    final caretHeight = textPainter.height;
    final boxOffset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      _suggestionOffset = Offset(caretOffset + boxOffset.dx, boxOffset.dy - caretHeight);
    });
  }

// for
  final FormosaAutocomplete formosaAutocomplete = FormosaAutocomplete();

  _validateWordToEntropy(List<String> words) {
    print('words ${words.length} $words');
    if (_controller.text.isEmpty) {
      setState(() {
        isErrorMessageVisible = false;
      });
    }
    if (words.length >= 12) {
      try {
        final isValid = formosaAutocomplete.toEntropyValidateChecksum(words);
        print("ENT ${isValid}");
        setState(() {
          isErrorMessageVisible = isValid.isEmpty;
        });
      } catch (e, t) {
        setState(() {
          isErrorMessageVisible = true;
        });
        print("AN ERR OCCURED $e $t");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _textfieldFocusNode = FocusNode(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (KeyType.isDown(event)) {
            _mainFocus.requestFocus();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_textfieldFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto complete formosa'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 650,
                    maxHeight: 500,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isErrorMessageVisible ? Colors.red : Colors.blueGrey.withOpacity(0.3),
                      width: isErrorMessageVisible ? 2 : 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _controller,
                    canRequestFocus: true,
                    focusNode: _textfieldFocusNode,
                    expands: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Start typing...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    onChanged: (v) => _updateSuggestions(v),
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  Positioned(
                    bottom: _suggestionOffset.dy + 200,
                    left: 0,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 200,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blueGrey.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return FocusableActionDetector(
                            focusNode: _mainFocus,
                            shortcuts: <LogicalKeySet, Intent>{
                              LogicalKeySet(LogicalKeyboardKey.arrowLeft): const PreviousFocusIntent(),
                              LogicalKeySet(LogicalKeyboardKey.arrowRight): const NextFocusIntent(),
                            },
                            actions: <Type, Action<Intent>>{
                              ActivateIntent: CallbackAction<Intent>(
                                onInvoke: (_) => _selectSuggestion(suggestion),
                              ),
                            },
                            child: ListTile(
                              title: Text(suggestion),
                              onTap: () => _selectSuggestion(suggestion),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateSuggestions(String input) {
    _validateWordToEntropy(_selectedWords);

    final lastWord = input.trim().split(' ').last;
    if (lastWord.isEmpty) {
      setState(() {
        _suggestions.clear();

        selectedIndex = -1;
      });
      return;
    }

    setState(() {
      _suggestions = formosaAutocomplete.start(lastWord);
      selectedIndex = -1;
      _updateSuggestionPosition();
    });
  }

  void _selectSuggestion(String suggestion) {
    setState(() {
      String text = _controller.text;
      List<String> words = text.trim().split(' ');
      if (words.isNotEmpty) {
        words[words.length - 1] = suggestion;
        _selectedWords = words;
      }
      _controller.text = '${words.join(' ')} ';
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
      _suggestions.clear();

      selectedIndex = -1;
      _validateWordToEntropy(words);
    });

    // Keep the focus on the TextField to allow typing the next word
    _textfieldFocusNode.requestFocus();
  }
}

class KeyType {
  static bool isEnter(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.select ||
        event.logicalKey == LogicalKeyboardKey.tab;
  }

  static bool isBackspace(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.backspace;
  }

  static bool isNumber(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.numpad0 ||
        event.logicalKey == LogicalKeyboardKey.numpad1 ||
        event.logicalKey == LogicalKeyboardKey.numpad2 ||
        event.logicalKey == LogicalKeyboardKey.numpad3 ||
        event.logicalKey == LogicalKeyboardKey.numpad4 ||
        event.logicalKey == LogicalKeyboardKey.numpad5 ||
        event.logicalKey == LogicalKeyboardKey.numpad6 ||
        event.logicalKey == LogicalKeyboardKey.numpad7 ||
        event.logicalKey == LogicalKeyboardKey.numpad8 ||
        event.logicalKey == LogicalKeyboardKey.numpad9;
  }

  static isLeft(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.gameButtonLeft1 ||
        event.logicalKey == LogicalKeyboardKey.gameButtonLeft2;
  }

  static isRight(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.gameButtonRight1 ||
        event.logicalKey == LogicalKeyboardKey.gameButtonRight2;
  }

  static isUp(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.arrowUp;
  }

  static isDown(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.arrowDown;
  }

  static isBack(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.escape ||
        event.logicalKey == LogicalKeyboardKey.goBack ||
        event.logicalKey == LogicalKeyboardKey.abort;
  }

  static isTrt(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.escape ||
        event.logicalKey == LogicalKeyboardKey.keyZ ||
        event.logicalKey == LogicalKeyboardKey.abort;
  }
}
