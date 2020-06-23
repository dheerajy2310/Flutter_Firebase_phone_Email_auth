import 'package:attraction/homepage.dart';
import 'package:attraction/registerpage.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';


class authservice {
  handleAuth(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData)
        return homepage();
        else
        return registerpage();
      },
    );
  }
}