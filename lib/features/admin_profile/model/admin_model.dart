class AdminModel {
  final String name;
  final String email;
  final String? image;

  AdminModel({
    required this.name,
    required this.email,
    this.image,
  });

  factory AdminModel.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) {
      return AdminModel(name: '', email: '', image: null);
    }

    return AdminModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      image: data['image'],
    );
  }
  }
