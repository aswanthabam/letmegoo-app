import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letmegoo/constants/app_theme.dart';
import 'package:letmegoo/notify.dart';

void main() {
  runApp(MaterialApp(home: ReportPage(), debugShowCheckedModeBanner: false));
}

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController regNumberController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isAnonymous = false;
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/angry.png', // Replace with your lock angry image path
                  height: 185,
                  width: 185,
                ),
                const SizedBox(height: 5),
                Text(
                  "Report a Vehicle",
                  textAlign: TextAlign.center,
                  style: AppFonts.semiBold24(),
                ),

                const SizedBox(height: 10),

                Text(
                  "Spotted a vehicle causing an obstruction?\nFill in the details below so we can alert the\nowner and get things moving quickly.",
                  textAlign: TextAlign.center,
                  style: AppFonts.regular14(),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: regNumberController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "KL00AA0000",
                    hintStyle: AppFonts.regular16(),
                    labelText: "Registration Number",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: messageController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter the message to the owner of this vehicle",
                    hintStyle: AppFonts.semiBold16(),
                    labelText: "Message",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Add an image of vehicle",
                          style: AppFonts.semiBold16(),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_image != null) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_image!, height: 150),
                  ),
                ],

                const SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(
                      value: isAnonymous,
                      onChanged: (val) {
                        setState(() {
                          isAnonymous = val ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    Expanded(
                      child: Text(
                        "Do you want to keep your identity anonymous",
                        style: AppFonts.regular16(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    final regNumber = regNumberController.text.trim();
                    final message = messageController.text.trim();

                    if (regNumber.isEmpty || message.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    // ✅ Navigate to next page after successful report
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Notify()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Report",
                    style: AppFonts.semiBold16(color: Color(0xFFFFFFFF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
