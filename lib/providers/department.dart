import 'package:flutter/material.dart';

class Department with ChangeNotifier {
  final String name;
  final String adminName;

  Department({
    @required this.name,
    @required this.adminName,
  });
}
