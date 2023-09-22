import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email, userId, userPhone;
  List<ScannedQrcodes> qrCollection;
  List<ScannedText> textCollection;
  UserModel({
    this.name,
    this.email,
    this.userId,
    this.userPhone,
    List<ScannedQrcodes>? qrCollection,
    List<ScannedText>? textCollection,
  })  : qrCollection = qrCollection ?? [],
        textCollection = textCollection ?? [];

  Map<String, dynamic> asMap() {
    return {
      'name': name ?? '',
      'email': email ?? '',
      'userId': userId ?? '',
      'userPhone': userPhone ?? '',
      // 'qrCollection': qrCollection.map((qr) => qr.asMap()).toList(),
      // 'textCollection': qrCollection.map((text) => text.asMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      userId: map['userId'],
      email: map['email'],
      userPhone: map['userPhone'],
    );
  }
}

class ScannedQrcodes {
  DateTime? timestamp;
  String? result;

  ScannedQrcodes({this.result, this.timestamp});
  Map<String, dynamic> asMap() {
    return {
      'result': result ?? '',
      'timestamp': timestamp?.toUtc(),
    };
  }

  factory ScannedQrcodes.fromMap(Map<String, dynamic> map) {
    return ScannedQrcodes(
      result: map['result'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}

class ScannedText {
  DateTime? timestamp;
  String? result;
  // String? imageUrl;

  ScannedText({this.result, this.timestamp});
  Map<String, dynamic> asMap() {
    return {
      'result': result ?? '',
      'timestamp': timestamp?.toUtc(),
      // 'imageUrl': imageUrl ?? '',
    };
  }

  factory ScannedText.fromMap(Map<String, dynamic> map) {
    return ScannedText(
      result: map['result'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate(),
      // imageUrl: map['imageUrl'],
    );
  }
}
