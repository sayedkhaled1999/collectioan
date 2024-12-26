import 'package:flutter/material.dart';

class HouseBuildingBankPage extends StatelessWidget {
  const HouseBuildingBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("بنك التعمير والإسكان", textDirection: TextDirection.rtl),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text("محتوى بنك التعمير والإسكان"),
      ),
    );
  }
}
