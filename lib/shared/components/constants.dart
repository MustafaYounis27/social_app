//base url : https://newsapi.org/
//method (url): v2/top-headlines?
//queries : country=eg&category=science&apiKey=b37eced752654858b1084bce0583a432
import 'package:flutter_app/modules/shop_app/login/shop_login_screen.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_app/shared/network/local/cache_helper.dart';

String token = '';

String uId = '';

void signOut(context) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value)
      navigateAndFinish(
        context,
        ShopLoginScreen(),
      );
  });
}
