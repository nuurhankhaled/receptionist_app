import 'package:reservationapp_reseptionist/core/helpers/extensions.dart';
import 'package:reservationapp_reseptionist/core/routing/routes.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/add-reservation/cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/presentation/add-reservation.dart';
import 'package:reservationapp_reseptionist/features/Dashboard/presentation/dashboard-screen.dart';
import 'package:reservationapp_reseptionist/features/View-Additional-Options/business-logic/additional_options_cubit/additional_options_cubit.dart';
import 'package:reservationapp_reseptionist/features/View-categories/business-logic/category_cubit/category_cubit.dart';
import 'package:reservationapp_reseptionist/features/View-category-details/business-logic/category_cubit/category_items_cubit.dart';
import 'package:reservationapp_reseptionist/features/home/business-logic/cubit/mainlayout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainlayoutCubit, MainlayoutState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var mainlayoutCubit = MainlayoutCubit.get(context);
        return AdminScaffold(
          appBar: AppBar(title: Text("reservationApp".tr())),
          sideBar: SideBar(
            items: [
              AdminMenuItem(
                title: 'dashboard'.tr(),
                route: '/dashboard',
                icon: Icons.dashboard,
              ),
              AdminMenuItem(
                icon: Icons.receipt,
                title: 'عرض الاضافات',
                route: "/viewExtras",
              ),
            ],
            selectedRoute: "/dashboard",
            onSelected: (item) {
              if (item.route != null) {
                mainlayoutCubit.changeSelectedItem(item.route!);
                print(mainlayoutCubit.selectedItem);
                switch (item.route) {
                  case "/addItem":
                    context.pushNamed(Routes.addItemScren);
                    break;
                  case "/viewExtras":
                    context.pushNamed(Routes.viewAdditionalOptionsScreen);
                    break;
                  default:
                    print('Route not handled: ${item.route}');
                    break;
                }
              }
            },
            header: Container(
                height: 90.h,
                width: double.infinity,
                color: const Color(0xff444444),
                child: Center(
                  child: Text("details".tr(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )),
            footer: Container(
              height: 90.h,
              width: double.infinity,
              color: const Color(0xff444444),
              child: Center(
                  child: Text(
                "signOut".tr(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                DashBoardScreen(),
              ],
            ),
          )),
        );
      },
    );
  }
}
