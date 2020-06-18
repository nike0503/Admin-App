import 'package:flutter/material.dart';

class Department with ChangeNotifier{
  final String name;

  Department({
    @required this.name,
  });
}