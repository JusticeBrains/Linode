import 'package:firebase_database/firebase_database.dart';

class UserInfor {
  late var fullName;
  late var email;
  late var phone;
  late var id;

  UserInfor({
    this.email,
    this.fullName,
    this.phone,
    this.id,
  });
  UserInfor.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    fullName = dataSnapshot.value['fullName'];
    email = dataSnapshot.value['email'];
    phone = dataSnapshot.value['phone'];
  }
}
