import 'package:get/get.dart';
class Country {
  String countryCode;
  String name;
  String countryFlag ;

  Country(this.countryCode, this.name,this.countryFlag);

  static List<Country> getCountries() {
    return <Country>[
      Country('SYP', 'Syrian Pounds'.tr,'sy'),
      Country('LBP', 'lebanon Pound'.tr,'lb'),
      Country('USD', 'American dollar'.tr,'us'),
      Country('EUR', 'euro'.tr,'eu'),
      Country('EGP', 'Egyptian Pound'.tr,'eg'),
      Country('JOD', 'Jordanian dirhams'.tr,'jo'),
      Country('SAR', 'Saudi Pound'.tr,'sa'),
      Country('KWD', 'Kuwaiti Dinar'.tr,'kw'),
      Country('AED', 'Emirate Dirham'.tr,'ae'),
      Country('IQD', 'Iraqi Dinar'.tr,'iq'),

    ];
  }
}
