import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/profile_bloc/profile_bloc.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/models/profile/emp_card_model.dart';
import 'package:kemsu_app/domain/models/profile/stud_card_model.dart';

class ProfileAdditionalInformation extends StatelessWidget {
  final VoidCallback? closeInfo;
  final AuthModel? userData;
  final StudCardModel? studCard;
  final EmpCardModel? empCard;
  final String avatar;
  const ProfileAdditionalInformation({
    super.key,
    required this.closeInfo,
    required this.studCard,
    required this.userData,
    required this.avatar,
    required this.empCard,
  });

  @override
  Widget build(BuildContext context) {
    UserType userType = userData?.userInfo.currentUserType ?? UserType.student;
    return Stack(
      children: [
        GestureDetector(
          onTap: closeInfo,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  AbsorbPointer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 72.0,
                          backgroundColor: Colors.white.withOpacity(0.4),
                          child: avatar.isEmpty ? Image.asset('images/avatar1.png') : ClipOval(child: Image.network(avatar, width: 200,  height: 200, fit: BoxFit.cover)),
                        ),
                        const SizedBox(height: 12.0),
                        if (userType == UserType.student) ...[
                          Text(userData?.userInfo.fullName ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                          Text(userData?.userInfo.userType ?? '', style: const TextStyle(fontSize: 16.0)),
                          Text(studCard?.groupName ?? '', style: const TextStyle(fontSize: 16.0)),
                          Divider(height: 14.0, color: Colors.grey.withOpacity(.5)),
                          Text(studCard?.speciality ?? '', style: const TextStyle(fontSize: 16.0)),
                          Text(studCard?.faculty ?? '', style: const TextStyle(fontSize: 16.0)),
                          Text('${studCard?.learnForm ?? ''} форма обучения', style: const TextStyle(fontSize: 16.0)),
                          Text('${studCard?.finform ?? ''} форма финансирования', style: const TextStyle(fontSize: 16.0)),
                        ],
                        if (userType == UserType.teacher) ...[
                          Text(empCard?.empList[0].dep ?? '', style: const TextStyle(fontSize: 16.0)),
                          const SizedBox(height: 12.0),
                        ],
                        Text(userData?.userInfo.email ?? '', style: const TextStyle(fontSize: 16.0))
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: closeInfo,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
