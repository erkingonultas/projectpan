import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/backend/models/event_models.dart';

class ConcertFullPage extends StatefulWidget {
  const ConcertFullPage({Key? key}) : super(key: key);

  @override
  State<ConcertFullPage> createState() => _ConcertFullPageState();
}

class _ConcertFullPageState extends State<ConcertFullPage> {
  late Dio _dio;
  bool _isLoading = false;
  late EventModel eventModel;
  bool _isFetched = false;
  final List<Events> _concerts = [];
  late final Image _performerImg;

  Future getInfo() async {
    try {
      setState(() {
        _isLoading = true;
      });
      //final Response response = await _httpService.getRequest('/events?venue.state=NY');
      //final Response response = await _dio.get('https://api.seatgeek.com/2/events?venue.state=NY&client_id=MjY3NzA0MTB8MTY1MTI1MTQwOS4wNTAzNTY');
      //print(response.data);
      dynamic response = await rootBundle.loadString('assets/anim/call.json');
      //response = jsonDecode(response);
      response = await json.decode(response);
      //eventModel = EventModel.fromJson(response.data);
      eventModel = EventModel.fromJson(response);

      for (var i = 0; i < eventModel.events!.length; i++) {
        if (eventModel.events![i].type == 'concert') {
          _concerts.add(eventModel.events![i]);
        }
      }
      _performerImg = Image.network(
          _concerts[0].performers![0].genres![3].images!.ipadEventModal!,
          fit: BoxFit.cover);
      setState(() {});
      print('@@@@@@@ VENUE NAME: ${eventModel.events![0].venue!.name}');

      // if (response.statusCode != 200) {
      //   if (kDebugMode) {
      //     print('@@@ status code error');
      //     print(response.statusCode);
      //   }
      // }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      _isLoading = false;
      _isFetched = true;
    });
  }

//   late Dio _dio;

  @override
  void initState() {
    _dio = Dio();
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: botticelli,
        body: _isFetched
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      BackButton(
                        color: ebonyclay,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      Text(
                        _concerts[0].performers![0].name!,
                        style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            color: woodsmoke),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: size.height * .55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: botticelli.withOpacity(.15)),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: _performerImg,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0)
                        .copyWith(top: 0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 28,
                          color: woodsmoke,
                        ),
                        const SizedBox(width: 10),
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '${_concerts[0].venue!.name!}\n',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: woodsmoke),
                              ),
                              TextSpan(
                                text: _concerts[0].venue!.displayLocation!,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: woodsmoke),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 15.0)
                        .copyWith(top: 0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.date_range_rounded,
                          color: woodsmoke,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _concerts[0].datetimeLocal!,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: woodsmoke),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: woodsmoke,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  Icons.share,
                                  color: botticelli,
                                ),
                                SizedBox(width: 12),
                                Text('Share',
                                    style: TextStyle(
                                        color: botticelli,
                                        fontWeight: FontWeight.w100)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: woodsmoke,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  Icons.bookmark_outline_rounded,
                                  color: botticelli,
                                  size: 32,
                                ),
                                SizedBox(width: 12),
                                Text('Mark as\nInterested',
                                    style: TextStyle(
                                        color: botticelli,
                                        fontWeight: FontWeight.w100),
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Text('Comments',
                        style: TextStyle(
                            color: woodsmoke,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : Center(
                child: GestureDetector(
                  onTap: () {
                    getInfo();
                  },
                  child: _isLoading
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator.adaptive())
                      : const Text(
                          'Concerts',
                          style: TextStyle(fontSize: 21),
                        ),
                ),
              ),
      ),
    );
  }
}
