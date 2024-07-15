// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/theme/constantThemes/appBar.dart';

class SkiiveHomeAppbar extends StatefulWidget {
  const SkiiveHomeAppbar({
    super.key,
  });
  @override
  SkiiveHomeAppbarState createState() => SkiiveHomeAppbarState();
}

class SkiiveHomeAppbarState extends State<SkiiveHomeAppbar> {
  String? studentName;
  String? googleName;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentName = prefs.getString('firstName');
      googleName = prefs.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SkiiveAppBar(
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: [
                Text(
                  'Welcome',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .apply(color: SkiiveColors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  FirebaseAuth.instance.currentUser != null
                      ? FirebaseAuth.instance.currentUser!.displayName!
                      : '$studentName'.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .apply(color: SkiiveColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}