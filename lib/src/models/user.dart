class User {
  final String email;
  final String pin;

  User({required this.email, required this.pin});

  Map<String, dynamic> toJson() => {
        'email': email,
        'pin': pin,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      pin: json['pin'] as String,
    );
  }
}
