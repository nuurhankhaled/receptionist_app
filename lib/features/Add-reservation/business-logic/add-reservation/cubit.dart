import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservationapp_reseptionist/core/Api/my_http.dart';
import 'package:reservationapp_reseptionist/core/utilies/easy_loading.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/data/models/available_time_model.dart';
import 'package:reservationapp_reseptionist/features/View-users/data/models/acceptance-model.dart';

part 'state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(AddReservationInitial());
  static const Duration timeoutDuration = Duration(seconds: 30);

  static ReservationCubit get(context) => BlocProvider.of(context);

  Future<void> addReservation({
    required String userid,
    required String categoryName,
    required String itemId,
    required String time,
    required String paid,
    required String packageId,
    required String additionalOptions,
    required String materialStatue,
    required image,
    required approveOfPayment,
    required String timeOfReservationfrom,
    required String timeOfReservationto,
    required price,
  }) async {
    emit(AddReservationLoading());
    showLoading();
    print("واحد");
    try {
      String fileName = "";
      if (image != null) {
        fileName = image.path.split('/').last;
      }
      String approveOfPaymentName = "";
      if (approveOfPayment != null) {
        approveOfPaymentName = approveOfPayment.path.split('/').last;
      }
      print("اتنين");
      FormData formData = FormData.fromMap({
        "approve_of_payment": await MultipartFile.fromFile(
            approveOfPayment.path,
            filename: approveOfPaymentName),
        "user_id": userid,
        "category_name": categoryName,
        "item_id": itemId,
        "package_id": packageId,
        "time": time,
        "time_of_reservation_from": timeOfReservationfrom,
        "time_of_reservation_to": timeOfReservationto,
        "additional_options": additionalOptions,
        "price": price,
        "paid": paid,
        "marital_status": materialStatue,
      });
      print("الحقونا");

      if (fileName != "" || image != null) {
        formData.files.add(MapEntry(
          "document",
          await MultipartFile.fromFile(image.path, filename: fileName),
        ));
      }
      print("يالاهوووي");

      print("انا علي اخري");
      print(formData.fields);
      var response = await MyDio.post(
          endPoint: "/reservations/add_reservation.php", data: formData);
      print("2 انا علي اخري");

      print(response!.data);
      if (response.statusCode == 200) {
        var decodedData = json.decode(response.data);
        var jsonResponse = AcceptanceModel.fromJson(decodedData);

        if (jsonResponse.success == true) {
          hideLoading();
          showSuccess("تم تعديل المرفق بنجاح");
          emit(AddReservationSuccess());
        } else {
          showError("حدث خطأ ما");
          print(response.data);
          print(response.statusCode);
          hideLoading();
          emit(AddReservationFailure());
        }
      }

      showError("حدث خطأ ما");
      print("حدث خطأ ما");
      hideLoading();
      emit(AddReservationFailure());
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

  File? pickedApproveOfPaymentImage;

  pickApproveOfPaymentImage(ImageSource source, context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      pickedApproveOfPaymentImage = imageTemp;
      emit(PickImageSuccessState());
    } catch (e) {
      print("failed to pick image : $e");
      emit(PickImageErrorState(e.toString()));
    }
  }

  List<DataofTime> availabetime = [];

  Future<void> getItemAvailabletime({required id}) async {
    availabetime = [];
    print("here");
    emit(GetAvailableTimeReservationLoading());
    try {
      var response = await MyDio.post(
        endPoint: "/item/get_item_available_time.php",
        data: {
          "item_id": id,
        },
      );
      print("----------------------------------");
      print(response!.statusCode);
      if (response.statusCode == 200) {
        print(response.data);
        var decodedData = json.decode(response.data);
        var jsonResponse = AvailableTimeModel.fromJson(decodedData);
        print(jsonResponse.data![0].availableTimeFrom);
        if (jsonResponse.success!) {
          availabetime =
              jsonResponse.data!.where((item) => item.status == "0").toList();
          print(availabetime[0].availableTimeFrom);
          emit(GetAvailableTimeReservationSuccess());
        }
      } else {
        print(response.data);
        print(response.statusCode);
        emit(GetAvailableTimeReservationError());
      }
    } catch (e) {
      var response = await MyDio.post(
        endPoint: "/item/get_item_available_time.php",
        data: {
          "item_id": id,
        },
      );
      print("----------------------------------");
      print(response!.statusCode);
      if (response.statusCode == 200) {
        availabetime = [];
        print("fadyaaaa");
        emit(GetAvailableTimeReservationSuccess());
      } else {
        print(e);
        emit(GetAvailableTimeReservationError());
      }
    }
  }
}
