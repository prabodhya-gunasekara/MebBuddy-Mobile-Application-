import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:medbuddy_mobile_app/screens/pillASchedule.dart';
import 'package:medbuddy_mobile_app/screens/pillBSchedule.dart';
import 'package:medbuddy_mobile_app/screens/pillCSchedule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  User? _user;
  String _userName = "User"; // Default name if not found
  String? existingDeviceId;
  String? existingDeviceName;
  List<Map<String, dynamic>> emergencyAlerts = [];

  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _fetchUserName();
      _fetchDeviceDetails();
    }
  }

  /// Fetch user's name from Firestore
  Future<void> _fetchUserName() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(_user!.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          _userName = userDoc["name"] ?? "User";
        });
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  /// Fetch user's existing device details
  void _fetchDeviceDetails() async {
    if (_user == null) return;

    DatabaseEvent event = await _dbRef.child("devices").orderByChild("userId").equalTo(_user!.uid).once();
    if (event.snapshot.value != null) {
      Map<String, dynamic> devices = Map<String, dynamic>.from(event.snapshot.value as Map);
      if (devices.isNotEmpty) {
        setState(() {
          existingDeviceId = devices.keys.first;
          existingDeviceName = devices[existingDeviceId]?["deviceName"];
        });
        _fetchSchedulesAndAlerts();
      }
    }
  }

  /// Fetch today's emergency alerts
  void _fetchSchedulesAndAlerts() async {
    if (existingDeviceId == null) return;

    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Fetch emergency alerts
    DatabaseEvent alertEvent = await _dbRef.child("devices/$existingDeviceId/emergencyAlerts").once();
    if (alertEvent.snapshot.value != null) {
      Map<String, dynamic> alerts = Map<String, dynamic>.from(alertEvent.snapshot.value as Map);
      setState(() {
        emergencyAlerts = alerts.values
            .where((alert) => alert["date"] == today)
            .map((alert) => alert as Map<String, dynamic>)
            .toList();
      });
    }
  }

  /// Show Add/Update Device Dialog
  void _showAddDeviceDialog() {
    _deviceIdController.text = existingDeviceId ?? "";
    _deviceNameController.text = existingDeviceName ?? "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingDeviceId != null ? "Update Device" : "Add Device"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _deviceNameController,
                decoration: const InputDecoration(labelText: "Device Name"),
              ),
              TextField(
                controller: _deviceIdController,
                decoration: const InputDecoration(labelText: "Device ID"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => _saveDevice(),
              child: Text(existingDeviceId != null ? "Update" : "Add"),
            ),
          ],
        );
      },
    );
  }

  /// Add or Update Device
  void _saveDevice() async {
    String userId = _user!.uid;
    String deviceId = _deviceIdController.text.trim();
    String deviceName = _deviceNameController.text.trim();

    if (deviceId.isEmpty || deviceName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter all fields!")));
      return;
    }

    DatabaseReference deviceRef = _dbRef.child("devices/$deviceId");

    await deviceRef.set({
      "deviceId": deviceId,
      "deviceName": deviceName,
      "userId": userId,
    }).then((_) {
      setState(() {
        existingDeviceId = deviceId;
        existingDeviceName = deviceName;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(existingDeviceId != null ? "Device updated successfully!" : "Device added successfully!"),
      ));

      _deviceNameController.clear();
      _deviceIdController.clear();
      Navigator.pop(context);
      _fetchSchedulesAndAlerts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MedBuddy")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _user?.photoURL != null
                        ? NetworkImage(_user!.photoURL!)
                        : const AssetImage("assets/images/account.png") as ImageProvider,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Welcome, $_userName",
                    style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),

            const Text("Schedule", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PillAScheduleScreen())),
              child: const Text("Schedule Pill A"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PillBScheduleScreen())),
              child: const Text("Schedule Pill B"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PillCScheduleScreen())),
              child: const Text("Schedule Pill C"),
            ),
            const SizedBox(height: 20),

            /// Emergency Alerts
            if (emergencyAlerts.isNotEmpty) ...[
              const Text("Emergency Alerts", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.red)),
              ...emergencyAlerts.map((alert) => ListTile(
                    title: Text("Time: ${alert['time']}"),
                    subtitle: Text(alert['message']),
                  )),
            ] else ...[
              const Text("No emergency alerts for today", style: TextStyle(fontSize: 18.0, color: Colors.green)),
            ],

            const Spacer(),
            ElevatedButton(
              onPressed: _showAddDeviceDialog,
              child: Text(existingDeviceId != null ? "Update Device" : "Add Device"),
            ),
          ],
        ),
      ),
    );
  }
}
