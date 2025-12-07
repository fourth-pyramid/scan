import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/card_type/card_type_controller.dart';
import 'package:qrscanner/features/card_type/card_type_states.dart';
import 'package:qrscanner/features/extract_image/extract_image_controller.dart';
import 'package:qrscanner/features/extract_image/extract_image_view.dart';

class CardTypeView extends StatelessWidget {
  const CardTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardTypeController()..getCategories(),
      child: BlocBuilder<CardTypeController, CardTypeStates>(
        builder: (context, state) {
          final controller = CardTypeController.of(context);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Select Card Type'),
              backgroundColor: colorPrimary,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            body: state is CardTypeLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.getCategoriesModel?.data == null
                ? const Center(child: Text('No Data'))
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16,
                        ),
                        child: Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.5,
                                  ),
                              itemCount:
                                  controller.getCategoriesModel!.data!.length,
                              itemBuilder: (context, index) {
                                final fallbackImages = [
                                  'assets/images/20.jpeg',
                                  'assets/images/25.jpeg',
                                  'assets/images/30.jpeg',
                                  'assets/images/50.jpeg',
                                  'assets/images/100.jpeg',
                                ];
                                final filteredList =
                                    controller.getCategoriesModel!.data!;

                                final item = filteredList[index];

                                final fallbackImage =
                                    fallbackImages[index %
                                        fallbackImages.length];

                                return InkWell(
                                  onTap: () {
                                    debugPrint(
                                      'Card ID: ${item.id} ========== ${item.name} ',
                                    );
                                    MagicRouter.navigateTo(
                                      BlocProvider(
                                        create: (context) =>
                                            ExtractImageController(
                                              item.name ?? '',
                                            ),
                                        child: ExtractImageView(
                                          scanType: item.name ?? '',
                                          categoryId: item.id!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        fallbackImage,
                                        fit: BoxFit.fill,
                                      ),
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
      ),
    );
  }
}
