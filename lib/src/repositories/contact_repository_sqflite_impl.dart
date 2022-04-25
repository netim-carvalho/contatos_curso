import 'package:contatos_curso/src/helpers/contact_helper.dart';
import 'package:contatos_curso/src/models/contact.dart';
import 'package:contatos_curso/src/repositories/contact_repository.dart';

class ContactRepositorySqfliteImpl implements ContactRepository {
  final ContactHelper contactHelper;

  ContactRepositorySqfliteImpl(this.contactHelper);

  @override
  Future<int> deleteContact(int id) {
    return contactHelper.deleteContact(id);
  }

  @override
  Future<List> getAllContacts() {
    return contactHelper.getAllContacts();
  }

  @override
  Future<Contact?> getContact(int id) {
    return contactHelper.getContact(id);
  }

  @override
  Future<int?> getNumber() {
    return contactHelper.getNumber();
  }

  @override
  Future<Contact> saveContact(Contact contact) {
    return contactHelper.saveContact(contact);
  }

  @override
  Future<int> updateContact(Contact contact) {
    return contactHelper.updateContact(contact);
  }
}
