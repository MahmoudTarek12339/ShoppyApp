import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart'as http;
import 'package:path_provider/path_provider.dart';
class SizeService{
  Future<List<String?>> sendDataToPython({
    required File selectedImage,
    required File selectedImage2,
    required String category,
    required String height,
  })async{
    final request=http.MultipartRequest(
        'POST',Uri.parse('https://e346-197-62-232-82.ngrok.io/size_recommend'));
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
  Future<File> sendDataToVirtual({
    required String selectedImage,
    required String selectedImage2,
    required String category,
    required String category2,
    required int index,
  })async{
    late File image1;
    late File image2;
    await convLinkToFile(selectedImage,'1').then((value) {
      image1=value;
    });
    await convLinkToFile(selectedImage2,'2').then((value) {
      image2=value;
    });
    final request=http.MultipartRequest(
        'POST',Uri.parse('https://e346-197-62-232-82.ngrok.io/virtual'));
    final headers={"Content-type":"multipart/form-data"};
    request.files.add(
        http.MultipartFile('image1',
            image1.readAsBytes().asStream(), image1.lengthSync(),
            filename: image1.path.split('/').last)
    );
    request.files.add(
        http.MultipartFile('image2',
            image2.readAsBytes().asStream(), image2.lengthSync(),
            filename: image2.path.split('/').last)
    );
    request.fields.addAll({
      'category1':category,
      'category2':category2,
      'model_index':(index+1).toString(),
    });
    request.headers.addAll(headers);
    final response=await request.send().timeout(Duration(seconds: 30));
    late File file;
    await http.Response.fromStream(response).then((value) async{
      Uint8List int8lst=value.bodyBytes;
      var tempDir = await getTemporaryDirectory();
      file=File('${tempDir.path}/image.png');
      file.writeAsBytes(int8lst);
    });
    return file;
  }
  Future<File> convLinkToFile(String url,String index)async{
    final http.Response responseData = await http.get(Uri.parse(url));
    Uint8List uInt8list = responseData.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image'+index+'.png').create();
    file.writeAsBytesSync(uInt8list);
    return file;
  }
}