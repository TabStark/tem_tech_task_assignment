import 'package:flutter/material.dart';

class FibonacciScreen extends StatefulWidget {
  @override
  _FibonacciScreenState createState() => _FibonacciScreenState();
}

class _FibonacciScreenState extends State<FibonacciScreen> {
  TextEditingController _positionController = TextEditingController();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2. Fibonacci Calculator'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: _positionController,
                decoration: InputDecoration(
                  labelText: 'Enter position',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  int? position = int.tryParse(_positionController.text);
                  if (position != null && position >= 0) {
                    setState(() {
                      _result = calculateFibonacci(position).toString();
                    });
                  } else {
                    setState(() {
                      _result = 'Invalid input';
                    });
                  }
                },
                child: Text('Calculate'),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Result: $_result',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  int calculateFibonacci(int n) {
    if (n <= 1) return n;

    int fibPrev = 0;
    int fibCurr = 1;

    for (int i = 2; i <= n; i++) {
      int fibNext = fibPrev + fibCurr;
      fibPrev = fibCurr;
      fibCurr = fibNext;
    }

    return fibCurr;
  }
}
