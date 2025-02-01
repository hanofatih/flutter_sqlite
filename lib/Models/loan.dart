class Loan {
  final int? id;
  final int borrowerId;
  final double amount;
  final String date;
  final String? borrowerName;

  Loan({
    this.id,
    required this.borrowerId,
    required this.amount,
    required this.date,
    this.borrowerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'borrower_id': borrowerId,
      'amount': amount,
      'date': date,
    };
  }

  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['id'],
      borrowerId: map['borrower_id'],
      amount: map['amount'],
      date: map['date'],
      borrowerName: map['fullname'],
    );
  }
}
