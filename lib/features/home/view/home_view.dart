import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/core/auth/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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
    return ElevatedButton(onPressed: signOut,
     child: const Text("sign out"));
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
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