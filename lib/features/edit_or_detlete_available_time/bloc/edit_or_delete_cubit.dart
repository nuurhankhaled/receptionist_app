import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservationapp_reseptionist/core/Api/endPoints.dart';
import 'package:reservationapp_reseptionist/core/Api/my_http.dart';
import 'package:reservationapp_reseptionist/core/utilies/easy_loading.dart';
import 'package:reservationapp_reseptionist/features/edit_or_detlete_available_time/model/available_time_model.dart';

part 'edit_or_delete_states.dart';

class EditOrDeleteAvailableCubit extends Cubit<EditOrDeleteStates> {
  EditOrDeleteAvailableCubit() : super(UsersInitial());

  static EditOrDeleteAvailableCubit get(context) => BlocProvider.of(context);
  static const Duration timeoutDuration = Duration(seconds: 30);

  List<Data> allAvailableTimes = [];

  Future<void> getallAvailable() async {
    emit(GetALLAvailableLoading());
    try {
      var response =
          await MyDio.get(endPoint: "/item/get_all_available_time.php");
      print(response!.statusCode);
      if (response.statusCode == 200) {
        print(response.data);
        var decodedData = json.decode(response.data);
        var jsonResponse = AvailableTimeModel.fromJson(decodedData);
        allAvailableTimes = jsonResponse.data!;
        print(allAvailableTimes);
        if (jsonResponse.success!) {
          print(allAvailableTimes);
          emit(GetALLAvailableSuccess());
        } else {
          print(response.data);
          print(response.statusCode);
          emit(GetALLAvailableFailure());
        }
      } else {
        print(response.data);
        print(response.statusCode);
        emit(GetALLAvailableFailure());
      }
    } catch (e) {
      print(e);
      emit(GetALLAvailableFailure());
    }
  }

  Future<void> delete({required String id, context}) async {
    emit(DeleteALLAvailableLoading());
    showLoading();
    try {
      var response =
          await MyDio.post(endPoint: "/item/delete_available_time.php", data: {
        'id': id,
      });
      print(response!);
      var data = response.data;
      print(data);
      var decodedData = json.decode(response.data);
      var jsonResponse = AvailableTimeModel.fromJson(decodedData);
      if (jsonResponse.success == true) {
        showSuccess("تم مسح المستخدم بنجاح");
        await getallAvailable();
        emit(DeleteALLAvailableSuccess());
      } else {
        showError("حدث خطأ ما");
        emit(DeleteALLAvailableFailure());
      }
    } catch (e) {
      print(e.toString());
      showError("حدث خطأ ما");
      emit(DeleteALLAvailableFailure());
    }
  }

  Future<void> edit(
      {required String id,
      required from,
      required to,
      required date,
      required price,
      required status,
      context}) async {
    emit(EditAvailableLoading());
    showLoading();
    try {
      var response = await MyDio.post(endPoint: EndPoints.editTime, data: {
        "id": id,
        "available_time_from": from,
        "available_time_to": to,
        "date": date,
        "price": price,
        "status": status,
      });
      print(response!);
      var data = response.data;
      print(data);
      var decodedData = json.decode(response.data);
      var jsonResponse = AvailableTimeModel.fromJson(decodedData);
      if (jsonResponse.success == true) {
        showSuccess("تم التعديل بنجاح");
        emit(EditAvailableSuccess());
      } else {
        showError("حدث خطأ ما");
        emit(EditAvailableFailure());
      }
    } catch (e) {
      print(e.toString());
      showError("حدث خطأ ما");
      emit(EditAvailableFailure());
    }
  }
}
