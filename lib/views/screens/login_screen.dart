import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickup_app/constant/colors.dart';
import 'package:pickup_app/views/screens/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final key = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.95;
    return Scaffold(
      appBar: AppBar(title: Text('Login Page'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone Number',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Form(
              key: key,
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: grey20),
                  ),
                  hintText: 'Enter your phone number',
                  hintStyle: GoogleFonts.poppins(color: grey99, fontSize: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field cannot be empty";
                  } else if (value.length < 10) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 40),
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
                if (key.currentState != null && key.currentState!.validate()) {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => OtpScreen()));
                }
              },
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
