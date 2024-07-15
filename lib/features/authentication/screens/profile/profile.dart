// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/features/authentication/screens/login/login.dart';
import 'package:skiive/utils/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? studentFirstName;
  String? studentLastName;
  String? studentEmail;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentFirstName = prefs.getString('firstName');
      studentLastName = prefs.getString('lastName');
      studentEmail = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: FirebaseAuth.instance.currentUser != null
                          ? Image(
                              image: NetworkImage(
                                  FirebaseAuth.instance.currentUser!.photoURL!),
                              fit: BoxFit.cover,
                            )
                          : Image(
                              image: AssetImage('assets/images/Profile.png'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: SkiiveColors.primary,
                      ),
                      child: Icon(
                        LineAwesomeIcons.alternate_pencil,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser != null
                        ? FirebaseAuth.instance.currentUser!.displayName!
                        : '$studentFirstName $studentLastName',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Text(
                  FirebaseAuth.instance.currentUser != null
                      ? FirebaseAuth.instance.currentUser!.email!
                      : "$studentEmail",
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(
                height: 20,
              ),
              // Container(
              //   width: 200,
              //   decoration: BoxDecoration(
              //     color: SkiiveColors.primary,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Center(
              //       child: Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: Text(
              //       "Student",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   )),
              // ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),

              //Menu
              MenuWidget(
                title: 'My Subscriptions',
                icon: LineAwesomeIcons.wallet,
                onPress: () {},
              ),
              MenuWidget(
                title: 'Certifications',
                icon: LineAwesomeIcons.certificate,
                onPress: () {},
              ),
              MenuWidget(
                title: 'My Quiz Attempts',
                icon: LineAwesomeIcons.question,
                onPress: () {},
              ),
              MenuWidget(
                title: 'My Assignments',
                icon: LineAwesomeIcons.tasks,
                onPress: () {},
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              MenuWidget(
                title: 'Logout',
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                iconColor: Colors.red,
                endIcon: false,
                onPress: () async {
                  await FirebaseAuth.instance.signOut();
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.clear();
                  Get.offAll(() => LoginScreen());
                },
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Joined in ',
                        style: TextStyle(fontSize: 12),
                        children: [
                          TextSpan(
                              text: '07 Jan 2024',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12))
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            elevation: 0,
                            foregroundColor: Colors.red,
                            shape: StadiumBorder(),
                            side: BorderSide.none),
                        child: Text('Delete'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.endIcon = true,
      this.textColor,
      this.iconColor});

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: SkiiveColors.primary.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          size: 30,
          color: Colors.blueAccent,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.1)),
              child: Icon(
                LineAwesomeIcons.angle_right,
                size: 20,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
