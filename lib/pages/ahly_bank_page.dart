import 'package:flutter/material.dart';

class AhlyBankPage extends StatelessWidget {
  const AhlyBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("بنك الأهلي المصري", textDirection: TextDirection.rtl),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text("محتوى بنك الأهلي المصري"),
      ),
    );
  }
}
