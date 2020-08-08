import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/departments.dart';
import '../providers/department.dart';
import '../providers/login.dart';

class EditDepartmentScreen extends StatefulWidget {
  static const routeName = '/edit-department';
  @override
  _EditDepartmentScreenState createState() => _EditDepartmentScreenState();
}

class _EditDepartmentScreenState extends State<EditDepartmentScreen> {
  final _form = GlobalKey<FormState>();
  String admin;
  var _editedDepartment = Department(name: '', adminName: '');
  var _initValue = '';
  var _isInit = true;
  var _isLoading = false;
  String deptName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments as List<String>;
      if (args != null) {
        deptName = args[0];
      }
      admin = Provider.of<SignIn>(context).username;
      if (deptName != null) {
        setState(() {
          _isLoading = true;
        });
        _editedDepartment = Department(name: deptName, adminName: admin);
        setState(() {
          _initValue = deptName;
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
    if (deptName != null) {
      await Provider.of<Departments>(context)
          .updateDepartment(_editedDepartment);
    } else {
      try {
        await Provider.of<Departments>(context)
            .addDepartment(_editedDepartment);
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
        title:
            deptName == null ? Text('Add Department') : Text('Edit Department'),
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
                        _editedDepartment = Department(
                          name: value,
                          adminName: admin,
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
