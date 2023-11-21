import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

// pick image from gallery
dynamic pickGalleryImage(String type) async {
  final ImagePicker picker = ImagePicker();
  // Pick an image.
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    // return image as String in base64
    if (type == 'base64') {
      Uint8List fileBytes = await pickedFile.readAsBytes();
      String base64Image = base64Encode(fileBytes);
      File imagePath = File(pickedFile.path);
      String fileName = basename(imagePath.path);
      Map<String, String> fileDetails = {
        "fileName": fileName,
        "imageUri": base64Image
      };
      return fileDetails;
    }
    // return image uri
    if (type == 'uri') {
      File imagePath = File(pickedFile.path);
      String fileName = basename(imagePath.path);
      String imageUri = imagePath.uri.toString();
      Map<String, String> fileDetails = {
        "fileName": fileName,
        "imageUri": imageUri
      };
      print(fileDetails);
      return fileDetails;
    }
  }
}

// take picture using camera
dynamic pickCameraImage(String type) async {
  final ImagePicker picker = ImagePicker();
  // Pick an image.
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    // return image as String in base64
    if (type == 'base64') {
      Uint8List fileBytes = await pickedFile.readAsBytes();
      String base64Image = base64Encode(fileBytes);
      File imagePath = File(pickedFile.path);
      String fileName = basename(imagePath.path);
      Map<String, String> fileDetails = {
        "fileName": fileName,
        "base64": base64Image
      };
      print(fileDetails);
      return fileDetails;
    }
    // return image uri
    if (type == 'uri') {
      File imagePath = File(pickedFile.path);
      String fileName = basename(imagePath.path);
      String imageUri = imagePath.uri.toString();
      Map<String, String> fileDetails = {
        "fileName": fileName,
        "imageUri": imageUri
      };
      print(fileDetails);
      return fileDetails;
    }
  }
}

dynamic pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    print(File);
    return file;
  }
}
