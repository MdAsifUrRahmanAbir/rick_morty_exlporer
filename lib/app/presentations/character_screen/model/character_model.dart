class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final CharacterLocation origin;
  final CharacterLocation location;
  final String image;
  final List<String> episode;
  final String url;
  final DateTime created;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      origin: CharacterLocation.fromJson(json['origin'] ?? {}),
      location: CharacterLocation.fromJson(json['location'] ?? {}),
      image: json['image'] ?? '',
      episode: List<String>.from(json['episode'] ?? []),
      url: json['url'] ?? '',
      created: DateTime.parse(json['created'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': origin.toJson(),
      'location': location.toJson(),
      'image': image,
      'episode': episode,
      'url': url,
      'created': created.toIso8601String(),
    };
  }

  CharacterModel copyWith({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    CharacterLocation? origin,
    CharacterLocation? location,
  }) {
    return CharacterModel(
      id: id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      location: location ?? this.location,
      image: image,
      episode: episode,
      url: url,
      created: created,
    );
  }
}

class CharacterLocation {
  final String name;
  final String url;

  CharacterLocation({
    required this.name,
    required this.url,
  });

  factory CharacterLocation.fromJson(Map<String, dynamic> json) {
    return CharacterLocation(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class CharacterResponse {
  final List<CharacterModel> results;
  final int totalPages;
  final int totalCount;
  final String? nextUrl;

  CharacterResponse({
    required this.results,
    required this.totalPages,
    required this.totalCount,
    this.nextUrl,
  });

  factory CharacterResponse.fromJson(Map<String, dynamic> json) {
    final info = json['info'] ?? {};
    return CharacterResponse(
      results: (json['results'] as List?)
              ?.map((c) => CharacterModel.fromJson(c))
              .toList() ??
          [],
      totalPages: info['pages'] ?? 0,
      totalCount: info['count'] ?? 0,
      nextUrl: info['next'],
    );
  }
}
