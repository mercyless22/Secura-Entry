//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:intl/intl.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
// import '/widgets/common/role_based_navbar.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
//
// class AddGuestScreen extends StatefulWidget {
//   @override
//   _AddGuestScreenState createState() => _AddGuestScreenState();
// }
//
// class _AddGuestScreenState extends State<AddGuestScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController numberOfGuestsController = TextEditingController();
//   final TextEditingController numberOfDaysController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   String? guestType;
//   String? qrData;
//
//   final List<String> guestTypes = ['Servant', 'Relatives or Friends', 'Service Man'];
//
//   final String encryptionKey = "SecuraEntry@2025";
//
//   // String encryptData(String plainText) {
//   //   final key = encrypt.Key.fromUtf8(encryptionKey.padRight(32, '0'));
//   //   final iv = encrypt.IV.fromLength(16);
//   //   final encrypter = encrypt.Encrypter(encrypt.AES(key));
//   //   final encrypted = encrypter.encrypt(plainText, iv: iv);
//   //   return encrypted.base64;
//   // }
//   String encryptData(String plainText) {
//     final key = encrypt.Key.fromUtf8(encryptionKey.padRight(32, '0')); // Ensure 32 bytes
//     final iv = encrypt.IV.fromLength(16); // Generate IV dynamically
//     final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
//
//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//
//     // Store IV and encrypted data together, separated by ':'
//     return base64Encode(iv.bytes) + ":" + encrypted.base64;
//   }
//
//   void _pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate != null) {
//       setState(() {
//         dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
//       });
//     }
//   }
//
//   void generateQrCode() {
//     if (_formKey.currentState!.validate()) {
//       String data =
//           'Name: ${nameController.text}\n'
//           'Mobile: ${mobileController.text}\n'
//           'Email: ${emailController.text}\n'
//           'Guests: ${numberOfGuestsController.text}\n'
//           'Days: ${numberOfDaysController.text}\n'
//           'Date: ${dateController.text}\n'
//           'Type: ${guestType ?? "Not Selected"}';
//
//       setState(() {
//         qrData = encryptData(data);
//       });
//     }
//   }
//
//   Future<void> shareQrCode() async {
//     if (qrData == null) return;
//
//     try {
//       final directory = await getTemporaryDirectory();
//       final imagePath = '${directory.path}/qr_code.png';
//
//       final qrImage = await QrPainter(
//         data: qrData!,
//         version: QrVersions.auto,
//         gapless: false,
//       ).toImageData(200);
//
//       if (qrImage != null) {
//         final buffer = qrImage.buffer.asUint8List();
//         final file = File(imagePath);
//         await file.writeAsBytes(buffer);
//
//         await Share.shareXFiles([XFile(imagePath)], text: 'Scan this QR Code');
//       }
//     } catch (e) {
//       print("Error sharing QR Code: $e");
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Guest'),
//         centerTitle: true,
//       ),
//       bottomNavigationBar: SizedBox(
//         width: double.infinity,
//         height: 70,
//         child: RoleBasedNavbar(role: 'guard'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Name of Guest',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter the name' : null,
//                 ),
//                 SizedBox(height: 16),
//
//                 TextFormField(
//                   controller: mobileController,
//                   decoration: InputDecoration(
//                     labelText: 'Mobile Number',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter a valid mobile number' : null,
//                 ),
//                 SizedBox(height: 16),
//
//                 TextFormField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email Address',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) => value == null || !value.contains('@') ? 'Please enter a valid email address' : null,
//                 ),
//                 SizedBox(height: 16),
//
//                 TextFormField(
//                   controller: numberOfGuestsController,
//                   decoration: InputDecoration(
//                     labelText: 'Number of Guests',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter the number of guests' : null,
//                 ),
//                 SizedBox(height: 16),
//
//                 TextFormField(
//                   controller: numberOfDaysController,
//                   decoration: InputDecoration(
//                     labelText: 'Number of Days',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter the number of days' : null,
//                 ),
//                 SizedBox(height: 16),
//
//                 TextFormField(
//                   controller: dateController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'Date of Arrival (DD-MM-YYYY)',
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.calendar_today, color: Color(0xFF41C1BA)),
//                       onPressed: _pickDate,
//                     ),
//                   ),
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter the date of arrival' : null,
//                 ),
//                 SizedBox(height: 16),
//
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     labelText: 'Type of Guest',
//                     border: OutlineInputBorder(),
//                   ),
//                   value: guestType,
//                   items: guestTypes.map((type) {
//                     return DropdownMenuItem(
//                       value: type,
//                       child: Text(type),
//                     );
//                   }).toList(),
//                   onChanged: (value) => setState(() => guestType = value),
//                   validator: (value) => value == null ? 'Please select a guest type' : null,
//                 ),
//                 SizedBox(height: 24),
//
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: generateQrCode,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF41C1BA),
//                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text('Generate QR Pass'),
//                   ),
//                 ),
//                 SizedBox(height: 24),
//
//                 if (qrData != null)
//                   Center(
//                     child: Column(
//                       children: [
//                         QrImageView(
//                           data: qrData ?? '',
//                           version: QrVersions.auto,
//                           size: 200.0,
//                           backgroundColor: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                 SizedBox(height: 16),
//                 Center(
//                   child: ElevatedButton.icon(
//                     onPressed: shareQrCode,
//                     icon: Icon(Icons.share),
//                     label: Text('Share QR Code'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF41C1BA),
//                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '/widgets/common/role_based_navbar.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AddGuestScreen extends StatefulWidget {
  @override
  _AddGuestScreenState createState() => _AddGuestScreenState();
}

