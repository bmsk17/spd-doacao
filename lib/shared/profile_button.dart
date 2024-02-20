import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  const ProfileButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.person,
        color: Colors.black87,
      ),
      label: Text(
        label,
        style: const TextStyle(
            color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(14),
        minimumSize: const Size.fromHeight(40),
        alignment: Alignment.centerLeft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
