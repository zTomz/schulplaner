import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<void> loadLicenses() async {
  return LicenseRegistry.addLicense(() async* {
    final appIconLicense = await rootBundle.loadString('assets/licenses/app_icon.txt');
    yield LicenseEntryWithLineBreaks(['app_icon'], appIconLicense);
  });
}
