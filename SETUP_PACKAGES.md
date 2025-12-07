# التعديلات المطلوبة للبكجات الجديدة

تم إجراء التعديلات التالية على ملفات Android و iOS لدعم البكجات الجديدة:

## البكجات المضافة:
- `image_picker`: ^1.2.0 - لاختيار الصور من المعرض أو الكاميرا
- `google_mlkit_text_recognition`: ^0.11.0 - للتعرف على النصوص في الصور
- `permission_handler`: ^12.0.1 - لإدارة الصلاحيات
- `path_provider`: ^2.1.5 - للوصول إلى مسارات النظام

---

## 📱 تعديلات Android

### 1. AndroidManifest.xml
تم إضافة الصلاحيات التالية في: `/android/app/src/main/AndroidManifest.xml`

```xml
<!-- Permissions for image_picker and camera -->
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>

<!-- Permission for internet (if needed for ML Kit) -->
<uses-permission android:name="android.permission.INTERNET"/>
```

### 2. build.gradle.kts
تم تحديث `minSdk` إلى 21 في: `/android/app/build.gradle.kts`

```kotlin
minSdk = 21  // Required for google_mlkit_text_recognition and image_picker
```

---

## 🍎 تعديلات iOS

### 1. Info.plist
تم إضافة الصلاحيات التالية في: `/ios/Runner/Info.plist`

```xml
<!-- Permissions for image_picker -->
<key>NSPhotoLibraryUsageDescription</key>
<string>نحتاج للوصول إلى معرض الصور لاختيار الصور</string>

<key>NSCameraUsageDescription</key>
<string>نحتاج للوصول إلى الكاميرا لالتقاط الصور</string>

<key>NSMicrophoneUsageDescription</key>
<string>نحتاج للوصول إلى الميكروفون لتسجيل الفيديو</string>

<!-- Permissions for permission_handler -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>نحتاج للوصول لإضافة صور إلى معرض الصور</string>

<!-- ML Kit Google Mobile Vision -->
<key>GMSMLKitVersion</key>
<string>3.2.0</string>
```

### 2. Podfile
تم إنشاء ملف Podfile جديد في: `/ios/Podfile`

الملف يحتوي على:
- تحديد الإصدار الأدنى لـ iOS: 12.0
- إعدادات google_mlkit_text_recognition
- إعدادات permission_handler للكاميرا والصور
- إعدادات Flutter pods

---

## ✅ الخطوات التالية

### على Linux (النظام الحالي):
يمكنك بناء التطبيق لـ Android:
```bash
flutter build apk --release
# أو
flutter build appbundle --release
```

### على macOS:
عند العمل على macOS، قم بتشغيل:
```bash
cd ios
pod install
pod update
cd ..
flutter build ios --release
```

---

## 🧪 اختبار الصلاحيات

تأكد من اختبار الصلاحيات التالية:
- ✅ الكاميرا (Camera)
- ✅ معرض الصور (Photo Library)
- ✅ القراءة والكتابة على التخزين (Storage)

---

## 📝 ملاحظات

1. **Android 13+**: تم استخدام `READ_MEDIA_IMAGES` للتوافق مع Android 13 وما فوق
2. **iOS Deployment Target**: تم تحديد iOS 12.0 كحد أدنى لدعم جميع البكجات
3. **ML Kit**: يعمل بدون الحاجة لـ Google Services في معظم الحالات

---

## 🔧 استكشاف الأخطاء

إذا واجهت مشاكل:

### Android:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter build apk
```

### iOS:
```bash
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter pub get
flutter build ios
```

---

تم إنشاء هذا الملف تلقائياً بواسطة GitHub Copilot 🤖
