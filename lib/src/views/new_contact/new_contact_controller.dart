import 'package:contatos_curso/src/models/contact.dart';
import 'package:contatos_curso/src/repositories/contact_repository.dart';
import 'package:flutter/material.dart';

class NewContactController {
  final ContactRepository contactRepository;

  NewContactController(this.contactRepository);

  Future<void> saveContact({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String? img,
  }) async {
    final contact = Contact.com(
      name: name,
      email: email,
      phone: phone,
      img: img,
    );
    await contactRepository.saveContact(contact);
    Navigator.pop(context, contact);
  }

  Future<void> updateContact({
    required BuildContext context,
    required int? id,
    required String name,
    required String email,
    required String phone,
    required String? img,
  }) async {
    final contact = Contact.com(
      id: id,
      name: name,
      email: email,
      phone: phone,
      img: img,
    );
    await contactRepository.updateContact(contact);
    Navigator.pop(context,  contact);
  }
}
