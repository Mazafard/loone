import "package:flutter/material.dart";

PreferredSize title(context, {bool applicationTitle = false, required String strTitle, backButtonIgnore = false}) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        elevation: 10,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: backButtonIgnore ? false : true,
        title: Text(
          applicationTitle ? "FutureBack" : strTitle,
          style: TextStyle(
            color: Colors.black,
            fontFamily: applicationTitle ? "Signatra" : "",
            fontSize: applicationTitle ? 50.0 : 22.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(50), bottomLeft: Radius.circular(50)),
        ),
      ));
}
