import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import './home_tabs.dart';
import './login_screen.dart';
import '../providers/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _isInit = true;
  var uid;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final auth = Provider.of<SignIn>(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      uid = prefs.getString('id');
      if (uid != null) {
        auth.autoLogin();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (uid != null) {
      Provider.of<SignIn>(context).autoLogin();
    }
    return Provider.of<SignIn>(context).curUser == null ? SignInScreen() : HomeTabs();
  }
}
