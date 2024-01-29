part of 'item_package_cubit.dart';

@immutable
abstract class ItemPackageState {}

class ItemPackageInitial extends ItemPackageState {}
class ItemPackageLoading extends ItemPackageState {}
class ItemPackageLoaded extends ItemPackageState {}
class ItemPackageFailed extends ItemPackageState {}

