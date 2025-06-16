import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c14_online_sun/core/resources/constant_manager.dart';
import 'package:evently_c14_online_sun/data/data_model/categoryDM.dart';

class EventDM
{
  String id;
  final String title;
  final String description;
  final CategoryDM category;
  final DateTime dateTime;
  final double? lat;
  final double? lng;

  EventDM(
      {
        this.id = "",
    required this.title,
    required this.description,
    required this.category,
    required this.dateTime,
    this.lat=0.0,
    this.lng=0.0});

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "categoryId": category.id,
    "date": Timestamp.fromDate(dateTime),
    "lat": lat,
    "lng": lng,
  };

  EventDM.fromJson(Map<String, dynamic> json)
      : this(
    id: json['id'],
    title: json["title"],
    description: json["description"],
    category: ConstantManager.categoriesWithoutAll.firstWhere(
          (category) => category.id == json["categoryId"],
    ),
    dateTime: (json["date"] as Timestamp).toDate(),
    lat: json["lat"]??0.0,
    lng: json["lng"]?? 0.0,
  );
}
