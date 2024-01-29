import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservationapp_reseptionist/core/Api/endPoints.dart';
import 'package:reservationapp_reseptionist/core/Api/my_http.dart';
import 'package:reservationapp_reseptionist/core/utilies/easy_loading.dart';
part 'state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(AddReservationInitial());
  static const Duration timeoutDuration = Duration(seconds: 30);

  static ReservationCubit get(context) => BlocProvider.of(context);

  Future<void> AddReservation({
    required String name,
    required String category_name,
    required String itemId,
    required String reservationTime,
    required String paid,
    required String additionalOptions,
    required image,
  }) async {
    emit(AddReservationLoading());
    showLoading();
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "document": await MultipartFile.fromFile(image.path, filename: fileName),
      "user_name": name,
      "category_name": category_name,
      "item_id": itemId,
      "time_of_reservation": reservationTime,
      "paid": paid,
      "additional_options": additionalOptions,
    });
    var response;
    try {
      response = await MyHttp.post(
        endPoint: EndPoints.addReservation,
        data: formData,
      );
      print('Name: $name');
      if (response != null) {
        print('Response Status Code: ${response.statusCode}');
        if (response.statusCode == 200) {
          emit(AddReservationSuccess());
        } else {
          emit(AddReservationFailure());
        }
      } else {
        // Handle null response
        print('Null response received');
        emit(AddReservationFailure());
      }
    } catch (e) {
      print('Exception occurred: $e');
      emit(AddReservationFailure());
    }
  }

  File? pickedImage;

  pickImage(ImageSource source, context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      pickedImage = imageTemp;
      emit(PickImageSuccessState());
    } catch (e) {
      print("failed to pick image : $e");
      emit(PickImageErrorState(e.toString()));
    }
  }
}
