import 'package:flutter/material.dart';
import 'package:flutter_app/layouts/news_layout/cubit/cubit.dart';
import 'package:flutter_app/layouts/news_layout/cubit/states.dart';
import 'package:flutter_app/modules/news_app/search/search_screen.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = NewsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('News App'),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.brightness_6_outlined,
                  ),
                  onPressed: () {
                    cubit.changeMode();
                  },
                ),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              items: cubit.bottomItems,
              onTap: (index) {
                cubit.changeBottomIndex(index);
              },
            ),
          );
        });
  }
}
