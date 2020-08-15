import 'package:flutter/material.dart';
import "package:quiver/core.dart";
import 'package:flutter/foundation.dart';

class Login{
  final String name;
  final String password;

  Login({
    @required this.name,
    @required this.password,
  });

  @override
  String toString() {
    return '$runtimeType($name, $password)';
  }

  bool operator ==(Object other) {
    if (other is Login) {
      return name == other.name && password == other.password;
    }
    return false;
  }

  int get hashCode => hash2(name, password);
}