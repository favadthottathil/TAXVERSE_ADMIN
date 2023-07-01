import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:taxverse_admin/constants.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({super.key});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  TextEditingController percentageController = TextEditingController();
  bool isCheckedInformation = false;
  bool isCheckedDocuments = false;
  bool isCheckedApproval = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SizedBox(
                  height: size.height * 0.5,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text('Enter Progress bar Percentage', style: AppStyle.poppinsBold12),
                          ),
                          Expanded(
                            child: TextField(
                              controller: percentageController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.015, horizontal: size.width * 0.01),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: blackColor, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: blackColor, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Checked Information',
                          style: AppStyle.poppinsBold12,
                        ),
                        value: isCheckedInformation,
                        onChanged: (bool? value) {
                          setState(
                            () {
                              isCheckedInformation = value ?? false;
                            },
                          );
                        },
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Checked Documents',
                          style: AppStyle.poppinsBold12,
                        ),
                        value: isCheckedDocuments,
                        onChanged: (value) {
                          isCheckedDocuments = value ?? false;
                        },
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Final Approval',
                          style: AppStyle.poppinsBold12,
                        ),
                        value: isCheckedApproval,
                        onChanged: (value) {
                          isCheckedApproval = value ?? false;
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Text(
          'Update Status To Client',
          style: AppStyle.poppinsBold16,
        ),
      ),
    );
  }
}
