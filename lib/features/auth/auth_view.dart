import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/features/home/view/home_view.dart';
import '../../core/auth/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
String? errorMsg='';
bool isLogin= true;

final TextEditingController _controllerEmail= TextEditingController();
final TextEditingController _controllerPassword= TextEditingController();

 String? mail;
 String? pass;

Future<void> signInWithEmailAndPassword() async{
  try{
    await Auth().signInWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }on FirebaseAuthException catch(e){
    setState(() {
      errorMsg=e.message;
    });
  }
}

Future<void> createUserWithEmailAndPassword() async{
  try{
    await Auth().createUserWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);
  }on FirebaseAuthException catch(e){
    setState(() {
      mail=_controllerEmail.text;
      pass=_controllerPassword.text;
      errorMsg=e.message;
    });
  }
}

Widget _title(){
    return const Text("App title");
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ){
    return TextField(controller: controller,decoration: InputDecoration(labelText: title),);
  }

  Widget _errorMsg(){
    
    return Text(errorMsg== ''?'': "?? $mail , $errorMsg");
  }

  Widget _submitButton(){
    return ElevatedButton(onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
     child: Text(isLogin ? "Login" : "Register"));
     
  }

Widget _loginRegisterButton(){
return TextButton(onPressed: (){setState(() {
  isLogin =!isLogin;
  print(mail);
});},
 child: Text(isLogin ? "go to Register" : "go to Login"));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: _title(),automaticallyImplyLeading: false),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _entryField("email", _controllerEmail),
        _entryField("password", _controllerPassword),
        _errorMsg(),
        _submitButton(),
        _loginRegisterButton()
    ],));
  }
}