import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:summarizeddebts/app_widget.dart';
import 'package:summarizeddebts/modules/login/login_module.dart';
import 'package:summarizeddebts/ui/screen/home/home_screen.dart';
import 'package:summarizeddebts/ui/utility/routers.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [];

  @override
  Widget get bootstrap => AppWidget();

  @override
  List<Router> get routers => [
        Router(Routers.initial, module: LoginModule()),
        Router(Routers.home, child: (_, args) => HomeScreen()),
      ];
}
