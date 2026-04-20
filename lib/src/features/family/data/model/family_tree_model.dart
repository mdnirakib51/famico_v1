class FamilyTreeModel {
  List<FamilyMembers>? familyMembers;
  Pagination? pagination;

  FamilyTreeModel({this.familyMembers, this.pagination});

  FamilyTreeModel.fromJson(Map<String, dynamic> json) {
    if (json['familyMembers'] != null) {
      familyMembers = <FamilyMembers>[];
      json['familyMembers'].forEach((v) {
        familyMembers!.add(FamilyMembers.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (familyMembers != null) {
      data['familyMembers'] =
          familyMembers!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class FamilyMembers {
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
  List<Relationships>? relationships;

  FamilyMembers(
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
        this.relationships});

  FamilyMembers.fromJson(Map<String, dynamic> json) {
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
    if (json['relationships'] != null) {
      relationships = <Relationships>[];
      json['relationships'].forEach((v) {
        relationships!.add(Relationships.fromJson(v));
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
    if (relationships != null) {
      data['relationships'] =
          relationships!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Relationships {
  String? id;
  String? familyId;
  String? memberId;
  String? relativeId;
  int? relationId;
  int? relationshipId;
  String? createdAt;
  String? updatedAt;
  Relative? relative;
  RelationNames? relationNames;
  RelationNames? relationshipTypes;

  Relationships(
      {this.id,
        this.familyId,
        this.memberId,
        this.relativeId,
        this.relationId,
        this.relationshipId,
        this.createdAt,
        this.updatedAt,
        this.relative,
        this.relationNames,
        this.relationshipTypes});

  Relationships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    familyId = json['family_id'];
    memberId = json['member_id'];
    relativeId = json['relative_id'];
    relationId = json['relation_id'];
    relationshipId = json['relationship_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    relative = json['relative'] != null
        ? Relative.fromJson(json['relative'])
        : null;
    relationNames = json['relation_names'] != null
        ? RelationNames.fromJson(json['relation_names'])
        : null;
    relationshipTypes = json['relationship_types'] != null
        ? RelationNames.fromJson(json['relationship_types'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['family_id'] = familyId;
    data['member_id'] = memberId;
    data['relative_id'] = relativeId;
    data['relation_id'] = relationId;
    data['relationship_id'] = relationshipId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (relative != null) {
      data['relative'] = relative!.toJson();
    }
    if (relationNames != null) {
      data['relation_names'] = relationNames!.toJson();
    }
    if (relationshipTypes != null) {
      data['relationship_types'] = relationshipTypes!.toJson();
    }
    return data;
  }
}

class Relative {
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

  Relative(
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
        this.updatedAt});

  Relative.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class RelationNames {
  int? id;
  String? relationship;
  String? createdAt;
  String? updatedAt;

  RelationNames({this.id, this.relationship, this.createdAt, this.updatedAt});

  RelationNames.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relationship = json['relationship'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['relationship'] = relationship;
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
