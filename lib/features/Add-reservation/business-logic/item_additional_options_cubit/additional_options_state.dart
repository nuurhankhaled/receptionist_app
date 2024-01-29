part of 'additional_options_cubit.dart';

abstract class ItemAdditionalOptionsState {}

class CategoryInitial extends ItemAdditionalOptionsState {}

class AddCategoryLoading extends ItemAdditionalOptionsState {}

class AddCategorySuccess extends ItemAdditionalOptionsState {}

class AddCategoryFailure extends ItemAdditionalOptionsState {}

class AddCategoryTimeOut extends ItemAdditionalOptionsState {}

class PickImageSuccessState extends ItemAdditionalOptionsState {}

class PickImageErrorState extends ItemAdditionalOptionsState {
  final String error;

  PickImageErrorState(this.error);
}

class UpdateImageLoading extends ItemAdditionalOptionsState {}

class UpdateImageSuccess extends ItemAdditionalOptionsState {}

class UpdateImageError extends ItemAdditionalOptionsState {}

class GetItemAdditionalOptionsLoading extends ItemAdditionalOptionsState {}

class GetItemAdditionalOptionsSuccess extends ItemAdditionalOptionsState {}

class GetItemAdditionalOptionsFailure extends ItemAdditionalOptionsState {}

class GetCategoriesTimeOut extends ItemAdditionalOptionsState {}
