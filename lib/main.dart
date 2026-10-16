import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('🎙️ ستوديو التسجيل'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text('التطبيق جاهز للبناء',
                style: TextStyle(color: Colors.white, fontSize: 22)),
            SizedBox(height: 10),
            Text('النسخة الكاملة بعد هالبناء',
                style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    ),
  ));
}
