import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

class registerpage extends StatefulWidget {
  registerpage({Key key}) : super(key: key);

  @override
  _registerpageState createState() => _registerpageState();
}

BuildContext context;
Widget form = Register(context);
Color left = Colors.lightBlueAccent;
Color right = Colors.white;
Color temp;
String m_pin, check_mpin, usermail, mobile, checkmobile, otp, verid;
String phonenum, verificationid;
final _registerkey = GlobalKey<FormState>();
final _loginkey = GlobalKey<FormState>();
bool _autovalidate = true;
AuthCredential ph_credential;
FirebaseUser mailuser, ph_user;
AuthCredential mail_credential;
TextEditingController emailcontroller = new TextEditingController();
TextEditingController passwordcontroller = new TextEditingController();
TextEditingController loginmailcontroller = new TextEditingController();
TextEditingController loginpasswordcontroller = new TextEditingController();
TextEditingController loginphonecontroller = new TextEditingController();


Future<void> verifyphone(mobile, context) async {
  final PhoneVerificationCompleted verifed = (AuthCredential authResult) {
    Toast.show('Verified automatically', context, duration: Toast.LENGTH_SHORT);
  };

  final PhoneVerificationFailed verificationfailed =
      (AuthException authException) {
        Toast.show('${authException.message}', context,duration: Toast.LENGTH_SHORT);
  };

  final PhoneCodeSent smssent = (String verid, [int forceResend]) {
    verificationid = verid;
    _verifyDialog(context).then((value) {
      print('sign in');
    });
  };

  final PhoneCodeAutoRetrievalTimeout autotimeout = (String verid) {
    verificationid = verid;
  };

  await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 10),
      verificationCompleted: verifed,
      verificationFailed: verificationfailed,
      codeSent: smssent,
      codeAutoRetrievalTimeout: autotimeout);
  print('number arrived here');
}

Future<void> _verifyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('OTP verification:'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextFormField(
                onChanged: (value) {
                  otp = value;
                },
                maxLength: 6,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.black54,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 14),
                decoration: InputDecoration(
                    hintText: "OTP Code",
                    hintStyle: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w300),
                    fillColor: Colors.transparent,
                    filled: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54))),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: Text("Verify"),
            onPressed: () async {
              ph_credential = PhoneAuthProvider.getCredential(
                verificationId: verificationid,
                smsCode: otp,
              );
              
              await FirebaseAuth.instance.signInWithCredential(ph_credential);
              ph_user = await FirebaseAuth.instance.currentUser();
                Navigator.of(context).pop();
                mail_credential = EmailAuthProvider.getCredential(
                    email: emailcontroller.text,
                    password: passwordcontroller.text);
                ph_user.linkWithCredential(mail_credential).then((user) {
                  print(user);
                }).catchError((error) {
                  print(error.toString());
                });
            },
          ),
        ],
      );
    },
  );
}
 
Future<void> _phonelogin(phonenum, context) async {
  final PhoneVerificationCompleted verifed = (AuthCredential authResult) {
    Toast.show('Verified automatically', context, duration: Toast.LENGTH_SHORT);
  };

  final PhoneVerificationFailed verificationfailed =
      (AuthException authException) {
        Toast.show('${authException.message}', context,duration: Toast.LENGTH_SHORT);
  };

  final PhoneCodeSent smssent = (String verid, [int forceResend]) {
    verificationid = verid;
    _loginDialog(context).then((value) {
      print('sign in');
    });
  };

  final PhoneCodeAutoRetrievalTimeout autotimeout = (String verid) {
    verificationid = verid;
  };

  await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phonenum,
      timeout: const Duration(seconds: 10),
      verificationCompleted: verifed,
      verificationFailed: verificationfailed,
      codeSent: smssent,
      codeAutoRetrievalTimeout: autotimeout);
  print('number arrived here');
}

Future<void> _loginDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('OTP verification:'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextFormField(
                onChanged: (value) {
                  otp = value;
                },
                maxLength: 6,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.black54,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 14),
                decoration: InputDecoration(
                    hintText: "OTP Code",
                    hintStyle: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w300),
                    fillColor: Colors.transparent,
                    filled: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54))),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: Text("Check"),
            onPressed: () async {
              ph_credential = PhoneAuthProvider.getCredential(
                verificationId: verificationid,
                smsCode: otp,
              );
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signInWithCredential(ph_credential);  
            },
          ),
        ],
      );
    },
  );
}

class _registerpageState extends State<registerpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Text(
                    'Authenticate',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 40,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: 300.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              color: left,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  print('register');
                                  form = Register(context);
                                  temp = left;
                                  left = right;
                                  right = temp;
                                });
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: "WorkSansSemiBold"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: right,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  form = Login(context);
                                  print("login");
                                  temp = left;
                                  left = right;
                                  right = temp;
                                });
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: "WorkSansSemiBold"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: form,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//  _validate_email(String usermail)
// {
//     if(EmailValidator.validate(usermail)) {
//       return null;
//     } else {
//       return 'enter correct format';
//     }
// }

