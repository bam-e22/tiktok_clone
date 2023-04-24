import 'package:flutter/material.dart';

class StfScreen extends StatefulWidget {
  const StfScreen({Key? key}) : super(key: key);

  @override
  State<StfScreen> createState() => _StfScreenState();
}

class _StfScreenState extends State<StfScreen> {
  int _clicks = 0;

  void _increase() {
    setState(() {
      _clicks += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$_clicks',
            style: TextStyle(
              fontSize: 48,
            ),
          ),
          TextButton(
              onPressed: _increase,
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 48,
                ),
              ))
        ],
      ),
    );
  }
}
