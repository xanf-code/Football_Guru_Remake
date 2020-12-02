import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfer_news/RealTime/bloc/model.dart';
import 'package:transfer_news/RealTime/bloc/repository.dart';

part 'data_events.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataStateLoading());

  List<StreamSubscription> subscriptions = [];
  List<List<Tweets>> tweets = [];
  bool hasMoreData = true;
  DocumentSnapshot lastDoc;

  handleStreamEvent(int index, QuerySnapshot snap) {
    if (snap.docs.length < 15) {
      hasMoreData = false;
    }

    if (snap.docs.isEmpty) return;

    if (index == tweets.length) {
      lastDoc = snap.docs[snap.docs.length - 1];
    }
    List<Tweets> newList = [];
    snap.docs.forEach((doc) {
      newList.add(Tweets.fromSnapshot(doc.data()));
    });
    if (tweets.length <= index) {
      tweets.add(newList);
    } else {
      tweets[index].clear();
      tweets[index] = newList;
    }
    add(DataEventLoad(tweets));
  }

  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    if (event is DataEventStart) {
      hasMoreData = true;
      lastDoc = null;
      subscriptions.forEach((sub) {
        sub.cancel();
      });
      tweets.clear();
      subscriptions.clear();
      subscriptions.add(PostRepository.instance.getPosts().listen((event) {
        handleStreamEvent(0, event);
      }));
      add(DataEventLoad(tweets));
    }

    if (event is DataEventLoad) {
      final elements = tweets.expand((i) => i).toList();

      if (elements.isEmpty) {
        yield DataStateEmpty();
      } else {
        yield DataStateLoadSuccess(elements, hasMoreData);
      }
    }

    if (event is DataEventFetchMore) {
      if (lastDoc == null) {
        throw Exception("Last doc is not set");
      }
      final index = tweets.length;
      subscriptions
          .add(PostRepository.instance.getPostsPage(lastDoc).listen((event) {
        handleStreamEvent(index, event);
      }));
    }
  }

  @override
  onChange(change) {
    print(change);
    super.onChange(change);
  }

  @override
  Future<void> close() async {
    subscriptions.forEach((s) => s.cancel());
    super.close();
  }
}
