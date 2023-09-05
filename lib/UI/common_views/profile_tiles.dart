import 'package:flutter/material.dart';

Widget profileTiles(context,
    {required VoidCallback onPressed,
    required String title,
    required String imageSource,
    required bool isActive}) {
  return GestureDetector(
    onTap: isActive ? onPressed : null,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColorLight,
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageSource,
                scale: 4,
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isActive)
          Center(
            child: ClipRect(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.red.withOpacity(0.75),
                ),
                child: const Center(
                  child: Text(
                    "Нет доступа",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
