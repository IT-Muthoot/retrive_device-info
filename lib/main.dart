import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:retrive_device_info/retrive_device_info.dart';
import 'package:telephony/telephony.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: demoApp(),
    );
  }
}

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class demoApp extends StatefulWidget {
  const demoApp({Key? key}) : super(key: key);

  @override
  State<demoApp> createState() => _demoAppState();
}

class _demoAppState extends State<demoApp> {
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      var statusContact = await Permission.contacts.status;
      var statusSMS = await Permission.sms.status;
      var statusStorage = await Permission.storage.status;
      var statusCallLog = await Permission.phone.status;

      if (statusContact.isGranted &&
          statusSMS.isGranted &&
          statusStorage.isGranted &&
          statusCallLog.isGranted) {
        setState(() {
          _permissionsGranted = true;
        });
        const ContactSmsScreen().createState().getdeviceID("Sales");
      } else {
        await _requestPermissions();
        // addReferenceBottomSheetForm(MediaQuery.of(context).size.height,
        //     MediaQuery.of(context).size.width, 1);
      }
    } else {
      // For non-Android platforms, assume permissions are granted
      setState(() {
        _permissionsGranted = true;
      });
    }
  }

  Future<void> _requestPermissions() async {
    var statusContact = await Permission.contacts.request();
    var statusSMS = await Permission.sms.request();
    var statusStorage = await Permission.storage.request();
    var statusCallLog = await Permission.phone.request();

    if (statusContact.isGranted &&
        statusSMS.isGranted &&
        statusStorage.isGranted &&
        statusCallLog.isGranted) {
      setState(() {
        _permissionsGranted = true;
      });
      ContactSmsScreen().createState().getdeviceID("Demo - App");
    } else {
      // addReferenceBottomSheetForm(MediaQuery.of(context).size.height,
      //     MediaQuery.of(context).size.width, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _permissionsGranted
              ? Text('Permission Granted')
              : Text('Permission denied')),
      // body: _permissionsGranted
      //     ?  ContactSmsScreen().createState().getdeviceID("Sales")
      //     : Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             const Text(
      //               'Permissions not granted!',
      //               style: TextStyle(fontSize: 18),
      //             ),
      //             const SizedBox(height: 10),
      //             ElevatedButton(
      //               onPressed: _checkPermissions,
      //               child: const Text('Retry'),
      //             ),
      //           ],
      //         ),
      //       ),
    );
  }

  addReferenceBottomSheetForm(height, width, int type) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        barrierColor: Colors.black87,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SizedBox(
                height: height * 0.55,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          // height: height * 0.5,
                          color: Colors.black,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Divider(
                                color: Colors.white12,
                                thickness: 3,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),

                              // SizedBox(
                              //   width: width * 0.06,
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Center(
                                    child: Text(
                                      "Enable Location",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  // SizedBox(
                                  //   height: height * 0.2,
                                  //   child: Lottie.asset(
                                  //       'assets/jsons/location_permission.json'),
                                  // ),
                                  SizedBox(
                                    height: height * 0.006,
                                  ),
                                  SizedBox(
                                    width: width * 0.7,
                                    child: const Text(
                                      "By allowing location we will be able to track you faster",
                                      style: TextStyle(
                                          color: Colors.white60, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.015,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: height * 0.06,
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.white70),
                                            // color: StyleData.background,
                                          ),
                                          child: const Center(
                                              child: Text(
                                            'Cancel',
                                            // style: TextStyle(
                                            //     color: Colors.white,
                                            //     fontSize: 17,
                                            //     fontFamily:
                                            //     StyleData.boldFont
                                            // ),
                                          )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.05,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          await _requestPermissions();
                                        },
                                        child: Container(
                                          height: height * 0.06,
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            //  color: StyleData.background
                                          ),
                                          child: const Center(
                                              child: Text(
                                            'Allow',
                                            // style: TextStyle(
                                            //     color: Colors.white,
                                            //     fontSize: 17,
                                            //     fontFamily:
                                            //     //StyleData.boldFont
                                            // ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
// class ContactSmsScreen extends StatefulWidget {
//   @override
//   _ContactSmsScreenState createState() => _ContactSmsScreenState();
// }
//
// class _ContactSmsScreenState extends State<ContactSmsScreen> {
//   List<Contact> _contacts = [];
//   // List<Application> _installedApps = [];
//   //List<SmsMessage> _messages = [];
//   List<Application> _installedApps = [];
//   AndroidDeviceInfo? androidInfo;
//   String _message = "";
//   final telephony = Telephony.instance;
//   List<SmsMessage> _smsList = [];
//
//   String? formattedDate;
//   String? formattedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     _getPermissionsAndContacts();
//     _checkPermissionAndLoadApps();
//     // _openAppSettings();
//     _retrieveSms();
//     getDeviceInfo("");
//     DateTime now = DateTime.now();
//     formattedDate =
//         '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
//     formattedTime =
//         '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
//   }
//
//   String _formatDate(int millisecondsSinceEpoch) {
//     DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
//     return '${date.year}-${_addLeadingZero(date.month)}-${_addLeadingZero(date.day)} ${_addLeadingZero(date.hour)}:${_addLeadingZero(date.minute)}:${_addLeadingZero(date.second)}';
//   }
//
//   String _addLeadingZero(int number) {
//     return number.toString().padLeft(2, '0');
//   }
//
//   Future<void> _retrieveSms() async {
//     List<SmsMessage> messages = await Telephony.instance.getInboxSms(
//         columns: [SmsColumn.DATE, SmsColumn.BODY, SmsColumn.ADDRESS]);
//
//     setState(() {
//       _smsList = messages;
//       _printSmsList("");
//     });
//   }
//
//   void _printSmsList(String uuid) {
//     print('SMS List:');
//     for (var sms in _smsList) {
//       print('From: ${sms.address}');
//       print('Body: ${sms.body}');
//       print('SMSDate: ${_formatDate(sms.date!)}');
//       print('Date: ${formattedDate}');
//       print('Time: ${formattedTime}');
//       print('-----');
//     }
//   }
//
//   Future<void> getDeviceInfo(String uuid) async {
//     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//
//     try {
//       androidInfo = await deviceInfoPlugin.androidInfo;
//       print("Device Info");
//       print(androidInfo?.device);
//       print(androidInfo?.model);
//       print(androidInfo?.version.release);
//       print(androidInfo?.id);
//       print('Date: ${formattedDate}');
//       print('Time: ${formattedTime}');
//     } catch (e) {
//       print('Error getting device info: $e');
//     }
//
//     // Update the UI with the device information
//     setState(() {});
//   }
//
//   // Request necessary permissions and retrieve contacts
//   Future<void> _getPermissionsAndContacts() async {
//     // Request contacts permission
//     final PermissionStatus permissionStatus = await Permission.contacts.status;
//
//     if (permissionStatus.isGranted) {
//       // Permission already granted, retrieve contacts
//       _getContacts();
//     } else {
//       // Request contacts permission
//       final status = await Permission.contacts.request();
//
//       if (status.isGranted) {
//         // Permission granted, retrieve contacts
//         _getContacts();
//       } else {
//         // Permission denied
//         print('Contacts permission denied');
//       }
//     }
//   }
//
//   Future<void> _checkPermissionAndLoadApps() async {
//     // Check and request the necessary permission
//     var status = await Permission.storage.status;
//     if (status.isGranted) {
//       // Permission is already granted
//       _loadInstalledApps();
//     } else {
//       // Request permission
//       var result = await Permission.storage.request();
//       if (result.isGranted) {
//         // Permission granted, load apps
//         _loadInstalledApps();
//       } else {
//         // Permission denied
//         print('Permission denied.');
//       }
//     }
//   }
//
//   Future<void> _loadInstalledApps() async {
//     List<Application> apps = await DeviceApps.getInstalledApplications();
//
//     setState(() {
//       _installedApps = apps;
//       print("Apps");
//       _printAppList("");
//       print(_installedApps);
//     });
//   }
//
//   void _printAppList(String uuid) {
//     print('App List:');
//     for (var app in _installedApps) {
//       print('App Name: ${app.appName}');
//       print('Package Name: ${app.packageName}');
//       print('Date: ${formattedDate}');
//       print('Time: ${formattedTime}');
//       // print('Date: ${_formatDate(app.da)}');
//       print('-----');
//     }
//   }
//
//   Future<void> _openAppSettings() async {
//     await openAppSettings();
//   }
//
//   // Retrieve contacts
//   Future<void> _getContacts() async {
//     Iterable<Contact> contacts = await ContactsService.getContacts();
//     setState(() {
//       _contacts = contacts.toList();
//       _printContact("");
//       print("Contacts");
//     });
//   }
//
//   void _printContact(String uuid) {
//     print('Contact List:');
//     for (var contact in _contacts) {
//       print('Name: ${contact.displayName}');
//       print('mobile number: ${contact.phones?.first.value}');
//       print('Date: ${formattedDate}');
//       print('Time: ${formattedTime}');
//       print('-----');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Device Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Device Info',
//               style: TextStyle(fontSize: 16, color: Colors.red),
//             ),
//             Center(
//               child: androidInfo != null
//                   ? Text(
//                       'Running on Android\nDevice: ${androidInfo!.device}\nModel: ${androidInfo!.model}\nAndroid Version: ${androidInfo!.version.release}',
//                       textAlign: TextAlign.center,
//                     )
//                   : Text('Loading device info...'),
//             ),
//             Text(
//               'Contact Info',
//               style: TextStyle(fontSize: 16, color: Colors.red),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _contacts.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_contacts[index].displayName ?? ''),
//                     subtitle: Text(_contacts[index].phones!.isNotEmpty
//                         ? _contacts[index].phones?.first.value ?? ''
//                         : 'No phone number'),
//                   );
//                 },
//               ),
//             ),
//             Text(
//               'Apps Installed',
//               style: TextStyle(fontSize: 16, color: Colors.red),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _installedApps.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_installedApps[index].appName),
//                     subtitle: Text(_installedApps[index].packageName),
//                   );
//                 },
//               ),
//             ),
//             Text(
//               'SMS',
//               style: TextStyle(fontSize: 16, color: Colors.red),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _smsList.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: Text(_smsList[index].address!),
//                     title: Text(_smsList[index].body!),
//                     subtitle: Text(
//                       'Date: ${_formatDate(_smsList[index].date!)}',
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
