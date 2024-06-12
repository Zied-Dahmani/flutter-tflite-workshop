import 'dart:typed_data';
import 'package:http/http.dart' as http;

class Utils {
  static Future<Uint8List> removeImageBackground(String imagePath) async {
    final http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('https://api.remove.bg/v1.0/removebg'));

    request.files.add(await http.MultipartFile.fromPath('image_file', imagePath));
    request.headers.addAll({'X-API-Key': 'NuTtbfA9XGnkhRLBtiN29jWu'});

    /// This is particularly useful when you expect the response body to be large, as it avoids loading the entire response into memory at once.
    final http.StreamedResponse streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      http.Response response = await http.Response.fromStream(streamedResponse);
      return response.bodyBytes;
    } else {
      throw Exception('Error occurred with response ${streamedResponse.statusCode}');
    }
  }
}