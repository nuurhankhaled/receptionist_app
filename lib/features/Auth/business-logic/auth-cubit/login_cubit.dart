import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservationapp_reseptionist/core/Api/endPoints.dart';
import 'package:reservationapp_reseptionist/core/Api/my_http.dart';
import 'package:reservationapp_reseptionist/core/utilies/easy_loading.dart';
import 'package:reservationapp_reseptionist/features/Auth/data/models/user-model.dart';
part 'login_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);
  bool ispasswordshow = true;
  IconData suffixicon = Icons.visibility_off;

  void showLoginpassword() {
    ispasswordshow = !ispasswordshow;
    suffixicon = ispasswordshow ? Icons.visibility : Icons.visibility_off;
    emit(PasswordIconChangestate());
  }

  UserModel? userModel;

  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    showLoading();
    var data = {
      'email': email,
      'password': password,
    };
    try {
      var response = await MyDio.post(
        endPoint: EndPoints.login,
        data: data,
      );
      print(response!.statusCode);
      if (response!.statusCode == 200) {
        var decodedData = json.decode(response.data);
        var jsonResponse = UserModel.fromJson(decodedData);
        print(response.data);

        if (jsonResponse.success!) {
          if (jsonResponse.userData!.type == "B3") {
            userModel = jsonResponse;
            hideLoading();
            emit(LoginSuccessState());
          } else {
            showError("حدث خطا");
            emit(LoginErrorState());
          }
        } else {
          showError("حدث خطا");
          emit(LoginErrorState());
        }
      } else {
        showError("حدث خطا");
        emit(LoginErrorState());
      }
    } catch (e) {
      showError("حدث خطا");
      print(e.toString());
      emit(LoginErrorState());
    }
  }
}
