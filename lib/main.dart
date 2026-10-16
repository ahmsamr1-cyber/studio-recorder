import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
void main()=>runApp(StudioApp());
class StudioApp extends StatelessWidget{
@override Widget build(BuildContext c)=>MaterialApp(debugShowCheckedModeBanner:false,theme:ThemeData.dark(),home:RecorderPage());
}
class RecorderPage extends StatefulWidget{
@override _RecorderPageState createState()=>_RecorderPageState();
}
class _RecorderPageState extends State<RecorderPage>{
FlutterSoundRecorder? _rec; bool _isRec=false,_isPause=false; String _path=''; List<String> _list=[];
@override void initState(){super.initState();_init();}
Future<void>_init()async{await Permission.microphone.request();await Permission.storage.request();_rec=FlutterSoundRecorder();await _rec!.openRecorder();_load();}
Future<void>_load()async{final d=await getApplicationDocumentsDirectory();final f=Directory(d.path).listSync().where((x)=>x.path.endsWith('.aac')).toList();setState(()=>_list=f.map((e)=>e.path).toList());}
Future<void>_start()async{final d=await getApplicationDocumentsDirectory();_path='${d.path}/studio_${DateTime.now().millisecondsSinceEpoch}.aac';await _rec!.startRecorder(toFile:_path,codec:Codec.aacADTS);setState((){_isRec=true;_isPause=false;});}
Future<void>_pause()async{await _rec!.pauseRecorder();setState(()=>_isPause=true);}
Future<void>_resume()async{await _rec!.resumeRecorder();setState(()=>_isPause=false);}
Future<void>_stop()async{await _rec!.stopRecorder();setState((){_isRec=false;_isPause=false;});_load();}
@override void dispose(){_rec!.closeRecorder();super.dispose();}
@override Widget build(BuildContext c){return Scaffold(backgroundColor:Colors.black,appBar:AppBar(title:Text('مسجل الاستديو - نظيف'),backgroundColor:Colors.black),body:Column(children:[SizedBox(height:60),Icon(_isRec?Icons.mic:Icons.mic_none,size:100,color:_isRec?Colors.red:Colors.white),SizedBox(height:20),Text(_isRec?(_isPause?'متوقف مؤقتاً':'يسجل...'):'جاهز للتسجيل',style:TextStyle(fontSize:22)),SizedBox(height:40),Row(mainAxisAlignment:MainAxisAlignment.center,children:[if(!_isRec)ElevatedButton.icon(onPressed:_start,icon:Icon(Icons.fiber_manual_record),label:Text('تسجيل'),style:ElevatedButton.styleFrom(backgroundColor:Colors.red,padding:EdgeInsets.symmetric(horizontal:30,vertical:15))),if(_isRec&&!_isPause)ElevatedButton.icon(onPressed:_pause,icon:Icon(Icons.pause),label:Text('إيقاف مؤقت'),style:ElevatedButton.styleFrom(backgroundColor:Colors.orange)),if(_isRec&&_isPause)...[ElevatedButton.icon(onPressed:_resume,icon:Icon(Icons.play_arrow),label:Text('متابعة'),style:ElevatedButton.styleFrom(backgroundColor:Colors.green)),SizedBox(width:10),ElevatedButton.icon(onPressed:_stop,icon:Icon(Icons.stop),label:Text('حفظ'),style:ElevatedButton.styleFrom(backgroundColor:Colors.grey))],if(_isRec&&!_isPause)...[SizedBox(width:10),ElevatedButton.icon(onPressed:_stop,icon:Icon(Icons.stop),label:Text('حفظ'),style:ElevatedButton.styleFrom(backgroundColor:Colors.grey))]]),SizedBox(height:30),Divider(color:Colors.white24),Expanded(child:ListView.builder(itemCount:_list.length,itemBuilder:(cc,i)=>ListTile(title:Text(_list[i].split('/').last),trailing:IconButton(icon:Icon(Icons.delete),onPressed:(){File(_list[i]).deleteSync();_load();}))))]));}
}
