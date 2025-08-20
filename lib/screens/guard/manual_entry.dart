import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'dart:io';
import '/widgets/common/role_based_navbar.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ManualEntry extends StatefulWidget {
  @override
  _ManualEntryState createState() => _ManualEntryState();
}

class _ManualEntryState extends State<ManualEntry> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController flatNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberOfGuestsController = TextEditingController();
  final TextEditingController numberOfDaysController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? guestType;
  String? qrData;
  File? visitorPhoto; // Holds the captured photo

  // Guest types
  final List<String> guestTypes = [
    'Servant',
    'Relatives or Friends',
    'Service Man'
  ];
  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        // Update the controller's text with the selected date in the desired format
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }
  //Capture Visitor Photo
  Future<void> capturePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        visitorPhoto = File(image.path);
      });
    }
  }

  void generateQrCode() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        qrData =
        'Name: ${nameController.text}\n'
            'Mobile: ${mobileController.text}\n'
            'Email: ${emailController.text}\n'
            'Guests: ${numberOfGuestsController.text}\n'
            'Days: ${numberOfDaysController.text}\n'
            'Date: ${dateController.text}\n'
            'Flat No. : ${flatNoController.text}\n'
            'image : $visitorPhoto \n'
            'Type: ${guestType ?? "Not Selected"}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manually Add Guest'),
        centerTitle: true,
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 70,
        child: RoleBasedNavbar(role: 'guard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name of Guest',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the name'
                      : null,
                ),
                SizedBox(height: 16),

                // Mobile Number
                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a valid mobile number'
                      : null,
                ),
                SizedBox(height: 16),

                // Flat Number
                TextFormField(
                  controller: flatNoController,
                  decoration: InputDecoration(
                    labelText: 'Flat No.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the flat number'
                      : null,
                ),
                SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || !value.contains('@')
                      ? 'Please enter a valid email address'
                      : null,
                ),
                SizedBox(height: 16),

                // Number of Guests
                TextFormField(
                  controller: numberOfGuestsController,
                  decoration: InputDecoration(
                    labelText: 'Number of Guests',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the number of guests'
                      : null,
                ),
                SizedBox(height: 16),

                // Number of Days
                TextFormField(
                  controller: numberOfDaysController,
                  decoration: InputDecoration(
                    labelText: 'Number of Days',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the number of days'
                      : null,
                ),
                SizedBox(height: 16),

                // Date of Arrival
                // TextFormField(
                //   controller: dateController,
                //   decoration: InputDecoration(
                //     labelText: 'Date of Arrival (DD-MM-YYYY)',
                //     border: OutlineInputBorder(),
                //   ),
                //   keyboardType: TextInputType.datetime,
                //   validator: (value) => value == null || value.isEmpty
                //       ? 'Please enter the date of arrival'
                //       : null,
                // ),
                // SizedBox(height: 16),

                // Date
                TextFormField(
                  controller: dateController,
                  readOnly: true, // Prevents manual input
                  decoration: InputDecoration(
                    labelText: 'Date of Arrival (DD-MM-YYYY)',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today, color: Color(0xFF41C1BA)),
                      onPressed: _pickDate,
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the date of arrival' : null,
                ),

                SizedBox(height: 16),

                // Guest Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Type of Guest',
                    border: OutlineInputBorder(),
                  ),
                  value: guestType,
                  items: guestTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => guestType = value),
                  validator: (value) =>
                      value == null ? 'Please select a guest type' : null,
                ),
                SizedBox(height: 24),

                // Capture Photo Button
                Center(
                  child: ElevatedButton(
                    onPressed: capturePhoto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xFFFDFDFD),

                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Capture Visitor Photo',
                      style: TextStyle(color:Color(0xFF41C1BA) ), // Change text color here
                    ),

                  ),
                ),
                SizedBox(height: 5),

                // Preview Captured Photo
                if (visitorPhoto != null)
                  Center(
                    child: Column(
                      children: [
                        Text('Captured Photo:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(visitorPhoto!,
                              width: 200, height: 200, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 24),

                // Create Pass Button
                Center(
                  child: ElevatedButton(
                    onPressed: generateQrCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF41C1BA),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Create Pass',
                      style: TextStyle(color: Colors.white),
                    ),

                  ),
                ),

                // QR Code Display
                if (qrData != null)
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: QrImageView(
                        data: qrData ?? '', // Ensure this is not null
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
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
