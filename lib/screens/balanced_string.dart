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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(labelText: 'Enter a string'),
              ),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  setState(() {
                    _result =
                        findLongestBalancedSubstring(_inputController.text);
                  });
                },
                child: Text(
                  'Find Balanced Substring',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Result: $_result',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
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
