import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String name;
  final String adminName;

  Category({
    @required this.name,
    @required this.adminName,
  });
}
