import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TryAgain extends StatelessWidget {
  const TryAgain({super.key, required this.onPressed});

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Column(
        children: <Widget>[
          const Text('replace with  error try again for may way app  '),
          ElevatedButton(onPressed: onPressed, child: const Text('try again'))
        ],
      ),
    );
  }
}
