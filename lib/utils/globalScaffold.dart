import 'package:flutter/material.dart';

class GlobalScaffold{

  static final GlobalScaffold instance = GlobalScaffold._();

  GlobalScaffold._();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackbar(SnackBar snackbar){
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}