// part of 'user_bloc.dart';

// sealed class UserState extends Equatable {
//   const UserState();

//   @override
//   List<Object> get props => [];
// }

// class UserInitial extends UserState {}

// class UserLoading extends UserState {}

// class UsersLoaded extends UserState {
//   final List<User> users;
  
//   const UsersLoaded({required this.users});

//   @override
//   List<Object> get props => [users];
// }

// class UserError extends UserState {
//   final String message;
  
//   const UserError({required this.message});

//   @override
//   List<Object> get props => [message];
// }