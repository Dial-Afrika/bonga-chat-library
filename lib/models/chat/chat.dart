class AgentMessageModel {
  final String message;
  final DateTime createdAt;
  final String clientId;
  final String agentId;
  final String agentName;

  AgentMessageModel({
    required this.message,
    required this.createdAt,
    required this.clientId,
    required this.agentId,
    required this.agentName,
  });

  factory AgentMessageModel.fromJson(Map<String, dynamic> json) {
    final agent = json['agent'] as Map<String, dynamic>;
    return AgentMessageModel(
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      clientId: json['clientId'],
      agentId: json['id'],
      agentName: agent['name'],
    );
  }
}
