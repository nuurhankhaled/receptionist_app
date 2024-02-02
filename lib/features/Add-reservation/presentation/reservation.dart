import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:reservationapp_reseptionist/core/helpers/extensions.dart';
import 'package:reservationapp_reseptionist/core/utilies/easy_loading.dart';
import 'package:reservationapp_reseptionist/core/widgets/custom_button.dart';
import 'package:reservationapp_reseptionist/core/widgets/custom_text_form_field.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/add-reservation/cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/calender_cubit/calender_cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/item_additional_options_cubit/additional_options_cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/data/models/items-additional-options-model.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationScreen extends StatefulWidget {
  ReservationScreen({
    super.key,
    required this.categoryName,
    required this.itemId,
  });
  String categoryName;
  String itemId;
  List<Data>? item;
  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  List<bool> checkedItems = List.generate(4, (index) => false);
  final List<String> _statues = ["متزوج", "اعزب"];
  String? statue;
  String? jsonString;
  File? pickedDocument;
  File? pickedApproveOfPayment;
  TextEditingController timeinputFrom = TextEditingController();
  TextEditingController timeinputTo = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController paiedController = TextEditingController();
  late TextEditingController totalMoneyController = TextEditingController();
  late TextEditingController offerController = TextEditingController();
  late TextEditingController commentController = TextEditingController();
  int? salary = 0;
  int selectedTimeIndex = -1;
  late String selectedPackageid;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> selectedItems = [];
  List<String> selectedItemsPrice = [];
  List<Map<String, dynamic>> itemList = [];

  String? formattedDate;
  @override
  void initState() {
    super.initState();
    print("___________________---------------------");
    print(widget.itemId);
    ItemAdditionalOptionsCubit.get(context)
        .getItemAdditionalOptions(id: widget.itemId);
    ReservationCubit.get(context).getItemAvailabletime(id: widget.itemId);
  }

  bool isPhoneNumeric(String str) {
    // Check if the string contains only numeric characters using a regular expression
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }

  @override
  Widget build(BuildContext context) {
    print("yalaaaaahwwy");
    print(widget.categoryName);
    print(widget.itemId);
    print("yallllaaaaaaaaahwy");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_work_sharp),
            SizedBox(
              width: 10.w,
            ),
            const Text("اضافه حجز جديد",
                style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
          ],
        ),
      ),
      body:
          BlocConsumer<ItemAdditionalOptionsCubit, ItemAdditionalOptionsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var addOp = ItemAdditionalOptionsCubit.get(context);
          return BlocConsumer<ReservationCubit, ReservationState>(
            listener: (context, state) {
              if (state is AddReservationSuccess) {
                hideLoading();
                context.pop();
              }
              if (state is AddReservationFailure) {
                showError("حدث خطأ ما");
              }
            },
            builder: (context, state) {
              var addReservationCubit = ReservationCubit.get(context);
              return BlocConsumer<CalenderCubit, CalenderState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  var calenderCubit = CalenderCubit.get(context);
                  return SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Adjust vertical alignment
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50.h,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.w, vertical: 20.h),
                                      child: const Text(
                                        "القسيمه اذا كان متزوج",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          width: 300.w,
                                          height: 280.h,
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  spreadRadius: -1,
                                                  blurRadius: 5)
                                            ],
                                            shape: BoxShape.circle,
                                            color: Colors.deepPurple.shade50,
                                            image: addReservationCubit
                                                        .pickedImage !=
                                                    null
                                                ? DecorationImage(
                                                    image: FileImage(
                                                        addReservationCubit
                                                            .pickedImage!),
                                                    fit: BoxFit.contain,
                                                  )
                                                : const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/loggo.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 220.3.h,
                                                left: 47.w,
                                                right: 47.w),
                                            child: Container(
                                                width: 80.w,
                                                height: 94.7.h,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 7.w,
                                                        color: Colors.white)),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.camera_alt_rounded,
                                                    size: 30.w,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    addReservationCubit
                                                        .pickImage(
                                                            ImageSource.gallery,
                                                            context);
                                                    setState(() {
                                                      pickedDocument =
                                                          addReservationCubit
                                                              .pickedImage;
                                                    });
                                                  },
                                                ))),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.w, vertical: 20.h),
                                      child: const Text(
                                        "تأكيد الدفع",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          width: 300.w,
                                          height: 280.h,
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  spreadRadius: -1,
                                                  blurRadius: 5)
                                            ],
                                            shape: BoxShape.circle,
                                            color: Colors.deepPurple.shade50,
                                            image: addReservationCubit
                                                        .pickedApproveOfPaymentImage !=
                                                    null
                                                ? DecorationImage(
                                                    image: FileImage(
                                                        addReservationCubit
                                                            .pickedApproveOfPaymentImage!),
                                                    fit: BoxFit.contain,
                                                  )
                                                : const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/loggo.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 220.3.h,
                                                left: 47.w,
                                                right: 47.w),
                                            child: Container(
                                                width: 80.w,
                                                height: 94.7.h,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 7.w,
                                                        color: Colors.white)),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.camera_alt_rounded,
                                                    size: 30.w,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    addReservationCubit
                                                        .pickApproveOfPaymentImage(
                                                            ImageSource.gallery,
                                                            context);
                                                    setState(() {
                                                      pickedApproveOfPayment =
                                                          addReservationCubit
                                                              .pickedApproveOfPaymentImage;
                                                    });
                                                  },
                                                ))),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 100.w),
                                          child: const Text(
                                            "لمعرفه الاوقات المتاحه و اختيار يوم الحجز اضغط هنا",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.calendar_today,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TableCalendar(
                                                        calendarFormat:
                                                            _calendarFormat,
                                                        startingDayOfWeek:
                                                            StartingDayOfWeek
                                                                .sunday,
                                                        focusedDay:
                                                            _selectedDate,
                                                        firstDay: DateTime(
                                                            DateTime.now()
                                                                .year),
                                                        lastDay: DateTime(
                                                            DateTime.now()
                                                                    .year +
                                                                1),
                                                        selectedDayPredicate:
                                                            (date) {
                                                          return isSameDay(
                                                              _selectedDate,
                                                              date);
                                                        },
                                                        onDaySelected:
                                                            (date, events) {
                                                          print(date);
                                                          if (date.isAfter(DateTime
                                                                  .now()
                                                              .subtract(
                                                                  const Duration(
                                                                      days:
                                                                          1)))) {
                                                            setState(() {
                                                              _selectedDate =
                                                                  date;
                                                            });

                                                            formattedDate = DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(
                                                                    _selectedDate);
                                                            print(
                                                                "&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                                            print(
                                                                formattedDate);
                                                            print(
                                                                "&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                                            calenderCubit
                                                                .getDayAvailableTime(
                                                                    date:
                                                                        formattedDate,
                                                                    id: widget
                                                                        .itemId);
                                                            context.pop();
                                                          } else {
                                                            // Show a message for past or current date
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return const AlertDialog(
                                                                  content: Text(
                                                                      "لا يمكن اختيار تاريخ قد مضي"),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        calendarStyle:
                                                            const CalendarStyle(
                                                          // weekendTextStyle: TextStyle(color: Colors.red),
                                                          selectedTextStyle:
                                                              TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                          selectedDecoration:
                                                              BoxDecoration(
                                                            color: Colors.blue,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          // markersColor: Colors.green,
                                                        ),
                                                        headerStyle:
                                                            const HeaderStyle(
                                                          formatButtonVisible:
                                                              true,
                                                          titleCentered: true,
                                                          titleTextStyle:
                                                              TextStyle(
                                                                  fontSize: 20),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        if (formattedDate != null)
                                          Text(
                                              "التاريخ المختار هو : ${formattedDate!}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Color.fromARGB(
                                                      255, 6, 103, 182))),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 70.w, vertical: 20.h),
                                          child: Container(
                                            margin: EdgeInsetsDirectional.only(
                                                end: 2.w),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 1.h),
                                            height: 80.h,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.sp)),
                                            child: Center(
                                              child: DropdownButtonFormField(
                                                menuMaxHeight: 700.h,
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                                hint: const Text(
                                                  "اختر الحاله",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                items: List.generate(
                                                  _statues.length,
                                                  (index) {
                                                    return DropdownMenuItem<
                                                            int>(
                                                        value: index,
                                                        child: SizedBox(
                                                          width: 130.w,
                                                          child: Text(
                                                              _statues[index]),
                                                        ));
                                                  },
                                                ),
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    statue = _statues[value!];
                                                  });
                                                  print('statue : $statue');
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50.w),
                                              child: const Text(
                                                "رقم الهاتف",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 70.w,
                                                  vertical: 20.h),
                                              child: SizedBox(
                                                width: 220,
                                                child: CustomTextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'هذا الحقل مطلوب';
                                                    }
                                                    if (!isPhoneNumeric(
                                                        value)) {
                                                      return 'من فضلك ادخل رقم هاتف صحيح';
                                                    }
                                                    if (value.length < 10 ||
                                                        value.length > 15) {
                                                      return 'رقم الهاتف يجب ان يكون بين 11 الي 15 رقم';
                                                    }
                                                    return null;
                                                  },
                                                  controller: nameController,
                                                  padding: EdgeInsets.only(
                                                      bottom: 22.h,
                                                      left: 10.w,
                                                      right: 10.w),
                                                  height: 70.h,
                                                ),
                                              ),
                                            ),
                                            // باقي تفاصيل الحجز
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 70.w),
                                              child: const Text(
                                                "القيمه المدفوعه",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 70.w,
                                                  vertical: 20.h),
                                              child: SizedBox(
                                                width: 220,
                                                child: CustomTextFormField(
                                                  controller: paiedController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'هذا الحقل مطلوب';
                                                    }
                                                    try {
                                                      double.parse(value);
                                                      return null; // Return null if the input is a valid integer
                                                    } catch (e) {
                                                      return 'من فضلك ادخل رقم صحيح'; // Error message for invalid input
                                                    }
                                                  },
                                                  padding: EdgeInsets.only(
                                                      bottom: 22.h,
                                                      left: 10.w,
                                                      right: 10.w),
                                                  height: 70.h,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 70.w),
                                              child: const Text(
                                                "عروض",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 70.w,
                                                  vertical: 20.h),
                                              child: SizedBox(
                                                width: 220,
                                                child: CustomTextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'هذا الحقل مطلوب';
                                                    }
                                                    return null;
                                                  },
                                                  controller: offerController,
                                                  padding: EdgeInsets.only(
                                                      bottom: 22.h,
                                                      left: 10.w,
                                                      right: 10.w),
                                                  height: 70.h,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 70.w),
                                              child: const Text(
                                                "قيمه الحجز الكلي",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 70.w,
                                                  vertical: 20.h),
                                              child: SizedBox(
                                                width: 220,
                                                child: CustomTextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'هذا الحقل مطلوب';
                                                    }
                                                    try {
                                                      double.parse(value);
                                                      return null; // Return null if the input is a valid integer
                                                    } catch (e) {
                                                      return 'من فضلك ادخل رقم صحيح'; // Error message for invalid input
                                                    }
                                                  },
                                                  controller:
                                                      totalMoneyController,
                                                  padding: EdgeInsets.only(
                                                      bottom: 22.h,
                                                      left: 10.w,
                                                      right: 10.w),
                                                  height: 70.h,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 70.w),
                                              child: const Text(
                                                "تعليقات",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 70.w,
                                                  vertical: 20.h),
                                              child: SizedBox(
                                                width: 220,
                                                child: CustomTextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'هذا الحقل مطلوب';
                                                    }
                                                    return null;
                                                  },
                                                  controller: commentController,
                                                  padding: EdgeInsets.only(
                                                      bottom: 22.h,
                                                      left: 10.w,
                                                      right: 10.w),
                                                  height: 70.h,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        SizedBox(
                                          height: 500,
                                          width: 300,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 20),
                                                  child: Text(
                                                    "اختر من المواعيد المتاحه ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                (addReservationCubit
                                                        .availabetime.isEmpty)
                                                    ? const Text(
                                                        "لا توجد مواعيد متاحة")
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            addReservationCubit
                                                                .availabetime
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var availableTime = (formattedDate !=
                                                                  null)
                                                              ? addReservationCubit
                                                                  .availabetime
                                                                  .where((item) =>
                                                                      item.date ==
                                                                      formattedDate)
                                                                  .toList()
                                                              : addReservationCubit
                                                                  .availabetime;

                                                          if (availableTime
                                                              .isEmpty) {
                                                            return const Text(
                                                                "لا توجد مواعيد متاحة في هذا التاريخ");
                                                          }

                                                          return RadioListTile(
                                                            title: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                        "التاريخ  :  "),
                                                                    Text(availableTime[
                                                                            index]
                                                                        .date!),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                        "السعر :"),
                                                                    Text(availableTime[
                                                                            index]
                                                                        .price!),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        const Text(
                                                                            "من :"),
                                                                        Text(availableTime[index]
                                                                            .availableTimeFrom!),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Row(
                                                                      children: [
                                                                        const Text(
                                                                            "الي :"),
                                                                        Text(availableTime[index]
                                                                            .availableTimeTo!),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            value: index,
                                                            groupValue:
                                                                selectedTimeIndex,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedPackageid =
                                                                    availableTime[
                                                                            index]
                                                                        .id!;
                                                                print(
                                                                    "a7eeeeeeeeeeeeeehhhh");
                                                                print(
                                                                    selectedPackageid);
                                                                print(
                                                                    "))))))*******************");
                                                                print(
                                                                    selectedTimeIndex);
                                                                selectedTimeIndex =
                                                                    value!;
                                                              });
                                                            },
                                                          );
                                                        },
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        // if (addOp.additionalOptions.isNotEmpty)
                                        SizedBox(
                                          width: 450.w,
                                          height: 500,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 100.w,
                                                    vertical: 15),
                                                child: const Text(
                                                  "الاضافات",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              (addOp.additionalOptions.isEmpty)
                                                  ? const Text("لا توجد اضافات")
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        alignment:
                                                            AlignmentDirectional
                                                                .topStart,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: addOp
                                                              .additionalOptions
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            var option = addOp
                                                                    .additionalOptions[
                                                                index];
                                                            var itemName =
                                                                option.name
                                                                    .toString();
                                                            var itemPrice =
                                                                option.price
                                                                    .toString();

                                                            return CheckboxListTile(
                                                              title: Text(
                                                                'السعر : $itemPrice , $itemName ',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,

                                                                  // fontSize: 20.sp,
                                                                ),
                                                              ),
                                                              value: selectedItems
                                                                  .contains(
                                                                      itemName),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  if (value ==
                                                                      true) {
                                                                    selectedItems
                                                                        .add(
                                                                            itemName);
                                                                    selectedItemsPrice
                                                                        .add(
                                                                            itemPrice);
                                                                  } else {
                                                                    selectedItems
                                                                        .remove(
                                                                            itemName);
                                                                    selectedItemsPrice
                                                                        .add(
                                                                            itemPrice);
                                                                  }
                                                                });
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            CustomButton(
                                width: 200,
                                text: "اضافه الحجز",
                                onPressed: () {
                                  if (formKey.currentState != null) {
                                    if (formKey.currentState!.validate() ||
                                        addReservationCubit
                                                .pickedApproveOfPaymentImage !=
                                            null ||
                                        statue != null ||
                                        selectedPackageid.isNotEmpty ||
                                        selectedTimeIndex != -1 ||
                                        selectedItems.isNotEmpty ||
                                        selectedItemsPrice.isNotEmpty) {
                                      if (selectedItems.isNotEmpty &&
                                          selectedItemsPrice.isNotEmpty) {
                                        for (int i = 0;
                                            i < selectedItems.length;
                                            i++) {
                                          Map<String, dynamic> item = {
                                            'name': selectedItems[i],
                                            'price': selectedItemsPrice[i],
                                          };
                                          itemList.add(item);
                                        }

                                        jsonString = jsonEncode(itemList);
                                        print(jsonString);
                                      }
                                      addReservationCubit.addReservation(
                                          userid: nameController.text,
                                          categoryName: widget.categoryName,
                                          itemId: widget.itemId,
                                          time: DateTime.now().toString(),
                                          paid: paiedController.text,
                                          additionalOptions: jsonString ??
                                              "لا يوجد اضافات",
                                          image: addReservationCubit
                                              .pickedImage,
                                          timeOfReservationfrom:
                                              addReservationCubit
                                                  .availabetime[
                                                      selectedTimeIndex]
                                                  .availableTimeFrom!,
                                          timeOfReservationto:
                                              addReservationCubit
                                                  .availabetime[
                                                      selectedTimeIndex]
                                                  .availableTimeTo!,
                                          price: totalMoneyController.text,
                                          packageId: selectedPackageid,
                                          materialStatue: statue!,
                                          approveOfPayment: addReservationCubit
                                              .pickedApproveOfPaymentImage);
                                    } else {
                                      showError("من فضلك املئ البيانات");
                                    }
                                    //      addReservationCubit.AddReservation(
                                    // userid: nameController.text,
                                    // category_name: widget.categoryName,
                                    // itemId: widget.itemId,
                                    // time: DateTime.now().toString(),
                                    // paid: paiedController.text,
                                    // additionalOptions: additionalOptions,
                                    // image: image,
                                    // timeOfReservationfrom: "12:00:00",
                                    // timeOfReservationto: "12:00:00",
                                    // price: totalMoneyController.text,
                                    // packageId: selectedPackageid,
                                    // materialStatue: '',
                                    // approveOfPayment: null);
                                  } else {
                                    showError("من فضلك املئ البيانات");
                                  }
                                }),
                            SizedBox(
                              height: 50.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
