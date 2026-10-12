import 'package:get/get.dart';
import 'package:visit_egypt/Utils/langs/en.dart';

import '../utils/langs/ar.dart';




class Translation extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar': ar,
      };
}
