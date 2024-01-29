// class AvailableTimeModel {
//   bool? success;
//   List<Data>? datatime;

//   AvailableTimeModel({this.success, this.datatime});

//   AvailableTimeModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       datatime = <Data>[];
//       json['data'].forEach((v) {
//         datatime!.add(Data.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     if (this.datatime != null) {
//       data['data'] = this.datatime!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Data {
//   String? id;
//   String? itemId;
//   String? availableTimeFrom;
//   String? availableTimeTo;
//   String? date;
//   String? status;
//   String? price;

//   Data(
//       {this.id,
//       this.itemId,
//       this.availableTimeFrom,
//       this.availableTimeTo,
//       this.date,
//       this.status,
//       this.price});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     itemId = json['item_id'];
//     availableTimeFrom = json['available_time_from'];
//     availableTimeTo = json['available_time_to'];
//     date = json['date'];
//     status = json['status'];
//     price = json['price'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['item_id'] = itemId;
//     data['available_time_from'] = availableTimeFrom;
//     data['available_time_to'] = availableTimeTo;
//     data['date'] = date;
//     data['status'] = status;
//     data['price'] = price;
//     return data;
//   }
// }

class AvailableTimeModel {
  bool? success;
  List<DataofTime>? data; // Fix: Change from datatime to data

  AvailableTimeModel({this.success, this.data});

  AvailableTimeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataofTime>[];
      json['data'].forEach((v) {
        data!.add(DataofTime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataofTime {
  String? id;
  String? itemId;
  String? availableTimeFrom;
  String? availableTimeTo;
  String? date;
  String? status;
  String? price;

  DataofTime({
    this.id,
    this.itemId,
    this.availableTimeFrom,
    this.availableTimeTo,
    this.date,
    this.status,
    this.price,
  });

  DataofTime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    availableTimeFrom = json['available_time_from'];
    availableTimeTo = json['available_time_to'];
    date = json['date'];
    status = json['status'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_id'] = itemId;
    data['available_time_from'] = availableTimeFrom;
    data['available_time_to'] = availableTimeTo;
    data['date'] = date;
    data['status'] = status;
    data['price'] = price;
    return data;
  }
}
