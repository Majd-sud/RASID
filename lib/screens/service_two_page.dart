import 'package:flutter/material.dart';
import 'package:rasid/widgets/navbar_top.dart';
import 'package:rasid/widgets/navbar_bottom.dart';
import 'package:firebase_database/firebase_database.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const NavBarTop(),
            _buildHeader(),
            _buildDivider(),
            _buildServiceCards(),
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

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,
      child: const Column(
        children: [
          SizedBox(height: 5),
          Divider(thickness: 0.2, color: Colors.grey),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildServiceCards() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        ...violationsList.map((violation) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _buildServiceCard(
              violation['violationNumber'] ?? 0,
              violation['imageUrl'],
              violationsList.indexOf(violation),
            ),
          );
        }).toList(),
        const SizedBox(height: 20.0),
      ],
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

  Widget _buildServiceCard(int number, String? imageUrl, int index) {
    const double titleFontSize = 14.0;
    const double numberFontSize = 20.0;
    const Color titleColor = Color.fromARGB(255, 14, 39, 2);
    const Color numberColor = Color(0xFF1B8354);

    return GestureDetector(
      onTap: () => _onServiceTap(index),
      child: MouseRegion(
        onEnter: (_) => setState(() {}),
        onExit: (_) => setState(() {}),
        child: Container(
          width: 900, // عرض ثابت
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 0), // موضع الظل
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (imageUrl != null)
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
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return const Center(
                                child: Text('خطأ في تحميل الصورة'));
                          },
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTextStyle(
                          text: 'تفاصيل رفع المخالفة رقم:',
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                        const SizedBox(height: 5.0),
                        _buildTextStyle(
                          text: number.toString(),
                          fontSize: numberFontSize,
                          fontWeight: FontWeight.bold,
                          color: numberColor,
                        ),
                        const SizedBox(height: 5.0),
                        _buildTextStyle(
                          text:
                              'لرفع المخالفة يجب عليك تعبئة حقول البيانات المطلوبة',
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              _buildViolationForm(number),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViolationForm(int violationNumber) {
    final _formKey = GlobalKey<FormState>();
    String? phoneNumber,
        carNumber,
        violationDate,
        violationMessage,
        violationDetails;

    Color buttonColor = const Color.fromARGB(255, 167, 167, 167);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
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
          _buildTextField(
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
          const SizedBox(height: 10.0),
          _buildTextField(
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
          const SizedBox(height: 10.0),
          _buildTextField(
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
          const SizedBox(height: 20.0),
          MouseRegion(
            onEnter: (_) {
              setState(() {
                buttonColor =
                    const Color(0xFF4CAF50); // اللون الأخضر عند المرور
              });
            },
            onExit: (_) {
              setState(() {
                buttonColor = const Color(0xFF1B8354); // العودة للون الافتراضي
              });
            },
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // منطق إرسال المخالفة الخاصة بهذه المخالفة
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
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'إرسال المخالفة',
                style: TextStyle(fontSize: 16.0),
              ),
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
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 145, 150, 148)), // لون النص في hintText
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1B8354)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Color(0xFFD2D6DB)), // لون الحافة العادية
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }

  void _sendViolation(
    int number,
    String? phoneNumber,
    String? carNumber,
    String? violationDate,
    String? violationMessage,
    String? violationDetails,
  ) {
    print('رقم المخالفة: $number');
    print('رقم الهاتف: $phoneNumber');
    print('رقم السيارة: $carNumber');
    print('تاريخ المخالفة: $violationDate');
    print('رسالة المخالفة: $violationMessage');
    print('تفاصيل المخالفة: $violationDetails');
  }

  void _onServiceTap(int index) {
    setState(() {
      activeServiceIndex = index;
    });
  }
}
