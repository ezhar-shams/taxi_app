class CityModel {
  final String id;
  final String nameFa;
  final String namePs;
  final String province;
  final double lat;
  final double lng;

  const CityModel({
    required this.id,
    required this.nameFa,
    required this.namePs,
    required this.province,
    required this.lat,
    required this.lng,
  });

  String name(String lang) => lang == 'ps' ? namePs : nameFa;

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      nameFa: json['name_fa'] as String,
      namePs: json['name_ps'] as String,
      province: json['province'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name_fa': nameFa,
    'name_ps': namePs,
    'province': province,
    'lat': lat,
    'lng': lng,
  };
}
