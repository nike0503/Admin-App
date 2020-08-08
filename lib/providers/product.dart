import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String name;
  final String adminName;
  final String description;
  final int price;
  final int quantity;
  final bool isAvailable;
  final String imageUrl;

  Product({
    @required this.name,
    @required this.adminName,
    @required this.description,
    @required this.price,
    @required this.quantity,
    @required this.isAvailable,
    @required this.imageUrl,
  });
}
