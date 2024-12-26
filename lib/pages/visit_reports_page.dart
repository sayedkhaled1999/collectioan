import 'package:flutter/material.dart';

class VisitReportsPage extends StatelessWidget {
  const VisitReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إرسال تقارير الزيارات", textDirection: TextDirection.rtl),
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
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('إرسال التقرير'),
            ),
          ],
        ),
      ),
    );
  }
}
