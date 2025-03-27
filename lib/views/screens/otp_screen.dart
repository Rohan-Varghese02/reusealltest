import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickup_app/constant/colors.dart';
import 'package:pickup_app/views/screens/home_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<TextEditingController> controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  KeyEventResult _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace &&
          controllers[index].text.isEmpty &&
          index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.95;
    return Scaffold(
      appBar: AppBar(title: Text("OTP Verification")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Focus(
                    onKeyEvent: (node, event) => _onKeyEvent(index, event),
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) => _onChanged(index, value),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(width, 60),
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Text(
              'Verify',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
