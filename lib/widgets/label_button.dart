import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelButton extends StatelessWidget {
  final String liteText;
  final double liteFont;
  final String boldText;
  final double boldFont;
  final Function pressed;

  const LabelButton(
      {Key key,
      this.liteText,
      this.liteFont,
      this.boldText,
      this.boldFont,
      this.pressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: RichText(
          text: TextSpan(
              text: liteText,
              style: GoogleFonts.poppins(
                color: Colors.blue[900],
                fontSize: liteFont ?? 14.0,
              ),
              children: [
                TextSpan(
                    text: boldText,
                    style: GoogleFonts.poppins(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                      fontSize: boldFont ?? 14.0,
                    ))
              ]),
        ),
      ),
    );
  }
}
