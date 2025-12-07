import 'package:flutter/material.dart';
import 'package:qrscanner/common_component/custom_text.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/core/dioHelper/dio_helper.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/card_type/card_type_view.dart';
import 'package:qrscanner/features/saved_data/saved_data_view.dart';

class CardScannerView extends StatelessWidget {
  const CardScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: containerDecoration,
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            CustomText(
              text: 'Card Scanner',
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () =>
                            MagicRouter.navigateTo(const CardTypeView()),
                        child: Image.asset('assets/images/scan.png'),
                      ),
                      InkWell(
                        onTap: () =>
                            MagicRouter.navigateTo(const SavedDataView()),
                        child: Image.asset('assets/images/saved.png'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  InkWell(
                    onTap: () async {
                      await DioHelper.post('delete', true, body: {});
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All saved data has been cleared.'),
                          ),
                        );
                      }
                    },
                    child: Image.asset('assets/images/clear.png'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
