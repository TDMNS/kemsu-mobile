import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;
  const MenuTile({super.key, required this.title, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 12.0,
      onTap: onTap,
      child: PhysicalModel(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12.0),
        elevation: 6,
        shadowColor: Theme.of(context).primaryColorLight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Image.asset(
                iconPath,
                scale: 4,
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
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
    );
  }
}
