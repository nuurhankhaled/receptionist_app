import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservationapp_reseptionist/core/Api/my_http.dart';
import 'package:reservationapp_reseptionist/core/utilies/easy_loading.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/data/models/items-additional-options-model.dart';
import '../../../../Core/Api/endPoints.dart'; // Import the library that defines 'getCategories'.
import 'package:reservationapp_reseptionist/core/helpers/extensions.dart';
part 'additional_options_state.dart';

class ItemAdditionalOptionsCubit extends Cubit<ItemAdditionalOptionsState> {
  ItemAdditionalOptionsCubit() : super(CategoryInitial());

  static ItemAdditionalOptionsCubit get(context) => BlocProvider.of(context);
  static const Duration timeoutDuration = Duration(seconds: 30);

  List<Data> additionalOptions = [];

  getItemAdditionalOptions({
    required id,
  }) async {
    emit(GetItemAdditionalOptionsLoading());
    try {
      var response =
          await MyDio.post(endPoint: EndPoints.getItemAdditionalOptions, data: {
        "item_id": id,
      });
      print("----------------------------------");
      print(response!.statusCode);
      if (response!.statusCode == 200) {
        print(response.data);
        var decodedData = json.decode(response.data);
        var jsonResponse = ItemAdditionalOptionsModel.fromJson(decodedData);
        print(jsonResponse.data![0].name);
        if (jsonResponse.success!) {
          additionalOptions = jsonResponse.data!;
          print("(((((((((((((((((((((((((((())))))))))))))))))))))))))))");
          print(additionalOptions[0].name);
          print("(((((((((((((((((((((((((((())))))))))))))))))))))))))))");
          emit(GetItemAdditionalOptionsSuccess());
        } else {
          print(response.data);
          print(response.statusCode);
          emit(GetItemAdditionalOptionsFailure());
        }
      } else {
        print(response.data);
        print(response.statusCode);
        emit(GetItemAdditionalOptionsFailure());
      }
    } catch (e) {
      print(e);
      emit(GetItemAdditionalOptionsFailure());
    }
  }



}
