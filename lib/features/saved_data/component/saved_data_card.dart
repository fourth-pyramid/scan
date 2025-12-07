import 'package:flutter/material.dart';
import 'package:qrscanner/common_component/custom_text.dart';
import 'package:qrscanner/core/appStorage/my_scans_model.dart';

class SavedDataCard extends StatelessWidget {
  const SavedDataCard({super.key, this.savedData});
  final SavedData? savedData;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CustomText(
                      text: 'Pin : ',
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    CustomText(
                      text: savedData!.pin!,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const CustomText(
                      text: 'Serial : ',
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    CustomText(
                      text: savedData!.serial!,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
            Image.asset('assets/images/edit.png'),
          ],
        ),
      ),
    );
  }
}
