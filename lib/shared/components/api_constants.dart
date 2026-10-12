import 'package:visit_egypt/config/env.dart';

String key = Env.mapsApiKey;

String AutoSearch = "/maps/api/place/autocomplete/json";
String searchDetails = "/maps/api/place/details/json";
String allPlaces = "/maps/api/place/textsearch/json";

String ApiUrl = Env.apiBaseUrl;

String postUserData = ApiUrl +"/auth/register";

String companiesEn= ApiUrl +"/companies/en";
String companiesAr = ApiUrl +"/companies/ar";
String companiesComments =  ApiUrl +"/comments/comments";
String postComment = ApiUrl +"/comments/comment";


String eventsEn = ApiUrl +"/events/en";
String eventsAr = ApiUrl +"/events/ar";

String cultureEn = ApiUrl +"/cultures/en";
String cultureAr = ApiUrl +"/cultures/ar";

String sendEvent = ApiUrl+"/events/event";
String sendPlace = ApiUrl+"/cities/addPlace";

String sendCulture = ApiUrl+"/cultures/culture";

String specificCultureAr = ApiUrl+"/cultures/category/ar/";

String specificCultureEn = ApiUrl+"/cultures/category/en/";

String categoriesCulture = ApiUrl+"/categories/culture";

String categoriesEvents = ApiUrl+"/categories/event";

String cityeAr = ApiUrl+"/cities/ar";

String cityEn = ApiUrl+"/cities/en";

String categoriesCity = ApiUrl+"/cities/allCatInCity/";

String allCategories = ApiUrl+"/categories/place";


String postPlaces = ApiUrl+"/cities/addPlace";

