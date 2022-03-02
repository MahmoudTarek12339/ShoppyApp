import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart'as http;
class SizeService{

  Future<String> sendDataToPython({
    required File selectedImage,
    required File selectedImage2,
    required String category,
    required String height,
  })async{
    final request=http.MultipartRequest(
        'POST',Uri.parse('http://10.0.2.2:4000/api'));
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
    final response=await request.send();
    http.Response res=await http.Response.fromStream(response);
    final resJson=jsonDecode(res.body);
    String message=resJson['message'];
    return message;
  }
}