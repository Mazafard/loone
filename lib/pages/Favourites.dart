import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loone/pages//profilePage.dart';
import 'package:loone/widgets/ads.dart';
import 'package:loone/widgets/progress.dart';

import 'HomePage.dart';

class Favorites extends StatefulWidget {
  final String? userID;
  Favorites({
    required this.userID,
  });
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Favorite> allPosted = [];

  @override
  void initState() {
    super.initState();
    saveFetch();
  }

  saveFetch() async {
    QuerySnapshot<Map<String, dynamic>> snapshot1 =
    await favoriteRef.doc(widget.userID).collection("Favorites").get();
    List<Favorite> kullanicires =
    snapshot1.docs.map((doc) => Favori.fromDocument(doc.data())).toList();
    setState(() {
      this.allPosted = kullanicires;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ilanRef.snapshots(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return circularProgress();
          }
          List<Ilanlar> tumIlanlar = [];
          dataSnapshot.data!.docs.forEach((element) {
            Ilanlar ilan = Ilanlar.fromDocument(element);
            for (var doc in tumIlan) {
              if (ilan.ilanID == doc.ilanID) {
                tumIlanlar.add(ilan);
              }
            }
          });
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.deepPurple[400]),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              title: Text("Favoriler",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[400],
                  )),
              backgroundColor: Colors.white,
            ),
            body: RefreshIndicator(
                color: Colors.black,
                child: ListView(
                  children: tumIlanlar,
                ),
                onRefresh: () {
                  return kaydetmeGetir();
                }),
          );
        });
  }

  onUserTap(String userId, String ilanID) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                profilSayfasi(kullaniciprofilID: userId, ilanID: ilanID)));
  }
}

class Favori {
  final String ilanID;
  final String ownerID;
  final String username;

  Favori({
    required this.ilanID,
    required this.username,
    required this.ownerID,
  });

  factory Favori.fromDocument(Map<String, dynamic> doc) {
    return Favori(
      ilanID: doc['ilanID'],
      ownerID: doc['ownerID'],
      username: doc['username'],
    );
  }
}