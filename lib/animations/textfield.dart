import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class AnimatedTextField extends StatefulWidget {
  final String labelText;
  final IconData iconData;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;

  const AnimatedTextField({
    Key? key,
    required this.labelText,
    required this.iconData,
    required this.onChanged,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _AnimatedTextFieldState createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _emailValid = true;
  bool _passwordValid = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    widget.controller.addListener(() {
      if (widget.keyboardType == TextInputType.emailAddress) {
        setState(() {
          _emailValid = EmailValidator.validate(widget.controller.text);
        });
      } else if (widget.obscureText) {
        final passwordPattern = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        setState(() {
          _passwordValid = passwordPattern.hasMatch(widget.controller.text);
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.yellow.shade700,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _isFocused ? Colors.yellow.shade700 : Colors.black,
            width: 1.0,
          ),
        ),
        errorText: widget.keyboardType == TextInputType.emailAddress && !_emailValid
            ? 'Please enter a valid email address'
            : widget.obscureText && !_passwordValid
            ? 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number and one special character'
            : null,
        prefixIcon: Icon(
          widget.iconData,
          color: Colors.black,
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 50.0,
        ),
      ),
      cursorColor: Colors.yellow,
      style: TextStyle(fontSize: 18.0),
      validator: (value) {
        if (widget.keyboardType == TextInputType.emailAddress) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email address';
          }
          if (!_emailValid) {
            return 'Please enter a valid email address';
          }
        } else if (widget.obscureText) {
          final passwordPattern = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          } else if (!passwordPattern.hasMatch(value)) {
            return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number and one special character';
          } else {
            return null;
          }
        } else {
          return null;
        }
      },// set the text input font size
    );
  }
}
