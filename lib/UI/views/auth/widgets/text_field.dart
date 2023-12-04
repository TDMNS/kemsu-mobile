import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../Configurations/hex.dart';

class AuthTextField extends StatefulWidget {
  final BuildContext context;
  final FocusNode focusNode;
  final Widget suffixIcon;
  final String hintText;
  final TextEditingController textEditingController;
  final bool isObscure;
  final TextInputAction textInputAction;
  final Function onChanged;
  final Function onTap;
  final Function onFieldSubmitted;

  const AuthTextField({
    super.key,
    required this.context,
    required this.focusNode,
    required this.suffixIcon,
    required this.hintText,
    required this.textEditingController,
    required this.isObscure,
    required this.textInputAction,
    required this.onChanged,
    required this.onTap,
    required this.onFieldSubmitted,
  });

  @override
  AuthTextFieldState createState() => AuthTextFieldState();
}

class AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 8, top: 8),
      child: TextFormField(
        focusNode: widget.focusNode,
        onChanged: (value) {
          widget.onChanged(value);
        },
        onTap: () {
          widget.onTap();
        },
        decoration: InputDecoration(
          fillColor: MediaQuery.of(widget.context).platformBrightness == Brightness.dark
              ? HexColor('#232325')
              : HexColor('#f2f3f5'),
          filled: true,
          suffixIcon: widget.suffixIcon,
          contentPadding: const EdgeInsets.only(left: 15, top: 15),
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontFamily: "Ubuntu", color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        style: const TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold),
        controller: widget.textEditingController,
        obscureText: widget.isObscure,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: (value) {
          widget.onFieldSubmitted(value);
        },
        textCapitalization: TextCapitalization.none,
      ),
    );
  }
}
