import 'package:flutter/material.dart';

class ActiveMisrBankPage extends StatelessWidget {
  const ActiveMisrBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("بنك مصر الأكتيف", textDirection: TextDirection.rtl),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text("محتوى بنك مصر الأكتيف"),
      ),
    );
  }
}
