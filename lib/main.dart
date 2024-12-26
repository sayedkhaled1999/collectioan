import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/attendance_page.dart';
import 'pages/visit_reports_page.dart';
import 'pages/emirates_bank_page.dart';
import 'pages/ahly_bank_page.dart';
import 'pages/ahly_projects_page.dart';
import 'pages/house_building_bank_page.dart';
import 'pages/active_misr_bank_page.dart';
import 'pages/bad_debts_misr_bank_page.dart';
import 'pages/employee_management_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runZonedGuarded(() async {
    await resetFirestoreFolder();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  }, (error, stack) {
    print('Error: $error');
    print('Stack: $stack');
  });
}

Future<void> resetFirestoreFolder() async {
  try {
    Directory tempDir = await getApplicationSupportDirectory();
    String firestorePath = '${tempDir.path}/firestore';
    final dir = Directory(firestorePath);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
      print('Firestore folder reset successfully');
    } else {
      dir.createSync(recursive: true);
      print('Firestore folder created');
    }
  } catch (e) {
    print('Error resetting Firestore folder: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirebaseInitializer(),
    );
  }
}

class FirebaseInitializer extends StatelessWidget {
  const FirebaseInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Failed to initialize Firebase')),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "الصفحة الرئيسية",
            textDirection: TextDirection.rtl,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: isDesktop ? _buildDesktopButtons(context) : _buildMobileButtons(context),
        ),
      ),
    );
  }

  List<Widget> _buildMobileButtons(BuildContext context) {
    return [
      _buildElevatedButtonWithShadow(
        context,
        "إرسال الحضور والانصراف",
        Icons.access_alarm,
        AttendancePage(),
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonWithShadow('assets/images/icon1.png', 'بنك مصر الأكتيف', context, ActiveMisrBankPage()),
          _buildButtonWithShadow('assets/images/icon1.png', 'بنك مصر ديون معدومة', context, BadDebtsMisrBankPage()),
        ],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonWithShadow('assets/images/icon2.png', 'بنك الأهلي المصري', context, AhlyBankPage()),
          _buildButtonWithShadow('assets/images/icon2.png', 'بنك الأهلي مشروعات', context, AhlyProjectsPage()),
        ],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonWithShadow('assets/images/icon3.png', 'بنك التعمير والإسكان', context, HouseBuildingBankPage()),
          _buildButtonWithShadow('assets/images/icon4.png', 'بنك الإمارات دبي الوطني', context, EmiratesBankPage()),
        ],
      ),
      SizedBox(height: 16),
      _buildElevatedButtonWithShadow(
        context,
        "إرسال تقارير الزيارات",
        Icons.send,
        VisitReportsPage(),
      ),
      SizedBox(height: 8),
      _buildSmallButtonWithShadow(
        context,
        "إدارة بيانات الموظفين",
        Icons.person,
        () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeManagementPage()));
        },
      ),
    ];
  }

  List<Widget> _buildDesktopButtons(BuildContext context) {
    return _buildMobileButtons(context); // نفس الأزرار لكل المنصات
  }

  Widget _buildElevatedButtonWithShadow(BuildContext context, String label, IconData icon, Widget targetPage) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.black,
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWithShadow(String imagePath, String label, BuildContext context, Widget targetPage) {
    double screenWidth = MediaQuery.of(context).size.width;

    double buttonWidth = Platform.isWindows || Platform.isMacOS || Platform.isLinux ? screenWidth * 0.45 : screenWidth * 0.42;
    double buttonHeight = buttonWidth * 0.11;

    if (screenWidth < 600) {
      buttonWidth = screenWidth * 0.42;
      buttonHeight = buttonWidth * 0.5;
    }

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
      },
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: buttonWidth * 0.33,
              height: buttonHeight * 0.5,
            ),
            SizedBox(height: 0),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallButtonWithShadow(BuildContext context, String label, IconData icon, Function() onTapAction) {
    return InkWell(
      onTap: onTapAction,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.black,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
