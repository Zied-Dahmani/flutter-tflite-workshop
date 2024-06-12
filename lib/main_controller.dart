import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:ml_workshop/classifier.dart';
import 'package:ml_workshop/floating_point_classifier.dart';
import 'package:ml_workshop/utils.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class MainController with ChangeNotifier {
  late Classifier _classifier;
  File? _image;
  Uint8List? _displayedImage;
  Category? _category;
  bool _isLoading = false;

  MainController() {
    _classifier = FloatingPointClassifier();
  }

  File? get image => _image;
  Uint8List? get displayedImage => _displayedImage;
  bool get isLoading => _isLoading;
  Category? get category => _category;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      isLoading = true;
      notifyListeners();
      _displayedImage = await Utils.removeImageBackground(pickedImage.path);
      _image = File(pickedImage.path);
      _category = _predict();
      isLoading = false;
      notifyListeners();
    }
  }

  Category _predict() {
    img.Image image = img.decodeImage(_image!.readAsBytesSync())!;
    return _classifier.predict(image);
  }
}