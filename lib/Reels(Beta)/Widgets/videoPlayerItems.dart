import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:transfer_news/Forum/Widgets/profileAvatar.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:transfer_news/Pages/home.dart';
import 'package:transfer_news/Reels(Beta)/CommentsPage.dart';
import 'package:transfer_news/Reels(Beta)/Widgets/Logics.dart';

class VideoPlayerItems extends ChangeNotifier {
  Widget topHeader(
      String userInfo, String userName, time, videos, context, ownerID) {
    final String currentUserOnlineId = currentUser?.id;
    bool isPostOwner = currentUserOnlineId == ownerID;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Row(
            children: [
              ProfileAvatar(
                imageUrl: userInfo,
                hasBorder: true,
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${tAgo.format(
                        time.toDate(),
                      )}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              currentUser.isAdmin == true || isPostOwner
                  ? GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        ReelsLogic().modalBottomSheetMenu(videos, context);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[900],
                        ),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  Widget footer(String id, likes, comments, context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 25,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                ReelsLogic().likes(id);
              },
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[900],
                    ),
                    child: Unicon(
                      UniconData.uniFire,
                      color: likes.contains(currentUser.id)
                          ? Colors.blue
                          : Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Row(
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            child: child,
                            scale: animation,
                          );
                        },
                        child: Text(
                          '${NumberFormat.compact().format(likes.length)} ',
                          key: ValueKey<String>(
                              '${NumberFormat.compact().format(likes.length)} '),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(
                        'Votes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                pushNewScreen(
                  context,
                  withNavBar: false,
                  customPageRoute: MorpheusPageRoute(
                    builder: (context) => ReelsCommentsPage(
                      postId: id,
                    ),
                    transitionDuration: Duration(
                      milliseconds: 200,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[900],
                    ),
                    child: Unicon(
                      UniconData.uniComment,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "${NumberFormat.compact().format(comments)} Comments",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget caption(String caption) {
    return Positioned(
      top: 80,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Text(
          caption,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
