import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reservationapp_reseptionist/core/routing/args/resrvation_args.dart';
import 'package:reservationapp_reseptionist/core/routing/routes.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/add-reservation/cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/calender_cubit/calender_cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/item_additional_options_cubit/additional_options_cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/presentation/add-reservation.dart';
import 'package:reservationapp_reseptionist/features/Auth/business-logic/auth-cubit/login_cubit.dart';
import 'package:reservationapp_reseptionist/features/View-Additional-Options/business-logic/additional_options_cubit/additional_options_cubit.dart';
import 'package:reservationapp_reseptionist/features/View-Additional-Options/presentation/view-additional-options-screen.dart';
import 'package:reservationapp_reseptionist/features/View-Reservations/presentation/view-reservations.dart';
import 'package:reservationapp_reseptionist/features/View-Waiting-Reservations/business-logic/reservations_cubit/reservations_cubit.dart';
import 'package:reservationapp_reseptionist/features/View-Waiting-Reservations/presentation/view-waiting-reservations.dart';
import 'package:reservationapp_reseptionist/features/View-categories/business-logic/category_cubit/category_cubit.dart';
import 'package:reservationapp_reseptionist/features/View-categories/presentation/view-categories-screen.dart';
import 'package:reservationapp_reseptionist/features/View-category-details/business-logic/category_cubit/category_items_cubit.dart';
import 'package:reservationapp_reseptionist/features/View-category-details/presentation/view-category-details.dart';
import 'package:reservationapp_reseptionist/features/View-receptionist/business-logic/receptionist_cubit/receptionist_cubit.dart';
import 'package:reservationapp_reseptionist/features/View-receptionist/presentation/view-receptionist.dart';
import 'package:reservationapp_reseptionist/features/View-users/business-logic/accept-user/cubit.dart';
import 'package:reservationapp_reseptionist/features/View-users/business-logic/users_cubit/users_cubit.dart';
import 'package:reservationapp_reseptionist/features/View-users/presentation/view-user.dart';
import 'package:reservationapp_reseptionist/features/home/business-logic/cubit/mainlayout_cubit.dart';

import '../../features/Add-reservation/presentation/add_reservation.dart';
import '../../features/Auth/presentation/login-screen.dart';
import '../../features/home/presentation/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )

    switch (settings.name) {
      case Routes.authScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
          child: BlocProvider(
            create: (context) => AuthCubit(),
            child: AuthScreen(),
          ),
        );
      case Routes.viewWatiningReservationsScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
          child: BlocProvider(
            create: (context) => ReservationsCubit()..getReservations(),
            child: ViewWaitingReservationscreen(),
          ),
        );
      case Routes.addReservationScreen:
        final reservationsArgs = settings.arguments as ReservationArguments;
        return PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            settings: settings,
            child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => CategoryCubit()..getCategories(),
                  ),
                  BlocProvider(
                    create: (context) => CategoryItemsCubit(),
                  ),
                  BlocProvider(
                    create: (context) => ReservationCubit(),
                  ),
                  BlocProvider(create: (context) => CalenderCubit()),
                  BlocProvider(
                      create: (context) => ItemAdditionalOptionsCubit()),
                ],
                child: AddReservationScreen(
                  categoryName: reservationsArgs.categoryName,
                  itemId: reservationsArgs.itemId,
                )));

      case Routes.viewReceptionistScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
          child: BlocProvider(
            create: (context) => ReceptionistCubit()..getReceptionists(),
            child: ViewReceptionistScreen(),
          ),
        );

      case Routes.viewReservationsScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
          child: BlocProvider(
            create: (context) => ReservationsCubit()..getReservations(),
            child: ViewReservationscreen(),
          ),
        );

      case Routes.viewUsersScreen:
        final isAccepted = settings.arguments as int;
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
          child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => UsersCubit()
                    ..getAcceptedUsers()
                    ..getPendingUsers(),
                ),
                BlocProvider(
                  create: (context) => AcceptUserCubit(),
                ),
              ],
              child: ViewUsersScreen(
                isAccepted: isAccepted,
              )),
        );

      case Routes.viewCategoryDetailsScreen:
        final categoryName = settings.arguments as String;
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
          child: BlocProvider(
            create: (context) => CategoryItemsCubit(),
            child: ViewCategoryDetails(
              title: categoryName,
            ),
          ),
        );

      case Routes.mainlayout:
        return PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            settings: settings,
            child: BlocProvider(
              create: (context) => MainlayoutCubit(),
              child: Home(),
            ));

      case Routes.viewCategoriesScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
          child: ViewCategoriesScreen(),
        );

      case Routes.viewAdditionalOptionsScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
          child: BlocProvider(
            create: (context) =>
                AdditionalOptionsCubit()..getAllAdditionalOptions(),
            child: ViewAdditionalOptionsScreen(),
          ),
        );

      default:
        return PageTransition(
          child: Scaffold(
            body: Text("No route found for ${settings.name}"),
          ),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
        );
    }
  }
}
