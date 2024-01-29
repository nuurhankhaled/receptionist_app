import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservationapp_reseptionist/core/Api/endPoints.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/data/models/item_package_model.dart';
import '../../../../core/Api/my_http.dart';
import '../../../View-Additional-Options/data/models/additional-options-model.dart';


part 'item_package_state.dart';

class ItemPackageCubit extends Cubit<ItemPackageState> {
  ItemPackageCubit() : super(ItemPackageInitial());

  static ItemPackageCubit get(context) => BlocProvider.of(context);
  List<dynamic> availabilityData=[];
  Future<void> getIemPackage(String itemId) async{
    emit(ItemPackageLoading());
    try{
      var response = await MyHttp.post(endPoint: EndPoints.itemPackage, data: {
        'item_id': itemId,
      });
      print(itemId);

      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = itemPackage.fromJson(jsonDecode(response.body));
        availabilityData = jsonResponse.data!;
        print(availabilityData);
        emit(ItemPackageLoaded());
      } else {
        emit(ItemPackageFailed());
      }

    }catch(e){
      emit(ItemPackageFailed());
      print(e.toString());
    }
  }


}
