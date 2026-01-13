import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Models/user_model.dart';
import '../../../Auth Screens/Provider/auth_provider.dart';
import '../../../Auth Screens/Provider/universal_provider.dart';

class ProfileEditController {
  final WidgetRef ref;
  late final TextEditingController nameController;
  late final TextEditingController phoneController;

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
  }

  ProfileEditController(this.ref) {
    final userModel = currentUserModel;
    nameController = TextEditingController(text: userModel?.fullName ?? '');
    phoneController = TextEditingController(
      text: userModel?.phoneNo?.toString() ?? '',
    );
  }

  UserModel? get currentUserModel {
    final user = ref.read(authProvider).userData;
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email,
      fullName: user.fullName,
      phoneNo: user.phoneNo,
    );
  }

  Future<bool> updateUserProfile() async {
    try {
      final user = ref.read(authProvider).user;
      if (user == null) false;
      final updatedModel = UserModel(
        uid: user?.id ?? '',
        email: user?.email ?? '',
        fullName: nameController.text,
        phoneNo: int.tryParse(phoneController.text),
      );
      ref.read(universalLoadingProvider.notifier).toggle();
      await ref.read(authProvider.notifier).editUserInfo(updatedModel);
      ref.read(universalLoadingProvider.notifier).toggle();
      return true;
    } catch (e) {
      print('eRROR' + e.toString());
      ref.read(universalLoadingProvider.notifier).toggle();
      return false;
    }
  }
}
