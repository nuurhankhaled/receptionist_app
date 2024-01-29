import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservationapp_reseptionist/core/Api/my_http.dart';
import 'package:reservationapp_reseptionist/core/utilies/easy_loading.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/data/models/calender-model.dart';
import '../../../../Core/Api/endPoints.dart'; // Import the library that defines 'getCategories'.
import 'package:reservationapp_reseptionist/core/helpers/extensions.dart';
part 'calender_state.dart';

class CalenderCubit extends Cubit<CalenderState> {
  CalenderCubit() : super(CategoryInitial());

  static CalenderCubit get(context) => BlocProvider.of(context);
  static const Duration timeoutDuration = Duration(seconds: 30);
//getDayAvailableTime

  List availableTime = [];

  getDayAvailableTime({required id, required date}) async {
    emit(GetAvailableTimeLoading());
    try {
      var response =
          await MyDio.post(endPoint: EndPoints.getDayAvailableTime, data: {
        "item_id": id,
        "date": date,
      });
      print("-----------------  getCategories  -----------------");
      print(response!.statusCode);
      if (response!.statusCode == 200) {
        print(response.data);
        // var decodedData = json.decode(response.data);
        // var jsonResponse = CategoryModel.fromJson(response.data);
        if (true) {
          print("categories");
          print("-----------------    -----------------");

          String data = response.data;
          // String stringValue =
          //     data['available_time']; // Incorrect if 'someKey' should be a Map
          // Map<String, dynamic> mapValue = data[
          //     'available_time']; // Correct if 'someKey' is expected to be a Map
          print(data);
          var decodedData = json.decode(data);
          print(decodedData);
          //print(stringValue);
          // print(mapValue);
          print("-----------------    -----------------");
          var jsonResponse = CalenderModel.fromJson(decodedData);
          print(jsonResponse.availableTime);
          availableTime = jsonResponse.availableTime!;
          print(availableTime);
          emit(GetAvailableTimeSuccess());
        } else {
          print(response.data);
          print(response.statusCode);
          emit(GetAvailableTimeFailure());
        }
      } else {
        print(response.data);
        print(response.statusCode);
        emit(GetAvailableTimeFailure());
      }
    } catch (e) {
      print(e);
      emit(GetAvailableTimeFailure());
    }
  }
}
