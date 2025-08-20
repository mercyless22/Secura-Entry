// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';  // For date formatting
// import 'package:qr_flutter/qr_flutter.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
//
// class BulkAddGuestScreen extends StatefulWidget {
//   @override
//   _BulkAddGuestScreenState createState() => _BulkAddGuestScreenState();
// }
//
// class _BulkAddGuestScreenState extends State<BulkAddGuestScreen> {
//
//   final _formKey = GlobalKey<FormState>();
//  // final TextEditingController _guestNameController = TextEditingController();
//  // final TextEditingController _contactController = TextEditingController();
//   final TextEditingController _numberOfGuestsController = TextEditingController();
//   final TextEditingController _noOfDaysController = TextEditingController();
//   final TextEditingController dateController = TextEditingController(); // Declare dateController here
//   String? _selectedWing;
//   String? _selectedFlatNo;
//   DateTime? _selectedDate;
//   String? _eventDetails;
//   String? qrData;
//
//   final String encryptionKey = "SecuraEntry@2025";
//
//   String encryptData(String plainText) {
//     final key = encrypt.Key.fromUtf8(encryptionKey.padRight(32, '0'));
//     final iv = encrypt.IV.fromLength(16);
//     final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//     return base64Encode(iv.bytes) + ":" + encrypted.base64;
//   }
//
//
//   // List for Wing and Flat No dropdowns
//   List<String> wings = ['A Wing', 'B Wing', 'C Wing'];
//   List<String> flatNos = ['101', '102', '103', '104'];
//
//   // Function to pick a date
//   Future<void> _pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//         dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate!); // Set the picked date in the date controller
//       });
//     }
//   }
//
//   // Function to simulate adding guests (either from file or manual entry)
//   // void _addGuests() {
//   //   print("Wing: $_selectedWing, Flat: $_selectedFlatNo");
//   //   print("Guest Name: ${_guestNameController.text}, Contact: ${_contactController.text}");
//   //   print("No of Guests: ${_numberOfGuestsController.text}, No of Days: ${_noOfDaysController.text}");
//   //   print("Event Details: $_eventDetails");
//   //   print("Date: ${_selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : 'Not selected'}");
//   // }
//
//   // void generateQrCode() {
//   //   if (_formKey.currentState!.validate()) {
//   //     setState(() {
//   //       qrData =
//   //         //  'Name: ${_guestNameController.text}\n'
//   //         //    'Mobile: ${_contactController.text}\n'
//   //           'Wing: $_selectedWing\n'
//   //           'Flat: {$_selectedFlatNo}\n'
//   //           'Guests: ${_numberOfGuestsController.text}\n'
//   //           'Days: ${_noOfDaysController.text}\n'
//   //           'Event Details : $_eventDetails\n'
//   //           'Date: ${_selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : 'Not selected'}\n';
//   //     });
//   //   }
//   // }
//   void generateQrCode() async {
//     if (_formKey.currentState!.validate()) {
//       String data =
//           // 'Name: ${nameController.text}\n'
//           // 'Mobile: ${mobileController.text}\n'
//           // 'Email: ${emailController.text}\n'
//           // 'Guests: ${numberOfGuestsController.text}\n'
//           // 'Days: ${numberOfDaysController.text}\n'
//           // 'Date: ${dateController.text}\n'
//           // 'Type: ${guestType ?? "Not Selected"}';
//                 'Wing: $_selectedWing\n'
//                 'Flat: {$_selectedFlatNo}\n'
//                 'Guests: ${_numberOfGuestsController.text}\n'
//                 'Days: ${_noOfDaysController.text}\n'
//                 'Event Details : $_eventDetails\n'
//                 'Date: ${_selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : 'Not selected'}\n';
//       setState(() {
//         qrData = encryptData(data);
//       });
//
//       await Future.delayed(Duration(seconds: 1));
//       shareQrOnWhatsApp();
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
//   Future<void> shareQrOnWhatsApp() async {
//     if (qrData == null) return;
//     String message = "Scan this QR Code: $qrData";
//     String url = "https://wa.me/?text=${Uri.encodeComponent(message)}";
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print("Could not launch WhatsApp");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Bulk Add Guest"),
//         centerTitle: true,
//         backgroundColor: Color(0xFF41C1BA),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // This will pop the current screen and show the previous screen
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Master Pass',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: _selectedWing,
//               hint: Text("Select Wing"),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedWing = newValue;
//                 });
//               },
//               items: wings.map((wing) {
//                 return DropdownMenuItem(
//                   value: wing,
//                   child: Text(wing),
//                 );
//               }).toList(),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Wing',
//               ),
//             ),
//             SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: _selectedFlatNo,
//               hint: Text("Select Flat No"),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedFlatNo = newValue;
//                 });
//               },
//               items: flatNos.map((flatNo) {
//                 return DropdownMenuItem(
//                   value: flatNo,
//                   child: Text(flatNo),
//                 );
//               }).toList(),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Flat No',
//               ),
//             ),
//
//             SizedBox(height: 16),
//             TextField(
//               controller: _numberOfGuestsController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "No. of Guests",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _noOfDaysController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "No. of Days",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: dateController, // Using the dateController here
//               readOnly: true, // Prevents manual input
//               decoration: InputDecoration(
//                 labelText: 'Date of Arrival (DD-MM-YYYY)',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.calendar_today, color: Color(0xFF41C1BA)),
//                   onPressed: _pickDate,
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 16),
//             TextField(
//               onChanged: (text) {
//                 setState(() {
//                   _eventDetails = text;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: "Event Details",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 child: Text(
//                   "Generate Master Pass",
//                   style: TextStyle(
//                     color: Colors.white, // Text color set to white
//                     fontSize: 17, // Increase the font size as needed
//                   ),
//                 ),
//                 onPressed: generateQrCode,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF41C1BA),
//                   foregroundColor: Colors.white, // Text color set to white
//                 ),
//               ),
//             ),
//
//
//             // if (qrData != null)
//             //   Center(
//             //     child: SizedBox(
//             //       width: 200,
//             //       height: 200,
//             //       child: QrImageView(
//             //         data: qrData ?? '', // Ensure this is not null
//             //         version: QrVersions.auto,
//             //         size: 200.0,
//             //         backgroundColor: Colors.white,
//             //       ),
//             //     ),
//             //   ),
//             Center(
//               child: Column(
//                 children: [
//                   QrImageView(
//                     data: qrData ?? '',
//                     version: QrVersions.auto,
//                     size: 200.0,
//                     backgroundColor: Colors.white,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: shareQrCode,
//                 icon: Icon(Icons.share),
//                 label: Text('Share QR Code'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class BulkAddGuestScreen extends StatefulWidget {
  @override
  _BulkAddGuestScreenState createState() => _BulkAddGuestScreenState();
}

