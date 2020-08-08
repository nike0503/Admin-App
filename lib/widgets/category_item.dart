import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_category_screen.dart';
import '../screens/products_overview_screen.dart';
import '../providers/category.dart';
import '../providers/departments.dart';
import '../providers/login.dart';

class CategoryItem extends StatelessWidget {
  final String deptName;

  CategoryItem(this.deptName);

  void selectCategory(BuildContext ctx, String catName, deptName) {
    Navigator.of(ctx).pushNamed(
      ProductOverviewScreen.routeName,
      arguments: [catName, deptName],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<SignIn>(context);
    final category = Provider.of<Category>(context, listen: false);
    return InkWell(
      onTap: () {
        selectCategory(context, category.name, deptName);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              category.name,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            Container(
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          EditCategoryScreen.routeName,
                          arguments: [deptName, category.name]);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await Provider.of<Departments>(context)
                            .getProds(auth.username, deptName, category.name);
                        if (Provider.of<Departments>(context).products.length !=
                            0) {
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Delete all products before deleting category',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 2),
                          ));
                          return;
                        }
                        await Provider.of<Departments>(context, listen: false)
                            .deleteCategory(deptName, category.name);
                      } catch (error) {
                        // scaffold.showSnackBar(
                        //   SnackBar(
                        //     content: Text(
                        //       'Deleting failed!',
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // );
                      }
                    },
                    color: Theme.of(context).errorColor,
                  ),
                ],
              ),
            ),
          ],
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
