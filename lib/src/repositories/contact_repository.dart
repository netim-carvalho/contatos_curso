import 'package:contatos_curso/src/models/contact.dart';

abstract class ContactRepository {
  Future<Contact> saveContact(Contact contact);

  Future<Contact?> getContact(int id);

  Future<int> deleteContact(int id);

  Future<int> updateContact(Contact contact);

  Future<List> getAllContacts();

  Future<int?> getNumber();

}