// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:skiive/utils/constants/colors.dart';

class CoursesSectionCard extends StatefulWidget {
  final String title;

  const CoursesSectionCard({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  CoursesSectionCardState createState() => CoursesSectionCardState();
}

class CoursesSectionCardState extends State<CoursesSectionCard> {
  @override
  Widget build(BuildContext context) {
    // final dark = SkiiveHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flexible(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: SkiiveColors.accent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Iconsax.play_circle,
                          size: 30,
                          color: Colors.blue.shade900,
                        ))
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
