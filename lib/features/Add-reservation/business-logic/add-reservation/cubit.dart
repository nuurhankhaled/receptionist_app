import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:reservationapp_reseptionist/core/Api/endPoints.dart';
import 'package:reservationapp_reseptionist/core/Api/my_http.dart';
import 'package:reservationapp_reseptionist/core/utilies/easy_loading.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/data/models/available_time_model.dart';

part 'state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(AddReservationInitial());
  static const Duration timeoutDuration = Duration(seconds: 30);

  static ReservationCubit get(context) => BlocProvider.of(context);

//   Future<void> AddReservation({
//     required String name,
//     required String category_name,
//     required String itemId,
//     required String time,
//     required String paid,
//     required String additionalOptions,
//     required image,
//     required String timeOfReservationfrom,
//     required String timeOfReservationto,
//     required price,
//   }) async {
//     emit(AddReservationLoading());
//     showLoading();
//     String fileName = image.path.split('/').last;
//     FormData formData = FormData.fromMap({
//       "user_id": 15,
//       "category_name": category_name,
//       "item_id": itemId,
//       "package_id": 7,

//       "time": time,
//       "time_of_reservation_from": timeOfReservationfrom,
//       "time_of_reservation_to": timeOfReservationto,
//       "additional_options": additionalOptions,
// // "approve_of_payment":""
//       "document": await MultipartFile.fromFile(image.path, filename: fileName),
//       "price": price,

//       "paid": paid,

//       "marital_status": "married",
//       // "comment": "",
//       // "offer": ""
//     });

//     http.Response response;
//     try {
//       response = await MyHttp.post(
//         endPoint: EndPoints.addReservation,
//         data: formData,
//       );
//       print('Name: $name');
//       print('Response Status Code: ${response.statusCode}');
//       if (response.statusCode == 200) {
//         emit(AddReservationSuccess());
//       } else {
//         emit(AddReservationFailure());
//       }
//     } catch (e) {
//       print('Exception occurred: $e');
//       emit(AddReservationFailure());
//     }
//   }

  Future<void> AddReservation({
    required String userid,
    required String category_name,
    required String itemId,
    required String time,
    required String paid,
    required String additionalOptions,
    required image,
    required String timeOfReservationfrom,
    required String timeOfReservationto,
    required price,
  }) async {
    emit(AddReservationLoading());
    showLoading();

    String fileName = image.path.split('/').last;
    final mimeTypeData = lookupMimeType(fileName)!.split('/');
    try {
      final http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse("${EndPoints.baseUrl}${EndPoints.addReservation}"),
      );

      request.fields.addAll({
        "user_id": userid,
        "category_name": category_name,
        "item_id": itemId,
        "package_id": "7",
        "time": time,
        "time_of_reservation_from": timeOfReservationfrom,
        "time_of_reservation_to": timeOfReservationto,
        "additional_options": additionalOptions,
        "price": price,
        "paid": paid,
        "marital_status": "married",
      });

      final file = await http.MultipartFile.fromPath(
        'document',
        image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      );

      request.files.add(file);

      try {
        final response = await request.send();
        print('Response Status Code: ${response.statusCode}');

        if (response.statusCode == 200) {
          emit(AddReservationSuccess());
        } else {
          emit(AddReservationFailure());
        }
      } catch (e) {
        print('Exception occurred: $e');
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

  List<DataofTime> availabetime = [];

  Future<void> getAvailabletime({required id}) async {
    print("here");

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
          availabetime = jsonResponse.data!;
          print(availabetime[0].availableTimeFrom);
        } else {}
      } else {
        print(response.data);
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
