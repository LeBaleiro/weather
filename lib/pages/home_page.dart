import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/api_request/models/api_response_model.dart';
import 'package:weather/api_request/repository/weather_request.dart';
import 'package:weather/theme.dart';
import 'package:weather/widgets/circular_button.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final weatherRequest = WeatherRequest();
  bool isSearching = false;
  VideoPlayerController _controllerRain;
  ApiResponseModel apiResponse = ApiResponseModel();
  bool isRaining = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {});
    _controllerRain = VideoPlayerController.asset("assets/300.mp4")
      ..initialize().then((_) {
        _controllerRain.play();
        _controllerRain.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controllerRain.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appTheme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFD76591),
          title: Text('Weather now'),
        ),
        body: Stack(
          children: [
            isRaining
                ? SizedBox.expand(
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return RadialGradient(
                          center: Alignment.topLeft,
                          radius: 1.0,
                          colors: <Color>[
                            Colors.grey.withOpacity(0.6),
                            Colors.white.withOpacity(.8)
                          ],
                          tileMode: TileMode.mirror,
                        ).createShader(bounds);
                      },
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: SizedBox(
                            width: _controllerRain?.value?.size?.width ?? 0,
                            height: _controllerRain?.value?.size?.height ?? 0,
                            child: VideoPlayer(_controllerRain),
                          )),
                    ),
                  )
                : Container(
                    color: Color(0xFFFFF9EF),
                  ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 24.0, left: 24.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isSearching
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 280,
                                      child: TextFormField(
                                        controller: textEditingController,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          labelText: "Insert the city name",
                                          labelStyle:
                                              appTheme.textTheme.headline1,
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFFD9B6A),
                                                  width: 1)),
                                        ),
                                        style: appTheme.textTheme.headline1,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        final response = await weatherRequest
                                            .getWeatherByCityName(
                                                textEditingController.text);
                                        setState(() {
                                          apiResponse = response;
                                          isSearching = false;
                                          if (apiResponse?.weather[0].id >=
                                                  500 &&
                                              apiResponse?.weather[0].id <
                                                  600) {
                                            isRaining = true;
                                          } else {
                                            isRaining = false;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 36,
                                        width: 280,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFD76591),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFE4E5E6),
                                                blurRadius: 10,
                                              )
                                            ]),
                                        child: Center(
                                          child: Text(
                                            'Search',
                                            style: appTheme.textTheme.button,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  apiResponse?.name?.toUpperCase() ??
                                      'Search by city name \nor location',
                                  style: isRaining
                                      ? appTheme.textTheme.headline4
                                      : appTheme.textTheme.caption,
                                ),
                          isSearching
                              ? CircularButton(
                                  icon: Icons.close,
                                  onTap: () {
                                    setState(() {
                                      isSearching = !isSearching;
                                    });
                                  },
                                )
                              : CircularButton(
                                  icon: Icons.search,
                                  onTap: () {
                                    setState(() {
                                      isSearching = !isSearching;
                                    });
                                  },
                                ),
                        ],
                      ),
                      SizedBox(height: 30),
                      CircularButton(
                        icon: Icons.location_on,
                        onTap: () async {
                          Position position = await getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high);
                          final response =
                              await weatherRequest.getWeatherByCoordinates(
                                  position.latitude.toString(),
                                  position.longitude.toString());
                          setState(() {
                            apiResponse = response;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            apiResponse?.main?.temp != null
                                ? (apiResponse?.main?.temp - 273.15)
                                    .round()
                                    .toString()
                                : '- -',
                            style: isRaining
                                ? appTheme.textTheme.bodyText1
                                : appTheme.textTheme.headline3,
                          ),
                          Text(
                            'ºC Temperature',
                            style: isRaining
                                ? appTheme.textTheme.bodyText2
                                : appTheme.textTheme.headline2,
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            apiResponse?.main?.humidity?.toString() ?? '- -',
                            style: isRaining
                                ? appTheme.textTheme.bodyText1
                                : appTheme.textTheme.headline3,
                          ),
                          Text(
                            '% Humidity',
                            style: isRaining
                                ? appTheme.textTheme.bodyText2
                                : appTheme.textTheme.headline2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
