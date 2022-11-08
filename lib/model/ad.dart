import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  final String? adID;
  final String? ownerBiography;
  final String? ownerProfileName;
  final String? adUse;
  final String? province;
  final String? district;
  final String? neighbourhood;
  final String? categoryName;
  final String? typeName;
  final String? broadcastName;
  final double? latitude;
  final double? longitude;
  final String? adCaptain;
  final String? adPrice;
  final String? adSquareMeters;
  final String? adNumberRooms;
  final String? adNumberBathrooms;
  final String? adNumberFloors;
  final String? adBuildingAge;
  final String? adCredit;
  final String? adWarmup;
  final String? adStructure;
  final String? adNumberHalls;
  final List? AdditionalFeatures;
  final String? ownerID;
  final String? ownerUrl;
  final likes;
  final String? username;
  final String? announcement;
  final Timestamp? timestamp;
  final String? frontUrl;
  final registered;

  Ad({
    this.adID,
    this.ownerBiography,
    this.ownerProfileName,
    this.adUse,
    this.province,
    this.district,
    this.neighbourhood,
    this.categoryName,
    this.typeName,
    this.broadcastName,
    this.latitude,
    this.longitude,
    this.adCaptain,
    this.adPrice,
    this.adSquareMeters,
    this.adNumberRooms,
    this.adNumberBathrooms,
    this.adNumberFloors,
    this.adBuildingAge,
    this.adCredit,
    this.adWarmup,
    this.adStructure,
    this.adNumberHalls,
    this.AdditionalFeatures,
    this.ownerID,
    this.ownerUrl,
    this.likes,
    this.username,
    this.announcement,
    this.timestamp,
    this.frontUrl,
    this.registered,
  });

  factory Ad.fromDocument(DocumentSnapshot doc) {
    return Ad(
      adID: doc['adID'],
      ownerBiography: doc['ownerBiography'],
      ownerProfileName: doc['ownerProfileName'],
      adUse: doc['adUse'],
      province: doc['province'],
      district: doc['district'],
      neighbourhood: doc['neighbourhood'],
      categoryName: doc['categoryName'],
      typeName: doc['typeName'],
      broadcastName: doc['broadcastName'],
      latitude: doc['latitude'],
      longitude: doc['longitude'],
      adCaptain: doc['adCaptain'],
      adPrice: doc['adPrice'],
      adSquareMeters: doc['adSquareMeters'],
      adNumberRooms: doc['adNumberRooms'],
      adNumberBathrooms: doc['adNumberBathrooms'],
      adNumberFloors: doc['adNumberFloors'],
      adBuildingAge: doc['adBuildingAge'],
      adCredit: doc['adCredit'],
      adWarmup: doc['adWarmup'],
      adStructure: doc['adStructure'],
      adNumberHalls: doc['adNumberHalls'],
      AdditionalFeatures: doc['AdditionalFeatures'],
      ownerID: doc['ownerID'],
      ownerUrl: doc['ownerUrl'],
      likes: doc['likes'],
      username: doc['username'],
      announcement: doc['announcement'],
      timestamp: doc['timestamp'],
      frontUrl: doc['frontUrl'],
      registered: doc['registered'],
    );
  }
}