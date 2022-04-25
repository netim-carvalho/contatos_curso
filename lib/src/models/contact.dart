class Contact {
  Contact();

  Contact.com(
      {this.id, required this.name,
        required this.email,
        required this.phone,
         this.img});

  int? id;
  String? name;
  String? email;
  String? phone;
  String? img;

  Contact.fromMap(Map map) {
    id = map['idColumn'];
    name = map['nameColumn'];
    email = map['emailColumn'];
    phone = map['phoneColumn'];
    img = map['imgColumn'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nameColumn': name,
      'emailColumn': email,
      'phoneColumn': phone,
      'imgColumn': img,
    };
    if (id != null) {
      map['idColumn'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact( id: $id, name: $name, email: $email, phone: $phone, img: $img";
  }
}
