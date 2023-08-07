class FaqModel {
  String type;
  String key;
  String value;
  String label;
  String description;

  FaqModel({
    required this.type,
    required this.key,
    required this.value,
    required this.label,
    required this.description,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      type: json['type'],
      key: json['value'],
      value: json['value'],
      label: json['label'],
      description: json['description'],
    );
  }
}
