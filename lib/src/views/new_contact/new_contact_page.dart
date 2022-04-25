import 'dart:io';

import 'package:contatos_curso/src/helpers/contact_helper.dart';
import 'package:contatos_curso/src/models/contact.dart';
import 'package:contatos_curso/src/repositories/contact_repository_sqflite_impl.dart';
import 'package:contatos_curso/src/views/new_contact/new_contact_controller.dart';
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
  late final NewContactController newContactController;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  Contact? editedContact;

  @override
  void initState() {
    newContactController = NewContactController(
      ContactRepositorySqfliteImpl(
        ContactHelper.internal(),
      ),
    );
    super.initState();
    if (widget.contact == null) {
      editedContact = Contact();
    } else {
      editedContact = Contact.fromMap(widget.contact!.toMap());
      controllerName.text = editedContact?.name ?? '';
      controllerEmail.text = editedContact?.email ?? '';
      controllerPhone.text = editedContact?.phone ?? '';
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
        floatingActionButton: editedContact?.id == null
            ? FloatingActionButton(
                onPressed: () {
                  newContactController.saveContact(
                    context: context,
                    name: controllerName.text,
                    email: controllerEmail.text,
                    phone: controllerPhone.text,
                    img: editedContact?.img,
                  );
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.save),
              )
            : FloatingActionButton(
                onPressed: () {
                  newContactController.updateContact(
                    context: context,
                    id: editedContact!.id,
                    name: controllerName.text,
                    email: controllerEmail.text,
                    phone: controllerPhone.text,
                    img: editedContact?.img,
                  );
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.update),
              ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
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
                          : const AssetImage("images/person.png") as ImageProvider,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: controllerName,
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
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controllerPhone,
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
