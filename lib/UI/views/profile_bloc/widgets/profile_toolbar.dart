import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kemsu_app/Configurations/navigation.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/models/profile/stud_card_model.dart';

class ProfileToolbar extends StatefulWidget {
  final VoidCallback? showAddInfo;
  final AuthModel? userData;
  final StudCardModel? studCard;
  final String avatar;
  const ProfileToolbar({super.key, required this.showAddInfo, required this.userData, required this.studCard, required this.avatar});

  @override
  State<ProfileToolbar> createState() => _ProfileToolbarState();
}

class _ProfileToolbarState extends State<ProfileToolbar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Gradient?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = LinearGradientTween(
      begin: LinearGradient(
        colors: [Colors.lightBlueAccent, Colors.blue.shade900],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.mirror,
      ),
      end: LinearGradient(
        colors: [Colors.blue.shade900, Colors.lightBlueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.mirror,
      ),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 132.0,
          decoration: BoxDecoration(
            gradient: _animation.value,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () => AppRouting.toEditProfile(),
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white.withOpacity(0.4),
                      child: widget.avatar.isEmpty ? Image.asset('images/avatar1.png') : ClipOval(child: Image.network(widget.avatar)),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Stack(
                    alignment: Alignment.bottomRight,
                    fit: StackFit.passthrough,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.userData?.userInfo.fullName ?? '',
                            style: mainText,
                          ),
                          Text(widget.userData?.userInfo.userType ?? '', style: addText),
                          Text(widget.studCard?.groupName ?? '', style: addText),
                        ],
                      ),
                      InkWell(
                        onTap: widget.showAddInfo,
                        child: const Icon(
                          Icons.info_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

TextStyle mainText = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0);

TextStyle addText = const TextStyle(color: Colors.white, fontSize: 16.0);

class LinearGradientTween extends Tween<Gradient?> {
  LinearGradientTween({required super.begin, required super.end});

  @override
  Gradient? lerp(double t) {
    return Gradient.lerp(begin, end, t);
  }
}
