import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/core/auth/auth.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async{
    await Auth().signOut();
  }

  Widget _title(){
    return const Text("App title");
  }

  Widget _userUid(){
    return Text(user?.email ?? "user bilgisi alınamadı");
  }

  Widget _signoutButton(){
    return ElevatedButton(onPressed: () {
      signOut();
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    },
     child: const Text("sign out"));
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title(),automaticallyImplyLeading: false,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userUid(),
          _signoutButton()
        ],
      ),
    );
  }
}