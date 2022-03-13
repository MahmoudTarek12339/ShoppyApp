import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart'as http;
class SizeService{
  Future<List<String?>> sendDataToPython({
    required File selectedImage,
    required File selectedImage2,
    required String category,
    required String height,
  })async{
    final request=http.MultipartRequest(
        'POST',Uri.parse('https://f255-197-62-16-213.ngrok.io/upload'));
    final headers={"Content-type":"multipart/form-data"};
    request.files.add(
      http.MultipartFile('image',
          selectedImage.readAsBytes().asStream(), selectedImage.lengthSync(),
          filename: category+'_'+selectedImage.path.split('/').last)
    );
    request.files.add(
        http.MultipartFile('imageSide',
            selectedImage2.readAsBytes().asStream(), selectedImage2.lengthSync(),
            filename: height+'_'+selectedImage2.path.split('/').last)
    );
    request.headers.addAll(headers);
    final response=await request.send().timeout(Duration(seconds: 30));
    http.Response res=await http.Response.fromStream(response);
    final resJson=jsonDecode(res.body);
    List<String?> lst=resJson['size'].cast<String?>();
    return lst;
  }
}