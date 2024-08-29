import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/config/app/app.config.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/button_widgets.dart';
import 'package:pix2life/functions/services/token.services.dart';
import 'package:pix2life/screens/billet/upload_profile.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuPage extends StatefulWidget {
  static Profile(context) {
    Navigator.pushNamed(context, '/Profile');
  }

  static Subscription(context) {
    Navigator.pushNamed(context, '/Subscriptions');
  }

  static Notification(context) {
    Navigator.pushNamed(context, '/Notifications');
  }

  static HelpCenter(context) {
    Navigator.pushNamed(context, '/HelpCenter');
  }

  static SignOut(context) {
    Navigator.pushReplacementNamed(context, '/SignIn');
  }

  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TokenService _tokenService = TokenService();

  @override
  Widget build(BuildContext context) {
    final authUser =
        (BlocProvider.of<AuthBloc>(context).state as AuthSuccess).user;
    final Map<String, dynamic> user = {
      'username': authUser.username,
      'email': authUser.email,
      'address': authUser.address,
      'phoneNumber': authUser.phoneNumber,
      'postCode': authUser.postCode,
    };

    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadProfilePicPage(),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: ScreenUtil().setWidth(60),
                  backgroundImage: NetworkImage(
                    authUser.avatarUrl.isNotEmpty
                        ? authUser.avatarUrl
                        : AppConfig.avatarUrl,
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Center(
              child: Flexible(
                child: RichText(
                  text: TextSpan(
                    text: 'Welcome! ',
                    style: TextStyle(
                      color: AppPalette.redColor1,
                      fontSize: ScreenUtil().setSp(27),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(
                        text: user['username'],
                        style: TextStyle(
                          color: AppPalette.redColor1,
                          fontSize: ScreenUtil().setSp(26),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Expanded(
              child: ListView(
                children: [
                  _buildMenuOption(Icons.account_circle, 'Profile', () {
                    MenuPage.Profile(context);
                  }),
                  _buildMenuOption(Icons.more, 'Subscription', () {
                    MenuPage.Subscription(context);
                  }),
                  _buildMenuOption(Icons.notification_add, 'Notifications', () {
                    MenuPage.Notification(context);
                  }),
                  _buildMenuOption(Icons.help_center, 'Help Center', () {
                    MenuPage.HelpCenter(context);
                  }),
                  _buildMenuOption(Icons.exit_to_app_rounded, 'Sign Out',
                      () async {
                    await _tokenService.deleteToken();
                    MenuPage.SignOut(context);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String name, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: AppPalette.redColor1),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            name,
            style: TextStyle(color: AppPalette.redColor1),
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: AppPalette.redColor1,
          backgroundColor: AppPalette.whiteColor, // Text and icon color
          side: BorderSide(color: AppPalette.redColor1), // Border color
          alignment: Alignment.centerLeft, // Align icon and text to the left
        ),
        onPressed: onPressed,
      ),
    );
  }
}
