import 'dart:io';

import 'package:contatos_curso/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'new_contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> listContac = [];

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text("CONTATOS"),
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: orderList,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: listContac.length,
        itemBuilder: (context, index) {
          return cardContact(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
        onPressed: () async {
          calledNewContactPage();
        },
      ),
    );
  }

  Widget cardContact(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => bottomOptions(context, index),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: listContac[index].img != null
                        ? FileImage(File(listContac[index].img!))
                        : AssetImage("images/person.png") as ImageProvider,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listContac[index].name ?? "",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        listContac[index].email ?? "",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        listContac[index].phone ?? "",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deletedDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Deletar Contato?"),
          content: Text("Deseja deletar o contato: ${listContac[index].name}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  helper.deleteContact(listContac[index].id!);
                  listContac.remove(listContac[index]);
                });
              },
              child: Text("Deletar"),
            ),
          ],
        );
      },
    );
  }

  void calledNewContactPage({Contact? contact}) async {
    final reContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewContactPage(contact: contact)));

    if (reContact == null) {
      return;
    } else {
      if (reContact.id == null) {
        helper.saveContact(reContact!);
      } else {
        helper.updateContact(reContact!);
      }
    }
    getAllContacts();
  }

  void getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        listContac = list as List<Contact>;
      });
    });
  }

  bottomOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        launch("tel:${listContac[index].phone}");
                      },
                      child: const Text(
                        "Ligar",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        calledNewContactPage(contact: listContac[index]);
                      },
                      child: const Text(
                        "Editar",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        deletedDialog(context, index);
                      },
                      child: const Text(
                        "Excluir",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            onClosing: () {},
          );
        });
  }

  void orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        if (listContac.isNotEmpty) {
          listContac.sort((a, b) {
            return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
          });
        }
        break;
      case OrderOptions.orderza:
        if (listContac.isNotEmpty) {
          listContac.sort((a, b) {
            return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
          });
        }
        break;
    }
    setState(() {

    });
  }
}
