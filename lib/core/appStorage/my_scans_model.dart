class MyScansModel {
  int? status;
  String? massage;
  List<SavedData>? data;

  MyScansModel({this.status, this.massage, this.data});

  MyScansModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    massage = json['massage'];
    if (json['data'] != null) {
      data = <SavedData>[];
      json['data'].forEach((v) {
        data!.add(SavedData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['massage'] = massage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SavedData {
  int? id;
  String? pin;
  String? serial;
  String? image;
  String? phoneType;
  String? userId;
  String? categoryId;
  String? createdAt;
  String? updatedAt;

  SavedData({
    this.id,
    this.pin,
    this.serial,
    this.image,
    this.phoneType,
    this.userId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  SavedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pin = json['pin'];
    serial = json['serial'];
    image = json['image'];
    phoneType = json['phone_type'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pin'] = pin;
    data['serial'] = serial;
    data['image'] = image;
    data['phone_type'] = phoneType;
    data['user_id'] = userId;
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
