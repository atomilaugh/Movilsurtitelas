import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movilsurtitela/domain/usecases/get_users.dart';
import 'package:movilsurtitela/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;

  UserBloc({required this.getUsers}) : super(UserInitial()) {
    on<GetUsersEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await getUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}