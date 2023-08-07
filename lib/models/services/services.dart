class Services {
  String type;
  String key;
  String value;
  String label;
  String description;

  Services ({
    required this.type,
    required this.key,
    required this.value,
    required this.label,
    required this.description,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      type: json['type'],
      key: json['value'],
      value: json['value'],
      label: json['label'],
      description: json['description'],
    );
  }
}