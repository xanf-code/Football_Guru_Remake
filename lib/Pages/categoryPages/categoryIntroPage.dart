import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transfer_news/Pages/categoryPages/Widget/categoryNewsWidget.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF0e0e10),
        appBar: AppBar(
          backgroundColor: Color(0xFF0e0e10),
          title: Text("Categories"),
        ),
        body: AnimationLimiter(
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 700),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        TopicName(
                          topic: "Trending News ⚡",
                        ),
                        Container(
                          height: 260,
                          child: ListView(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 101,
                                        title: "Indian Super League",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "Indian Super League",
                                  image:
                                      "https://lh3.googleusercontent.com/NNu2BXmV8ICziHp9ThuSt24KxYz8SGEmOFaLQ7Y3KXyl67kOdW_O_08zqqyvTYZbauFkGOWoOyjRafn2NILfaWD53A",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 95,
                                        title: "I-League",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "I-League",
                                  image:
                                      "https://www.mykhel.com/img/400x90/2016/12/ileague-21-1482306774.jpg",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 133,
                                        title: "Indian National Team",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://khelnow-legacy.s3.ap-south-1.amazonaws.com/uploads/team/profile_pic/large/4713962850_8940637521.jpg",
                                  text: "National Team",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 149,
                                        title: "Women's National Team",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://images.newindianexpress.com/uploads/user/imagelibrary/2019/7/13/w900X450/Indian_WOmen.jpg",
                                  text: "Women's Team",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 142,
                                        title: "Interview",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "Interview",
                                  image:
                                      "https://i.pinimg.com/originals/2b/e3/33/2be33377594e0fb52fa4056dda248911.jpg",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 147,
                                        title: "Transfer News",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "Transfer News",
                                  image:
                                      "https://pbs.twimg.com/profile_images/1266494177984090112/rEjgb7a6_400x400.jpg",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 211,
                                        title: "Featured",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://pbs.twimg.com/profile_images/1011321411363901440/h9VzxMT_.jpg",
                                  text: "Featured",
                                ),
                              ),
                            ],
                          ),
                        ),
                        TopicName(
                          topic: "Indian Super League 🏆",
                        ),
                        Container(
                          height: 260,
                          child: ListView(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 259,
                                        title: "ATK Mohun Bagan FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "ATK Mohun Bagan FC",
                                  image:
                                      "https://static.toiimg.com/thumb/msid-78984643,width-1200,height-900,resizemode-4/.jpg",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 260,
                                        title: "Bengaluru FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "Bengaluru FC",
                                  image:
                                      "https://ss.thgim.com/football/article30810548.ece/alternates/FREE_380/bengaluru-fcjpg",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 261,
                                        title: "Chennaiyin FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://static.toiimg.com/photo/59576319.cms",
                                  text: "Chennaiyin FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 262,
                                        title: "FC Goa",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "FC Goa",
                                  image:
                                      "https://sportstar.thehindu.com/football/article32326469.ece/ALTERNATES/LANDSCAPE_1200/FC-GOA",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 263,
                                        title: "Hyderabad FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "Hyderabad FC",
                                  image:
                                      "https://images.news18.com/ibnlive/uploads/2020/08/1597146968_hyderabad-fc-logo.png",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 264,
                                        title: "Jamshedpur FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://timesofindia.indiatimes.com/thumb/msid-78009055,imgsize-125963,width-400,resizemode-4/78009055.jpg",
                                  text: "Jamshedpur FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 265,
                                        title: "Kerala Blasters FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://static.toiimg.com/thumb/msid-77700605,width-1200,height-900,resizemode-4/.jpg",
                                  text: "Kerala Blasters FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 266,
                                        title: "Mumbai City FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTGrLmkxyuZvb81BOHmshmoMFrczCbJX4KxWw&usqp=CAU",
                                  text: "Mumbai City FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 267,
                                        title: "NortEast United FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://static.toiimg.com/photo/59576509.cms",
                                  text: "NorthEast United FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 268,
                                        title: "Odisha FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2019/09/odisha-fc-1568569221.jpg",
                                  text: "Odisha FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 1774,
                                        title: "SC East Bengal",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://thebridge.in/wp-content/uploads/2020/10/sc-eb-696x364.jpg",
                                  text: "SC East Bengal",
                                ),
                              ),
                            ],
                          ),
                        ),
                        TopicName(
                          topic: "I-League 🏆",
                        ),
                        Container(
                          height: 260,
                          child: ListView(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 2034,
                                        title: "Aizawl FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "Aizawl FC",
                                  image:
                                      "https://www.india.com/wp-content/uploads/2017/05/aizawl-fc.jpg",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 2035,
                                        title: "Chennai City FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "Chennai City FC",
                                  image:
                                      "https://pbs.twimg.com/profile_images/1154273627300233216/5KMvGotq.jpg",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 2036,
                                        title: "Churchill Brothers FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://static.toiimg.com/thumb/msid-74139033,width-1070,height-580,imgsize-192896,resizemode-75,overlay-toi_sw,pt-32,y_pad-40/photo.jpg",
                                  text: "Churchill Brothers FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 1844,
                                        title: "Gokulam Kerala FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "Gokulam Kerala FC",
                                  image:
                                      "https://english.cdn.zeenews.com/sites/default/files/styles/zm_700x400/public/2020/07/24/874628-gokulamfclogo.jpg",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 2037,
                                        title: "Indian Arrows",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  text: "Indian Arrows",
                                  image:
                                      "https://upload.wikimedia.org/wikipedia/en/0/0c/Official_Indian_Arrows_Logo.png",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 2038,
                                        title: "Mohammedan SC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://assets.sentinelassam.com/h-upload/2020/07/10/143184-mohammedan.webp?w=400&dpr=2.6",
                                  text: "Mohammedan SC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 2039,
                                        title: "NEROCA FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://upload.wikimedia.org/wikipedia/en/5/5a/Official_NEROCA_FC_Logo.png",
                                  text: "NEROCA FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 2040,
                                        title: "Punjab FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://upload.wikimedia.org/wikipedia/en/thumb/f/f6/RoundGlass_Punjab_FC_logo.svg/1200px-RoundGlass_Punjab_FC_logo.svg.png",
                                  text: "Punjab FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 2041,
                                        title: "Real Kashmir FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://a.espncdn.com/i/teamlogos/soccer/500/19341.png",
                                  text: "Real Kashmir FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 1926,
                                        title: "Sudeva FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://upload.wikimedia.org/wikipedia/en/9/9c/Sudeva_Moonlight_F.C._logo.jpg",
                                  text: "Sudeva FC",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => CategoryNewsWidget(
                                        catID: 2042,
                                        title: "TRAU FC",
                                      ),
                                    ),
                                  );
                                },
                                child: CategoryWidget(
                                  image:
                                      "https://upload.wikimedia.org/wikipedia/en/f/f7/Official_TRAU_FC_Logo.png",
                                  text: "TRAU FC",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class TopicName extends StatelessWidget {
  final String topic;
  const TopicName({
    Key key,
    this.topic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 8,
          ),
          child: Text(
            topic,
            style: GoogleFonts.oxygen(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            bottom: 15,
            top: 3,
          ),
          child: Container(
            height: 3,
            width: MediaQuery.of(context).size.width / 8,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String text;
  final String image;
  const CategoryWidget({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 195,
            width: 185,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.dstATop),
                image: CachedNetworkImageProvider(
                  image,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Text(
              text,
              style: GoogleFonts.cabin(
                color: Colors.grey[200],
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
