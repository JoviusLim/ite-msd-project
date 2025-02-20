class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final int weight;
  final int height;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }

  static ProfileModel fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      age: map['age'],
      weight: map['weight'],
      height: map['height'],
    );
  }
}
