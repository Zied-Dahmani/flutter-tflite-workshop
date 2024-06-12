import 'dart:math';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:collection/collection.dart';

abstract class Classifier {
  late final Interpreter _interpreter;
  late final InterpreterOptions _interpreterOptions;
  late final List<int> _inputShape;
  late final List<int> _outputShape;
  late final TfLiteType _inputType;
  late final TfLiteType _outputType;
  late TensorBuffer _outputBuffer;
  late final _probabilityProcessor;
  late TensorImage _inputImage;
  late List<String> _labels;

  String get modelName;

  NormalizeOp get preProcessNormalizeOp;

  NormalizeOp get postProcessNormalizeOp;

  Classifier({int? threads}) {
    _interpreterOptions = InterpreterOptions();

    /// Threads are CPU resources that the interpreter uses to process inference tasks
    if (threads != null) {
      _interpreterOptions.threads = threads;
    }
    _loadModel();
    _loadLabels();
  }

  Future<void> _loadModel() async {
    try {
      /// Loading the TensorFlow Lite interpreter with a machine learning model from the app's assets, including configurable options like thread settings
      _interpreter = await Interpreter.fromAsset(modelName, options: _interpreterOptions);

      /// Input Shape and Type: Ensure the input data is correctly formatted and typed before feeding it to the model
      /// Output Shape and Type: Ensure the output data is correctly interpreted and processed after inference
      _inputShape = _interpreter.getInputTensor(0).shape;
      _outputShape = _interpreter.getOutputTensor(0).shape;
      _inputType = _interpreter.getInputTensor(0).type;
      _outputType = _interpreter.getOutputTensor(0).type;


      /// A buffer (a region of memory allocated to store data) to hold the model's output data
      _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
      /// Set up a processor to apply post-processing operations, such as normalization, to the raw output before interpretation
      _probabilityProcessor = TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    } catch (e) {
      print('Error loading model: ${e.toString()}');
    }
  }

  Future<void> _loadLabels() async {
    try {
      _labels = await FileUtil.loadLabels('assets/labels.txt');
    } catch (e) {
      print('Error loading labels: ${e.toString()}');
    }
  }

  /// This function resizes and preprocesses the input image to match the expected dimensions and normalization requirements specified by the model for inference.
  TensorImage _preProcess() {
    int cropSize = min(_inputImage.height, _inputImage.width);
    return ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(_inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

  /// This function preprocesses an image, performs inference using a TF Lite interpreter, and returns the category with the highest probability.
  Category predict(image) {
    _inputImage = TensorImage(_inputType);
    _inputImage.loadImage(image);
    _inputImage = _preProcess();

    _interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());

    Map<String, double> labeledProb = TensorLabel.fromList(_labels, _probabilityProcessor.process(_outputBuffer)).getMapWithFloatValue();

    final topProbability = _getTopProbability(labeledProb);

    return Category(topProbability.key, topProbability.value);
  }

  /// Function to get the highest probability label from the predictions
  MapEntry<String, double> _getTopProbability(Map<String, double> labeledProb) {
    var pq = PriorityQueue<MapEntry<String, double>>(_compare);
    pq.addAll(labeledProb.entries);

    return pq.first;
  }

  /// Comparison function for sorting the probabilities in descending order
  int _compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
    return e2.value.compareTo(e1.value);
  }

  /// Close the interpreter and release resources
  void close() {
    _interpreter.close();
  }
}