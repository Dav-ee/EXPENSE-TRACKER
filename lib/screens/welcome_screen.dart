import 'package:flutter/services.dart';
import './home_page.dart';
import 'package:flutter/material.dart';
import '../models/usermodel.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Welcoming_Screen extends StatefulWidget {
  @override
  State<Welcoming_Screen> createState() => _Welcoming_ScreenState();
}

class _Welcoming_ScreenState extends State<Welcoming_Screen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    if(user != null){
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
        if (loggedInUser.username != null) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    }
  }

  late String _username;
  late String _email;
  late String _password;
  final int entertainment = 0;
  final int  food = 0;
  final int  travel = 0;
  final int  shopping = 0;
  final int  tt_income = 0;
  final int  tt_expense = 0;


  final formkey = GlobalKey<FormState>();

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address')
  ]);
  final requiredValidator =
  RequiredValidator(errorText: 'Username is required');

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText:
        'Passwords must have at least one special character i.e /*&%%(')
  ]);


  checkFields() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  loginUser() {
    if (checkFields()) {
      var snackBar = SnackBar(
        content: Text("Authentication taking place."),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Fluttertoast.showToast(msg: "${_email}");
      // Fluttertoast.showToast(msg: "Authenticating..");
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((uid) {
        // Fluttertoast.showToast(
        //     msg: "Login  successful ${_email}",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER_LEFT,
        //     timeInSecForIosWeb: 4,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

        var snackBar = SnackBar(
          content: Text("Login  successful ${_email}"),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);


        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }).catchError((e) {
        // Fluttertoast.showToast(
        //     msg: e!.message,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER_LEFT,
        //     timeInSecForIosWeb: 4,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

        var snackBar = SnackBar(
          content: Text("${e!.message}"),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }


  //register
  RegisterUser(){
    if(checkFields()){
      var snackBar = SnackBar(
        content: Text("Processing your request"),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
//  do this
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)
          .then((uid) => {postValuesToFirestore()}
      ).catchError((e){
        var snackBar = SnackBar(
          content: Text("${e!.message}"),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }
  postValuesToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();
    // writing all the values to user db
    userModel.email = _email;
    userModel.uid = user?.uid;
    userModel.username = _username;
    userModel.entertainment = entertainment;
    userModel.food = food;
    userModel.shopping = shopping;
    userModel.travel = travel;
    userModel.tt_income = tt_income;
    userModel.tt_expense = tt_expense;

    await firebaseFirestore.collection("users").doc(user?.uid).set(
      userModel.toMap(),
    );



    var snackBar = SnackBar(
      content: Text("Account created successfully."),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomePage()));
  }

  inputfomart_email_pwd(){
    FilteringTextInputFormatter.deny(
        RegExp(r'\s'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
          User? user = FirebaseAuth.instance.currentUser;
          UserModel userModel = UserModel();
          await firebaseFirestore.collection("users").doc(user?.uid).set(
            userModel.toMap(),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),

          child: Form(
          key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
         Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "WELCOME TO ",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "EXPENSE TRACKER",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 50.0,
                ),

                TextFormField(
                  inputFormatters:  [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s'))
                  ],
                  autofocus: false,
                  validator: emailValidator,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepOrange,
                        width: 2.0,
                      ),
                    ),
                    prefixIcon:
                    Icon(Icons.email),
                    labelText: 'Email Address',
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Your e-mail here",
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onChanged: (newValue) {
                    _email = newValue;
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),

                TextFormField(
                  inputFormatters:  [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s'))
                  ],
                  autofocus: false,
                  validator: requiredValidator,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    prefixIcon:
                    Icon(Icons.supervised_user_circle),
                    labelText: 'Username',
                    fillColor: Colors.white,
                    hintText: "Your username required",
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onChanged: (newValue) {
                    _username = newValue;
                  },
                ),

                const SizedBox(
                  height:5.0,
                ),

                TextFormField(
                  inputFormatters:  [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s'))
                  ],
                  obscureText: true,
                  autofocus: false,
                  validator: passwordValidator,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    prefixIcon:
                    Icon(Icons.lock),
                    labelText: 'Password',
                    fillColor: Colors.white,
                    hintText: "Your Password here",

                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onChanged: (newValue) {
                    _password = newValue;
                  },
                ),

                SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        // width: 0,
                        height: 36,
                        child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            onPressed: () {
                              loginUser();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(4)),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10,
                                    top: 10,
                                    left: 14,
                                    right: 14),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceAround,
                                  children: [

                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("LOGIN",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize: 13))
                                  ],
                                ))),
                      ),
                      Container(
                        // width: 0,
                        height: 36,
                        child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.redAccent,
                            onPressed: () {
                              RegisterUser();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(4)),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10,
                                    top: 10,
                                    left: 8,
                                    right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("REGISTER",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize: 13))
                                  ],
                                ))),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
