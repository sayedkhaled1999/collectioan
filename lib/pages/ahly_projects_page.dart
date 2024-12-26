import 'package:flutter/material.dart';

class AhlyProjectsPage extends StatelessWidget {
  const AhlyProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("بنك الأهلي مشروعات", textDirection: TextDirection.rtl),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text("محتوى بنك الأهلي مشروعات"),
      ),
    );
  }
}
