enum PGType {
  girls('Girls PG'),
  boys('Boys PG'),
  coLiving('Co-living');

  final String label;
  const PGType(this.label);

  static PGType fromString(String value) {
    if (value.toLowerCase().contains('girl')) return PGType.girls;
    if (value.toLowerCase().contains('boy')) return PGType.boys;
    return PGType.coLiving;
  }
}

enum PGAvailability {
  available('Available'),
  limited('Limited Availability'),
  full('Full'),
  temporarilyUnavailable('Unavailable');

  final String label;
  const PGAvailability(this.label);

  static PGAvailability fromString(String value) {
    switch (value.toLowerCase()) {
      case 'limited':
      case 'limited availability':
        return PGAvailability.limited;
      case 'full':
        return PGAvailability.full;
      case 'unavailable':
      case 'temporarily unavailable':
        return PGAvailability.temporarilyUnavailable;
      default:
        return PGAvailability.available;
    }
  }
}

enum PGVerificationStatus {
  draft('Draft'),
  pendingVerification('Pending Verification'),
  verified('Verified'),
  published('Published'),
  suspended('Suspended'),
  archived('Archived');

  final String label;
  const PGVerificationStatus(this.label);
}

class LandmarkInfo {
  final String name;
  final String distance;

  const LandmarkInfo({required this.name, required this.distance});

  Map<String, dynamic> toJson() => {'name': name, 'distance': distance};

  factory LandmarkInfo.fromJson(Map<String, dynamic> json) => LandmarkInfo(
    name: json['name'] as String,
    distance: json['distance'] as String,
  );
}

class VirtualTourScene {
  final String id;
  final String title;
  final String roomType; // e.g. "Bedroom", "Kitchen", "Lounge", "Study Area"
  final String imageUrl;
  final String description;

  const VirtualTourScene({
    required this.id,
    required this.title,
    required this.roomType,
    required this.imageUrl,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'roomType': roomType,
    'imageUrl': imageUrl,
    'description': description,
  };

  factory VirtualTourScene.fromJson(Map<String, dynamic> json) =>
      VirtualTourScene(
        id: json['id'] as String,
        title: json['title'] as String,
        roomType: json['roomType'] as String,
        imageUrl: json['imageUrl'] as String,
        description: json['description'] as String,
      );
}

class PGModel {
  final String id;
  final String name;
  final PGType type;
  final String description;
  final double monthlyRent;
  final double securityDeposit;
  final String sharingType; // e.g. "1, 2 & 3 Sharing" or "2 Sharing"
  final String minimumStay; // e.g. "3 Months"
  final String foodOption; // e.g. "3 Meals Included (Veg/Non-Veg)"
  final String electricityOption; // e.g. "Included in rent" or "₹10/unit"
  final String address;
  final String locality; // e.g. "Navrangpura", "Satellite", "Maninagar"
  final String city; // e.g. "Ahmedabad"
  final double latitude;
  final double longitude;
  final double distanceKm;
  final String contactNumber;
  final bool isVerified;
  final PGAvailability availability;
  final PGVerificationStatus verificationStatus;
  final List<String> photos;
  final List<String> amenities;
  final List<String> rules;
  final List<LandmarkInfo> nearbyLandmarks;
  final List<VirtualTourScene> virtualTourScenes;
  final String youtubeVideoTitle;
  final String youtubeVideoId;
  final int likesCount;
  final int viewsCount;
  final int contactUnlocksCount;
  final int enrollmentsCount;
  final DateTime createdAt;

