// ignore_for_file: avoid_classes_with_only_static_members

import 'package:get_storage/get_storage.dart';
import 'package:qrscanner/core/appStorage/user_model.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/login/login_view.dart';

abstract class AppStorage {
  static final GetStorage _box = GetStorage();

  static Future<void> init() async => GetStorage.init();

  static UserModel? get getUserInfo {
    UserModel? profileModel;
    if (_box.hasData('user')) {
      profileModel = UserModel.fromJson(_box.read('user'));
    }
    return profileModel;
  }

  static bool get isLogged => getUserInfo != null;

  static Future<void> cacheUserInfo(UserModel userModel) =>
      _box.write('user', userModel.toJson());

  static Future<void> cacheImagePath(String imagePath) =>
      _box.write('image', imagePath);

  static String? get getImagePath => _box.read('image');

  static int? get getUserId => getUserInfo?.data?.user!.id;

  static String? get getToken => getUserInfo?.data!.token;

  static User? get getUserData => getUserInfo!.data!.user!;

  // Base URL Storage
  static Future<void> cacheBaseUrl(String baseUrl) =>
      _box.write('baseUrl', baseUrl);

  static String? get getBaseUrl => _box.read('baseUrl');

  static bool get hasBaseUrl => _box.hasData('baseUrl');

  static final productsDetails = <Map>[];

  static Future<void> signOut() async {
    await _box.erase();
    MagicRouter.navigateAndPopAll(const LogInView());
  }
}
