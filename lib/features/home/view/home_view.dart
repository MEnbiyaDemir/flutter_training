import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/core/auth/auth.dart';

import '../../auth/auth_view.dart';
import '../model/recipe_model.dart';

const COLLECTION_NAME = 'recipes';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> recipes = [];

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text("App title");
  }

  Widget _userUid() {
    return Text(user?.email ?? "user bilgisi alınamadı");
  }

  Widget _signoutButton() {
    return ElevatedButton(
        onPressed: () {
          signOut();

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AuthPage()));
        },
        child: const Text("sign out"));
  }

  @override
  void initState() {
    fetchRecords();
    FirebaseFirestore.instance
        .collection('recipes')
        .snapshots()
        .listen((records) {
      mapRecords(records);
    });
    super.initState();
  }

  fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection('recipes').get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs
        .map((item) => RecipeModel(
            id: item.id,
            name: item['name'],
            summary: item['summary'],
            ingredients: item['ingredients'],
            steps: item['steps']))
        .toList();

    setState(() {
      recipes = _list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: showItemDialog, icon: const Icon(Icons.edit))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _userUid(),
          _signoutButton(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(recipes[index].name),
                leading: Icon(Icons.ballot),
                subtitle: Text(recipes[index].summary),
                trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                  color: Colors.brown[900],
                ),
                onPressed: () {
                  
                showUpdateDialog(recipes[index].name,recipes[index].summary,recipes[index].ingredients[0],recipes[index].ingredients[1],recipes[index].steps[0],recipes[index].steps[1],recipes[index].id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20.0,
                  color: Colors.brown[900],
                ),
                onPressed: () {
                  deleteItem(recipes[index].id);
                },
              ),
            ],
          ),
                //IconButton(onPressed: (){deleteItem(recipes[index].id);}, icon: Icon(Icons.delete),),
              );
            },
          )
        ],
      ),
    );
  }

//ADD RECIPE KISMI

  // burada aslında kullanıcıdan step ve ingredient girdilerini
  // virgülle alıp virgül arasındaki stringleri arraylere atmak istiyordum
  //ancak vaktim olmadı. biraz daha statik bir girdi oldu
  // virgül ile almak ve kullanıcının doğru yazdığından
  //emin olmak burada yapacağım şeylerdi
  showItemDialog() {
    var nameController = TextEditingController();
    var sumController = TextEditingController();
    var ingr1Controller = TextEditingController();
    var ingr2Controller = TextEditingController();
    var step1Controller = TextEditingController();
    var step2Controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "name"),
                  controller: nameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "sumamry"),
                  controller: sumController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "ingredient"),
                  controller: ingr1Controller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "ingredient"),
                  controller: ingr2Controller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "step 1"),
                  controller: step1Controller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "step 2"),
                  controller: step2Controller,
                ),
                TextButton(
                    onPressed: () {
                      var name = nameController.text.trim();
                      var sum = sumController.text.trim();
                      var ingr1 = ingr1Controller.text.trim();
                      var ingr2 = ingr2Controller.text.trim();
                      var step1 = step1Controller.text.trim();
                      var step2 = step1Controller.text.trim();
                      addItem(name, sum, ingr1, ingr2, step1, step2);
                    },
                    child: Text("Kaydet"))
              ],
            ),
          );
        });
  }

  addItem(String name, String summary, String ingr1, String ingr2, String step1,
      String step2) {
    List<dynamic> ingrlist = [ingr1, ingr2];
    List<dynamic> steplist = [step1, step2];
    var data = RecipeModel(
        id: 'id',
        name: name,
        summary: summary,
        ingredients: ingrlist,
        steps: steplist);
    FirebaseFirestore.instance.collection(COLLECTION_NAME).add(data.toJson());
  }

// DELETE KISMI
  deleteItem(String id){
    FirebaseFirestore.instance.collection(COLLECTION_NAME).doc(id).delete();
  }

   //UPDATE KISMI
  showUpdateDialog(String name, String summary, String ingr1, String ingr2, String step1,String step2, String id) {
    var upnameController = TextEditingController();
    var upsumController = TextEditingController();
    var upingr1Controller = TextEditingController();
    var upingr2Controller = TextEditingController();
    var upstep1Controller = TextEditingController();
    var upstep2Controller = TextEditingController();
    upnameController.text = name;
    upsumController.text = summary;
    upingr1Controller.text = ingr1;
    upingr2Controller.text = ingr2;
    upstep1Controller.text = step1;
    upstep2Controller.text = step2;
    
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "name"),
                  controller: upnameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "sumamry"),
                  controller: upsumController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "ingredient"),
                  controller: upingr1Controller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "ingredient"),
                  controller: upingr2Controller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "step 1"),
                  controller: upstep1Controller,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "step 2"),
                  controller: upstep2Controller,
                ),
                TextButton(
                    onPressed: () {
                      var name = upnameController.text.trim();
                      var sum = upsumController.text.trim();
                      var ingr1 = upingr1Controller.text.trim();
                      var ingr2 = upingr2Controller.text.trim();
                      var step1 = upstep1Controller.text.trim();
                      var step2 = upstep1Controller.text.trim();
                      updateItem(name, sum, ingr1, ingr2, step1, step2,id);
                    },
                    child: Text("Kaydet"))
              ],
            ),
          );
        });
  }

  updateItem(String name, String summary, String ingr1, String ingr2, String step1,
      String step2,String id){
  List<dynamic> ingrlist = [ingr1, ingr2];
    List<dynamic> steplist = [step1, step2];
    var data = RecipeModel(
        id: 'id',
        name: name,
        summary: summary,
        ingredients: ingrlist,
        steps: steplist);
    FirebaseFirestore.instance.collection(COLLECTION_NAME).doc(id).set(data.toJson());
  }
}
