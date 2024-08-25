import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/square_button.dart';
import 'package:pix2life/functions/services/token.services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateProfilePage extends StatefulWidget {
  static void _logout(BuildContext context) async {
    Navigator.pushReplacementNamed(context, '/');
  }

  static void route(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/upload');
  }

  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TokenService _tokenService = TokenService();
  final Map<String, dynamic> user = {
    'name': 'Admin',
    'email': 'admin@gmail.com',
    'address': 'Planet Earth',
    'phone': '(+254)791823746',
    'postCode': '005001',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            SizedBox(height: ScreenUtil().setHeight(10)),
            _buildSubtitle(),
            SizedBox(height: ScreenUtil().setHeight(30)),
            _buildProfileImage(),
            SizedBox(height: ScreenUtil().setHeight(20)),
            _buildUserInfoList(),
            SizedBox(height: ScreenUtil().setHeight(10)),
            _buildSaveButton(context),
            SizedBox(height: ScreenUtil().setHeight(10)),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        GestureDetector(
          onTap: () async {
            await _tokenService.deleteToken();
            UpdateProfilePage._logout(context);
          },
          child: Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            child: Icon(Icons.curtains_closed_rounded,
                size: ScreenUtil().setWidth(20)),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Text(
        'Create Profile',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: ScreenUtil().setSp(35),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Center(
      child: Text(
        "Fill in the information to update your profile",
        style: TextStyle(
          fontSize: ScreenUtil().setSp(15),
          color: AppPalette.blackColor,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: ScreenUtil().setWidth(120),
        height: ScreenUtil().setWidth(120),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppPalette.greyColor2.withOpacity(0.6),
              spreadRadius: 8,
              blurRadius: 16,
            ),
          ],
          border: Border.all(
            color: AppPalette.greyColor1,
            width: 4,
          ),
        ),
        child: CircleAvatar(
          radius: ScreenUtil().setWidth(60),
          backgroundImage: NetworkImage(
            'https://th.bing.com/th/id/R.0bebd3b416fff93c13f89aca8d0cdbb1?rik=fjPIU0uQcKti6g&pid=ImgRaw&r=0',
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoList() {
    return Expanded(
      child: ListView(
        children: [
          _buildUserInfoRow('Name', user['name']),
          _buildUserInfoRow('Email', user['email']),
          _buildUserInfoRow('Address', user['address']),
          _buildUserInfoRow('Postal Code', user['postCode']),
          _buildUserInfoRow('Contact', user['phone']),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(24),
          horizontal: ScreenUtil().setWidth(70)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(10)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          UpdateProfilePage.route(context);
        },
        splashColor: AppPalette.greyColor2.withOpacity(0.3),
        highlightColor: AppPalette.greyColor3.withOpacity(0.1),
        child: SquareButton(name: 'Save and Continue'),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
        height: ScreenUtil().setHeight(5),
        width: ScreenUtil().setWidth(150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(5, 3),
            ),
          ],
        ),
      ),
    );
  }
}