  const PGModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.sharingType,
    required this.minimumStay,
    required this.foodOption,
    required this.electricityOption,
    required this.address,
    required this.locality,
    this.city = 'Ahmedabad',
    required this.latitude,
    required this.longitude,
    this.distanceKm = 1.2,
    required this.contactNumber,
    this.isVerified = true,
    this.availability = PGAvailability.available,
    this.verificationStatus = PGVerificationStatus.published,
    required this.photos,
    required this.amenities,
    required this.rules,
    required this.nearbyLandmarks,
    required this.virtualTourScenes,
    required this.youtubeVideoTitle,
    required this.youtubeVideoId,
    this.likesCount = 0,
    this.viewsCount = 0,
    this.contactUnlocksCount = 0,
    this.enrollmentsCount = 0,
    required this.createdAt,
  });

  PGModel copyWith({
    String? id,
    String? name,
    PGType? type,
    String? description,
    double? monthlyRent,
    double? securityDeposit,
    String? sharingType,
    String? minimumStay,
    String? foodOption,
    String? electricityOption,
    String? address,
    String? locality,
    String? city,
    double? latitude,
    double? longitude,
    double? distanceKm,
    String? contactNumber,
    bool? isVerified,
    PGAvailability? availability,
    PGVerificationStatus? verificationStatus,
    List<String>? photos,
    List<String>? amenities,
    List<String>? rules,
    List<LandmarkInfo>? nearbyLandmarks,
    List<VirtualTourScene>? virtualTourScenes,
    String? youtubeVideoTitle,
    String? youtubeVideoId,
    int? likesCount,
    int? viewsCount,
    int? contactUnlocksCount,
    int? enrollmentsCount,
    DateTime? createdAt,
  }) {
    return PGModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      sharingType: sharingType ?? this.sharingType,
      minimumStay: minimumStay ?? this.minimumStay,
      foodOption: foodOption ?? this.foodOption,
      electricityOption: electricityOption ?? this.electricityOption,
      address: address ?? this.address,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceKm: distanceKm ?? this.distanceKm,
      contactNumber: contactNumber ?? this.contactNumber,
      isVerified: isVerified ?? this.isVerified,
      availability: availability ?? this.availability,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      photos: photos ?? this.photos,
      amenities: amenities ?? this.amenities,
      rules: rules ?? this.rules,
      nearbyLandmarks: nearbyLandmarks ?? this.nearbyLandmarks,
      virtualTourScenes: virtualTourScenes ?? this.virtualTourScenes,
      youtubeVideoTitle: youtubeVideoTitle ?? this.youtubeVideoTitle,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      likesCount: likesCount ?? this.likesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      contactUnlocksCount: contactUnlocksCount ?? this.contactUnlocksCount,
      enrollmentsCount: enrollmentsCount ?? this.enrollmentsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'description': description,
    'monthlyRent': monthlyRent,
    'securityDeposit': securityDeposit,
    'sharingType': sharingType,
    'minimumStay': minimumStay,
    'foodOption': foodOption,
    'electricityOption': electricityOption,
    'address': address,
    'locality': locality,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
    'distanceKm': distanceKm,
    'contactNumber': contactNumber,
    'isVerified': isVerified,
    'availability': availability.name,
    'verificationStatus': verificationStatus.name,
    'photos': photos,
    'amenities': amenities,
    'rules': rules,
    'nearbyLandmarks': nearbyLandmarks.map((e) => e.toJson()).toList(),
    'virtualTourScenes': virtualTourScenes.map((e) => e.toJson()).toList(),
    'youtubeVideoTitle': youtubeVideoTitle,
    'youtubeVideoId': youtubeVideoId,
    'likesCount': likesCount,
    'viewsCount': viewsCount,
    'contactUnlocksCount': contactUnlocksCount,
    'enrollmentsCount': enrollmentsCount,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PGModel.fromJson(Map<String, dynamic> json) {
    return PGModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: PGType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PGType.girls,
      ),
      description: json['description'] as String,
      monthlyRent: (json['monthlyRent'] as num).toDouble(),
      securityDeposit: (json['securityDeposit'] as num).toDouble(),
      sharingType: json['sharingType'] as String,
      minimumStay: json['minimumStay'] as String,
      foodOption: json['foodOption'] as String,
      electricityOption: json['electricityOption'] as String,
      address: json['address'] as String,
      locality: json['locality'] as String,
      city: (json['city'] as String?) ?? 'Ahmedabad',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 1.2,
      contactNumber: json['contactNumber'] as String,
      isVerified: json['isVerified'] as bool? ?? true,
      availability: PGAvailability.values.firstWhere(
        (e) => e.name == json['availability'],
        orElse: () => PGAvailability.available,
      ),
      verificationStatus: PGVerificationStatus.values.firstWhere(
        (e) => e.name == json['verificationStatus'],
        orElse: () => PGVerificationStatus.published,
      ),
      photos: List<String>.from(json['photos'] as List),
      amenities: List<String>.from(json['amenities'] as List),
      rules: List<String>.from(json['rules'] as List),
      nearbyLandmarks: (json['nearbyLandmarks'] as List)
          .map((e) => LandmarkInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      virtualTourScenes: (json['virtualTourScenes'] as List)
          .map((e) => VirtualTourScene.fromJson(e as Map<String, dynamic>))
          .toList(),
      youtubeVideoTitle: json['youtubeVideoTitle'] as String,
      youtubeVideoId: json['youtubeVideoId'] as String,
      likesCount: json['likesCount'] as int? ?? 0,
      viewsCount: json['viewsCount'] as int? ?? 0,
      contactUnlocksCount: json['contactUnlocksCount'] as int? ?? 0,
      enrollmentsCount: json['enrollmentsCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
