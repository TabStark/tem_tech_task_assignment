import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomWidgets{

  // Progressbar
   static void showProgressBar(BuildContext context, _animationcontroller) {
    showDialog(
      context: context,
      builder: (_) => SpinKitFadingCircle(
        color: Colors.white,
        size: 50,
        controller: _animationcontroller,
      ),
    );
  }

  // Popup MSg
  static void showFlushBar(BuildContext context, String msg) {
    Flushbar(
      backgroundColor: Colors.black,
      message: msg,
      messageColor: Colors.white,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }
}