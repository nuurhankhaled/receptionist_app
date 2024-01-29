import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservationapp_reseptionist/core/helpers/extensions.dart';
import 'package:reservationapp_reseptionist/core/utilies/easy_loading.dart';
import 'package:reservationapp_reseptionist/core/widgets/custom_loading_indecator.dart';
import 'package:reservationapp_reseptionist/core/widgets/custom_text_form_field.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/add-reservation/cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/calender_cubit/calender_cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/business-logic/item_additional_options_cubit/additional_options_cubit.dart';
import 'package:reservationapp_reseptionist/features/Add-reservation/data/models/items-additional-options-model.dart';
import 'package:table_calendar/table_calendar.dart';

class AddReservationScreen extends StatefulWidget {
  AddReservationScreen({
    super.key,
    required this.categoryName,
    required this.itemId,
  });
  String categoryName;
  String itemId;
  List<Data>? item;
  @override
  State<AddReservationScreen> createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4"];
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, double> _reservationPercentages = {};
  List<bool> checkedItems = List.generate(4, (index) => false);
  File? pickedImage;
  TextEditingController timeinputFrom = TextEditingController();
  TextEditingController timeinputTo = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  List<String> selectedItems = [];
  String? formattedDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("___________________---------------------");
    print(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    ItemAdditionalOptionsCubit.get(context)
        .getItemAdditionalOptions(id: widget.itemId);
    ReservationCubit.get(context).getAvailabletime(id: widget.itemId);
    print(widget.categoryName);
    print(widget.itemId);
    return BlocConsumer<ItemAdditionalOptionsCubit, ItemAdditionalOptionsState>(
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
              hideLoading();
            }
          },
          builder: (context, state) {
            var addReservationCubit = ReservationCubit.get(context);
            return PopScope(
              canPop: false,
              child: BlocConsumer<CalenderCubit, CalenderState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  var calenderCubit = CalenderCubit.get(context);
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
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 45, vertical: 10),
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
                                          horizontal: 70.w, vertical: 20.h),
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
                                                    pickedImage =
                                                        addReservationCubit
                                                            .pickedImage;
                                                  },
                                                ))),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 70.w, vertical: 20.h),
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
                                                    pickedImage =
                                                        addReservationCubit
                                                            .pickedImage;
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
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 100.w),
                                                  child: const Text(
                                                    "لمعرفه الاوقات المتاحه و اختيار يوم الحجز اضغط هنا",
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                      builder: (context) =>
                                                          Dialog(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
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
                                                                    (date,
                                                                        events) {
                                                                  print(date);
                                                                  if (date.isAfter(DateTime
                                                                          .now()
                                                                      .subtract(
                                                                          const Duration(
                                                                              days: 1)))) {
                                                                    setState(
                                                                        () {
                                                                      _selectedDate =
                                                                          date;
                                                                    });

                                                                    formattedDate = DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(
                                                                            _selectedDate);

                                                                    print(
                                                                        formattedDate);
                                                                    calenderCubit.getDayAvailableTime(
                                                                        date:
                                                                            formattedDate,
                                                                        id: widget
                                                                            .itemId);
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                'Free Times on ${_selectedDate.toString().split(' ')[0]}',
                                                                              ),
                                                                              const SizedBox(height: 8),
                                                                              SizedBox(
                                                                                height: 480,
                                                                                width: 200,
                                                                                child: ListView.builder(
                                                                                  itemCount: calenderCubit.availableTime.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    if (index < calenderCubit.availableTime.length) {
                                                                                      print(calenderCubit.availableTime[index].toString());
                                                                                      return (state is GetAvailableTimeLoading)
                                                                                          ? const CustomLoadingIndicator()
                                                                                          : ListTile(
                                                                                              title: Text(" متاح الساعه  :${calenderCubit.availableTime[index]}"),
                                                                                              // ... other code
                                                                                            );
                                                                                    } else {
                                                                                      // Handle the case when the index is out of bounds
                                                                                      return const SizedBox.shrink(); // or another widget
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              )
                                                                              // _buildFreeTimes(),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  } else {
                                                                    // Show a message for past or current date
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return const AlertDialog(
                                                                          content:
                                                                              Text("Cannot select a past or current date."),
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
                                                                          color:
                                                                              Colors.white),
                                                                  selectedDecoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  // markersColor: Colors.green,
                                                                ),
                                                                headerStyle:
                                                                    const HeaderStyle(
                                                                  formatButtonVisible:
                                                                      true,
                                                                  titleCentered:
                                                                      true,
                                                                  titleTextStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                ),
                                                              ),
                                                              // SizedBox(height: 16),
                                                              // Text(
                                                              //   'Free Times on ${_selectedDate.toString().split(' ')[0]}',
                                                              //   style: TextStyle(
                                                              //     fontSize: 16,
                                                              //     fontWeight: FontWeight.bold,
                                                              //   ),
                                                              // ),
                                                              // SizedBox(height: 8),
                                                              // _buildFreeTimes(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 120,
                                                ),
                                                if (formattedDate != null)
                                                  Text(
                                                      "التاريخ المختار هو : ${formattedDate!}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color: Color.fromARGB(
                                                              255,
                                                              6,
                                                              103,
                                                              182)))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 70.w),
                                                      child: const Text(
                                                        "رقم الهاتف",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 70.w,
                                                              vertical: 20.h),
                                                      child: SizedBox(
                                                        width: 220,
                                                        child:
                                                            CustomTextFormField(
                                                          controller:
                                                              nameController,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 22.h,
                                                                  left: 10.w,
                                                                  right: 10.w),
                                                          height: 70.h,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Column(
                                                //   children: [
                                                //     Padding(
                                                //       padding:
                                                //           EdgeInsets.symmetric(
                                                //               horizontal: 70.w),
                                                //       child: const Text(
                                                //         " من صباحا",
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //                 FontWeight
                                                //                     .bold),
                                                //       ),
                                                //     ),
                                                //     Padding(
                                                //       padding:
                                                //           EdgeInsets.symmetric(
                                                //               horizontal: 30.w,
                                                //               vertical: 40.h),
                                                //       child: SizedBox(
                                                //         width: 190.w,
                                                //         child:
                                                //             CustomTextFormField(
                                                //           readOnly: true,
                                                //           onTap: () async {
                                                //             TimeOfDay?
                                                //                 pickedTime =
                                                //                 await showTimePicker(
                                                //               initialTime:
                                                //                   TimeOfDay
                                                //                       .now(),
                                                //               context: context,
                                                //             );

                                                //             if (pickedTime !=
                                                //                 null) {
                                                //               // Explicitly set the locale to English when formatting and parsing
                                                //               String
                                                //                   formattedTime =
                                                //                   DateFormat(
                                                //                           'HH:mm:ss',
                                                //                           'en_US')
                                                //                       .format(
                                                //                 DateTime(
                                                //                   2024,
                                                //                   1,
                                                //                   1,
                                                //                   pickedTime
                                                //                       .hour,
                                                //                   pickedTime
                                                //                       .minute,
                                                //                 ),
                                                //               );

                                                //               print(
                                                //                   formattedTime);

                                                //               DateTime
                                                //                   parsedTime =
                                                //                   DateFormat(
                                                //                           'HH:mm:ss',
                                                //                           'en_US')
                                                //                       .parse(
                                                //                 formattedTime,
                                                //               );
                                                //               // Converting to DateTime so that we can further format on a different pattern.
                                                //               print(
                                                //                   parsedTime); // Output: 1970-01-01 22:53:00.000
                                                //               String
                                                //                   finalFormattedTime =
                                                //                   DateFormat(
                                                //                           'HH:mm:ss')
                                                //                       .format(
                                                //                           parsedTime);
                                                //               print(
                                                //                   finalFormattedTime); // Output: 14:59:00
                                                //               // DateFormat() is from the intl package, and you can format the time in any pattern you need.

                                                //               setState(() {
                                                //                 timeinputFrom
                                                //                         .text =
                                                //                     formattedTime; // Set the value of the text field.
                                                //               });
                                                //             } else {
                                                //               print(
                                                //                   "Time is not selected");
                                                //             }
                                                //           },
                                                //           controller:
                                                //               timeinputFrom,
                                                //           prefixIcon:
                                                //               const Padding(
                                                //             padding:
                                                //                 EdgeInsets.only(
                                                //                     top: 7),
                                                //             child: Icon(
                                                //               Icons.timer,
                                                //               size: 25,
                                                //             ),
                                                //           ),
                                                //           backgroundColor:
                                                //               Colors.grey[300],
                                                //           padding:
                                                //               EdgeInsets.only(
                                                //                   bottom: 8,
                                                //                   left: 10.w,
                                                //                   right: 10.w),
                                                //           height: 80.h,
                                                //         ),
                                                //       ),
                                                //     )
                                                //   ],
                                                // ),

                                                // Column(
                                                //   children: [
                                                //     Padding(
                                                //       padding:
                                                //           EdgeInsets.symmetric(
                                                //               horizontal: 70.w),
                                                //       child: const Text(
                                                //         " الي مساءا",
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //                 FontWeight
                                                //                     .bold),
                                                //       ),
                                                //     ),
                                                //     Padding(
                                                //       padding:
                                                //           EdgeInsets.symmetric(
                                                //               horizontal: 30.w,
                                                //               vertical: 40.h),
                                                //       child: SizedBox(
                                                //         width: 190.w,
                                                //         child:
                                                //             CustomTextFormField(
                                                //           readOnly: true,
                                                //           onTap: () async {
                                                //             TimeOfDay?
                                                //                 pickedTime =
                                                //                 await showTimePicker(
                                                //               initialTime:
                                                //                   TimeOfDay
                                                //                       .now(),
                                                //               context: context,
                                                //             );

                                                //             if (pickedTime !=
                                                //                 null) {
                                                //               // Explicitly set the locale to English when formatting and parsing
                                                //               String
                                                //                   formattedTime =
                                                //                   DateFormat(
                                                //                           'HH:mm:ss',
                                                //                           'en_US')
                                                //                       .format(
                                                //                 DateTime(
                                                //                     2024,
                                                //                     1,
                                                //                     1,
                                                //                     pickedTime
                                                //                         .hour,
                                                //                     pickedTime
                                                //                         .minute),
                                                //               );
                                                //               print(
                                                //                   formattedTime);
                                                //               DateTime
                                                //                   parsedTime =
                                                //                   DateFormat(
                                                //                           'HH:mm:ss',
                                                //                           'en_US')
                                                //                       .parse(
                                                //                 formattedTime,
                                                //               );
                                                //               //converting to DateTime so that we can further format on different pattern.
                                                //               print(
                                                //                   parsedTime); //output 1970-01-01 22:53:00.000
                                                //               String
                                                //                   finalFormattedTime =
                                                //                   DateFormat(
                                                //                           'HH:mm:ss')
                                                //                       .format(
                                                //                           parsedTime);
                                                //               print(
                                                //                   finalFormattedTime); //output 14:59:00
                                                //               //DateFormat() is from intl package, you can format the time on any pattern you need.
                                                //               setState(() {
                                                //                 timeinputTo
                                                //                         .text =
                                                //                     formattedTime; //set the value of text field.
                                                //                 print(
                                                //                     timeinputTo
                                                //                         .text);
                                                //               });
                                                //             } else {
                                                //               print(
                                                //                   "Time is not selected");
                                                //             }
                                                //           },
                                                //           controller:
                                                //               timeinputTo,
                                                //           prefixIcon:
                                                //               const Padding(
                                                //             padding:
                                                //                 EdgeInsets.only(
                                                //                     top: 7),
                                                //             child: Icon(
                                                //               Icons.timer,
                                                //               size: 25,
                                                //             ),
                                                //           ),
                                                //           backgroundColor:
                                                //               Colors.grey[300],
                                                //           padding:
                                                //               EdgeInsets.only(
                                                //                   bottom: 8,
                                                //                   left: 10.w,
                                                //                   right: 10.w),
                                                //           height: 80.h,
                                                //         ),
                                                //       ),
                                                //     )
                                                //   ],
                                                // ),

                                                SizedBox(
                                                  height: 500,
                                                  width: 300,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        addReservationCubit
                                                            .availabetime
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        child: Column(
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
                                                                Text(addReservationCubit
                                                                    .availabetime[
                                                                        index]
                                                                    .date!),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                    "السعر :"),
                                                                Text(addReservationCubit
                                                                    .availabetime[
                                                                        index]
                                                                    .price!),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                        "من :"),
                                                                    Text(addReservationCubit
                                                                        .availabetime[
                                                                            index]
                                                                        .availableTimeFrom!),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                        "الي :"),
                                                                    Text(addReservationCubit
                                                                        .availabetime[
                                                                            index]
                                                                        .availableTimeTo!),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),

                                                const SizedBox(
                                                  width: 65,
                                                ),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  100.w),
                                                      child: const Text(
                                                        "الاضافات",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      height: 300,
                                                      width: 300,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.r),
                                                      ),
                                                      //                               ListView.builder(
                                                      //   shrinkWrap: true,
                                                      //   physics: NeverScrollableScrollPhysics(),
                                                      //   itemCount: addOp.additionalOptions.length,
                                                      //   itemBuilder: (context, index) {
                                                      //     final option = addOp.additionalOptions[index];
                                                      //     final itemName = option.name.toString();
                                                      //     final itemPrice = option.price.toString();

                                                      //     return CheckboxListTile(
                                                      //       title: Text(
                                                      //         '$itemPrice   $itemName',
                                                      //         style: TextStyle(
                                                      //           color: Colors.indigo,
                                                      //           fontFamily: 'Cairo',
                                                      //           fontWeight: FontWeight.bold,
                                                      //           fontSize: 20.sp,
                                                      //         ),
                                                      //       ),
                                                      //       value: selectedItems.contains(itemName),
                                                      //       onChanged: (value) {
                                                      //         setState(() {
                                                      //           if (value == true) {
                                                      //             selectedItems.add(itemName);
                                                      //           } else {
                                                      //             selectedItems.remove(itemName);
                                                      //           }
                                                      //         });
                                                      //       },
                                                      //     );
                                                      //   },
                                                      // ),

                                                      child: ListView.builder(
                                                        itemCount: addOp
                                                            .additionalOptions
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final option = addOp
                                                                  .additionalOptions[
                                                              index];
                                                          final itemName =
                                                              option.name
                                                                  .toString();
                                                          final itemPrice =
                                                              option.price
                                                                  .toString();

                                                          return CheckboxListTile(
                                                            title: Text(
                                                              "$itemName و سعره : $itemPrice",
                                                              style: TextStyle(
                                                                  color: checkedItems[
                                                                          index]
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        20.w,
                                                                    vertical:
                                                                        8.h),
                                                            tileColor:
                                                                checkedItems[
                                                                        index]
                                                                    ? Colors
                                                                        .blueGrey
                                                                    : null,
                                                            value: checkedItems[
                                                                index],
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                if (value ==
                                                                    true) {
                                                                  selectedItems.add(
                                                                      itemName);
                                                                } else {
                                                                  selectedItems
                                                                      .remove(
                                                                          itemName);
                                                                }
                                                                checkedItems[
                                                                        index] =
                                                                    value!;
                                                              });
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    const Row(
                                      children: [
                                        /////////////////////////////////////
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Align Row to start
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      // List<String> selectedItems = [];
                                      // for (int i = 0;
                                      //     i < checkedItems.length;
                                      //     i++) {
                                      //   if (checkedItems[i]) {
                                      //     selectedItems.add(items[i]);
                                      //   }
                                      // }
                                      // print(selectedItems);
                                      ReservationCubit.get(context)
                                          .AddReservation(
                                        category_name: widget.categoryName,
                                        itemId: widget.itemId,
                                        paid: 120.toString(),
                                        additionalOptions: "ss",
                                        image: ReservationCubit.get(context)
                                            .pickedImage,
                                        time: DateTime.now().toString(),
                                        timeOfReservationfrom:
                                            addReservationCubit.availabetime[0]
                                                .availableTimeFrom!,
                                        timeOfReservationto: addReservationCubit
                                            .availabetime[0].availableTimeTo!,
                                        price: addReservationCubit
                                            .availabetime[0].price,
                                        userid: '14',
                                      );
                                    },
                                    child: const Text("اضافه")),
                                SizedBox(
                                  width: 50.w,
                                ),
                                SizedBox(
                                  width: 50.w,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text("الغاء")),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
