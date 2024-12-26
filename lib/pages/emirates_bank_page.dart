import 'package:flutter/material.dart';

class EmiratesBankPage extends StatelessWidget {
  const EmiratesBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("بنك الإمارات دبي الوطني", textDirection: TextDirection.rtl),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text("محتوى بنك الإمارات دبي الوطني"),
      ),
    );
  }
}
