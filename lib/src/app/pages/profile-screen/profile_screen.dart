import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/date-format/format_timestamp.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/audio/data/data%20sources/audio_provider.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/features/gallery/data/data_source/gallery_provider.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/image/data/data%20sources/image_provider.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/video/data/data%20sources/video_provider.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/shared/widgets/animations/fade_animation.dart';
import 'package:pix2life/src/shared/widgets/quotes/quotes_display.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  User? authUser;
  List<Photo>? images;
  List<Video>? videos;
  List<Audio>? audios;
  List<Gallery>? galleries;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();

    // Initialize isDarkMode based on themeProvider's current theme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider =
          Provider.of<MyThemeProvider>(context, listen: false);
      setState(() {
        isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
            (themeProvider.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
      });
    });

    final userState = BlocProvider.of<AuthBloc>(context).state;
    if (userState is! AuthenticatedUser) {
      BlocProvider.of<AuthBloc>(context)
          .add(AuthRetrieveAuthenticatedUserEvent());
    }
  }

  void checkForErrors(BuildContext context) {
    final userProvider = Provider.of<MyUserProvider>(context, listen: false);
    final imageProvider = Provider.of<MyImageProvider>(context, listen: false);
    final videoProvider = Provider.of<MyVideoProvider>(context, listen: false);
    final audioProvider = Provider.of<MyAudioProvider>(context, listen: false);
    final galleryProvider =
        Provider.of<MyGalleryProvider>(context, listen: false);

    // Check for user errors
    if (!userProvider.isLoading &&
        userProvider.user == null &&
        userProvider.errorMessage.isNotEmpty) {
      ErrorSnackBar.show(context: context, message: userProvider.errorMessage);
      return; // Exit the function after showing the error
    }

    // Check for image errors
    if (!imageProvider.isLoading &&
        (imageProvider.images.isEmpty) &&
        imageProvider.errorMessage.isNotEmpty) {
      ErrorSnackBar.show(context: context, message: imageProvider.errorMessage);
      return;
    }

    // Check for video errors
    if (!videoProvider.isLoading &&
        (videoProvider.videos.isEmpty) &&
        videoProvider.errorMessage.isNotEmpty) {
      ErrorSnackBar.show(context: context, message: videoProvider.errorMessage);
      return;
    }

    // Check for audio errors
    if (!audioProvider.isLoading &&
        (audioProvider.audios.isEmpty) &&
        audioProvider.errorMessage.isNotEmpty) {
      ErrorSnackBar.show(context: context, message: audioProvider.errorMessage);
      return;
    }

    // Check for gallery errors
    if (!galleryProvider.isLoading &&
        (galleryProvider.galleries.isEmpty) &&
        galleryProvider.errorMessage.isNotEmpty) {
      ErrorSnackBar.show(
          context: context, message: galleryProvider.errorMessage);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<MyUserProvider>(context);
    final imageProvider = Provider.of<MyImageProvider>(context);
    final videoProvider = Provider.of<MyVideoProvider>(context);
    final audioProvider = Provider.of<MyAudioProvider>(context);
    final galleryProvider = Provider.of<MyGalleryProvider>(context);
    authUser = userProvider.user;
    images = imageProvider.images;
    videos = videoProvider.videos;
    audios = audioProvider.audios;
    galleries = galleryProvider.galleries;

    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    checkForErrors(context);

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
      body: Stack(
        children: <Widget>[
          buildProfileContent(),
          buildThemeButton(context),
        ],
      ),
    );
  }

  Widget buildProfileContent() {
    return CustomScrollView(
      slivers: <Widget>[
        buildSliverAppBar(),
        buildProfileDetails(),
      ],
    );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 450,
      // backgroundColor:
      //     isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: buildProfileHeader(),
      ),
    );
  }

  Widget buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: authUser != null && authUser!.avatarUrl.isNotEmpty
              ? NetworkImage(authUser!.avatarUrl)
              : const AssetImage(AppImage.welcomeImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            colors: [
              isDarkMode
                  ? AppPalette.darkBackground
                  : AppPalette.lightBackground,
              isDarkMode
                  ? AppPalette.darkBackground.withOpacity(.3)
                  : AppPalette.lightBackground.withOpacity(.3)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FadeAnimation(
                1,
                Text(
                  authUser!.username,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: isDarkMode
                        ? AppPalette.fontGrey
                        : AppPalette.primaryBlack.withAlpha(220),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildStatsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatsRow() {
    return Row(
      children: <Widget>[
        FadeAnimation(
          1.2,
          Text(
            "${images!.length} Images",
            style: TextStyle(
              color:
                  isDarkMode ? AppPalette.primaryGrey : AppPalette.primaryBlack,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 20),
        FadeAnimation(
          1.3,
          Text(
            "${videos!.length} Videos",
            style: TextStyle(
              color:
                  isDarkMode ? AppPalette.primaryGrey : AppPalette.primaryBlack,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 20),
        FadeAnimation(
          1.4,
          Text(
            "${audios!.length} Audios",
            style: TextStyle(
              color:
                  isDarkMode ? AppPalette.primaryGrey : AppPalette.primaryBlack,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProfileDetails() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildUpdateRow(),
                SizedBox(height: 20.h),
                buildBiography(),
                SizedBox(height: 20.h),
                if (authUser != null) buildUserDetailsCard(user: authUser!),
                SizedBox(height: 20.h),
                buildGallerySection(),
                SizedBox(height: 120.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBiography() {
    return const FadeAnimation(
        1.6,
        SizedBox(
          width: double.infinity,
          child: QuoteDisplay(),
        ));
  }

  Widget buildUpdateRow() {
    return FadeAnimation(
      1.6,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Update Profile Picture Button
          Column(
            children: [
              IconButton(
                icon: const Icon(
                    LineAwesomeIcons.user_circle), // Profile picture icon
                onPressed: () {
                  Navigator.pushNamed(context, '/Avatar');
                },
                tooltip: 'Update Profile Picture',
              ),
              const Text('Profile Pic', style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(width: 40.w),
          // Update Personal Info Button
          Column(
            children: [
              IconButton(
                icon: const Icon(
                    LineAwesomeIcons.edit), // Edit personal info icon
                onPressed: () async {},
                tooltip: 'Update Personal Info',
              ),
              const Text('Edit Info', style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(width: 40.w),
          // Logout Button
          Column(
            children: [
              IconButton(
                icon: const Icon(
                    LineAwesomeIcons.sign_out_alt_solid), // Logout icon
                onPressed: () async {
                  final userProvider =
                      Provider.of<MyUserProvider>(context, listen: false);
                  userProvider.logOutUser();
                  Navigator.pushReplacementNamed(context, '/SignIn');
                },
                tooltip: 'Log Out',
              ),
              const Text('Log Out', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow({required String title, required String detail}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FadeAnimation(
          1.6,
          Text(
            title,
            style: const TextStyle(
              color:
                  AppPalette.green, //isDarkMode ? AppPalette.fontWhite : null,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        FadeAnimation(
          1.6,
          Text(
            detail,
            style: const TextStyle(
              color: AppPalette.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUserDetailsCard({required User user}) {
    return FadeAnimation(
      1.8,
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: isDarkMode
            ? AppPalette.darkBackground.withOpacity(.2)
            : Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildDetailRow(
                  title: "Subscription Plan",
                  detail: authUser!.subscriptionPlan),
              SizedBox(height: 15.h),
              FadeAnimation(
                1.6,
                Text(
                  'Personal Details',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              _buildData('Email: ', user.email, LineAwesomeIcons.envelope),
              _buildData('Phone Number: ', user.phoneNumber,
                  LineAwesomeIcons.phone_solid),
              _buildData('Post Code: ', user.postCode,
                  LineAwesomeIcons.map_marker_solid),
              _buildData(
                  'Address: ', user.address, LineAwesomeIcons.home_solid),
              _buildData('Login: ', Utility.formatTimestamp(user.lastLogin),
                  LineAwesomeIcons.sign_in_alt_solid),
              _buildData(
                  'Session Time: ',
                  Utility.getRelativeTime(user.lastLogin),
                  LineAwesomeIcons.clock),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildData(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon,
              color: isDarkMode ? Colors.white : Colors.black87, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.black54,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FadeAnimation(
          1.6,
          Text(
            "${galleries!.length} Galleries",
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeAnimation(
          1.8,
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: galleries!.length,
              itemBuilder: (BuildContext context, int index) {
                final Gallery gallery = galleries![index];
                return makeGalleryCard(gallery: gallery);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildThemeButton(BuildContext context) {
    final themeProvider = Provider.of<MyThemeProvider>(context);

    return Positioned(
      top: 35,
      right: 10,
      child: Align(
        alignment: Alignment.topRight,
        child: FadeAnimation(
          2,
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: isDarkMode
                  ? Colors.transparent
                  : AppPalette.darkBackground.withOpacity(.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons
                            .dark_mode, // Switch between light/dark mode icon
                  ),
                  color: isDarkMode
                      ? AppPalette.lightBackground
                      : AppPalette.lightBackground, // Icon color
                  onPressed: themeProvider.toggleTheme, // Toggle theme mode
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeGalleryCard({required Gallery gallery}) {
    return AspectRatio(
      aspectRatio: 1.5 / 1,
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: gallery.iconUrl.isNotEmpty
                ? NetworkImage(gallery.iconUrl)
                : const AssetImage(AppImage.welcomeImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(.9),
                Colors.black.withOpacity(.3),
              ],
            ),
          ),
          child: const Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.play_arrow,
              color: Colors.transparent,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
