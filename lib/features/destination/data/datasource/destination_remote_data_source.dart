import 'dart:convert';

import 'package:course_travel/api/urls.dart';
import 'package:course_travel/core/error/execeptins.dart';
import 'package:course_travel/features/destination/data/models/destination_model.dart';
import 'package:http/http.dart' as http;


abstract class DestinationRemoteDataSource {
  Future<List<DestinationModel>> all();
  Future<List<DestinationModel>> top();
  Future<List<DestinationModel>> search(String query);
}

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  final http.Client client;

  DestinationRemoteDataSourceImpl(this.client);

  @override
  Future<List<DestinationModel>> all() async{
    Uri url = Uri.parse('${URls.base}/destination/all.php');
    final response = await client.get(url).timeout(Duration(seconds: 3),
    );
    if(response.statusCode==200){
     List list = jsonDecode(response.body);
     return list.map((e) => DestinationModel.fromJson(e)).toList();
    }else if(response.statusCode==404){
      throw NotFoundException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<DestinationModel>> search(String query) async{
    Uri url = Uri.parse('${URls.base}/destination/search.php');
    final response = await client.post(url, body: {
      'query': query,
    }).timeout(Duration(seconds: 3),
    );
    if(response.statusCode==200){
     List list = jsonDecode(response.body);
     return list.map((e) => DestinationModel.fromJson(e)).toList();
    }else if(response.statusCode==404){
      throw NotFoundException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<DestinationModel>> top() async{
   Uri url = Uri.parse('${URls.base}/destination/all.php');
    final response = await client.get(url).timeout(Duration(seconds: 3),
    );
    if(response.statusCode==200){
     List list = jsonDecode(response.body);
     return list.map((e) => DestinationModel.fromJson(e)).toList();
    }else if(response.statusCode==404){
      throw NotFoundException();
    }else{
      throw ServerException();
    }
  }
}
