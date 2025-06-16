class userDM {
  static userDM? currentUser;

  String id;
  String name;
  String email;
  List<String> favouriteEventsIds;

  userDM(
      {required this.id,
        required this.name,
        required this.email,
        required this.favouriteEventsIds});

  userDM.fromJson(Map<String, dynamic> json)
      : this(
      id: json["id"],
      name: json['name'],
      email: json["email"],
      favouriteEventsIds: (json["favouriteEventsIds"] as List<dynamic>)
          .map(
            (e) => e.toString(),
      )
          .toList());

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "favouriteEventsIds": favouriteEventsIds,
  };
}