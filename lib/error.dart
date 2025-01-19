
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorMsg extends StatelessWidget {
  const ErrorMsg({super.key, required this.errorMsg, required this.height});
  final String errorMsg;
  final double height;
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/error.svg",
            width: 50,
            height: 50,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            errorMsg,
            style: const TextStyle(
                fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );;
  }
}
