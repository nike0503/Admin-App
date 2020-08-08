import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
        centerTitle: true,
      ),
      body: _EmailPasswordForm(),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  __EmailPasswordFormState createState() => __EmailPasswordFormState();
}

class __EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var _isLoading = false;
  bool _success;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<SignIn>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Email cannot be empty';
              }
              if (!value.contains('@')) {
                return 'Invalid email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  String signInMessage = await auth.loginWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (signInMessage != null) {
                    setState(() {
                      _success = true;
                    });
                  } else {
                    setState(() {
                      _success = false;
                    });
                  }
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _success == null
                ? Text('')
                : _success
                    ? Text(
                        'Successfully signed in ',
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(
                        'User entered is not an admin or the email/password is incorrect',
                        style: TextStyle(color: Colors.red),
                      ),
          ),
          if (_isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
