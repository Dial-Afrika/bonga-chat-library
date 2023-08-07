class Categories {
  String type;
  String key;
  String value;
  String label;
  String description;

  Categories({
    required this.type,
    required this.key,
    required this.value,
    required this.label,
    required this.description,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      type: json['type'],
      key: json['value'],
      value: json['value'],
      label: json['label'],
      description: json['description'],
    );
  }
}