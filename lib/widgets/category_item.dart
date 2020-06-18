import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/products_overview_screen.dart';
import '../providers/category.dart';

class CategoryItem extends StatelessWidget {
  final deptName;

  CategoryItem(this.deptName);

  void selectCategory(BuildContext ctx, String catName, deptName) {
    Navigator.of(ctx).pushNamed(
      ProductOverviewScreen.routeName,
      arguments: [catName, deptName],
    );
  }


  @override
  Widget build(BuildContext context) {
    final category = Provider.of<Category>(context, listen: false);
    return InkWell(
      onTap: () {
        selectCategory(context, category.name, deptName);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          category.name,
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}