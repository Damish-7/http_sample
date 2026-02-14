class Student {

  final String id;
  final String name;
  final String email;
  final String course;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.course,
  }) ;

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      course: json['course'],
    );
  }
}