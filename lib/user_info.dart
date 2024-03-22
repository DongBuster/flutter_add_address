import 'address_info.dart';

class UserInfo {
  late String name;
  late String email;
  late String phoneNumber;
  late DateTime birthday;
  late AddressInfo addressInfo;
  UserInfo();
  // UserInfo({
  //   required this.name,
  //   required this.phoneNumber,
  //   required this.email,
  //   required this.birthday,
  //   required this.addressInfo,
  // });

  UserInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        phoneNumber = json['phoneNumber'] as String,
        email = json['email'] as String,
        birthday = json['birthday'],
        addressInfo = json['addressInfo'] as AddressInfo;
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'birthday': birthday,
        'addressInfo': addressInfo,
      };
}
