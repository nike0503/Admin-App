import 'package:admin/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  final String catName;
  final String deptName;

  ProductItem({
    @required this.catName,
    @required this.deptName,
  });
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: null,
        child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              title: Text(
                product.name,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: product.isAvailable
                  ? Text(
                      'Available   ₹${product.price}',
                      style: TextStyle(fontSize: 15),
                    )
                  : Text(
                      'Out of stock',
                      style: TextStyle(fontSize: 15),
                    ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductsScreen.routeName,
                      arguments: [product.name, catName, deptName]);
                },
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
