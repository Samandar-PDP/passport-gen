import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passport_gen/db/sql_helper.dart';
import 'package:passport_gen/model/passport.dart';
import 'package:passport_gen/screen/main_screen.dart';
import 'package:passport_gen/widget/app_text_field.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _picker = ImagePicker();
  final _fullname = TextEditingController();
  final _city = TextEditingController();
  final _homeAddress = TextEditingController();
  final _passportGotDate = TextEditingController();
  final _passportExpireDate = TextEditingController();
  XFile? _xFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Passport"),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _xFile == null ? _defaultImage() : _passportImage(),
            const Gap(20),
            AppTextField(controller: _fullname, hint: "To'liq ism"),
            const Gap(20),
            AppTextField(controller: _homeAddress, hint: "Manzili"),
            const Gap(20),
            AppTextField(controller: _city, hint: "Shahar, tuman"),
            const Gap(20),
            AppTextField(controller: _passportGotDate, hint: "Passport olgan vaqti"),
            const Gap(20),
            AppTextField(controller: _passportExpireDate, hint: "Passport muddati"),
            const Gap(20),
            ElevatedButton(onPressed: _saveNewPassport, child: Text("Saqlash"))
          ],
        ),
      ),
    );
  }
  Widget _defaultImage() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.black,width: 2),
      ),
      child: InkWell(
        onTap: () async {
          _xFile = await _picker.pickImage(source: ImageSource.gallery);
          setState(() {});
        },
        child: const Center(
          child: Icon(CupertinoIcons.photo),
        ),
      ),
    );
  }
  _passportImage() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.black,width: 2),
      ),
      child: Image.file(File(_xFile?.path ?? ""),fit: BoxFit.cover),
    );
  }
  void _saveNewPassport() {
    final newPassport = Passport(null, _fullname.text, _homeAddress.text, _city.text, _xFile?.path, _passportExpireDate.text, _passportGotDate.text);
    SqlHelper.saveNewPassport(newPassport).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved")));
      Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const MainScreen()), (route) => false);
    });
  }
}
