class LocationItem {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;
  final Map<String, String>? localNames;

  LocationItem({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
    this.localNames,
  });

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      country: json['country'] as String,
      state: json['state'] as String?, // might be missing
      // Convert local_names to a Map<String, String> if present
      localNames: json['local_names'] == null
          ? null
          : Map<String, String>.from(json['local_names']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
      'country': country,
      if (state != null) 'state': state,
      if (localNames != null) 'local_names': localNames,
    };
  }
}

List<LocationItem> parseLocationList(List<dynamic> jsonList) {
  return jsonList
      .map((item) => LocationItem.fromJson(item as Map<String, dynamic>))
      .toList();
}
