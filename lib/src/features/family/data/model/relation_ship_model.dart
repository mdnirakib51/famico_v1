class RelationShipModel {
  List<Relationships>? relationships;

  RelationShipModel({this.relationships});

  RelationShipModel.fromJson(Map<String, dynamic> json) {
    if (json['relationships'] != null) {
      relationships = <Relationships>[];
      json['relationships'].forEach((v) {
        relationships!.add(Relationships.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (relationships != null) {
      data['relationships'] =
          relationships!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Relationships {
  int? id;
  String? relationship;
  String? createdAt;
  String? updatedAt;

  Relationships({this.id, this.relationship, this.createdAt, this.updatedAt});

  Relationships.fromJson(Map<String, dynamic> json) {
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
