import 'package:flutter/material.dart';

class BadDebtsMisrBankPage extends StatelessWidget {
  const BadDebtsMisrBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("بنك مصر ديون معدومة", textDirection: TextDirection.rtl),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text("محتوى بنك مصر ديون معدومة"),
      ),
    );
  }
}
