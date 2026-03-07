enum UserRole { passenger, driver, admin }

class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final UserRole role;
  final String? avatarUrl;
  final DateTime createdAt;
  final int totalBookings;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
    required this.totalBookings,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.passenger,
      ),
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      totalBookings: json['total_bookings'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'phone': phone,
    'email': email,
    'role': role.name,
    'avatar_url': avatarUrl,
    'created_at': createdAt.toIso8601String(),
    'total_bookings': totalBookings,
  };

  UserModel copyWith({
    String? fullName,
    String? email,
    String? avatarUrl,
    int? totalBookings,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone,
      email: email ?? this.email,
      role: role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
      totalBookings: totalBookings ?? this.totalBookings,
    );
  }
}
