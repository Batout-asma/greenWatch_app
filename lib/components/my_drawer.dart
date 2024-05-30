import 'package:flutter/material.dart';
import 'package:green_watch_app/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSettingsTap;
  final void Function()? onLogOutTap;
  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onLogOutTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(45, 103, 48, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              DrawerHeader(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/logo_white.png'),
                          fit: BoxFit.cover)),
                ),
              ),

              // profile navigator
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: MyListTile(
                  icon: Icons.person_outlined,
                  text: 'P R O F I L E',
                  onTap: onProfileTap,
                ),
              ),
              MyListTile(
                icon: Icons.settings,
                text: 'S E T T I N G S',
                onTap: onSettingsTap,
              ),
            ],
          ),
          // logout
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: MyListTile(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: onLogOutTap,
            ),
          ),
        ],
      ),
    );
  }
}
