class CategoryModel {
  final String label;
  final String icon;

  CategoryModel({required this.label, required this.icon});

  factory CategoryModel.fromFirebase(Map<String, dynamic> data) {
    return CategoryModel(label: data['label'], icon: data['icon']);
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'icon': icon};
  }
}
