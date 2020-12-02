part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataStateLoading extends DataState {}

class DataStateEmpty extends DataState {}

class DataStateLoadSuccess extends DataState {
  final List<Tweets> tweets;
  final bool hasMoreData;

  const DataStateLoadSuccess(this.tweets, this.hasMoreData);

  @override
  List<Object> get props => [tweets];
}
