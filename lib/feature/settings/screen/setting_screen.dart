import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDarkMode = false;
  bool isNotificationOn = true;
  String selectedLanguage = "English";
  String appVersion = "1.0.0";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Settings', showBackButton: true),
      body: SafeArea(
        child: CustomContainer(
          margin: EdgeInsets.zero,
          color: CustomColor.whiteColor,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // _buildSwitchTile(
                    //   icon: Icons.brightness_6,
                    //   title: "Dark Mode",
                    //   value: isDarkMode,
                    //   onChanged: (val) => setState(() => isDarkMode = val),
                    // ),
                    // _buildLanguageTile(),
                    _buildSwitchTile(
                      icon: Icons.notifications,
                      title: "Notifications",
                      value: isNotificationOn,
                      onChanged: (val) => setState(() => isNotificationOn = val),
                    ),
                
                  ],
                ),
              ),

              Center(child: Text('App Version  $appVersion'),),
              20.height
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey[700]),
          title: Text(title),
          trailing: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: CustomColor.appColor,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildLanguageTile() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.language, color: Colors.grey[700]),
          title: const Text("Language"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(selectedLanguage),
              const Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
          onTap: () => _showLanguagePicker(context),
        ),
        const Divider(),
      ],
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 300,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              onTap: () => _selectLanguage("English"),
            ),
            ListTile(
              title: const Text("हिंदी"),
              onTap: () => _selectLanguage("हिंदी"),
            ),
            ListTile(
              title: const Text("Marathi"),
              onTap: () => _selectLanguage("Marathi"),
            ),
          ],
        ),
      ),
    );
  }

  void _selectLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
    Navigator.pop(context);
  }
}
