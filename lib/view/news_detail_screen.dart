import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  String? image;
  String? title;
  String? source;
  String? dateTime;
  String? description;
  NewsDetailScreen(
      this.image, this.title, this.source, this.dateTime, this.description,
      {super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = DateFormat('MM dd,yyyy');
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.dateTime.toString());
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(children: [
          Container(
            height: height * .5,
            width: width,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(20)),
              child: CachedNetworkImage(
                // height: height * .43,
                imageUrl: widget.image.toString(),
                fit: orientation == Orientation.landscape
                    ? BoxFit.contain
                    : BoxFit.fill,
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
          ),
          Container(
            height: orientation == Orientation.landscape
                ? height * .6
                : height * .4,
            margin: EdgeInsets.only(top: height * .48),
            padding: EdgeInsets.all(width * 0.03),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    widget.title.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: orientation == Orientation.landscape ? 10 : 15,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.source.toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        format.format(dateTime),
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Text(
                    widget.description.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          )
        ]));
  }
}
