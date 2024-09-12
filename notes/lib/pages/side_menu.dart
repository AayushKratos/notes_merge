import 'package:flutter/material.dart';
import 'package:notes/colors.dart';
import 'package:notes/pages/archive.dart';
import 'package:notes/pages/home.dart';
// import 'package:notes/pages/archive.dart';
import 'package:notes/pages/setting.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: bgColor),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: Text(
                  'Google Keep',
                  style: TextStyle(
                      color: white, fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: white.withOpacity(0.3),
              ),
              sectionOne(),
              SizedBox(height: 5),
              sectionTwo(),
              SizedBox(height: 5),
              SectionSetting(),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionOne() {
    return Container(
        margin: EdgeInsets.only(right: 10),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ))),
          ),
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));},
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  size: 25,
                  color: white.withOpacity(0.7),
                ),
                SizedBox(width: 27),
                Text(
                  'Notes',
                  style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
                ),
              ],
            ),
          ),
        ));
  }

  Widget sectionTwo() {
    return Container(
        margin: EdgeInsets.only(right: 10),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ))),
          ),

          onPressed: () {Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ArchivePage()));},
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 25,
                  color: white.withOpacity(0.7),
                ),
                SizedBox(width: 27),
                Text(
                  'Archive',
                  style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
                ),
              ],
            ),
          ),
        ));
  }

  Widget SectionSetting() {
    return Container(
        margin: EdgeInsets.only(right: 10),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ))),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Setting()));
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 25,
                  color: white.withOpacity(0.7),
                ),
                SizedBox(width: 27),
                Text(
                  'Settings',
                  style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
                ),
              ],
            ),
          ),
        ));
  }
}
