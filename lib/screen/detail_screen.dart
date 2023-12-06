import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:passport_gen/model/passport.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.passport});
  final Passport? passport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(passport?.fullName ?? ""),),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Image.file(File(passport?.image ?? "")),
            const Gap(20),
            Text(passport?.address ?? "")
          ],
        ),
      ),
    );
  }
}
