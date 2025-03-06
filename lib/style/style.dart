import 'package:flutter/material.dart';

InputDecoration dekorasiInput({hint, icon, fill}) {
  return InputDecoration(
    hintText: hint ?? '',
    label: Text(hint),
    prefixIcon: icon != null ? Icon(icon) : null,
    filled: fill ?? false,
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 1),
    ),
  );
}
