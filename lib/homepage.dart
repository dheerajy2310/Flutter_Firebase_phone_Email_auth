import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attraction/registerpage.dart';

class homepage extends StatefulWidget {
  homepage({Key key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // new Text('you are now logged in as: ${emailcontroller.text}'),
            // new Text('phone number: $mobile'),
            FlatButton(
                onPressed: _signout,
                color: Colors.black54,
                child: Text(
                  'Signout',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                )),
          ],
        )),
      ),
    );
  }
}

_signout() {
  FirebaseAuth.instance.signOut();
}
