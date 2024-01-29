class CalenderModel {
  bool success;
  List<String>? availableTime;
  double percent;

  CalenderModel({
    required this.success,
    this.availableTime,
    required this.percent,
  });

  factory CalenderModel.fromJson(Map<String, dynamic> json) {
    return CalenderModel(
      success: json['success'],
      availableTime: List<String>.from(json['available_time'] ?? []),
      percent: json['percent'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'available_time': availableTime,
      'percent': percent,
    };
  }
}