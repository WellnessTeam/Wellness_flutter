class UserProfileModel {
  final String bio; // 간단한 자기 소개
  final String link; // 사용자가 추가할 웹사이트 링크
  final String email; // 사용자의 이메일
  final String uid; // 사용자의 고유 식별자
  final String name; // 사용자의 이름
  final String sex; // 사용자의 성별
  final double height; // 사용자의 키
  final double weight; // 사용자의 몸무게

  UserProfileModel({
    required this.bio,
    required this.link,
    required this.email,
    required this.uid,
    required this.name,
    required this.sex,
    required this.height,
    required this.weight,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      bio: json['bio'] ?? '',
      link: json['link'] ?? '',
      email: json['email'] ?? '',
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      sex: json['sex'] ?? '',
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'link': link,
      'email': email,
      'uid': uid,
      'name': name,
      'sex': sex,
      'height': height,
      'weight': weight,
    };
  }

  UserProfileModel copyWith({
    String? bio,
    String? link,
    String? email,
    String? uid,
    String? name,
    String? sex,
    double? height,
    double? weight,
  }) {
    return UserProfileModel(
      bio: bio ?? this.bio,
      link: link ?? this.link,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  static UserProfileModel empty() {
    return UserProfileModel(
      bio: '',
      link: '',
      email: '',
      uid: '',
      name: '',
      sex: '',
      height: 0.0,
      weight: 0.0,
    );
  }
}
