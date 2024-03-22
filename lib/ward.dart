class Ward {
  late String? id;
  late String? name;
  late String level;
  late String provinceId;
  late String districtId;

  Ward({
    required this.id,
    required this.name,
    required this.level,
    required this.provinceId,
    required this.districtId,
  });

  Ward.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        level = json['level'] as String,
        provinceId = json['provinceId'] as String,
        districtId = json['districtId'] as String;
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        'provinceId': provinceId,
        'districtId': districtId,
      };
}
