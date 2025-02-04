import 'package:flutter/material.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/shared/widgets/user-avatar/cached_avatar_image.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatelessWidget {
  final double? radius;
  const UserAvatar({super.key, this.radius = 60});

  @override
  Widget build(BuildContext context) {
    User? authUser;
    final userProvider = Provider.of<MyUserProvider>(context);
    authUser = userProvider.user;

    final imageUrl = authUser != null && authUser.avatarUrl.isNotEmpty
        ? authUser.avatarUrl
        : 'https://random.imagecdn.app/150/150';

    return CachedAvatarImage(imageUrl: imageUrl, radius: radius);
  }
}
