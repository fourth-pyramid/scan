import 'package:qrscanner/core/appStorage/user_model.dart';

abstract class LoginStates {}

class LoginInit extends LoginStates {}

class LoginLoading extends LoginStates {}

class LoginSuccess extends LoginStates {
  final UserModel userModel;
  LoginSuccess(this.userModel);
}

class LoginError extends LoginStates {}
