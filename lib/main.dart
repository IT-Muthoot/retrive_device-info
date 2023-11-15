import 'package:contacts_service/contacts_service.dart';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

import 'demo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: demoApp(),
    );
  }
}

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class ContactSmsScreen extends StatefulWidget {
  @override
  _ContactSmsScreenState createState() => _ContactSmsScreenState();
}

class _ContactSmsScreenState extends State<ContactSmsScreen> {
  List<Contact> _contacts = [];
  // List<Application> _installedApps = [];
  //List<SmsMessage> _messages = [];
  List<Application> _installedApps = [];
  AndroidDeviceInfo? androidInfo;
  String _message = "";
  final telephony = Telephony.instance;
  List<SmsMessage> _smsList = [];

  @override
  void initState() {
    super.initState();
    _getPermissionsAndContacts();
    _checkPermissionAndLoadApps();
    // _openAppSettings();
    _retrieveSms();
    getDeviceInfo();
  }

  String _formatDate(int millisecondsSinceEpoch) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return '${date.year}-${_addLeadingZero(date.month)}-${_addLeadingZero(date.day)} ${_addLeadingZero(date.hour)}:${_addLeadingZero(date.minute)}:${_addLeadingZero(date.second)}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<void> _retrieveSms() async {
    List<SmsMessage> messages = await Telephony.instance.getInboxSms(
        columns: [SmsColumn.DATE, SmsColumn.BODY, SmsColumn.ADDRESS]);

    setState(() {
      _smsList = messages;
      _printSmsList();
    });
  }

  void _printSmsList() {
    print('SMS List:');
    for (var sms in _smsList) {
      print('From: ${sms.address}');
      print('Body: ${sms.body}');
      print('Date: ${_formatDate(sms.date!)}');
      print('-----');
    }
  }

  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      androidInfo = await deviceInfoPlugin.androidInfo;
      print("Device Info");
      print(androidInfo?.device);
      print(androidInfo?.model);
      print(androidInfo?.version.release);
    } catch (e) {
      print('Error getting device info: $e');
    }

    // Update the UI with the device information
    setState(() {});
  }

  // Request necessary permissions and retrieve contacts
  Future<void> _getPermissionsAndContacts() async {
    // Request contacts permission
    final PermissionStatus permissionStatus = await Permission.contacts.status;

    if (permissionStatus.isGranted) {
      // Permission already granted, retrieve contacts
      _getContacts();
    } else {
      // Request contacts permission
      final status = await Permission.contacts.request();

      if (status.isGranted) {
        // Permission granted, retrieve contacts
        _getContacts();
      } else {
        // Permission denied
        print('Contacts permission denied');
      }
    }
  }

  Future<void> _checkPermissionAndLoadApps() async {
    // Check and request the necessary permission
    var status = await Permission.storage.status;
    if (status.isGranted) {
      // Permission is already granted
      _loadInstalledApps();
    } else {
      // Request permission
      var result = await Permission.storage.request();
      if (result.isGranted) {
        // Permission granted, load apps
        _loadInstalledApps();
      } else {
        // Permission denied
        print('Permission denied.');
      }
    }
  }

  Future<void> _loadInstalledApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications();

    setState(() {
      _installedApps = apps;
      print("Apps");
      _printAppList();
      print(_installedApps);
    });
  }

  void _printAppList() {
    print('App List:');
    for (var app in _installedApps) {
      print('App Name: ${app.appName}');
      print('Package Name: ${app.packageName}');
      // print('Date: ${_formatDate(app.da)}');
      print('-----');
    }
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  // Retrieve contacts
  Future<void> _getContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
      _printContact();
      print("Contacts");
    });
  }

  void _printContact() {
    print('Contact List:');
    for (var contact in _contacts) {
      print('Name: ${contact.displayName}');
      print('mobile number: ${contact.phones?.first.value}');
      // print('Date: ${_formatDate(sms.date)}');
      print('-----');
    }
  }
  //
  // // Retrieve SMS messages
  // Future<void> _getMessages() async {
  //   List<SmsMessage> messages = await SmsQuery().querySms(
  //     kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent],
  //   );
  //   setState(() {
  //     _messages = messages;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Info',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            Center(
              child: androidInfo != null
                  ? Text(
                      'Running on Android\nDevice: ${androidInfo!.device}\nModel: ${androidInfo!.model}\nAndroid Version: ${androidInfo!.version.release}',
                      textAlign: TextAlign.center,
                    )
                  : Text('Loading device info...'),
            ),
            Text(
              'Contact Info',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_contacts[index].displayName ?? ''),
                    subtitle: Text(_contacts[index].phones!.isNotEmpty
                        ? _contacts[index].phones?.first.value ?? ''
                        : 'No phone number'),
                  );
                },
              ),
            ),
            Text(
              'Apps Installed',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _installedApps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_installedApps[index].appName),
                    subtitle: Text(_installedApps[index].packageName),
                  );
                },
              ),
            ),
            Text(
              'SMS',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _smsList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(_smsList[index].address!),
                    title: Text(_smsList[index].body!),
                    subtitle: Text(
                      'Date: ${_formatDate(_smsList[index].date!)}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
