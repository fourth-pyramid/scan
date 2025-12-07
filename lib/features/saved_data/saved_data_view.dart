import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/common_component/custom_app_bar.dart';
import 'package:qrscanner/common_component/custom_button.dart';
import 'package:qrscanner/common_component/custom_text.dart';
import 'package:qrscanner/common_component/custom_text_field.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/features/saved_data/component/saved_data_card.dart';
import 'package:qrscanner/features/saved_data/saved_data_controllers.dart';
import 'package:qrscanner/features/saved_data/saved_data_states.dart';

//my scans
class SavedDataView extends StatelessWidget {
  const SavedDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavesDataController()..myScans(),
      child: Scaffold(
        body: Container(
          decoration: containerDecoration,
          child: ListView(
            children: [
              const CustomAppBar(text: 'Saved Data'),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).size.height * 0.14,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: BlocBuilder<SavesDataController, SavedDataStates>(
                  builder: (context, state) {
                    final controller = context.watch<SavesDataController>();
                    final scans = controller.myScansModel?.data ?? [];

                    if (state is SavedDataLoading ||
                        (state is SavedDataInit && scans.isEmpty)) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is SavedDataError) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CustomText(
                            text:
                                'Unable to load saved scans. Please try again later.',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    if (scans.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CustomText(
                            text: 'You don\'t have any saved scans yet.',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return ListView(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: 'No .${scans.length}',
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              Row(
                                children: [
                                  CustomButton(
                                    text: 'Excel',
                                    fontSize: 12,
                                    widthButton:
                                        MediaQuery.of(context).size.width *
                                        0.25,
                                  ),
                                  const SizedBox(width: 5),
                                  CustomButton(
                                    text: 'Send Email',
                                    fontSize: 12,
                                    widthButton:
                                        MediaQuery.of(context).size.width *
                                        0.25,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: CustomTextField(hint: 'Search....'),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: scans.length,
                          itemBuilder: (context, index) =>
                              SavedDataCard(savedData: scans[index]),
                        ),
                      ],
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
