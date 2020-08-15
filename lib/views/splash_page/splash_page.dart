import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  final int splashDuration = 2;

  countDownTime() async {
    return Timer(Duration(seconds: splashDuration), () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Navigator.of(context).pushReplacementNamed('LoginScreen');
    });
  }

  @override
  void initState() {
    super.initState();
    countDownTime();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 99, 170, 1)
          ),
          child:
          Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


              Image(
                image: AssetImage('assets/logo.png'),
                width: 350,
              ),
              new CircularProgressIndicator(
                backgroundColor: Colors.orange,
                strokeWidth: 10,
              ),

            ],



          )
      );
  }
}

