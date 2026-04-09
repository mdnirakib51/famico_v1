class FamilyNameModel {
  List<Families>? families;

  FamilyNameModel({this.families});

  FamilyNameModel.fromJson(Map<String, dynamic> json) {
    if (json['families'] != null) {
      families = <Families>[];
      json['families'].forEach((v) {
        families!.add(new Families.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (families != null) {
      data['families'] = families!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Families {
  String? id;
  String? name;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  Families(
      {this.id, this.name, this.createdBy, this.createdAt, this.updatedAt});

  Families.fromJson(Map<String, dynamic> json) {
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
