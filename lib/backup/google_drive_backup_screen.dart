import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneygram/backup/google_drive_service.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

class GoogleDriveBackupScreen extends StatefulWidget {
  const GoogleDriveBackupScreen({Key? key}) : super(key: key);

  @override
  State<GoogleDriveBackupScreen> createState() =>
      _GoogleDriveBackupScreenState();
}

class _GoogleDriveBackupScreenState extends State<GoogleDriveBackupScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [_header(), SizedBox(height: 16), _body(), _debugWidgets()]);
  }

  Widget _header() {
    return Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
        color: context.appSecondaryColor,
        child: IntrinsicHeight(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("Backup",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, thickness: 0)
          ],
        )));
  }

  Widget _body() {
    return SafeArea(
      minimum: EdgeInsets.only(bottom: 36),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
              "Keep your data safe and easily accessible by backing up to Google Drive. If you ever need to reinstall the app, you can restore your data quickly and easily.",
              style:
                  TextStyle(color: context.appPrimaryColor.withOpacity(0.7))),
          const SizedBox(height: 24),
          Text("Last synced at : time_here"),
          const SizedBox(height: 12),
          IntrinsicWidth(
            child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: context.appPrimaryColor,
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  'BACK UP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: context.appSecondaryColor,
                      fontWeight: FontWeight.w600),
                )),
          ),
        ]),
      ),
    );
  }

  Widget _debugWidgets() {
    return Column(
      children: [
        InkWell(
            onTap: () async {
              await GoogleDriveService.upload();
            },
            child: Container(
                padding: EdgeInsets.all(32),
                color: Colors.cyan,
                child: Text("Upload here"))),
        const SizedBox(height: 12),
        InkWell(
            onTap: () async {
              await GoogleDriveService.readFiles();
            },
            child: Container(
                padding: EdgeInsets.all(32),
                color: Colors.cyan,
                child: Text("Read here"))),
        const SizedBox(height: 12),
        InkWell(
            onTap: () async {
              await GoogleDriveService.deleteFiles();
            },
            child: Container(
                padding: EdgeInsets.all(32),
                color: Colors.cyan,
                child: Text("Delete here"))),
      ],
    );
  }
}
