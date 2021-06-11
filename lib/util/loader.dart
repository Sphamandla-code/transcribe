import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Floader {
  Widget floader_spinter() {
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );
  }

  Widget floder_Wave() {
    return SpinKitWave(
      color: Colors.blueGrey,
      size: 50.0,
    );
  }
}
