// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/features/authentication/screens/courses/courses.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/theme/constantThemes/relatedCard.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../models/all_courses_model.dart';
import '../../../../utils/http/api.dart';
import '../../../../utils/http/http_client.dart';
import '../../../../utils/loaders/loaders.dart';
import '../../../../utils/validators/validators.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  final String description;
  final String category;
  const DetailsScreen({
    Key? key,
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController mpesaNumber = TextEditingController();
  GlobalKey<FormState> mpesaNumberFormKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? token;
  String? studentId;
  String? certificateUrl;

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('accessToken');
      studentId = prefs.getString('parameterId');
    });
  }

  String loading = 'init';
  String pay = 'init';
  String certificate = 'init';

  Future<void> startCourse(id) async {
    try {
      setState(() {
        loading = 'processing';
      });
      final token = await _getToken();
      final studentId = await _getStudentId();
      final url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.bookmark);
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = {
        "courseId": id,
        "studentId": studentId,
      };
      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        setState(() {
          loading = 'complete';
        });
        SkiiveLoaders.successSnackBar(
            title: 'Course started Successfully!',
            message: 'Welcome to Emerge Learning Management platform.');
        Get.to(() => const CoursesScreen())?.then((value) => setState(() {
              loading = 'init';
            }));
      } else {
        setState(() {
          loading = 'error';
        });
        SkiiveLoaders.errorSnackBar(title: 'Error', message: response.body);
      }
    } catch (e) {
      setState(() {
        loading = 'error';
      });
      SkiiveLoaders.errorSnackBar(title: 'Error', message: e.toString());
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          loading = 'init';
        });
      });
    }
  }

  Future<void> payCourse(id) async {
    try {
      // Form validation
      if (!mpesaNumberFormKey.currentState!.validate()) return;

      // Set loading state
      setState(() {
        pay = 'processing';
      });
      Future.delayed(const Duration(minutes: 1), () {
        setState(() {
          loading = 'init';
        });
        return false;
      });

      final token = await _getToken();
      final studentId = await _getStudentId();
      final url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.pay);
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = {
        "courseId": id,
        "mpesaPhone": mpesaNumber.text,
        "studentId": studentId,
      };
      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        setState(() {
          pay = 'complete';
        });
        mpesaNumber.clear();
        SkiiveLoaders.successSnackBar(
            title: 'Success!', message: 'Request accepted for processing');
        Get.to(() => const CoursesScreen())?.then((value) => setState(() {
              pay = 'init';
            }));
      } else {
        setState(() {
          pay = 'error';
        });
        SkiiveLoaders.errorSnackBar(title: 'Error', message: response.body);
      }
    } catch (e) {
      setState(() {
        pay = 'error';
      });
      SkiiveLoaders.errorSnackBar(title: 'Error', message: e.toString());
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          pay = 'init';
        });
      });
    }
  }

  Future<void> getCertificate(id) async {
    try {
      setState(() {
        certificate = 'processing';
      });

      final token = await _getToken(); // Get the token
      final url = Uri.parse("https://api.emergekenya.org/api/v1/certificate");
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Prepare the body for the request
      final body = {
        "courseId": id,
        "studentId": studentId,
      };

      // Make the POST request
      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 201) {
        // Parse the response
        final responseData = jsonDecode(response.body);
        final url = responseData['data']['certificate'];

        // Set the certificate URL in the state
        setState(() {
          certificateUrl = url; // Store the URL
          certificate = 'complete';
        });
        SkiiveLoaders.successSnackBar(
            title: 'Success!', message: 'Certificate retrieved successfully');
      } else {
        setState(() {
          certificate = 'error';
        });
        SkiiveLoaders.errorSnackBar(title: 'Error', message: response.body);
      }
    } catch (e) {
      setState(() {
        certificate = 'error';
      });
      SkiiveLoaders.errorSnackBar(title: 'Error', message: e.toString());
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          certificate = 'init';
        });
      });
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> _getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('parameterId');
  }

  late String id, name, image, description, category;
  @override
  void initState() {
    super.initState();
    fetchData();
    id = widget.id;
    name = widget.name;
    image = widget.image;
    description = widget.description;
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          leading: Container(
            height: 50,
            width: 70,
            margin: const EdgeInsets.only(top: 16, left: 16),
            decoration: BoxDecoration(
              color: SkiiveColors.buttonPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
                onPressed: () => Get.back(),
                color: Colors.white,
                icon: const Icon(LineAwesomeIcons.angle_left)),
          ),
          backgroundColor: Colors.transparent,
          expandedHeight: 200,
          pinned: true,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(name),
            background: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.black.withOpacity(0.8)
                  ], stops: const [
                    0.0,
                    0.8
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(
                  height: 10,
                ),
                Text(description,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Category :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      category,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 120,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SkiiveColors.primary,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        startCourse(id);
                      },
                      child: loading == 'init'
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text('Start Course'),
                            )
                          : loading == 'processing'
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation(
                                        Color.fromRGBO(172, 173, 189, 0.9)),
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : const Icon(Iconsax.tick_circle)),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                    "Enter number and pay to get certificate after finishing the course",
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: mpesaNumberFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: mpesaNumber,
                          validator: (value) =>
                              SkiiveValidator.validateMpesaNumber(value),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.call),
                            labelText: '254...',
                            labelStyle: TextStyle(
                              color: Colors
                                  .grey, // Change this to your desired color
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 80,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        payCourse(id);
                      },
                      child: pay == 'init'
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text('Pay'),
                            )
                          : pay == 'processing'
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation(
                                        Color.fromRGBO(172, 173, 189, 0.9)),
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : const Icon(Iconsax.tick_circle)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("Already paid and finished the course?",
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        getCertificate(id);
                      },
                      child: certificate == 'init'
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text('Get Certificate'),
                            )
                          : certificate == 'processing'
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation(
                                        Color.fromRGBO(172, 173, 189, 0.9)),
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : const Icon(Iconsax.tick_circle)),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Display the certificate URL if available
                Row(
                  children: [
                    const Text(
                      'Resources :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    if (certificateUrl != null) ...[
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _launchURL(
                                certificateUrl!); // Launch the URL when tapped
                          },
                          child: Text(
                            certificateUrl!,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration
                                  .underline, // Underline the text
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Related Courses',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<CoursesModel>>(
                    future: CoursesApi.getCourses(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        List<CoursesModel> courses = snapshot.data!;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: courses.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                name = courses[index].name!;
                                                image = courses[index].image!;
                                                description =
                                                    courses[index].description!;
                                                category =
                                                    courses[index].category!;
                                              });
                                            },
                                            child: RelatedCard(
                                              image: courses[index].image!,
                                              name: courses[index].name!,
                                              price: courses[index].price!,
                                            ))),
                              ),
                            )
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
