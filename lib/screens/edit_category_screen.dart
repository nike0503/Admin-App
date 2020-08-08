import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/departments.dart';
import '../providers/category.dart' as Cat;
import '../providers/login.dart';

class EditCategoryScreen extends StatefulWidget {
  static const routeName = '/edit-category';
  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _form = GlobalKey<FormState>();
  String admin;
  var _editedCategory = Cat.Category(name: '', adminName: '');
  var _initValue = '';
  var _isInit = true;
  var _isLoading = false;
  String deptName, catName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments as List<String>;
      if (args.length == 2) {
        deptName = args[0];
        catName = args[1];
      } else if (args.length == 1) {
        deptName = args[0];
      }
      admin = Provider.of<SignIn>(context).username;
      if (catName != null) {
        setState(() {
          _isLoading = true;
        });
        _editedCategory = Cat.Category(name: catName, adminName: admin);
        setState(() {
          _initValue = catName;
          _isLoading = false;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (catName != null) {
      await Provider.of<Departments>(context)
          .updateCategory(deptName, _editedCategory);
    } else {
      try {
        await Provider.of<Departments>(context)
            .addCategory(deptName, _editedCategory);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: catName == null ? Text('Add Category') : Text('Edit Category'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValue,
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCategory = Cat.Category(
                          name: value,
                          adminName: admin
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
