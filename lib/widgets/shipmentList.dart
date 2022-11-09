import 'package:flutter/material.dart';
import 'package:loone/pages//sendScreenPage.dart';

import 'Ads.dart';

// ignore: camel_case_types
class shipmentListing extends StatelessWidget {
  final ads? send;
  gonderiListeleme(this.gonderi);
  tumIlanlariGoster(context, {String? gonderiID, String? kullaniciID}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => gonderiEkranSayfasi(
                gonderiID: gonderiID!, kullaniciID: kullaniciID!)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tumIlanlariGoster(context,
            gonderiID: gonderi!.ilanID, kullaniciID: gonderi!.ownerID);
      },
      child: Image.network(gonderi!.frontUrl as String),
    );
  }
}