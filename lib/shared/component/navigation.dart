import 'package:flutter/material.dart';

void pushWithAnimationLeftAndBottom({required BuildContext context,
  required Widget widget,bool left=true}){
  Navigator.push(context,
      PageRouteBuilder(
        transitionDuration:
        const Duration(milliseconds: 150),
        pageBuilder: (_, __, ___) {
          return widget;
        },
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin:  Offset(left?1.0:0.0,left? 0.0:1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      )

  );
}