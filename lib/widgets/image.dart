import 'package:flutter/material.dart';

class FullImage extends StatefulWidget {
  final String ImageUrl;
   FullImage({super.key, required this.ImageUrl});

  @override
  State<FullImage> createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
       Container(
        width:double.infinity,
        
        child: Image.network(widget.ImageUrl,fit: BoxFit.contain,),)
    );
  }
}