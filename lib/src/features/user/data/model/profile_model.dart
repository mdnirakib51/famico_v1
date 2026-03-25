class ProfileModel {
  Profile? profile;

  ProfileModel({this.profile});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    profile =
    json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
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
  Null? loginAttempt;
  String? image;
  String? nid;
  String? lastLogin;
  PresentAddress? presentAddress;
  PresentAddress? permanentAddress;
  AuthEntity? authEntity;

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
        this.lastLogin,
        this.presentAddress,
        this.permanentAddress,
        this.authEntity});

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
    lastLogin = json['lastLogin'];
    presentAddress = json['presentAddress'] != null
        ? PresentAddress.fromJson(json['presentAddress'])
        : null;
    permanentAddress = json['permanentAddress'] != null
        ? PresentAddress.fromJson(json['permanentAddress'])
        : null;
    authEntity = json['authEntity'] != null
        ? AuthEntity.fromJson(json['authEntity'])
        : null;
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
    data['lastLogin'] = lastLogin;
    if (presentAddress != null) {
      data['presentAddress'] = presentAddress!.toJson();
    }
    if (permanentAddress != null) {
      data['permanentAddress'] = permanentAddress!.toJson();
    }
    if (authEntity != null) {
      data['authEntity'] = authEntity!.toJson();
    }
    return data;
  }
}

class PresentAddress {
  int? id;
  String? street;
  String? zip;
  String? city;
  String? state;
  String? country;
  String? addressType;
  int? createdByUserId;

  PresentAddress(
      {this.id,
        this.street,
        this.zip,
        this.city,
        this.state,
        this.country,
        this.addressType,
        this.createdByUserId});

  PresentAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    street = json['street'];
    zip = json['zip'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    addressType = json['addressType'];
    createdByUserId = json['createdByUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['street'] = street;
    data['zip'] = zip;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['addressType'] = addressType;
    data['createdByUserId'] = createdByUserId;
    return data;
  }
}

class AuthEntity {
  int? id;
  String? username;
  String? phone;
  String? email;
  String? passwordHash;
  Null? loginAttempt;
  String? lastLogin;
  Null? blockingTime;

  AuthEntity(
      {this.id,
        this.username,
        this.phone,
        this.email,
        this.passwordHash,
        this.loginAttempt,
        this.lastLogin,
        this.blockingTime});

  AuthEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    phone = json['phone'];
    email = json['email'];
    passwordHash = json['passwordHash'];
    loginAttempt = json['loginAttempt'];
    lastLogin = json['lastLogin'];
    blockingTime = json['blockingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['phone'] = phone;
    data['email'] = email;
    data['passwordHash'] = passwordHash;
    data['loginAttempt'] = loginAttempt;
    data['lastLogin'] = lastLogin;
    data['blockingTime'] = blockingTime;
    return data;
  }
}
