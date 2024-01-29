import 'package:flutter/material.dart';
import 'package:reservationapp_reseptionist/core/helpers/extensions.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios));
  }
}
