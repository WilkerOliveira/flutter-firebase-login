import 'package:flutter_modular/flutter_modular.dart';
import 'package:summarizeddebts/modules/login/controller/login_controller.dart';
import 'package:summarizeddebts/modules/login/controller/register_controller.dart';
import 'package:summarizeddebts/modules/login/repository/api/login_api.dart';
import 'package:summarizeddebts/modules/login/repository/login_repository.dart';
import 'package:summarizeddebts/modules/login/screen/login_screen.dart';
import 'package:summarizeddebts/modules/login/screen/register_screen.dart';
import 'package:summarizeddebts/ui/utility/routers.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LoginApi()),
        Bind((i) => LoginRepository(i.get<LoginApi>())),
        Bind((i) => LoginController(i.get<LoginRepository>())),
        Bind((i) => RegisterController(i.get<LoginRepository>())),
      ];

  @override
  List<Router> get routers => [
        Router(Routers.initial, child: (_, args) => LoginScreen()),
        Router(Routers.signUp, child: (_, args) => RegisterScreen()),
      ];
}
