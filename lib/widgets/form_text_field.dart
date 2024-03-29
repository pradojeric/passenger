import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool pass;
  final TextInputType keyboardType;
  final Function validator;
  final Function onSaved;
  final List<TextInputFormatter> formatters;
  final String initialValue;
  final bool autofocus;

  FormTextField({
    Key key,
    this.validator,
    this.hint,
    this.icon,
    this.pass = false,
    this.keyboardType = TextInputType.text,
    this.onSaved,
    this.formatters,
    this.initialValue,
    this.autofocus,
  }) : super(key: key);

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool obscureText = true;
  bool showPass = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F8),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: TextFormField(
        autofocus: widget.autofocus ?? false,
        initialValue: widget.initialValue,
        inputFormatters: widget.formatters,
        onSaved: (value) => widget.onSaved(value),
        validator: (value) => widget.validator(value),
        keyboardType: widget.keyboardType,
        obscureText: widget.pass ? obscureText : false,
        cursorColor: Colors.blue[900],
        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: Colors.grey,
            size: 24,
          ),
          suffixIcon: widget.pass
              ? IconButton(
                  icon: Icon(showPass ? Icons.visibility : Icons.visibility_off),
                  onPressed: _toggle,
                  color: Colors.grey,
                )
              : SizedBox(),
          hintText: widget.hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      showPass = !showPass;
      obscureText = !obscureText;
    });
  }
}
