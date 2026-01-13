class KnowledgeBaseItem {
  final int id;
  final List<String> names;
  final String category;
  final String risk;

  KnowledgeBaseItem({
    required this.id,
    required this.names,
    required this.category,
    required this.risk,
  });

  factory KnowledgeBaseItem.fromJson(Map<String, dynamic> json) {
    return KnowledgeBaseItem(
      id: json['id'],
      names: List<String>.from(json['name'] ?? []),
      category: json['category'] ?? '',
      risk: json['risk'] ?? '',
    );
  }
}
