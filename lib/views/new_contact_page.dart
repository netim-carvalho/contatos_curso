import 'dart:io';

import 'package:contatos_curso/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum OrderOptions { orderaz, orderza }

class NewContactPage extends StatefulWidget {
  const NewContactPage({Key? key, this.contact}) : super(key: key);

  final Contact? contact;

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  TextEditingController controlerName = TextEditingController();
  TextEditingController controlerEmail = TextEditingController();
  TextEditingController controlerPhone = TextEditingController();

  Contact? editedContact;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      editedContact = Contact();
    } else {
      editedContact = Contact.fromMap(widget.contact!.toMap());
      controlerName.text = editedContact!.name ?? "";
      controlerEmail.text = editedContact!.email ?? "";
      controlerPhone.text = editedContact!.phone ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final back = await wheBack(context);
        return back ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: Text(editedContact?.name ?? "Novo Contato"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.save),
          onPressed: () {
            Contact contact = Contact.com(
                id: editedContact?.id,
                name: controlerName.text,
                email: controlerEmail.text,
                phone: controlerPhone.text,
                img: editedContact?.img);
            Navigator.pop(context, contact);
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  ImagePicker.platform
                      .pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) return;

                    setState(() {
                      editedContact?.img = file.path;
                    });
                  });
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: editedContact?.img != null
                          ? FileImage(File(editedContact!.img!))
                          : AssetImage("images/person.png") as ImageProvider,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: controlerName,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  setState(() {
                    editedContact?.name = text;
                  });
                },
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

  Future<bool?> wheBack(BuildContext context) async => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Descartar Alterações ?"),
          content: const Text("Se sair as alterações serão perdidas!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Sim"),
            ),
          ],
        ),
      );
}
