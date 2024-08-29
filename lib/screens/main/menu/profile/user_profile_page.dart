import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/config/app/app.config.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/button_widgets.dart';
import 'package:pix2life/config/common/quotes_widget.dart';
import 'package:pix2life/functions/services/token.services.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfilePage extends StatefulWidget {
  static route(context) {
    Navigator.pushReplacementNamed(context, '/SignIn');
  }

  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TokenService _tokenService = TokenService();
  late Map<String, dynamic> userInfo = {};
  bool toggle = true;

  @override
  Widget build(BuildContext context) {
    final authUser =
        (BlocProvider.of<AuthBloc>(context).state as AuthSuccess).user;

    final Map<String, dynamic> user = {
      'name': authUser.username,
      'email': authUser.email,
      'address': authUser.address,
      'phone': authUser.phoneNumber,
      'postCode': authUser.postCode,
    };
    userInfo = user;

    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      appBar: AppBar(
        backgroundColor: AppPalette.whiteColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(user, authUser),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _buildDivider(),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _buildContent(user),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _buildLogoutButton(context),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _buildFooter(),
              SizedBox(height: ScreenUtil().setHeight(10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> user, dynamic authUser) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Username ::: ",
                style: TextStyle(
                  color: AppPalette.redColor1,
                  fontFamily: 'Poppins',
                  fontSize: ScreenUtil().setSp(15),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${user['name']}'s Profile",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ScreenUtil().setSp(19),
                  color: AppPalette.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Text(
                "User Bio ::: ",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppPalette.redColor1,
                  fontSize: ScreenUtil().setSp(15),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(1)),
              SizedBox(
                width: ScreenUtil().setWidth(230),
                child: QuoteDisplay(),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: ScreenUtil().setWidth(42.5),
                backgroundImage: NetworkImage(
                  authUser.avatarUrl.isNotEmpty
                      ? authUser.avatarUrl
                      : AppConfig.avatarUrl,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              GestureDetector(
                onTap: () {
                  setState(() {
                    toggle = !toggle;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(20),
                      right: ScreenUtil().setWidth(20)),
                  child: Icon(
                    Icons.grass_rounded,
                    color: AppPalette.redColor1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(2),
      color: AppPalette.redColor1,
    );
  }

  Widget _buildContent(Map<String, dynamic> user) {
    return Container(
      child: toggle
          ? SingleChildScrollView(
              child: Column(
                children: [
                  _buildInfoCard('User Info', user),
                  _buildInfoCard('Canvasses', {}),
                  _buildInfoCard('Audio Files', {}),
                  _buildInfoCard('Video Files', {}),
                ],
              ),
            )
          : StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 6,
              crossAxisSpacing: 4,
              children: [
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 3,
                  child: _buildInfoCard('User Info', user),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 2,
                  child: _buildInfoCard('Audio Files', {}),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: _buildInfoCard('Video Files', {}),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: _buildInfoCard('Image Files', {}),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 4,
                  mainAxisCellCount: 3,
                  child: _buildInfoCard('User Info', user),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoCard(String title, Map<String, dynamic> info) {
    return GestureDetector(
      onTap: () {
        _showEditDialog(title, info);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(10),
            vertical: ScreenUtil().setHeight(10)),
        color: AppPalette.redColor1.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(),
                ...info.entries.map((entry) => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${entry.key}:',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: AppPalette.blackColor3,
                            ),
                          ),
                          Text(
                            entry.value.toString(),
                            style: TextStyle(color: AppPalette.whiteColor3),
                          ),
                        ],
                      ),
                    )),
                if (info.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(4)),
                    child: Text(
                      'Lorem ipsum dolor sit amet.',
                      style: TextStyle(color: AppPalette.whiteColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(String title, Map<String, dynamic> info) {
    TextEditingController nameController =
        TextEditingController(text: info['name']);
    TextEditingController emailController =
        TextEditingController(text: info['email']);
    TextEditingController addressController =
        TextEditingController(text: info['address']);
    TextEditingController postCodeController =
        TextEditingController(text: info['postCode']);
    TextEditingController phoneController =
        TextEditingController(text: info['phone']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (title == 'User Info') ...[
                  _buildTextField(nameController, 'Name'),
                  _buildTextField(emailController, 'Email'),
                  _buildTextField(addressController, 'Address'),
                  _buildTextField(postCodeController, 'Postal Code'),
                  _buildTextField(phoneController, 'Phone'),
                ],
                if (title != 'User Info')
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Lorem ipsum',
                      labelStyle: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            title == 'User Info'
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        userInfo['name'] = nameController.text;
                        userInfo['email'] = emailController.text;
                        userInfo['address'] = addressController.text;
                        userInfo['postCode'] = postCodeController.text;
                        userInfo['phone'] = phoneController.text;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.scatter_plot_sharp),
                    label: const Text('Close'),
                  ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Poppins'),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          await _tokenService.deleteToken();
          UserProfilePage.route(context);
        },
        splashColor: AppPalette.whiteColor.withOpacity(0.3),
        highlightColor: AppPalette.whiteColor.withOpacity(0.1),
        child: SquareButton(name: 'Logout'),
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
              offset: const Offset(5, 3),
            ),
          ],
        ),
      ),
    );
  }
}
