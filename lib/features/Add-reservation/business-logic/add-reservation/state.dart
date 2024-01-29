part of 'cubit.dart';

sealed class ReservationState extends Equatable {
  const ReservationState();

  @override
  List<Object> get props => [];
}

//
final class AddReservationInitial extends ReservationState {}

final class AddReservationLoading extends ReservationState {}

final class AddReservationSuccess extends ReservationState {}

final class AddReservationFailure extends ReservationState {}

final class AddReservationTimeOut extends ReservationState {}

class PickImageSuccessState extends ReservationState {}

class PickImageErrorState extends ReservationState {
  final String error;
  PickImageErrorState(this.error);
}
