// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:ecommerce_app/core/error/failure.dart';
// import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
// import 'package:ecommerce_app/features/chat/domain/usecases/get_users.dart';

// part 'user_event.dart';
// part 'user_state.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final GetUsers getUsers;

//   UserBloc({required this.getUsers}) : super(UserInitial()) {
//     on<LoadUsersEvent>(_onLoadUsers);
//     on<SearchUsersEvent>(_onSearchUsers);
//   }

//   Future<void> _onLoadUsers(
//     LoadUsersEvent event,
//     Emitter<UserState> emit,
//   ) async {
//     try {
//       emit(UserLoading());
      
//       final result = await getUsers(NoParams());
      
//       result.fold(
//         (failure) => emit(UserError(message: _mapFailureToMessage(failure))),
//         (users) => emit(UsersLoaded(users: users)),
//       );
//     } catch (e) {
//       emit(UserError(message: 'An unexpected error occurred'));
//     }
//   }

//   Future<void> _onSearchUsers(
//     SearchUsersEvent event,
//     Emitter<UserState> emit,
//   ) async {
//     final currentState = state;
//     if (currentState is UsersLoaded) {
//       final filteredUsers = currentState.users.where((user) =>
//           user.name.toLowerCase().contains(event.query.toLowerCase()) ||
//           user.email.toLowerCase().contains(event.query.toLowerCase()));
      
//       emit(UsersLoaded(users: filteredUsers.toList()));
//     }
//   }

//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure _:
//         return 'Server error occurred';
//       case NetworkFailure _:
//         return 'No internet connection';
//       case CacheFailure _:
//         return 'Local data error';
//       default:
//         return 'Unexpected error';
//     }
//   }
// }