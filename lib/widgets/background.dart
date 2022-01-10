import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final bool withImage;
  String? source = '';

  Background({
    Key? key,
    required this.child,
    required this.withImage,
    this.source,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          source == 'addReport'
              ? Container()
              : Positioned(
                  top: 0,
                  right: 0,
                  child:
                      Image.asset("assets/images/top1.png", width: size.width),
                ),
          source == 'addReport'
              ? Container()
              : Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset("assets/images/top2.png",
                      color: Colors.blue, width: size.width),
                ),
          withImage
              ? Positioned(
                  top: 50,
                  right: 20,
                  child: Image.asset(
                    "assets/images/doc.png",
                    width: size.width * 0.35,
                    height: 150,
                  ),
                )
              : Container(),
          source == 'addReport'
              ? Positioned(
                  bottom: 40,
                  right: 30,
                  child: Image.asset("assets/images/report2.png", width: 100),
                )
              : Container(),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/bottom1.png",
                color: Colors.blue, width: size.width),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/bottom2.png", width: size.width),
          ),
          child
        ],
      ),
    );
  }
}
