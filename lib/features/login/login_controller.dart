import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/common_component/snack_bar.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/appStorage/user_model.dart';
import 'package:qrscanner/core/dioHelper/dio_helper.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/card_scanner/card_scanner_view.dart';
import 'package:qrscanner/features/login/login_states.dart';

class LogInController extends Cubit<LoginStates> {
  LogInController() : super(LoginInit());

  static LogInController of(context) => BlocProvider.of(context);

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  UserModel? userModel;

  bool get isLoading => state is LoginLoading;

  void login() async {
    if (isLoading) return;

    if (!formKey.currentState!.validate()) return;

    emit(LoginLoading());

    final phoneType = Platform.isAndroid ? 'Samsung' : 'iPhone';
    final body = {
      'email': email.text.trim(),
      'password': password.text,
      'phone': phoneType,
    };

    debugPrint('📤 Attempting login with: $body');
    debugPrint('🌐 Base URL: ${DioHelper.dioSingleton.options.baseUrl}');

    try {
      final response = await DioHelper.post('login', false, body: body);
      debugPrint('✅ Login Response: ${response.data}');

      final data = response.data as Map<String, dynamic>;
      final message = data['massage'] ?? 'login failed';

      if (data['status'] == 1) {
        try {
          userModel = UserModel.fromJson(data);
          await AppStorage.cacheUserInfo(userModel!);

          MagicRouter.navigateAndPopAll(const CardScannerView());
          emit(LoginSuccess(userModel!));
        } catch (e) {
          debugPrint('❌ UserModel Parsing Error: $e');
          showSnackBar('Invalid user data received.');
          emit(LoginError());
        }
      } else {
        emit(LoginError());
        showSnackBar(message);
      }
    } on SocketException {
      showSnackBar(
        'Cannot connect to server. Please check your IP configuration.',
      );
      emit(LoginError());
    } on TimeoutException {
      showSnackBar('Connection timeout. Server is not responding.');
      emit(LoginError());
    } catch (e) {
      debugPrint('❌ Unexpected Login Error: $e');
      showSnackBar('Connection error. Please check your network or server.');
      emit(LoginError());
    }
  }
}
