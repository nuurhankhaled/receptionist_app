double calculateTotalSalary( List<String> salaryOfOptions, double salary) {

  // Calculate the total salary considering additional factors
  double additionalSalary = 0;
  print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  print(salaryOfOptions.length);
  for (int i = 0; i < salaryOfOptions.length; i++) {

    double option = double.parse(salaryOfOptions[i]);
    additionalSalary+=option;
  }

  return salary + additionalSalary;
}