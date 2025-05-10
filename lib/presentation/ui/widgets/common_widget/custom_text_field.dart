import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:flutter/material.dart';

@immutable
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textLabel,
    required this.textController,
    required this.textFieldSuffix,
    required this.validatorFunction,
    this.readOnly = false,
    this.onChangedFunction,
    this.textFieldPrefix = const SizedBox(width: 1),
    this.isObsecure = false,
    this.keyboardType = TextInputType.text,
  });
  final TextEditingController textController;
  final Widget? textFieldSuffix;
  final Widget? textFieldPrefix;
  final String textLabel;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validatorFunction;
  final Function(String)? onChangedFunction;
  final bool isObsecure;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: textController,
        obscureText: isObsecure,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          prefixIcon: textFieldPrefix,
          hintText: textLabel,

          hintStyle: TextStyleHelper.textStylefontSize16,

          filled: true,
          fillColor: ColorHelper.white1,
          suffixIcon: textFieldSuffix,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: ColorHelper.black, width: 1),
          ),
          enabledBorder: InputBorder.none,
        ),
        validator: validatorFunction,
        onChanged: onChangedFunction,
      ),
    );
  }
}
