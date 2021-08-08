import 'package:flutter/material.dart';
import 'package:flutter_app/layouts/news_layout/cubit/cubit.dart';
import 'package:flutter_app/layouts/news_layout/cubit/states.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultFormField(
                  controller: searchController,
                  label: 'search',
                  prefix: Icons.search,
                  type: TextInputType.text,
                  onChange: (value) {
                    NewsCubit.get(context).getSearch(value);
                  },
                  validator: (String value) {
                    if (value.isEmpty) return 'search must not be null';
                    return null;
                  },
                ),
              ),
              Expanded(
                child: articleBuilder(
                  NewsCubit.get(context).search,
                  context,
                  isSearch: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
