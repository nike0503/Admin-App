import 'package:flutter/material.dart';

import './departments_overview_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Card(
            elevation: 3,
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DepartmentOverviewScreen.routeName);
              },
              leading: Icon(Icons.library_books),
              title: Text('Catalogue'),
            ),
          ),
        )
      ],
    );
  }
}
