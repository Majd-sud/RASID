import 'package:flutter/material.dart';
import 'package:rasid/widgets/navbar_top.dart';
import 'package:rasid/widgets/navbar_bottom.dart';

// خدمة عرض المخالفات المرسلة
class ServiceToViewSentViolationsPage extends StatefulWidget {
  const ServiceToViewSentViolationsPage({super.key});
  static const String screenRoute = 'service_view_sent_violations';

  @override
  _ServiceToViewSentViolationsPageState createState() =>
      _ServiceToViewSentViolationsPageState();
}

class _ServiceToViewSentViolationsPageState
    extends State<ServiceToViewSentViolationsPage> {
  int? activeServiceIndex;

  void _onServiceTap(int index) {
    setState(() {
      activeServiceIndex = index;
    });
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
              'المخالفات التي تم ارسالها',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 10),
            Text(
              'من هنا يمكنك رؤية المخالفات التي تم رفعها وتحقق منها وأرسالها كا مخالفة مسبقًا',
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

  Widget _buildServiceCards() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }
}
