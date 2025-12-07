import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/common_component/custom_app_bar.dart';
import 'package:qrscanner/common_component/custom_button.dart';
import 'package:qrscanner/common_component/custom_text_field.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/login/login_view.dart';
import 'package:qrscanner/features/settings/settings_controller.dart';
import 'package:qrscanner/features/settings/settings_states.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsController()..loadCurrentSettings(),
      child: Scaffold(
        body: Container(
          decoration: containerDecoration,
          child: ListView(
            children: [
              const CustomAppBar(text: 'Settings'),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.06,
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
                child: BlocBuilder<SettingsController, SettingsStates>(
                  builder: (context, state) {
                    final controller = SettingsController.of(context);

                    return Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Server Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // -------- Text Field --------
                          CustomTextField(
                            hint:
                                'Enter IP (192.168.x.x:8000) or domain (bestscan.store)',
                            lableText: 'Server Address',
                            controller: controller.ipController,
                            onChanged: (_) {
                              // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                              controller.emit(SettingsLoaded());
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter server address';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // -------- Server Type Detector --------
                          Builder(
                            builder: (context) {
                              final text = controller.ipController.text.trim();

                              if (text.isEmpty) {
                                return const SizedBox();
                              }

                              final isIP = RegExp(
                                r'^(\d{1,3}\.){3}\d{1,3}(:\d+)?$',
                              ).hasMatch(text);

                              return Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  color: isIP
                                      ? Colors.green.withAlpha(
                                          (0.12 * 255).toInt(),
                                        )
                                      : Colors.blue.withAlpha(
                                          (0.12 * 255).toInt(),
                                        ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isIP ? Colors.green : Colors.blue,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isIP ? Icons.wifi : Icons.cloud_outlined,
                                      color: isIP ? Colors.green : Colors.blue,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        isIP
                                            ? 'Local server detected\nhttp://$text'
                                            : 'Production server detected\nhttps://$text',
                                        style: TextStyle(
                                          color: isIP
                                              ? Colors.green[900]
                                              : Colors.blue[900],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 30),

                          // -------- Save Button --------
                          CustomButton(
                            text: 'Save',
                            onPress: () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.saveSettings();
                                MagicRouter.navigateTo(const LogInView());
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