// _validateMobile(String value) {
//   Pattern numpattern = r'^(?:[+0]9)?[0-9]{10}$';
//   RegExp regexnum = new RegExp(numpattern);
//   if (value.length == 0) {
//     return 'Please enter mobile number';
//   } else if (!regexnum.hasMatch(value)) {
//     return 'Please enter valid mobile number';
//   }
//   return null;
// }

  Widget Login(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
          child: Form(
            key: _loginkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new SizedBox(height: 10),
                TextFormField(
                  controller: loginphonecontroller,
                  autovalidate: _autovalidate,
                  onSaved: (value) {
                    checkmobile = value;
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      fontSize: 14),
                  decoration: InputDecoration(
                      hintText: "Mobile Number with Country Code",
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      fillColor: Colors.transparent,
                      filled: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                ),
                SizedBox(height: 20),
                FlatButton(
                  padding: EdgeInsets.fromLTRB(60, 10, 70, 10),
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                   _phonelogin(loginphonecontroller.text,context);
                  }, 
                  color: Colors.red[400],
                  child: Text(
                    'Login with otp',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                new SizedBox(height: 50),
                new Text(
                  "Or Login with:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new IconButton(
                          color: Colors.lightBlue,
                          icon: Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              form=Login(context);
                            });
                          }),
                      new Text(
                        "Or",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      new IconButton(
                          color: Colors.lightBlue,
                          icon: Icon(
                            Icons.mail,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              form = LoginWithEmail(context);
                            });
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

 
  Widget LoginWithEmail(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
          child: Form(
            key: _loginkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new SizedBox(height: 10),
                TextFormField(
                  controller: loginmailcontroller,
                  autovalidate: _autovalidate,
                  onSaved: (value) {
                    checkmobile = value.toString();
                  },
                  textInputAction: TextInputAction.next,
                  // keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      fontSize: 14),
                  decoration: InputDecoration(
                      hintText: "Mail Id",
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      fillColor: Colors.transparent,
                      filled: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                ),
                new SizedBox(height: 30),
                new Text(
                  "Enter M Pin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white),
                ),
                new SizedBox(height: 15),
                new PinCodeTextField(
                  controller: loginpasswordcontroller,
                  autoValidate: _autovalidate,
                  //  validator: _validatepin(check_mpin),
                  autoDisposeControllers: false,
                  enableActiveFill: false,
                  textInputType: TextInputType.number,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  length: 6,
                  onChanged: (value) {
                    check_mpin = value;
                  },
                  backgroundColor: Colors.transparent,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 40,
                    fieldWidth: 40,
                    activeFillColor: Colors.grey,
                    selectedColor: Colors.blue,
                  ),
                ),
                SizedBox(height: 10),
                FlatButton(
                  padding: EdgeInsets.fromLTRB(60, 10, 70, 10),
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: loginmailcontroller.text,
                        password: loginpasswordcontroller.text);
                  }, //register button
                  color: Colors.red[400],
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                new SizedBox(height: 20),
                new Text(
                  "Or Login with:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new IconButton(
                          color: Colors.lightBlue,
                          icon: Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              form = Login(context);
                            });
                          }),
                      new Text(
                        "Or",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      new IconButton(
                          color: Colors.lightBlue,
                          icon: Icon(
                            Icons.mail,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              form = LoginWithEmail(context);
                            });
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget Register(BuildContext context) {
  return Container(
    child: Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
        child: Form(
          key: _registerkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                autovalidate: _autovalidate,
                onChanged: (value) {
                  usermail = value;
                },
            
                cursorColor: Colors.white,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 14),
                decoration: InputDecoration(
                    hintText: "Usermail",
                    hintStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    fillColor: Colors.transparent,
                    filled: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              new SizedBox(height: 10),
              TextFormField(
                autovalidate: _autovalidate,
                // validator: _validateMobile(mobile),
                onChanged: (value) {
                  mobile = value;
                },
                keyboardType: TextInputType.number,
                cursorColor: Colors.white,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 14),
                initialValue: '+91',
                decoration: InputDecoration(
                    hintText: "Mobile Number",
                    hintStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    fillColor: Colors.transparent,
                    filled: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              new SizedBox(height: 30),
              new Text(
                "Set M Pin",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.white),
              ),
              new SizedBox(height: 10),
              new PinCodeTextField(
                controller: passwordcontroller,
                enabled: true,
                autoValidate: _autovalidate,
                //  validator: _validatepin(m_pin),
                autoDisposeControllers: false,
                enableActiveFill: false,
                textInputType: TextInputType.number,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                length: 6,
                onChanged: (value) {
                  m_pin = value;
                },

                backgroundColor: Colors.transparent,
                pinTheme: PinTheme(
                  activeColor: Colors.green,
                  disabledColor: Colors.black,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 40,
                  fieldWidth: 40,
                  selectedColor: Colors.blue,
                ),
              ),
              new SizedBox(height: 10),
              new Container(
                child: new CheckboxListTile(
                  //have to change this.............(not working)
                  checkColor: Colors.white,
                  activeColor: Colors.grey,
                  value: true,
                  onChanged: (bool value) {},
                  title: RichText(
                      text: TextSpan(
                          text: 'I Agree the',
                          style: TextStyle(
                            fontSize: 9,
                          ),
                          children: [
                        TextSpan(
                            text: ' Terms and conditions & privacy Policy',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.redAccent,
                                decoration: TextDecoration.underline))
                      ])),
                ),
              ),
              FlatButton(
                padding: EdgeInsets.fromLTRB(60, 10, 70, 10),
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Toast.show(mobile, context, duration: Toast.LENGTH_LONG);
                  verifyphone(mobile,context);
                },
                color: Colors.red[400],
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
