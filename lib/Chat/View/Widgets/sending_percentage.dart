import 'package:flutter/material.dart';

class SendingPercentage extends StatefulWidget {
  const SendingPercentage({
    super.key,
  });

  @override
  State<SendingPercentage> createState() => SendingPercentageState();
}

class SendingPercentageState extends State<SendingPercentage> {
  sending(int value) {
    percentage = value;
    setState(() {});
  }

  int percentage = 0;
  @override
  Widget build(BuildContext context) {
    return Text(
      "$percentage%",
      style: TextStyle(color: Colors.green[300]),
    );
  }
}
