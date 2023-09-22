import 'package:flutter/material.dart';

class SmallerDividerHeading extends StatelessWidget {
  final String heading;

  const SmallerDividerHeading({Key? key, required this.heading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 9, right: 9, top: 20, bottom: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Divider(
              thickness: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Text(
              heading,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
              child: Divider(
            thickness: 1,
          )),
        ],
      ),
    );
  }
}
