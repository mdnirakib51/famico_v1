class AuthModel {
  Profile? profile;
  String? token;

  AuthModel({this.profile, this.token});

  AuthModel.fromJson(Map<String, dynamic> json) {
    profile =
    json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class Profile {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? dob;
  int? age;
  int? presentAddressId;
  int? permanentAddressId;
  String? loginAttempt;
  String? image;
  String? nid;
  String? passwordHash;
  String? lastLogin;

  Profile(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.dob,
        this.age,
        this.presentAddressId,
        this.permanentAddressId,
        this.loginAttempt,
        this.image,
        this.nid,
        this.passwordHash,
        this.lastLogin});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    dob = json['dob'];
    age = json['age'];
    presentAddressId = json['presentAddressId'];
    permanentAddressId = json['permanentAddressId'];
    loginAttempt = json['loginAttempt'];
    image = json['image'];
    nid = json['nid'];
    passwordHash = json['passwordHash'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['dob'] = dob;
    data['age'] = age;
    data['presentAddressId'] = presentAddressId;
    data['permanentAddressId'] = permanentAddressId;
    data['loginAttempt'] = loginAttempt;
    data['image'] = image;
    data['nid'] = nid;
    data['passwordHash'] = passwordHash;
    data['lastLogin'] = lastLogin;
    return data;
  }
}
