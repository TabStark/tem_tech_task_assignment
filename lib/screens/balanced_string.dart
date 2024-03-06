import 'package:flutter/material.dart';

class BalancedString extends StatefulWidget {
  @override
  _BalancedStringState createState() => _BalancedStringState();
}

class _BalancedStringState extends State<BalancedString> {
  TextEditingController _inputController = TextEditingController();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balanced Substring Finder'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _inputController,
                decoration: InputDecoration(labelText: 'Enter a string'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _result =
                        findLongestBalancedSubstring(_inputController.text);
                  });
                },
                child: Text('Find Longest Balanced Substring'),
              ),
              SizedBox(height: 20.0),
              Text(
                'Longest Balanced Substring: $_result',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String findLongestBalancedSubstring(String input) {
    List<String> result = [];

    for (int i = 0; i < input.length; i++) {
      for (int j = i + 1; j < input.length; j++) {
        String substring = input.substring(i, j + 1);
        // print(substring);
        if (isBalanced(substring)) {
          if (result.isEmpty || result.first.length == substring.length) {
            result.add(substring);
          } else if (result.first.length < substring.length) {
            result = [substring];
            print(result);
          }
        }
      }
    }

    return result.isNotEmpty
        ? result.join(', ')
        : 'No balanced substring found';
  }

  bool isBalanced(String s) {
    if (s.isEmpty) return false;

    Set<String> uniqueChars = s.split('').toSet();
    if (uniqueChars.length != 2) return false;

    int count1 = s.split(uniqueChars.elementAt(0)).length - 1;
    int count2 = s.split(uniqueChars.elementAt(1)).length - 1;

    return count1 == count2;
  }
}
