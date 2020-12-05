import 'dart:async';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unihub/Database/DBRef.dart';
import 'package:unihub/bloc_provider.dart';

class posts_bloc extends BlocBase {
  posts_bloc() {
    DBRef().initCommentsStream().listen((event) {
      _inFirestore.add(event);
    });
  }

  String id;
  final _controller = StreamController<String>();

  Sink<String> get _inID => _controller.sink;

  Stream<String> get _outID => _controller.stream;

  final _firestoreCont = StreamController<QuerySnapshot>();

  Sink<QuerySnapshot> get _inFirestore => _firestoreCont.sink;

  Stream<QuerySnapshot> get _outFirestore => _firestoreCont.stream;


  @override
  void dispose() {
    // TODO: implement dispose
    _controller.close();
    _firestoreCont.close();
  }
}
