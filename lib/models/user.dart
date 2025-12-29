class UserModel {
  final String id;
  final String name;
  final String email;
  final String dob;
  final double monthlyBudget;
  final double spent;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.dob,
    required this.monthlyBudget,
    required this.spent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dob': dob,
      'monthlyBudget': monthlyBudget,
      'spent':spent,
    };
  }

  factory UserModel.fromFirebase(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      dob: data['dob'],
      monthlyBudget: data['monthlyBudget'],
      spent: (data['spent']as int).toDouble()
    );
  }
}
