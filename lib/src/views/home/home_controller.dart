import 'package:contatos_curso/src/repositories/contact_repository.dart';

class HomeController {
  final ContactRepository contactRepository;

  HomeController(this.contactRepository);

  Future<List> getAllContacts() async {
    return await contactRepository.getAllContacts();
  }

  Future<int> deleteContact(int id) async {
    return await contactRepository.deleteContact(id);
  }
}
