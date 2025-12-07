import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/common_component/custom_button.dart';
import 'package:qrscanner/common_component/custom_text.dart';
import 'package:qrscanner/common_component/custom_text_field.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/features/login/login_controller.dart';
import 'package:qrscanner/features/login/login_states.dart';

class LogInView extends StatelessWidget {
  const LogInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogInController(),
      child: Scaffold(
        body: Container(
          decoration: containerDecoration,
          child: ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              CustomText(
                text: 'Login',
                color: colorSecondary,
                fontWeight: FontWeight.bold,
                alignment: Alignment.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 20,
                  right: 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: BlocBuilder<LogInController, LoginStates>(
                  builder: (context, state) => Form(
                    key: LogInController.of(context).formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          hint: 'Enter your email',
                          controller: LogInController.of(context).email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hint: 'Enter your password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          secure: true,
                          controller: LogInController.of(context).password,
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<LogInController, LoginStates>(
                          builder: (context, state) {
                            if (state is LoginLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return CustomButton(
                                text: 'Login',
                                onPress: () => login(context),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) {
    if (LogInController.of(context).formKey.currentState!.validate()) {
      LogInController.of(context).login();
    }
  }
}
