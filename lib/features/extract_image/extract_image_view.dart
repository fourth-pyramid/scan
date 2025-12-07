import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/common_component/custom_button.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/features/extract_image/extact_image_states.dart';
import 'package:qrscanner/features/extract_image/extract_image_controller.dart';

class ExtractImageView extends StatefulWidget {
  final String? scanType;
  final int categoryId;

  const ExtractImageView({super.key, this.scanType, required this.categoryId});

  @override
  State<ExtractImageView> createState() => _ExtractImageViewState();
}

class _ExtractImageViewState extends State<ExtractImageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExtractImageController>().loadHistoryCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtractImageController, ExtractImageStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Scan Card'),
            foregroundColor: Colors.white,
            centerTitle: true,
            backgroundColor: colorPrimary,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    // -------------------------------------------------------
                    // PREVIEW IMAGE
                    // -------------------------------------------------------
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.28,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          BlocBuilder<
                            ExtractImageController,
                            ExtractImageStates
                          >(
                            builder: (context, state) {
                              final controller = ExtractImageController.of(
                                context,
                              );
                              final previewFile =
                                  controller.image ?? controller.image;

                              if (previewFile != null) {
                                return Image.file(previewFile);
                              }

                              return SizedBox(
                                height: 50,
                                width: 40,
                                child: Padding(
                                  padding: const EdgeInsets.all(50),
                                  child: Image.asset(
                                    'assets/images/screenshot.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),
                    ),

                    const SizedBox(height: 16.0),

                    // -------------------------------------------------------
                    // CAMERA BUTTON
                    // -------------------------------------------------------
                    SizedBox(
                      height: 70,
                      child: CustomButton(
                        isIcon: true,
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        text: 'Open Camera',
                        onPress: () {
                          ExtractImageController.of(context).getImage(context);
                        },
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // -------------------------------------------------------
                    // PIN
                    // -------------------------------------------------------
                    BlocBuilder<ExtractImageController, ExtractImageStates>(
                      buildWhen: (previous, current) =>
                          current is ScanPinSuccess,
                      builder: (context, state) {
                        final controller = ExtractImageController.of(context);
                        return TextFormField(
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          controller: controller.pin,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorPrimary),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorPrimary),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            isDense: false,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 12,
                            ),
                            labelText: 'No Pin',
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 22,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16.0),

                    // -------------------------------------------------------
                    // SERIAL (editable)
                    // -------------------------------------------------------
                    BlocBuilder<ExtractImageController, ExtractImageStates>(
                      buildWhen: (previous, current) =>
                          current is ScanPinSuccess,
                      builder: (context, state) {
                        final controller = ExtractImageController.of(context);
                        return TextFormField(
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          controller: controller.serial,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorPrimary),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorPrimary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            isDense: false,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 12,
                            ),
                            labelText: 'Serial',
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 22,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18.0),

                    // -------------------------------------------------------
                    // SAVE BUTTON
                    // -------------------------------------------------------
                    BlocBuilder<ExtractImageController, ExtractImageStates>(
                      builder: (context, state) {
                        return state is ScanLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                text: 'Save',
                                onPress: () async {
                                  final controller = context
                                      .read<ExtractImageController>();
                                  final messenger = ScaffoldMessenger.of(
                                    context,
                                  );

                                  if (controller.image == null) {
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please capture a card image first.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final phoneType = Platform.isAndroid
                                      ? 'Samsung'
                                      : 'iPhone';

                                  /// 🔥 Scan API call
                                  await controller.scan(
                                    categoryId: widget.categoryId,
                                    phoneType: phoneType,
                                  );
                                  if (context.mounted) {
                                    context
                                        .read<ExtractImageController>()
                                        .loadHistoryCount();
                                  }
                                },
                              );
                      },
                    ),

                    const SizedBox(height: 16.0),
                    BlocBuilder<ExtractImageController, ExtractImageStates>(
                      builder: (context, state) {
                        final controller = ExtractImageController.of(context);

                        return Center(
                          child: Text(
                            'Number of Card is ${controller.historyCount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
