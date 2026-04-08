class ProfileModel {
  UserInfo? user;

  ProfileModel({this.user});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class UserInfo {
  String? id;
  String? username;
  String? dialCode;
  String? phone;
  String? email;
  String? password;
  String? lastLogin;
  int? loginAttempt;
  int? otp;
  String? blockingTime;
  String? createdAt;
  String? updatedAt;
  Details? details;
  List<Addresses>? addresses;

  UserInfo(
      {this.id,
        this.username,
        this.dialCode,
        this.phone,
        this.email,
        this.password,
        this.lastLogin,
        this.loginAttempt,
        this.otp,
        this.blockingTime,
        this.createdAt,
        this.updatedAt,
        this.details,
        this.addresses});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    dialCode = json['dial_code'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    lastLogin = json['last_login'];
    loginAttempt = json['login_attempt'];
    otp = json['otp'];
    blockingTime = json['blocking_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    details =
    json['details'] != null ? Details.fromJson(json['details']) : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['dial_code'] = dialCode;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['last_login'] = lastLogin;
    data['login_attempt'] = loginAttempt;
    data['otp'] = otp;
    data['blocking_time'] = blockingTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? id;
  String? userId;
  String? name;
  String? gender;
  String? dob;
  int? age;
  String? image;
  String? createdAt;
  String? updatedAt;

  Details(
      {this.id,
        this.userId,
        this.name,
        this.gender,
        this.dob,
        this.age,
        this.image,
        this.createdAt,
        this.updatedAt});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    gender = json['gender'];
    dob = json['dob'];
    age = json['age'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['gender'] = gender;
    data['dob'] = dob;
    data['age'] = age;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Addresses {
  String? id;
  String? userId;
  String? street;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? addressType;
  String? createdAt;
  String? updatedAt;

  Addresses(
      {this.id,
        this.userId,
        this.street,
        this.city,
        this.state,
        this.zip,
        this.country,
        this.addressType,
        this.createdAt,
        this.updatedAt});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    addressType = json['address_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    data['country'] = country;
    data['address_type'] = addressType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
