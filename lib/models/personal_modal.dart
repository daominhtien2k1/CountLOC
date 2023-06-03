class UserInfo {
  UserInfo({
    required this.avatar,
    required this.coverImage,
    required this.name,
    required this.gender,
    required this.phoneNumber,
    required this.description,
    required this.city,
    required this.country,
    required this.createdAt,
  });

  final String avatar;
  final String coverImage;
  final String name;
  final String gender;
  final String phoneNumber;
  final String description;
  final String city;
  final String country;
  final String createdAt;

  UserInfo.initial()
      : avatar = "",
        coverImage = "",
        name = "",
        gender = "",
        phoneNumber = "",
        description = "",
        city = "",
        country = "",
        createdAt = "";

  UserInfo copyWith({
    String? avatar,
    String? coverImage,
    String? name,
    String? gender,
    String? phoneNumber,
    String? description,
    String? city,
    String? country,
    String? createdAt,
  }) =>
      UserInfo(
        avatar: avatar ?? this.avatar,
        coverImage: coverImage ?? this.coverImage,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        description: description ?? this.description,
        city: city ?? this.city,
        country: country ?? this.country,
        createdAt: createdAt ?? this.createdAt,
      );

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        avatar: json["avatar"],
        coverImage: json["coverImage"],
        name: json["name"],
        gender: json["gender"],
        phoneNumber: json["phoneNumber"],
        description: json["description"],
        city: json["city"],
        country: json["country"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "coverImage": coverImage,
        "name": name,
        "gender": gender,
        "phoneNumber": phoneNumber,
        "description": description,
        "city": city,
        "country": country,
        "createdAt": createdAt,
      };
}
