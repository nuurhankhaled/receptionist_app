part of 'calender_cubit.dart';

abstract class CalenderState {}

class CategoryInitial extends CalenderState {}

class AddCategoryLoading extends CalenderState {}

class AddCategorySuccess extends CalenderState {}

class AddCategoryFailure extends CalenderState {}

class AddCategoryTimeOut extends CalenderState {}

class PickImageSuccessState extends CalenderState {}

class PickImageErrorState extends CalenderState {
  final String error;

  PickImageErrorState(this.error);
}

class UpdateImageLoading extends CalenderState {}

class UpdateImageSuccess extends CalenderState {}

class UpdateImageError extends CalenderState {}

class GetAvailableTimeLoading extends CalenderState {}

class GetAvailableTimeSuccess extends CalenderState {}

class GetAvailableTimeFailure extends CalenderState {}

class GetCategoriesTimeOut extends CalenderState {}
