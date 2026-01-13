class UserModel {
  final String? uid;
  final String email;
  final String? fullName;
  final int? phoneNo;

  UserModel({
    required this.uid,
    required this.email,
    this.fullName,
    this.phoneNo,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      fullName: map['full_name'] as String?,
      phoneNo: map['phone_no'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'full_name': fullName,
      'phone_no': phoneNo,
    };
  }
}
