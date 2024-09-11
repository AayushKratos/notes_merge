import 'package:flutter/material.dart';
import 'package:notes/colors.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        title: Text('Settings', style: TextStyle(color: white),),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Sync', style: TextStyle(fontSize: 18, color: white),),
                  Spacer(),
                  Transform.scale(
                    scale: 1.3,
                    child: new Switch.adaptive(splashRadius: 30, value: value, onChanged: (switchValue){
                      setState(() {
                        this.value = switchValue;
                      });
                    }),
                  )
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}