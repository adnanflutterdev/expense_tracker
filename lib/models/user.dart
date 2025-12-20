class UserModel {
  final String id;
  final String name;
  final String email;
  final String dob;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.dob,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'dob': dob};
  }

  factory UserModel.fromFirebase(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      dob: data['dob'],
    );
  }
}
