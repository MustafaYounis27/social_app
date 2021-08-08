import 'package:flutter_app/modules/counter_app/counter/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<CounterStates>
{
  CounterCubit() : super(CounterInitState());

  static CounterCubit get(context) => BlocProvider.of(context);

  int counter = 0;

  void minus()
  {
    counter--;
    emit(CounterMinusState());
  }

  void plus()
  {
    counter++;
    emit(CounterPlusState());
  }
}