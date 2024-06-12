import 'package:ml_workshop/classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class FloatingPointClassifier extends Classifier {
  FloatingPointClassifier({super.threads});

  @override
  String get modelName => 'model_unquant.tflite';

  /// Normalizes input images (pixel values) from the [0, 255] range to [-1, 1] before feeding into the model.
  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(127.5, 127.5);

  /// Keeps the model's output unchanged (identity operation) after inference.
  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);
}

/*
class QuantClassifier extends Classifier {
  QuantClassifier({int numThreads: 1}) : super(numThreads: numThreads);

  @override
  String get modelName => 'mobilenet_v1_1.0_224_quant.tflite';

  /// Leaves the input values unchanged. This is used when the model expects input values in the [0, 1] range without further scaling.
  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1);

  /// Scales output values to the [0, 255] range, used for quantized models.
  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 255);
}*/