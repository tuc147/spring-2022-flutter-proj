import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_app/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyAwesomeApp();
        }
        return Scaffold(
          body: Center(
            child: Text("Loading..."),
          ),
        );
      },
    );
  }
}

class Root extends StatefulWidget {
  const Root({ Key? key }) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:Auth(auth: _auth).user,
      builder: 
          BuildContext(context, AsyncSnapshot<User> snapshot){
            if(snapshot.ConnectionState == ConnectionState.active){
              if(snapshot.data?.uid == null){
                return Login(
                  auth: _auth,
                  firestore: _firestore,
                  );
              } else {
                return Home(
                  auth 
                )
              }
            } else {
              return const Scaffold(
                body: Center(
                  child: Text("Loading..."), 
                  ),
                );
            }
          }, //AuthString 
    );
  }
}