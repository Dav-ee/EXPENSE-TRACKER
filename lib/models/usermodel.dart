class UserModel {
  String? uid;
  String? email;
  String? username;
  int? entertainment;
  int? food;
  int? travel;
  int? shopping;
  int? tt_income;
  int? tt_expense;

  UserModel({
    this.uid,
    this.email,
    this.username,
    this.entertainment,
    this.food,
    this.travel,
    this.shopping,
    this.tt_income,
    this.tt_expense,
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      entertainment: map['entertainment'],
      food: map['food'],
      travel: map['travel'],
      shopping: map['shopping'],
      tt_income: map['tt_income'],
      tt_expense: map['tt_expense'],
    );
  }
  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'entertainment': entertainment,
      'food': food,
      'travel': travel,
      'shopping': shopping,
      'tt_income': tt_income,
      'tt_expense': tt_expense,
    };
  }
}
