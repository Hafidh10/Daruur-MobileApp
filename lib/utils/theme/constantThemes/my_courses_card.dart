// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:skiive/utils/constants/colors.dart';

class MyCoursesCard extends StatefulWidget {
  final String id;
  final String image;
  final String name;

  const MyCoursesCard({
    Key? key,
    required this.id,
    required this.image,
    required this.name,
  }) : super(key: key);

  @override
  MyCoursesCardState createState() => MyCoursesCardState();
}

class MyCoursesCardState extends State<MyCoursesCard> {
  @override
  Widget build(BuildContext context) {
    // final dark = SkiiveHelperFunctions.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
          color: SkiiveColors.accent, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              child: Image.network(
                widget.image,
                height: 120,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '1000 Ksh',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