class _BulkAddGuestScreenState extends State<BulkAddGuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberOfGuestsController = TextEditingController();
  final TextEditingController _noOfDaysController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? _selectedWing;
  String? _selectedFlatNo;
  DateTime? _selectedDate;
  String? _eventDetails;
  String? qrData;

  final String encryptionKey = "SecuraEntry@2025";

  String encryptData(String plainText) {
    final key = encrypt.Key.fromUtf8(encryptionKey.padRight(32, '0'));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return base64Encode(iv.bytes) + ":" + encrypted.base64;
  }

  List<String> wings = ['A Wing', 'B Wing', 'C Wing'];
  List<String> flatNos = ['101', '102', '103', '104'];

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate!);
      });
    }
  }

  Future<void> generateQrCode() async {
    if (_formKey.currentState!.validate()) {
      String data =
          'Wing: $_selectedWing\n'
          'Flat: $_selectedFlatNo\n'
          'Guests: ${_numberOfGuestsController.text}\n'
          'Days: ${_noOfDaysController.text}\n'
          'Event Details: $_eventDetails\n'
          'Date: ${_selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : 'Not selected'}';

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
        title: Text("Bulk Add Guest"),
        centerTitle: true,
        backgroundColor: Color(0xFF41C1BA),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Master Pass', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedWing,
                hint: Text("Select Wing"),
                onChanged: (String? newValue) => setState(() => _selectedWing = newValue),
                items: wings.map((wing) => DropdownMenuItem(value: wing, child: Text(wing))).toList(),
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Wing'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFlatNo,
                hint: Text("Select Flat No"),
                onChanged: (String? newValue) => setState(() => _selectedFlatNo = newValue),
                items: flatNos.map((flatNo) => DropdownMenuItem(value: flatNo, child: Text(flatNo))).toList(),
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Flat No'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _numberOfGuestsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "No. of Guests", border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _noOfDaysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "No. of Days", border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Arrival (DD-MM-YYYY)',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(icon: Icon(Icons.calendar_today, color: Color(0xFF41C1BA)), onPressed: _pickDate),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                onChanged: (text) => setState(() => _eventDetails = text),
                decoration: InputDecoration(labelText: "Event Details", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  child: Text("Generate Master Pass"),
                  onPressed: generateQrCode,
                ),
              ),
              SizedBox(height: 20),
              if (qrData != null)
                Center(
                  child: QrImageView(
                    data: qrData!,
                    version: QrVersions.auto,
                    size: 200.0,
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
    );
  }
}
