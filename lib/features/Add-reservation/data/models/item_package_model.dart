class itemPackage {
  bool? success;
  List<Data>? data;

  itemPackage({this.success, this.data});

  itemPackage.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? itemId;
  String? availableTimeFrom;
  String? availableTimeTo;
  String? date;
  String? status;
  String? price;

  Data(
      {this.id,
        this.itemId,
        this.availableTimeFrom,
        this.availableTimeTo,
        this.date,
        this.status,
        this.price});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?? "";
    itemId = json['item_id'] ?? "";
    availableTimeFrom = json['available_time_from'] ??"";
    availableTimeTo = json['available_time_to']??"";
    date = json['date']??"";
    status = json['status']??"";
    price = json['price']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['available_time_from'] = this.availableTimeFrom;
    data['available_time_to'] = this.availableTimeTo;
    data['date'] = this.date;
    data['status'] = this.status;
    data['price'] = this.price;
    return data;
  }
}
