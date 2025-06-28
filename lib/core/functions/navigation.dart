import 'package:flutter/material.dart';

pushTo(BuildContext context, Widget newScreen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return newScreen;
  }));
}

pushWithReplacement(BuildContext context, Widget newScreen) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
    return newScreen;
  }));
}

popTo(BuildContext context, Widget newScreen) {
  Navigator.of(context).pop(MaterialPageRoute(builder: (context) {
    return newScreen;
  }));
}