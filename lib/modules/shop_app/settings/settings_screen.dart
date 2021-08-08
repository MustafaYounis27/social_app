import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/layouts/shop_layout/cubit/cubit.dart';
import 'package:flutter_app/layouts/shop_layout/cubit/states.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_app/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessUpdateUserDataState) {
          if (state.userModel.status) {
            showToast(
              message: state.userModel.message,
              state: ToastStates.SUCCESS,
            );
          } else {
            showToast(
              message: state.userModel.message,
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        var userModel = ShopCubit.get(context).userModel;

        nameController.text = userModel.data.name;
        emailController.text = userModel.data.email;
        phoneController.text = userModel.data.phone;

        return ConditionalBuilder(
          condition: userModel != null,
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      ShopCubit.get(context).updateUserData(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                      );
                    }
                  },
                  child: Text(
                    'update'.toUpperCase(),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (state is ShopLoadingUpdateUserDataState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 30.0,
                    ),
                    defaultFormField(
                      controller: nameController,
                      label: 'Name',
                      prefix: Icons.person,
                      type: TextInputType.name,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'name must not be empty';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: emailController,
                      label: 'Email Address',
                      prefix: Icons.email,
                      type: TextInputType.emailAddress,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'email must not be empty';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      label: 'Phone',
                      prefix: Icons.phone,
                      type: TextInputType.phone,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'phone must not be empty';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                      function: () {
                        signOut(context);
                      },
                      text: 'logout',
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
