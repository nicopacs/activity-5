import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imageFile;
  @override
  void initState() {
    super.initState();
    storagePermission();
  }

  /// PICK IMAGE FROM LOCAL STORAGE
  void pickImage() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 600);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// PERMISSION FUNCTIONS
  void openPermissionSettings() async {
    openAppSettings();
  }

  void storagePermission() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      showPermissionGranted();
    } else if (status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        showGranted();
      }
    }
  }


  /// SNACK BAR
  showPermissionGranted() {
    const snackBar = SnackBar(
      content: Text('Successfully Granted Permission!'),
      backgroundColor: Colors.teal,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showGranted() {
    const snackBar = SnackBar(
      content: Text('Permission was Granted!'),
      backgroundColor: Colors.teal,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permission Handler - Image Picker',
          style: TextStyle(fontSize: 15),
        ),
      ),
      floatingActionButton: SpeedDial(
        elevation: 15,
        icon: Icons.settings_suggest,
        children: [

          SpeedDialChild(
            child: const Icon(Icons.settings_applications),
            label: 'Open Permission Settings',
            onTap: openPermissionSettings,
          ),
        ],
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                child: imageFile == null
                    ? const Align(
                        child: CircleAvatar(
                          radius: 1,
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    : Image.file(imageFile!, fit: BoxFit.cover),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                        pickImage();
                    },
                    child: const Text(
                      'Choose Image',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
