class EndPoints {
  static const String baseUrl = 'https://quizzy.site/reservation_app';
  static const String addCashier = '/user/add_receptionist.php';
  static const String addAdmin = '/user/add_admin.php';
  static const String login = '/user/login.php';
  static const String addCategory = '/category/add_category.php';
  static const String getCategories = '/category/get_category.php';
  static const String getCategoryItems = '/category/get_category_items.php';
  static const String getReceptionists = '/user/get_receptionist.php';
  static const String getAcceptedUsers = '/user/get_accepted_users.php';
  static const String getPendingUsers = '/user/get_waiting_users.php';
  static const String acceptUser = '/user/accept_user.php';
  static const String getReservations = '/reservations/get_reservation.php';
  static const String getDayAvailableTime = '/user/calender.php';
  static const String addAdditionalOptions =
      '/additional_options/add_option.php';
  static const String getAllAdditionalOptions =
      '/additional_options/get_options.php';
  static const String deleteOptiopn = '/additional_options/delete_option.php';
  static const String editOptiopn = '/additional_options/edit_option.php';
  static const String addReservation = '/reservations/add_reservation.php';
  static const String acceptReservation =
      '/reservations/approve_reservation.php';
  static const String declineReservation =
      '/reservations/delete_reservation.php';
  static const String getItemAdditionalOptions = '/item/get_item_options.php';
}
