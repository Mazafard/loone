import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loone/model/User.dart';
import 'package:loone/widgets/progress.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'LoginDisplay.dart';
import 'AccountCreationPage2.dart';
import 'AccountCreationPage.dart';

User? instantUser;

final userRef = FirebaseFirestore.instance.collection("users");
final notificationRef = FirebaseFirestore.instance.collection("notifications");
final commentRef = FirebaseFirestore.instance.collection("comments");
final followerRef = FirebaseFirestore.instance.collection("followers");
final followedRef = FirebaseFirestore.instance.collection("following");
final sendRef = FirebaseFirestore.instance.collection("sent");
final flowRef = FirebaseFirestore.instance.collection("main Stream");
final saveRef = FirebaseFirestore.instance.collection("saved");
final favoriteRef = FirebaseFirestore.instance.collection("favorites");
final messageRef = FirebaseFirestore.instance.collection("messages");
final chatRef = FirebaseFirestore.instance.collection("chat");
final adPhotoRef = FirebaseFirestore.instance.collection("photos");
final adRef = FirebaseFirestore.instance.collection("Ads");

final scaffoldKey = GlobalKey<ScaffoldState>();
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final DateTime timestamp = DateTime.now();

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '1234', // id
  "Test Title", // title
  description: 'Test Description.', // description
  importance: Importance.high,
);
final GoogleSignIn googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  final bool entered;

  HomePage({super.key,
    required this.entered,
  });
  final _HomePageState child = _HomePageState(entered: false);
  @override
  _HomePageState createState() {
    _HomePageState(
      entered: this.entered,
    );
    return child;
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool entered = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> _initFirebaseSdk = Firebase.initializeApp();
  bool isToogle = false;

  bool userOnline = false;

  //String _token = "";

  _HomePageState({
    required this.entered,
  });

  /*String constructFCMPayload(String token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }*/

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print('state = $state');
      }
      userRef.doc(instantUser!.id).update({
        "isEnteredApp": true,
      });
    } else {
      userRef.doc(instantUser!.id).update({
        "isEnteredApp": false,
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    /* const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: _configureDidReceiveLocalNotificationSubject,
    );
    final initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _configureSelectNotificationSubject);
    messaging.subscribeToTopic("testcribe");*/
    /*messaging.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        SnackBar snackBar = SnackBar(
          content: Text("Mesaj boş"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });*/
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'launch_background',
              ),
            ));
      }
      showNotification(message);
    });
    /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      bool isMessage = true;
      showNotification(message);
      if (isMessage) {
        sayfaKontrol.jumpToPage(2);
        Navigator.push(context, MaterialPageRoute(builder: (context) => bildirimSayfasi()));
      } else {
        sayfaKontrol.jumpToPage(1);
        Navigator.push(context, MaterialPageRoute(builder: (context) => profilDuzenle()));
      }
    });*/
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();

    googleSignIn!.onCurrentUserChanged.listen((googleAccount) {
      setState(() {
        userControl(googleAccount!);
      });
    }, onError: (gError) {
      if (kDebugMode) {
        print("Error Message: $gError");
      }
    });

    googleSignIn!.isSignedIn().then((isSignedIn) async {
      if (isSignedIn == true) {
        googleSignIn!.signInSilently(suppressErrors: false).then((googleHesap2) {
          setState(() {
            userControl(googleHesap2!);
          });
        }).catchError((gError) {
          print(
              "Error Message 2: $gError");
        });
      }
    });
    firebaseonAuth();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  firebaseonAuth() {
    return FutureBuilder(
        future: _initFirebaseSdk,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            print("Error firebase on Auth 2: ");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            // Assign listener after the SDK is initialized successfully
            FirebaseAuth.instance.authStateChanges().listen((User? user) {
              if (user == null) {
                setState(() {
                  entered = false;
                });
              } else {
                setState(() {
                  entered = true;
                });
              }
            });
          }

          return circularProgress();
        });
  }

  static void showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        '1234', 'New Post',, 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message.data['title'],
        message.data['message'], platformChannelSpecifics,
        payload: 'item x');
  }

  /*Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        //body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }*/


  userLogin() {
    setState(() {
      googleSignIn!.signIn();
    });
  }

  userControl(GoogleSignInAccount? loginAccount) async {
    if (loginAccount != null) {
      await userFireStoreRegister();
      setState(() {
        entered = true;
      });
    } else {
      setState(() {
        entered = false;
      });
    }
  }

  /*Scaffold anaEkrani() {
  }*/

  void toggleScreen() {
    setState(() {
      isToogle = !isToogle;
    });
  }

  Scaffold kayitEkrani() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 75,
            right: 25,
            left: 25,
            bottom: 40,
          ),
          child: Container(
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 10), blurRadius: 10, color: Colors.grey)
            ], borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Container(
                            width: 220,
                            height: 90,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 10),
                                      blurRadius: 10,
                                      color: Colors.grey)
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(1),
                                      BlendMode.dstATop),
                                  image: const AssetImage("assets/images/sscard.png"),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "maCarD",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 34,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Share your card",
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          toggle(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding toggle() {
    if (isToogle) {
      return Register();
    } else {
      return Login();
    }
  }

  // ignore: non_constant_identifier_names
  Padding Login() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(offset: Offset(0, 10), blurRadius: 10, color: Colors.grey)
        ], borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Back",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Sign in to continue",
                      style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (val) => val!.isNotEmpty
                          ? null
                          : "Please enter a mail address",
                      decoration: InputDecoration(
                        hintText: "E-mail",
                        prefixIcon: const Icon(Icons.mail),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.deepOrange, width: 6),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (val) =>
                      val!.length < 6 ? "Enter more than 6 char " : null,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.vpn_key),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.deepOrange, width: 6),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          debugPrint("Email= ${_emailController.text}");
                          debugPrint("pass= ${_passwordController.text}");
                          signIn(_emailController.text,
                              _passwordController.text)
                              .then((value) {
                            setState(() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginDisplay()));
                            });
                          });
                        }
                      },
                      height: 45,
                      minWidth: double.infinity,
                      color: Colors.deepOrange[200],
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account ?"),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            toggleScreen();
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.deepOrange[200]),
                          ),
                        )
                      ],
                    ),
                    Center(
                      child: Text(
                        "OR",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          userLogin();
                        });
                      },
                      child: Container(
                        width: 270.0,
                        height: 65.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                          image: const DecorationImage(
                            image: AssetImage(
                                "assets/images/google_signin_button1.png"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Padding Register() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(offset: Offset(0, 10), blurRadius: 10, color: Colors.grey)
        ], borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Create account to continue",
                      style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      validator: (val) => val!.length <= 4
                          ? "Enter 4 char or more than 4 char "
                          : null,
                      decoration: InputDecoration(
                        hintText: "Username",
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.deepOrange, width: 6),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (val) => val!.length <= 3
                          ? "Enter 3 char or more than 3 char "
                          : null,
                      decoration: InputDecoration(
                        hintText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.deepOrange, width: 6),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (val) => val!.isNotEmpty
                          ? null
                          : "Please enter a mail address",
                      decoration: InputDecoration(
                        hintText: "E-mail",
                        prefixIcon: const Icon(Icons.mail),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.deepOrange.shade200, width: 6),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (val) =>
                      val!.length < 6 ? "Enter more than 6 char " : null,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.vpn_key),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.deepOrange, width: 6),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          debugPrint("Email= ${_emailController.text}");
                          debugPrint("pass= ${_passwordController.text}");
                          createPerson(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                              _usernameController.text)
                              .then((value) {
                            setState(() {
                              isToogle = false;
                            });
                          });
                        }
                      },
                      height: 45,
                      minWidth: double.infinity,
                      color: Colors.deepOrange[200],
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account ?"),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            toggleScreen();
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.deepOrange[200]),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  userFireStoreRegister() async {
    final GoogleSignInAccount? gInstantUser = googleSignIn!.currentUser;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await userRef.doc(gInstantUser!.id).get();
    if (!documentSnapshot.exists) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => AccountCreationPage()));

      userRef.doc(gInstantUser.id).set({
        "id": gInstantUser.id,
        "profileName": gInstantUser.displayName,
        "username": username,
        "url": gInstantUser.photoUrl,
        "email": gInstantUser.email,
        "biography": "",
        "timestamp": timestamp,
        "chattingWith": "",
        "isWriting": false,
        "pushToken": "",
      });

      documentSnapshot = await userRef.doc(instantUser!.id).get();
    }
    instantUser = User.fromDocument(documentSnapshot);
  }

  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await userRef.doc(user.user!.uid).get();
    if (!documentSnapshot.exists) {
      documentSnapshot = await userRef.doc(user.user!.uid).get();
    }
    instantUser = User.fromDocument(documentSnapshot);
    return user.user;
  }

  signOut() async {
    return await _auth.signOut();
  }

  // ignore: non_constant_identifier_names
  Future<User?> createPerson(
      String email, String password, String name, String username) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await userRef.doc(user.user!.uid).get();
    if (!documentSnapshot.exists) {
      final urlIndirme = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AccountCreationPage2(
                user: instantUser,
              )));

      userRef.doc(user.user!.uid).set({
        "id": user.user!.uid,
        "profileName": name,
        "username": username,
        "url": urlIndirme,
        "email": user.user!.email,
        "biography": "",
        "timestamp": timestamp,
        "chattingWith": "",
        "isWriting": false,
        "pushToken": "",
      });
      documentSnapshot = await userRef.doc(user.user!.uid).get();
    }
    instantUser = User.fromDocument(documentSnapshot);
    return user.user;
  }

  @override
  Widget build(BuildContext context) {
    if (entered == true) {
      return LoginDisplay();
    } else {
      return kayitEkrani();
    }
  }

// ignore: missing_return
//Future _configureDidReceiveLocalNotificationSubject(int id, String title, String body, String payload) {}

// ignore: missing_return
/*Future _configureSelectNotificationSubject(String payload) {
    if (payload != null) {
      debugPrint('Notification Payload = ' + payload);
    }
  }
}*/

}