class CalenderModel {
  bool? success;
  List<dynamic>? availableTime;
  int? percent;

  CalenderModel({this.success, this.availableTime, this.percent});

  CalenderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    availableTime = json['available_time'];
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['available_time'] = availableTime;
    data['percent'] = percent;
    return data;
  }
}
