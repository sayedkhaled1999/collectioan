import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart'; // استيراد مكتبة Logger

class AttendancePage extends StatelessWidget {
  // إنشاء كائن من Logger
  final logger = Logger();

  AttendancePage({super.key});

  // وظيفة لالتقاط الصورة من الكاميرا فقط
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera); // فقط الكاميرا
      if (image != null) {
        logger.i('تم التقاط الصورة: ${image.path}'); // استخدام logger بدلاً من print
      } else {
        logger.w("لم يتم التقاط الصورة.");
      }
    } catch (e) {
      logger.e("حدث خطأ أثناء التقاط الصورة: $e");
    }
  }

  // وظيفة للحصول على الموقع الجغرافي
  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        logger.w("تم رفض إذن الوصول إلى الموقع.");
        return;
      } else if (permission == LocationPermission.deniedForever) {
        logger.e("تم رفض إذن الوصول بشكل دائم.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      logger.i('الموقع الجغرافي: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      logger.e("حدث خطأ أثناء الحصول على الموقع: $e");
    }
  }

  // وظيفة لتوحيد تنفيذ الحضور والانصراف
  Future<void> _handleAttendance(String type) async {
    await _pickImage();
    await _getLocation();
    logger.i("تم تسجيل $type بنجاح.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "الحضور والانصراف",
            textDirection: TextDirection.rtl,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "تعليمات الحضور والانصراف:\n"
              "1- التأكد من حلاقة الذقن.\n"
              "2- ارتداء البدلة كاملة.\n"
              "3- موعد الحضور الساعة 8:30 بحد أقصى.",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 32),
            // زر الحضور
            _buildButtonWithShadow(
              context,
              'الحضور',
              Icons.wb_sunny,
              Colors.orange,
              () => _handleAttendance("الحضور"),
            ),
            SizedBox(height: 16),
            // زر الانصراف
            _buildButtonWithShadow(
              context,
              'الانصراف',
              Icons.nightlight_round,
              Colors.blueGrey,
              () => _handleAttendance("الانصراف"),
            ),
            SizedBox(height: 16),
            // زر متابعة الجزاءات
            _buildButtonWithShadow(
              context,
              'متابعة الجزاءات',
              Icons.warning,
              Colors.red,
              () {
                logger.i("تم الضغط على متابعة الجزاءات");
                // إضافة الوظيفة هنا
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWithShadow(
      BuildContext context, String label, IconData icon, Color iconColor, VoidCallback onPressed) {
    double buttonHeight = MediaQuery.of(context).size.height * 0.17;
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: iconColor,
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
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
