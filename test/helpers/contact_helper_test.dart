import 'package:contatos_curso/src/helpers/contact_helper.dart';
import 'package:contatos_curso/src/models/contact.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
    Contact contact = Contact.com(
      id: 1,
        name: "Netim",
        email: "netim123@gmail.com",
        phone: "00022333",
        img: 'asin');
  test("Deve retornar um contato com um id", ()  {
    expect(contact.name, equals('Netim'));
  });

  test("Id é null", (){
    expect(contact.id, isNotNull);
  });
}
