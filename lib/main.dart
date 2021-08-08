import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/layouts/news_layout/cubit/cubit.dart';
import 'package:flutter_app/layouts/news_layout/cubit/states.dart';
import 'package:flutter_app/layouts/shop_layout/cubit/cubit.dart';
import 'package:flutter_app/layouts/social_layout/cubit/cubit.dart';
import 'package:flutter_app/layouts/social_layout/social_layout.dart';
import 'package:flutter_app/modules/social_app/login/social_login_screen.dart';

import 'package:flutter_app/shared/bloc_observe.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_app/shared/components/constants.dart';
import 'package:flutter_app/shared/network/local/cache_helper.dart';
import 'package:flutter_app/shared/network/remote/dio_helper.dart';
import 'package:flutter_app/shared/style/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async
{
  print(message.data.toString());
  showToast(message: 'onBackground', state: ToastStates.SUCCESS,);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onMessage.listen((event)
  {
    print(event.data.toString());
    showToast(message: 'on message', state: ToastStates.SUCCESS,);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print(event.data.toString());
    showToast(message: 'open message', state: ToastStates.SUCCESS,);
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  // bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  // token = CacheHelper.getData(key: 'token');
  //
  // if (onBoarding != null) {
  //   if (token != null)
  //     widget = ShopLayout();
  //   else
  //     widget = ShopLoginScreen();
  // } else {
  //   widget = OnBoardingScreen();
  // }

  uId = CacheHelper.getData(key: 'uId');

  if(uId != null)
    widget = SocialLayout();
  else
    widget = SocialLoginScreen();

  runApp(MyApp(isDark, widget));
}

class MyApp extends StatelessWidget
{
  final bool isDark;
  final Widget startWidget;

  MyApp(this.isDark, this.startWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          NewsCubit()
            ..changeMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
        ),
        BlocProvider(
          create: (context) => SocialCubit()..getUserData()..getPosts(),
        ),
      ],
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            home: startWidget,
            themeMode: ThemeMode.light,
            // themeMode: NewsCubit
            //     .get(context)
            //     .isDark
            //     ? ThemeMode.dark
            //     : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
