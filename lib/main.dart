import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MaterialApp(home: RecorderPage(), debugShowCheckedModeBanner: false));

class RecorderPage extends StatefulWidget {
  @override State<RecorderPage> createState() => _RecorderPageState();
}
class _RecorderPageState extends State<RecorderPage> {
  final rec = AudioRecorder();
  bool isRec = false;
  String? path;
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    loadFiles();
  }
  Future<void> loadFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    setState(() => files = Directory(dir.path).listSync().where((f) => f.path.endsWith('.m4a')).toList());
  }
  Future<void> start() async {
    if (await Permission.microphone.request().isGranted) {
      final dir = await getApplicationDocumentsDirectory();
      path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
      await rec.start(const RecordConfig(), path: path!);
      setState(() => isRec = true);
    }
  }
  Future<void> stop() async {
    await rec.stop();
    setState(() => isRec = false);
    loadFiles();
  }
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(title: Text('🎙️ ستوديو التسجيل'), backgroundColor: Colors.black, centerTitle: true),
      body: Column(children: [
        SizedBox(height: 40),
        Center(
          child: GestureDetector(
            onTap: () => isRec ? stop() : start(),
            child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(shape: BoxShape.circle, color: isRec ? Colors.red : Colors.white),
              child: Icon(isRec ? Icons.stop : Icons.mic, size: 70, color: isRec ? Colors.white : Colors.black),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(isRec ? 'عم يسجل...' : 'اضغط للتسجيل', style: TextStyle(color: Colors.white, fontSize: 20)),
        Divider(color: Colors.white24, height: 40),
        Expanded(
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (_, i) => ListTile(
              leading: Icon(Icons.audio_file, color: Colors.white),
              title: Text(files[i].path.split('/').last, style: TextStyle(color: Colors.white)),
            ),
          ),
        )
      ]),
    );
  }
}
