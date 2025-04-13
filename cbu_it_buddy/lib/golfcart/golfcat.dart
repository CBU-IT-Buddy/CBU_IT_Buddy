import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:golfcart/gameapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();
  runApp(GameApp());
}
