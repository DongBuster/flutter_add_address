class District {
  late String id;
  late String name;
  late String level;
  late String provinceId;
  District(
      {required this.id,
      required this.name,
      required this.level,
      required this.provinceId});

  District.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        level = json['level'] as String,
        provinceId = json['provinceId'] as String;
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        'provinceId': provinceId,
      };
}
