// import 'package:flutter/material.dart';
//
// class AddUserScreen extends StatefulWidget {
//   @override
//   _AddUserScreenState createState() => _AddUserScreenState();
// }
//
// class _AddUserScreenState extends State<AddUserScreen> {
//   final TextEditingController _ownerNameController = TextEditingController();
//   final TextEditingController _mobileNoController = TextEditingController();
//   final TextEditingController _alternateMobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//
//   String? _selectedWing;
//   String? _selectedFlatNo;
//
//   final List<String> _wings = ['A', 'B', 'C'];
//   final List<String> _flatNos = ['101', '102', '201', '202'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add New User"),
//         backgroundColor: Color(0xFF41C1BA),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Enter User Information:",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//
//               // Owner Name
//               TextField(
//                 controller: _ownerNameController,
//                 decoration: InputDecoration(
//                   labelText: "Owner Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 10),
//
//               // Wing Dropdown
//               DropdownButtonFormField<String>(
//                 value: _selectedWing,
//                 decoration: InputDecoration(
//                   labelText: "Wing",
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedWing = newValue;
//                   });
//                 },
//                 items: _wings.map((wing) {
//                   return DropdownMenuItem<String>(
//                     value: wing,
//                     child: Text(wing),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 10),
//
//               // Flat Number Dropdown
//               DropdownButtonFormField<String>(
//                 value: _selectedFlatNo,
//                 decoration: InputDecoration(
//                   labelText: "Flat No.",
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedFlatNo = newValue;
//                   });
//                 },
//                 items: _flatNos.map((flatNo) {
//                   return DropdownMenuItem<String>(
//                     value: flatNo,
//                     child: Text(flatNo),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 10),
//
//               // Mobile Number
//               TextField(
//                 controller: _mobileNoController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: "Mobile No.",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 10),
//
//               // Alternate Mobile Number
//               TextField(
//                 controller: _alternateMobileController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: "Alternate Mobile No.",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 10),
//
//               // Email
//               TextField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               // Centered Add User Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Logic to add user
//                     String ownerName = _ownerNameController.text;
//                     String mobileNo = _mobileNoController.text;
//                     String alternateMobile = _alternateMobileController.text;
//                     String email = _emailController.text;
//
//                     if (ownerName.isNotEmpty && mobileNo.isNotEmpty && alternateMobile.isNotEmpty && email.isNotEmpty && _selectedWing != null && _selectedFlatNo != null) {
//                       // Add the user to the list or database (print as a placeholder)
//                       print("User added: $ownerName, Wing: $_selectedWing, Flat: $_selectedFlatNo, Mobile: $mobileNo, Alt. Mobile: $alternateMobile, Email: $email");
//                       Navigator.pop(context); // Go back to the ManageUsersScreen
//                     } else {
//                       // Show a message if some fields are missing
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Please fill in all fields")),
//                       );
//                     }
//                   },
//                   child: Text("Add User"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF41C1BA),
//                     textStyle: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _alternateMobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedWing;
  String? _selectedFlatNo;

  final List<String> _wings = ['A', 'B', 'C'];
  final List<String> _flatNos = ['101', '102', '201', '202'];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(); // Ensure Firebase is initialized
  }

  Future<void> _addUser() async {
    String ownerName = _ownerNameController.text.trim();
    String mobileNo = _mobileNoController.text.trim();
    String alternateMobile = _alternateMobileController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (ownerName.isEmpty || mobileNo.isEmpty || email.isEmpty || password.isEmpty || _selectedWing == null || _selectedFlatNo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid; // Get User ID

      // Store user details in Firestore
      await _firestore.collection('users').doc(uid).set({
        'ownerName': ownerName,
        'wing': _selectedWing,
        'flatNo': _selectedFlatNo,
        'mobileNo': mobileNo,
        'alternateMobile': alternateMobile,
        'email': email,
        'role': 'resident', // Default role
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User added successfully!")),
      );

      Navigator.pop(context); // Go back
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New User"),
        backgroundColor: Color(0xFF41C1BA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter User Information:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              TextField(controller: _ownerNameController, decoration: InputDecoration(labelText: "Owner Name", border: OutlineInputBorder())),
              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _selectedWing,
                decoration: InputDecoration(labelText: "Wing", border: OutlineInputBorder()),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedWing = newValue;
                  });
                },
                items: _wings.map((wing) => DropdownMenuItem<String>(value: wing, child: Text(wing))).toList(),
              ),
              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _selectedFlatNo,
                decoration: InputDecoration(labelText: "Flat No.", border: OutlineInputBorder()),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFlatNo = newValue;
                  });
                },
                items: _flatNos.map((flatNo) => DropdownMenuItem<String>(value: flatNo, child: Text(flatNo))).toList(),
              ),
              SizedBox(height: 10),

              TextField(controller: _mobileNoController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "Mobile No.", border: OutlineInputBorder())),
              SizedBox(height: 10),

              TextField(controller: _alternateMobileController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "Alternate Mobile No.", border: OutlineInputBorder())),
              SizedBox(height: 10),

              TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder())),
              SizedBox(height: 10),

              // Password Field for Firebase Authentication
              TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder())),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _addUser,
                  child: Text("Add User"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF41C1BA),
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
