class FamilyMemberModel {
  List<Members>? members;
  Pagination? pagination;

  FamilyMemberModel({this.members, this.pagination});

  FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Members {
  String? id;
  String? familyId;
  String? name;
  String? dob;
  String? phone;
  String? email;
  String? spouseName;
  int? childrenCount;
  String? status;
  String? image;
  String? nid;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  Family? family;
  List<MemberAddresses>? memberAddresses;

  Members(
      {this.id,
        this.familyId,
        this.name,
        this.dob,
        this.phone,
        this.email,
        this.spouseName,
        this.childrenCount,
        this.status,
        this.image,
        this.nid,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.family,
        this.memberAddresses});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    familyId = json['family_id'];
    name = json['name'];
    dob = json['dob'];
    phone = json['phone'];
    email = json['email'];
    spouseName = json['spouse_name'];
    childrenCount = json['children_count'];
    status = json['status'];
    image = json['image'];
    nid = json['nid'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    family =
    json['family'] != null ? Family.fromJson(json['family']) : null;
    if (json['member_addresses'] != null) {
      memberAddresses = <MemberAddresses>[];
      json['member_addresses'].forEach((v) {
        memberAddresses!.add(MemberAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['family_id'] = familyId;
    data['name'] = name;
    data['dob'] = dob;
    data['phone'] = phone;
    data['email'] = email;
    data['spouse_name'] = spouseName;
    data['children_count'] = childrenCount;
    data['status'] = status;
    data['image'] = image;
    data['nid'] = nid;
    data['added_by'] = addedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (family != null) {
      data['family'] = family!.toJson();
    }
    if (memberAddresses != null) {
      data['member_addresses'] =
          memberAddresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Family {
  String? id;
  String? name;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  Family({this.id, this.name, this.createdBy, this.createdAt, this.updatedAt});

  Family.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MemberAddresses {
  String? id;
  String? memberId;
  String? street;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? addressType;
  String? createdAt;
  String? updatedAt;

  MemberAddresses(
      {this.id,
        this.memberId,
        this.street,
        this.city,
        this.state,
        this.zip,
        this.country,
        this.addressType,
        this.createdAt,
        this.updatedAt});

  MemberAddresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
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
    data['member_id'] = memberId;
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

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({this.total, this.page, this.limit, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    return data;
  }
}
