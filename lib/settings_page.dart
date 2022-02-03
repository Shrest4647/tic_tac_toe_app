import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/setting_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SettingDialog(),
    );
  }
}