class _AddGuestScreenState extends State<AddGuestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberOfGuestsController = TextEditingController();
  final TextEditingController numberOfDaysController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? guestType;
  String? qrData;

  final List<String> guestTypes = ['Servant', 'Relatives or Friends', 'Service Man'];

  final String encryptionKey = "SecuraEntry@2025";

  String encryptData(String plainText) {
    final key = encrypt.Key.fromUtf8(encryptionKey.padRight(32, '0'));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return base64Encode(iv.bytes) + ":" + encrypted.base64;
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void generateQrCode() async {
    if (_formKey.currentState!.validate()) {
      String data =
          'Name: ${nameController.text}\n'
          'Mobile: ${mobileController.text}\n'
          'Email: ${emailController.text}\n'
          'Guests: ${numberOfGuestsController.text}\n'
          'Days: ${numberOfDaysController.text}\n'
          'Date: ${dateController.text}\n'
          'Type: ${guestType ?? "Not Selected"}';

      setState(() {
        qrData = encryptData(data);
      });

      await Future.delayed(Duration(seconds: 0));
      shareQrOnWhatsApp();
    }
  }

  Future<void> shareQrCode() async {
    if (qrData == null) return;

    try {
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/qr_code.png';

      final qrImage = await QrPainter(
        data: qrData!,
        version: QrVersions.auto,
        gapless: false,
      ).toImageData(200);

      if (qrImage != null) {
        final buffer = qrImage.buffer.asUint8List();
        final file = File(imagePath);
        await file.writeAsBytes(buffer);

        await Share.shareXFiles([XFile(imagePath)], text: 'Scan this QR Code');
      }
    } catch (e) {
      print("Error sharing QR Code: $e");
    }
  }

  Future<void> shareQrOnWhatsApp() async {
    if (qrData == null) return;
    String message = "Scan this QR Code: $qrData";
    String url = "https://wa.me/?text=${Uri.encodeComponent(message)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Guest'),
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
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name of Guest',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the name' : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a valid mobile number' : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || !value.contains('@') ? 'Please enter a valid email address' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: numberOfGuestsController,
                  decoration: InputDecoration(
                    labelText: 'Number of Guests',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the number of guests' : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: numberOfDaysController,
                  decoration: InputDecoration(
                    labelText: 'Number of Days',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the number of days' : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: dateController,
                  readOnly: true,
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
                  validator: (value) => value == null ? 'Please select a guest type' : null,
                ),
                SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: generateQrCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF41C1BA),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Generate QR Pass'),
                  ),
                ),
                SizedBox(height: 24),

                if (qrData != null)
                  Center(
                    child: Column(
                      children: [
                        QrImageView(
                          data: qrData ?? '',
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: shareQrCode,
                    icon: Icon(Icons.share),
                    label: Text('Share QR Code'),
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