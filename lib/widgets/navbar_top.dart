import 'package:flutter/material.dart';

class NavBarTop extends StatefulWidget {
  const NavBarTop({super.key});

  @override
  _NavBarTopState createState() => _NavBarTopState();
}

class _NavBarTopState extends State<NavBarTop> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'images/2023logo.png',
                    height: 45,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('خطأ في تحميل الصورة');
                    },
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.black54,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  _navItem('فريق العمل', 2),
                  SizedBox(width: 20),
                  _navItem('كيف بدأنا', 1),
                  SizedBox(width: 20),
                  _navItem('الصفحة الرئيسية', 0),
                  SizedBox(width: 25),
                  Image.asset(
                    'images/logo.png',
                    height: 45,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('خطأ في تحميل الصورة');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 0.2,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _navItem(String title, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Color(0xFF1B8354) : Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
