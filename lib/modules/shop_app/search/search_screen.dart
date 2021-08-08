import 'package:flutter/material.dart';
import 'package:flutter_app/modules/shop_app/search/cubit/cubit.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/states.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  defaultFormField(
                    controller: searchController,
                    label: 'search',
                    prefix: Icons.search,
                    type: TextInputType.text,
                    onSubmit: (String text) {
                      SearchCubit.get(context).search(text);
                    },
                    validator: (String value) {
                      if (value.isEmpty) return 'enter text to search';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (state is SearchLoadingState) LinearProgressIndicator(),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildProductItem(
                          SearchCubit.get(context).model.data.data[index],
                          context,
                          isOldPrice: false,
                        ),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount:
                            SearchCubit.get(context).model.data.data.length,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
