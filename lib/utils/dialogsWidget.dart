import 'package:flutter/material.dart';

class Dialogs{
  static Future<void> showLoadingDialog(BuildContext context,
      GlobalKey key,
      String message
      ) async{

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){

        return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
                key: key,
                backgroundColor: Colors.black54,
                children: <Widget>[
                  Center(
                    child: Column(children: [
                      CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.white)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        message,
                        style: TextStyle(color: Colors.white),
                      )
                    ]),
                  )
                ])
        );
      }
    );
  }
}