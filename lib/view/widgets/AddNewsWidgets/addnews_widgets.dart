  import 'package:flutter/material.dart';
import 'package:taxverse_admin/constants.dart';

TextFormField headLineTextfield(TextEditingController heading) {
    return TextFormField(
      controller: heading,
      decoration: InputDecoration(
        hintText: 'Enter News Headline',
        hintStyle: AppStyle.poppinsRegular16,
        labelText: 'Headline',
        labelStyle: AppStyle.poppinsRegular16,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: blackColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: blackColor, width: 2),
        ),
      ),
    );
  }

  TextFormField autherNameTextfield(TextEditingController autherName) {
    return TextFormField(
      controller: autherName,
      decoration: InputDecoration(
        hintText: 'Enter Auther Name',
        hintStyle: AppStyle.poppinsRegular16,
        labelText: 'Auther Name',
        labelStyle: AppStyle.poppinsRegular16,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: blackColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: blackColor, width: 2),
        ),
      ),
    );
  }


  TextFormField descriptionTextfield(TextEditingController description) {
    return TextFormField(
      controller: description,
      maxLines: 10,
      decoration: InputDecoration(
        labelText: 'Descrption',
        labelStyle: AppStyle.poppinsRegular16,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: blackColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: blackColor, width: 2),
        ),
      ),
    );
  }