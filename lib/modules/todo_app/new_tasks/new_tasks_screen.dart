import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/shared/components/components.dart';
import 'package:flutter_app/shared/cubit/cubit.dart';
import 'package:flutter_app/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NewTasksScreen extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          body: taskBuilder(
            tasks: tasks,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState.validate()) {
                  cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);
                  cubit.changeBottomSheetState(
                    isShown: false,
                    icon: Icons.edit,
                  );
                }
              } else {
                cubit.changeBottomSheetState(
                  isShown: true,
                  icon: Icons.add,
                );
                scaffoldKey.currentState
                    .showBottomSheet(
                      (context) => Container(
                        padding: EdgeInsets.all(
                          20.0,
                        ),
                        color: Colors.white,
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                label: 'Task Title',
                                prefix: Icons.title,
                                type: TextInputType.text,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'title must not be empty';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                controller: timeController,
                                label: 'Task Time',
                                prefix: Icons.access_time_outlined,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text = value.format(context);
                                  });
                                },
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'time must not be empty';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                controller: dateController,
                                label: 'Task Date',
                                prefix: Icons.calendar_today_outlined,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2022),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
                                  });
                                },
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'date must not be empty';
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20.0,
                    )
                    .closed
                    .then((value) {
                  // setState(() {
                  //   isBottomSheetShown = false;
                  //   fabIcon = Icons.edit;
                  // });
                });
              }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
        );
      },
    );
  }
}
