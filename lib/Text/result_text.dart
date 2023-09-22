import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
          backgroundColor: const Color.fromRGBO(102, 153, 153, 1),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Text(text),
            ),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromRGBO(153, 153, 136, 1))),
                onPressed: () {
                  if (text.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Copied to Clipboard")),
                    );
                  }
                },
                child: const Text("Copy")),
          ],
        ),
      );
}
