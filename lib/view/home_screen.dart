import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/model/categories_news_model.dart';
import 'package:news/model/news_model.dart';
import 'package:news/view/categories_screen.dart';
import 'package:news/view/news_detail_screen.dart';
import 'package:news/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

NewsViewModel newsViewModel = NewsViewModel();

enum filterList {
  Al_Jazeera,
  Associated_Press,
  BBC,
}

class _HomeScreenState extends State<HomeScreen> {
  filterList? selectedMenue;
  final format = DateFormat('MM dd,yyyy');
  String? name = 'al-jazeera-english';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoriesScreen()));
            },
            icon: Image.asset(
              'images/category_icon.png',
              height: width * 0.05,
              width: width * 0.05,
            )),
        title: Text(
          'News',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          PopupMenuButton<filterList>(
            onSelected: (filterList item) {
              if (filterList.Al_Jazeera.name == item.name) {
                name = 'al-jazeera-english';
              }
              if (filterList.Associated_Press.name == item.name) {
                name = 'associated-press';
              }
              if (filterList.BBC.name == item.name) {
                name = 'bbc_news';
              }

              setState(() {
                selectedMenue = item;
              });
            },
            icon: const Icon(Icons.more_vert, color: Colors.black),
            initialValue: selectedMenue,
            itemBuilder: (context) => <PopupMenuEntry<filterList>>[
              const PopupMenuItem(
                  value: filterList.Al_Jazeera, child: Text('Al_Jazeera')),
              const PopupMenuItem(
                  value: filterList.Associated_Press,
                  child: Text('Associated Press')),
              const PopupMenuItem(value: filterList.BBC, child: Text('BBC')),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: height * .45,
            // color: const Color.fromARGB(75, 211, 247, 144),
            child: FutureBuilder<NewsModel>(
              future: newsViewModel.fetching(name.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitThreeInOut(
                      color: Colors.blue.shade400,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(
                                    snapshot.data!.articles![index].urlToImage
                                        .toString(),
                                    snapshot.data!.articles![index].title
                                        .toString(),
                                    snapshot.data!.articles![index].source!.name
                                        .toString(),
                                    dateTime.toString(),
                                    snapshot.data!.articles![index].description
                                        .toString(),
                                  )));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: width * .9,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * .01),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    // height: height * .43,
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: orientation == Orientation.landscape
                                        ? BoxFit.contain
                                        : BoxFit.fill,
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.amber,
                                        ),
                                        Text(
                                          error.toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: height * .01,
                              right: height * .01,
                              child: Card(
                                color: const Color.fromARGB(230, 247, 246, 244),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  height: orientation == Orientation.landscape
                                      ? height * .17
                                      : height * .13,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.7,
                                          child: Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: orientation ==
                                                      Orientation.landscape
                                                  ? 10
                                                  : 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: width * .7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: orientation ==
                                                          Orientation.landscape
                                                      ? 12
                                                      : 15,
                                                ),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: orientation ==
                                                          Orientation.landscape
                                                      ? 12
                                                      : 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          FutureBuilder<CategoriesNewsModel>(
            future: newsViewModel.fetchingCategories('General'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitThreeInOut(
                    color: Colors.blue.shade400,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return Container(
                  height: orientation == Orientation.landscape
                      ? height * .45
                      : height * .65,
                  child: ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(
                                      snapshot
                                          .data!.articles![index].urlToImage,
                                      snapshot.data!.articles![index].title,
                                      snapshot
                                          .data!.articles![index].source!.name,
                                      dateTime.toString(),
                                      snapshot.data!.articles![index]
                                          .description)));
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                height: height * .18,
                                width: orientation == Orientation.landscape
                                    ? width * .18
                                    : width * .3,
                                imageUrl: snapshot
                                    .data!.articles![index].urlToImage
                                    .toString(),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Column(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      error.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                height: height * .18,
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.data!.articles![index].title
                                          .toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: orientation ==
                                                  Orientation.landscape
                                              ? 10
                                              : 15),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        Text(
                                          format.format(dateTime),
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
