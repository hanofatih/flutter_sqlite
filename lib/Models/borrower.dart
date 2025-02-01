class Borrower {
  final int? id;
  final String fullname;
  final String phone;

  Borrower({this.id, required this.fullname, required this.phone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'fullname': fullname, 'phone': phone};
  }

  factory Borrower.fromMap(Map<String, dynamic> map) {
    return Borrower(
      id: map['id'],
      fullname: map['fullname'],
      phone: map['phone'],
    );
  }
}
