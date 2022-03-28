import 'package:contatos_curso/helpers/contact_helper.dart';
import 'package:contatos_curso/views/home_page.dart';
import 'package:flutter/material.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({Key? key}) : super(key: key);

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  TextEditingController controlerName = TextEditingController();
  TextEditingController controlerEmail = TextEditingController();
  TextEditingController controlerPhone = TextEditingController();

  bool back = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await wheBack();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: const Text("NOVO CONTATO"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.save),
          onPressed: () {
            Contact contact = Contact(name: controlerName.text, email: controlerEmail.text, phone: controlerPhone.text, img: "ab");
            ContactHelper.internal().saveContact(contact);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              const Icon(
                Icons.person,
                size: 130,
              ),
              TextField(
                controller: controlerName,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controlerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controlerPhone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> wheBack() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Descartar Alterações ?"),
              content: const Text("Se sair as alterações serão perdidas!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    back = true;
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                  },
                  child: const Text("Sim"),
                ),
              ]);
        });
    return back;
  }
}
