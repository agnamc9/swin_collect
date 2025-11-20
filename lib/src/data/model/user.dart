class User {
  int? id;
  String? username;
  String? password;
  String? email;
  String? firstName;
  String? lastName;
  List<String>? roles;
  bool? isFirstLogin;

  User({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.roles,
    this.isFirstLogin,
    this.password,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    roles = json['roles'].cast<String>();
    isFirstLogin = json['isFirstLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = id;
    if (username != null) data['username'] = username;
    if (password != null) data['password'] = password;
    if (email != null) data['email'] = email;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (roles != null) data['roles'] = roles;
    if (isFirstLogin != null) data['isFirstLogin'] = isFirstLogin;
    return data;
  }
}
