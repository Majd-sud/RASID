import 'package:flutter/material.dart';
import 'package:rasid/widgets/navbar_top.dart';
import 'package:rasid/widgets/navbar_bottom.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceSendViolationsPage extends StatefulWidget {
  const ServiceSendViolationsPage({super.key});

  static const String screenRoute = 'service_send_violations';

  @override
  _ServiceSendViolationsPageState createState() =>
      _ServiceSendViolationsPageState();
}

class _ServiceSendViolationsPageState extends State<ServiceSendViolationsPage> {
  int? activeServiceIndex;
  List<Map<String, dynamic>> violationsList = [];

  @override
  void initState() {
    super.initState();
    fetchViolationNumbers();
    print("👉 2");
  }

  Future<void> fetchViolationNumbers() async {
    final databaseReference =
        FirebaseDatabase.instance.ref("violation_information");

    try {
      final snapshot = await databaseReference.once();
      final data = snapshot.snapshot.value;

      if (data != null && data is Map) {
        violationsList.clear();
        data.forEach((key, value) {
          violationsList.add({
            'violationNumber': value['violationNumber'],
            'imageUrl': value['imageUrl'], // إضافة رابط الصورة
          });
        });
        setState(() {}); // تحديث الواجهة بعد جلب البيانات
      } else {
        print('No data found or data is not in the expected format.');
      }
    } catch (e) {
      print('Error fetching violation details: ${e.toString()}');
    }
  }

  Future<void> saveViolationInformation(
    int violationNumber,
    String phoneNumber,
    String carNumber,
    String violationDate,
    String violationMessage,
    String violationDetails,
  ) async {
    final databaseReference =
        FirebaseDatabase.instance.ref('SentViolation'); // مجموعة البيانات

    try {
      // إضافة بيانات المخالفة كعنصر جديد في مجموعة SentViolation
      await databaseReference.push().set({
        'violationNumber': violationNumber,
        'phoneNumber': phoneNumber,
        'carNumber': carNumber,
        'violationDate': violationDate,
        'violationMessage': violationMessage,
        'violationDetails': violationDetails,
      });

      // رسالة النجاح
      print('Violation information saved successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال المخالفة بنجاح.'),
        ),
      );
    } catch (e) {
      // معالجة الأخطاء
      print('Error saving violation information: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء إرسال المخالفة.'),
        ),
      );
    }
  }

  void _sendViolation(
    int number,
    String? phoneNumber,
    String? carNumber,
    String? violationDate,
    String? violationMessage,
    String? violationDetails,
  ) {
    if (phoneNumber != null &&
        carNumber != null &&
        violationDate != null &&
        violationMessage != null &&
        violationDetails != null) {
      saveViolationInformation(
        number,
        phoneNumber,
        carNumber,
        violationDate,
        violationMessage,
        violationDetails,
      );
    } else {
      print('Please fill in all fields before submitting the violation.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    const double titleFontSize = 14.0;
    const double numberFontSize = 20.0;
    const Color titleColor = Color.fromARGB(255, 14, 39, 2);
    const Color numberColor = Color(0xFF1B8354);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBarTop(),
            _buildHeader(),
            ...violationsList.map((violation) {
              return Container(
                height: h * .6,
                width: w * .9,
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey[300]!,
                    )),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: h * .15,
                            width: w * .3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildTextStyle(
                                  text:
                                      '${violation['violationNumber']}  تفاصيل رفع المخالفة رقم :',
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: titleColor,
                                ),
                                const SizedBox(height: 5.0),
                                const Text(
                                  'لرفع المخالفة يجب عليك تعبئة حقول \nالبيانات المطلوبة',
                                  textAlign: TextAlign.right,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * .3,
                      width: w * .9,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              if (violation['imageUrl'] != null)
                                Container(
                                  width: 150,
                                  height: 150,
                                  margin: const EdgeInsets.only(right: 20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      violation['imageUrl'],
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return const Center(
                                            child: Text('خطأ في تحميل الصورة'));
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          )),
                          Expanded(
                              flex: 3,
                              child: _buildViolationForm(
                                  violationsList.first['violationNumber'])),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
      bottomNavigationBar: const NavBarBottom(),
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
              'خدمة رفع المخالفات وتحقق',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 10),
            Text(
              'من هنا يمكنك رفع المخالفات وتحقق قبل رفعها',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextStyle({
    required String text,
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  Widget _buildViolationForm(int violationNumber) {
    final formKey = GlobalKey<FormState>();
    String? phoneNumber,
        carNumber,
        violationDate,
        violationMessage,
        violationDetails;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTextField(
            label: 'تفاصيل المخالفة',
            hintText: 'أدخل تفاصيل المخالفة هنا',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال تفاصيل المخالفة';
              }
              return null;
            },
            onChanged: (value) {
              violationDetails = value;
            },
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'رقم الهاتف',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الهاتف';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _buildTextField(
                  label: 'رقم السيارة',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم السيارة';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    carNumber = value;
                  },
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _buildTextField(
                  label: 'تاريخ المخالفة',
                  hintText: 'YYYY-MM-DD',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال تاريخ المخالفة';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    violationDate = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          _buildTextField(
            label: 'رسالة المخالفة',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال رسالة المخالفة';
              }
              return null;
            },
            onChanged: (value) {
              violationMessage = value;
            },
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final url =
                      Uri.parse('https://freeemailapi.vercel.app/sendEmail/');
                  final response = await http.post(url,
                      headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                      },
                      body: jsonEncode({
                        "toEmail": "majdalsahafi3@gmail.com",
                        "title": "RAASID",
                        "subject": "$violationNumber",
                        // "body": "تم رصد مخالفة الرجاء مطابقتها و رفعها",
                        "body":
                            "Dear car owner number 7401, has been detected in a traffic safety violation."
                      }));

                  if (response.statusCode == 200) {
                    final responseData = jsonDecode(response.body);
                    if (responseData['message'] == 'emailSendSuccess') {
                      print('Email sent successfully: $responseData');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              const Text('تم إرسال البريد الإلكتروني بنجاح'),
                          action: SnackBarAction(
                              label: 'موافق',
                              onPressed: () {
                                // Perform some action if needed
                              })));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Fail: $responseData'),
                          action: SnackBarAction(
                              label: 'موافق',
                              onPressed: () {
                                // Perform some action if needed
                              })));
                      print('Email sending failed: $responseData');
                    }
                  } else {
                    print('Request failed with status: ${response.statusCode}');
                    print('Response body: ${response.body}');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Fail: ${response.body}'),
                        action: SnackBarAction(
                            label: 'موافق',
                            onPressed: () {
                              // Perform some action if needed
                            })));
                  }
                } catch (e, st) {
                  print("💥 error is $e, stack trace: $st");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Fail: $e'),
                      action: SnackBarAction(
                          label: 'موافق',
                          onPressed: () {
                            // Perform some action if needed
                          })));
                }
                _sendViolation(
                  violationNumber,
                  phoneNumber,
                  carNumber,
                  violationDate,
                  violationMessage,
                  violationDetails,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B8354),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'إرسال المخالفة',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hintText,
    required String? Function(String?) validator,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 145, 150, 148)), // لون النص في hintText
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1B8354)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color(0xFFD2D6DB)), // لون الحافة العادية
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
