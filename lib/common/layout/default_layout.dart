import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget{
  //
  final Color? backGroundColor;
  // Body Child Widget
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final bool useScroll;

  const DefaultLayout({
    required this.child,
    this.backGroundColor,
    this.title,
    this.bottomNavigationBar,
    this.useScroll = true,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      backgroundColor: backGroundColor ?? Colors.white,
      body: this.child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar(){
    if(title == null){
      return null;
    }
    else{
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // ! 를 넣어서 null 값이 들어가지 않는다라는 걸 보장해줘야한다.
        title: Text(title!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
        foregroundColor: Colors.black,
        centerTitle: true,
      );
    }
  }
}