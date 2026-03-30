class AddressListModel {
  List<Address>? address;

  AddressListModel({this.address});

  AddressListModel.fromJson(Map<String, dynamic> json) {
    if (json['address'] != null) {
      address = <Address>[];
      json['address'].forEach((v) {
        address!.add(Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  int? id;
  String? street;
  String? zip;
  String? city;
  String? state;
  String? country;
  String? addressType;
  int? createdByUserId;

  Address(
      {this.id,
        this.street,
        this.zip,
        this.city,
        this.state,
        this.country,
        this.addressType,
        this.createdByUserId});

  Address.fromJson(Map<String, dynamic> json) {
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
