class Cashflow {
  int? id;
  String date;
  int nominal;
  String type;
  String? description;
  int timestamp;

  Cashflow({this.id, required this.date, required this.nominal, required this.type, this.description, required this.timestamp});

  Cashflow.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        date = res["date"],
        nominal = res["nominal"],
        type = res["type"],
        description = res["description"],
        timestamp = res["timestamp"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date': date,
      'nominal': nominal,
      'type': type,
      'description': description,
      'timestamp': timestamp,
    };
  }
}
