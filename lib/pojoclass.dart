// ignore_for_file: file_names, unnecessary_new, non_constant_identifier_names

class BookKeeperModel {
  int? userid;
  int? flow;
  String? appToken;
  String userFirstName;
  String userMiddleName;
  String userLastName;
  String userEmailAddress;
  String userMobileNumber;
  var profileImage;
  String? gender;
  String rolename;

  BookKeeperModel({
    required this.userid,
    required this.flow,
    required this.appToken,
    required this.userFirstName,
    required this.userMiddleName,
    required this.userLastName,
    required this.userEmailAddress,
    required this.userMobileNumber,
    required this.profileImage,
    required this.gender,
    required this.rolename,
  });

  // ignore: unnecessary_new
  factory BookKeeperModel.fromMap(Map<String, dynamic> json) =>
      new BookKeeperModel(
        userid: json['userid'],
        flow: json['flow'],
        appToken: json['appToken'],
        userFirstName: json['userFirstName'],
        userMiddleName: json['userMiddleName'],
        userLastName: json["userLastName"],
        userEmailAddress: json['userEmailAddress'],
        userMobileNumber: json['userMobileNumber'],
        profileImage: json['profileImage'],
        gender: json['gender'],
        rolename: json['rolename'],
      );
  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      "flow": flow,
      "appToken": appToken,
      "userFirstName": userFirstName,
      "userMiddleName": userMiddleName,
      "userLastName": userLastName,
      'userEmailAddress': userEmailAddress,
      'userMobileNumber': userMobileNumber,
      'profileImage': profileImage,
      'gender': gender,
      'rolename': rolename,
    };
  }
}

// ignore_for_file: file_names, unnecessary_new
class Modeofpayment {
  int modeOfPaymentId;
  int paymentValue;

  Modeofpayment({
    required this.modeOfPaymentId,
    required this.paymentValue,
  });

  // ignore: unnecessary_new
  factory Modeofpayment.fromMap(Map<String, dynamic> json) => new Modeofpayment(
        modeOfPaymentId: json['modeOfPaymentId'],
        paymentValue: json['paymentValue'],
      );
  Map<String, dynamic> toMap() {
    return {
      'modeOfPaymentId': modeOfPaymentId,
      "paymentValue": paymentValue,
    };
  }
}
