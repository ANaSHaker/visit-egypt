

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visit_egypt/Screens/SignUpScreens/cubit/states.dart';
import 'package:visit_egypt/shared/components/api_constants.dart';
import 'package:visit_egypt/shared/network/remote/dio_helper.dart';

class userCubit extends Cubit<UserSignStates> {
  userCubit() : super(InitialUserationState());
  static userCubit get(context) => BlocProvider.of(context);


  void postUser({required firebase_id,required name,required email}) {
    emit(postUserLoadingState());
    DioHelper.postData(path: postUserData, data: {
      'firebase_id':firebase_id,
      'name':name,
      'email':email,
    }).then((value) {
      print(value.data);
      emit(postUserSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(postUserErrorState());
    });
  }

}