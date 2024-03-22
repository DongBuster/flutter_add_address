class Province {
  late String id;
  late String name;
  late String level;
  Province({
    required this.id,
    required this.name,
    required this.level,
  });

  Province.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        level = json['level'] as String;
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
      };
}
