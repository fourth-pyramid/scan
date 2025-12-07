import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:qrscanner/common_component/snack_bar.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/dioHelper/dio_helper.dart';
import 'package:qrscanner/features/settings/settings_states.dart';

class SettingsController extends Cubit<SettingsStates> {
  SettingsController() : super(SettingsInitial());

  static SettingsController of(context) => BlocProvider.of(context);

  final TextEditingController ipController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  /// Load the saved URL into the text ﬁeld
  void loadCurrentSettings() {
    final savedBaseUrl = AppStorage.getBaseUrl;

    if (savedBaseUrl != null && savedBaseUrl.isNotEmpty) {
      ipController.text = _cleanUrl(savedBaseUrl);
      emit(SettingsLoaded());
    }
  }

  /// Auto-detect Wi-Fi IP
  Future<void> getMyIP() async {
    try {
      final info = NetworkInfo();
      final wifiIP = await info.getWifiIP();

      if (wifiIP != null && wifiIP.isNotEmpty) {
        ipController.text = '$wifiIP:8000';
        showSnackBar('IP detected: $wifiIP');
        emit(SettingsLoaded());
      } else {
        showSnackBar('Could not detect IP. Check Wi-Fi.');
      }
    } catch (e) {
      showSnackBar('Error getting IP: $e');
    }
  }

  /// Save based on text value
  Future<void> saveSettings() async {
    final text = ipController.text.trim();

    if (text.isEmpty) {
      // Default to production if empty
      const baseUrl = 'https://bestscan.store';
      AppStorage.cacheBaseUrl(baseUrl);
      DioHelper.updateBaseUrl(baseUrl);

      showSnackBar('Using default production server.');
      emit(SettingsSaved());
      return;
    }

    // Detect if user wrote IP → Local
    if (_isIP(text)) {
      final baseUrl = 'http://$text';
      AppStorage.cacheBaseUrl(baseUrl);
      DioHelper.updateBaseUrl(baseUrl);

      showSnackBar('Local server saved successfully!');
      emit(SettingsSaved());
      return;
    }

    // Otherwise treat it as full domain → Production
    final cleaned = _cleanUrl(text);
    final baseUrl = 'https://$cleaned';

    AppStorage.cacheBaseUrl(baseUrl);
    DioHelper.updateBaseUrl(baseUrl);

    showSnackBar('Production server saved.');
    emit(SettingsSaved());
  }

  /// Detect Local IP (e.g., 192.168.x.x)
  bool _isIP(String text) {
    final ipPattern = RegExp(
      r'^(\d{1,3}\.){3}\d{1,3}(:\d+)?$',
    ); // 192.168.1.10:8000
    return ipPattern.hasMatch(text);
  }

  /// Clean full URL to only the domain/IP
  String _cleanUrl(String url) {
    return url
        .replaceAll('http://', '')
        .replaceAll('https://', '')
        .replaceAll('/api/v1', '')
        .replaceAll('/', '')
        .trim();
  }

  @override
  Future<void> close() {
    ipController.dispose();
    return super.close();
  }
}
