import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content.toString())));
}

// Future<File?> pickAudio() async {
//   try {
//     final filePickerRes = await FilePicker.platform.pickFiles(
//       type: FileType.audio,
//     );
//     if (filePickerRes != null) {
//       return File(filePickerRes!.files.first.xFile.path);
//     }
//     return null;
//   } catch (e) {
//     return null; // Handle the error gracefully
//   }
// }

// Future<File?> pickImage() async {
//   try {
//     final filePickerRes = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//     );
//     if (filePickerRes != null) {
//       return File(filePickerRes!.files.first.xFile.path);
//     }
//     return null;
//   } catch (e) {
//     return null; // Handle the error gracefully
//   }
// }

Future<File?> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (filePickerRes != null && filePickerRes.files.isNotEmpty) {
      final path = filePickerRes.files.first.path;
      if (path != null) {
        return File(path);
      }
    }
    return null;
  } catch (e) {
    return null; // Handle the error gracefully
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (filePickerRes != null && filePickerRes.files.isNotEmpty) {
      final path = filePickerRes.files.first.path;
      if (path != null) {
        return File(path);
      }
    }
    return null;
  } catch (e) {
    return null; // Handle the error gracefully
  }
}
