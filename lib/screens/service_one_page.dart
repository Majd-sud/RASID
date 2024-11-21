import 'package:flutter/material.dart';
import 'package:rasid/widgets/navbar_top.dart';
import 'package:rasid/widgets/navbar_bottom.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ServiceToSeeViolationsPage extends StatefulWidget {
  const ServiceToSeeViolationsPage({super.key});
  static const String screenRoute = 'service_see_violations';

  @override
  _ServiceToSeeViolationsPageState createState() =>
      _ServiceToSeeViolationsPageState();
}

class _ServiceToSeeViolationsPageState
    extends State<ServiceToSeeViolationsPage> {
  List<String> imagePaths = [];

  final FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyA1Vvd-X4oO28bVVOSByJgeV5glfM6DM6I",
    authDomain: "rasid-cam.firebaseapp.com",
    databaseURL: "https://rasid-cam-default-rtdb.firebaseio.com",
    projectId: "rasid-cam",
    storageBucket: "rasid-cam.appspot.com",
    messagingSenderId: "570394682961",
    appId: "1:570394682961:web:bdeff5621a871d60663a70",
  );

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(options: firebaseOptions);
    await _loadImagesFromFirebase();
  }

  Future<void> _loadImagesFromFirebase() async {
    try {
      final firebaseStorage = FirebaseStorage.instance;
      final ListResult result =
          await firebaseStorage.ref('violation_images').listAll();

      for (var ref in result.items) {
        if (ref.name.endsWith('.jpg')) {
          final String imageUrl = await ref.getDownloadURL();
          print('Image URL: $imageUrl'); // طباعة الرابط
          final violationNumber =
              _generateViolationNumber(imagePaths.length); // توليد رقم المخالفة
          setState(() {
            imagePaths.add(imageUrl);
          });
          // حفظ تفاصيل المخالفة
          await saveViolationDetails(violationNumber, imageUrl);
        }
      }
    } catch (e) {
      print('Error loading images: $e');
      _showErrorSnackBar('خطأ في تحميل الصور: $e');
    }
  }

  Future<void> saveViolationDetails(
      int violationNumber, String imageUrl) async {
    try {
      final databaseReference =
          FirebaseDatabase.instance.ref("violation_information");
      await databaseReference.child(violationNumber.toString()).set({
        'violationNumber': violationNumber,
        'imageUrl': imageUrl,
      });
      print('Violation details saved successfully.');
    } catch (e) {
      print('Error saving violation details: $e');
      _showErrorSnackBar('خطأ في حفظ تفاصيل المخالفة: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBarTop(),
            _buildHeader(),
            _buildDivider(),
            _buildImageGrid(),
            const SizedBox(height: 200),
            const NavBarBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 10),
            Text(
              'راصد لرصد المخالفات المرورية',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 20),
            Text(
              'رؤية المخالفات الصادرة',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 10),
            Text(
              'من هنا يمكنك رؤية المخالفات التي يتم التقاطها مباشرةً',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      width: 1000,
      child: const Column(
        children: [
          SizedBox(height: 5),
          Divider(thickness: 0.2, color: Colors.grey),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return ViolationImageCard(
          imageUrl: imagePaths[index], // تمرير رابط الصورة
          violationNumber: _generateViolationNumber(index),
        );
      },
    );
  }

  int _generateViolationNumber(int index) {
    return 1000 + index;
  }
}

class ViolationImageCard extends StatelessWidget {
  final String imageUrl;
  final int violationNumber;

  const ViolationImageCard({
    super.key,
    required this.imageUrl,
    required this.violationNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
            color: Color.fromARGB(255, 210, 214, 210), width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      color: const Color(0xFFF7FDF9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Text(
              'مخالفة رقم $violationNumber',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              textAlign: TextAlign.right,
            ),
          ),
          const Divider(thickness: 0.5, color: Colors.grey),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: ${error.toString()}');
                return const Center(
                    child: Icon(Icons.error, size: 40, color: Colors.red));
              },
            ),
          ),
        ],
      ),
    );
  }
}
