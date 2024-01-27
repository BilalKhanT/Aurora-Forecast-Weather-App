import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/model/weather_model.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/services/api_service.dart';
import 'package:location/location.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  var lat;
  var lang;
  HomeScreen({
    required this.lat,
    required this.lang,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<WeatherModel> weather;
  late Future<LocationData> location;
  String searchBarText = 'Select a location';
  bool isDarkMode = false;
  var searchController = TextEditingController();
  List<String> cities = [
    'Current location',
    'London',
    'Karachi',
    'Islamabad',
    'Lahore',
    'Karachi',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta',
    'Sialkot',
    'Gujranwala',
    'Bahawalpur',
    'Sargodha',
    'Sukkur',
    'Jhelum',
    'Gujrat',
    'Abbottabad',
    'Sahiwal',
    'Mardan',
    'Larkana',
    'Sheikhupura',
    'Mirpur Khas',
    'Rahim Yar Khan',
    'Kohat',
    'Jhang',
    'Dera Ghazi Khan',
    'Okara',
    'Mingora',
    'Chiniot',
    'Nawabshah',
    'Korangi',
    'Hub',
    'Dera Ismail Khan',
    'Charsadda',
    'Kamalia',
    'Layyah',
    'Tando Adam',
    'Khuzdar',
    'Jacobabad',
    'Shikarpur',
    'New York',
    'Tokyo',
    'Paris',
    'Los Angeles',
    'Berlin',
    'Sydney',
    'Beijing',
    'Moscow',
    'Rio de Janeiro',
    'Toronto',
    'Mumbai',
    'Istanbul',
    'Dubai',
    'Seoul',
    'Bangkok',
    'Singapore',
    'Rome',
    'Barcelona',
    'Amsterdam',
    'Stockholm',
    'Copenhagen',
    'Athens',
    'Prague',
    'Vienna',
    'Buenos Aires',
    'Lisbon',
    'Warsaw',
    'Oslo',
    'Helsinki',
    'Zurich',
    'Dublin',
    'Brussels',
    'Brasília',
    'Budapest',
    'Vancouver',
    'Montreal',
    'Edinburgh',
    'Auckland',
    'Wellington',
    'Jerusalem',
    'Hanoi',
    'Lima',
    'Kuala Lumpur',
    'Mexico City',
    'Nairobi',
    'Osaka',
    'Manila',
    'San Francisco',
    'San Diego',
    'Miami',
    'Chicago',
    'Houston',
    'Dallas',
    'Phoenix',
    'Philadelphia',
    'Boston',
    'Seattle',
    'Denver',
    'Detroit',
    'Atlanta',
    'Toronto',
    'Vancouver',
    'Montreal',
    'Calgary',
    'Ottawa',
    'Quebec City',
    'Winnipeg',
    'Halifax',
  ];

  String formatDateWithAmPm(DateTime dateTime) {
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    weather = getWeatherData(widget.lat, widget.lang);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 20.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 450),
                  curve: Curves.easeInOut,
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: isDarkMode
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isDarkMode
                                ? Icons.nightlight_round
                                : Icons.wb_sunny,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                          toggleDarkMode();
                        },
                        child: Align(
                          alignment: isDarkMode
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDarkMode
                                  ? Colors.grey.withOpacity(0.4)
                                  : Colors.grey.shade400.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<WeatherModel>(
        future: weather,
        builder: (BuildContext context,
            AsyncSnapshot<WeatherModel> weatherSnapshot) {
          if (weatherSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (weatherSnapshot.hasError) {
            return Center(child: Text('Error: ${weatherSnapshot.error}'));
          } else if (weatherSnapshot.hasData) {
            WeatherModel weatherData = weatherSnapshot.data!;
            double kelvinTemperature =
                (weatherData.mainData["temp"] ?? 0.0) as double;
            double celsiusTemperature = kelvinTemperature - 273.15;
            double feelslikeTemperature =
                (weatherData.mainData["feels_like"] ?? 0.0) as double;
            double celfeelslikeTemperature = feelslikeTemperature - 273.15;
            double minTemperature =
                (weatherData.mainData["temp_min"] ?? 0.0) as double;
            double celMinTemperature = minTemperature - 273.15;
            double maxTemperature =
                (weatherData.mainData["temp_max"] ?? 0.0) as double;
            double celMaxTemperature = maxTemperature - 273.15;
            var windSpeed = (weatherData.windData["speed"] ?? 0);
            double speedKmh = windSpeed * 3.6;
            DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(
                weatherData.sysData["sunrise"] * 1000);
            DateTime sunset = DateTime.fromMillisecondsSinceEpoch(
                weatherData.sysData["sunset"] * 1000);
            String formattedSunrise = formatDateWithAmPm(sunrise);
            String formattedSunset = formatDateWithAmPm(sunset);

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: screenWidth - 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Welcome to',
                          style: GoogleFonts.syne(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 33,
                            letterSpacing: 1,
                          ),),
                          Text('Aurora Forecast',
                            style: GoogleFonts.syne(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              letterSpacing: 1,
                            ),),
                          SizedBox(height: 20.0,),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                            width: screenWidth - 50,
                            child: TextField(
                              controller: searchController,
                              readOnly: true,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                fillColor: Theme.of(context)
                                    .colorScheme.outline,
                                filled: true,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: DropdownButton(
                                    underline: Container(),
                                    borderRadius: BorderRadius.circular(15.0),
                                    dropdownColor: Theme.of(context)
                                        .colorScheme
                                        .outline.withOpacity(0.6),
                                    onChanged: (String? newValue) {
                                      if (newValue == 'Current location'){
                                        setState(() {
                                          weather = getWeatherData(widget.lat, widget.lang);
                                          searchBarText = 'Select a location';
                                        });
                                      }
                                      else{
                                        setState(() {
                                          weather = getWeatherDataByCity(newValue);
                                          searchBarText = newValue!;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.tune_outlined),
                                    iconEnabledColor: Theme.of(context)
                                        .colorScheme.primary,
                                    items:
                                      cities.map((String city) {
                                        return DropdownMenuItem(
                                          value: city,
                                          child: Text(
                                            city,
                                            style: GoogleFonts.poppins(), // Apply your font style
                                          ),
                                        );
                                      }).toList(),
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Theme.of(context)
                                      .colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "${searchBarText}",
                                hintStyle: GoogleFonts.poppins(
                                  color: Theme.of(context)
                                      .colorScheme.secondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${celsiusTemperature.toStringAsFixed(0)}°",
                                    style: GoogleFonts.poppins(
                                      fontSize: 40,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.0001,
                                  ),
                                  Text(
                                    "${weatherData.weatherData[0]["main"]}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        weatherData.locationName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.0001,
                                  ),
                                  Text(
                                    "${celMinTemperature.toStringAsFixed(0)}° / ${celMaxTemperature.toStringAsFixed(0)}° Feels like ${celfeelslikeTemperature.toStringAsFixed(0)}°",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/cloud.gif",
                                height: screenHeight * 0.3,
                                width: screenWidth * 0.4,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: screenWidth - 40,
                          height: screenHeight * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: screenHeight * 0.15,
                                      width: screenWidth - 250,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        borderRadius:
                                            BorderRadius.circular(15.5),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Image.asset(
                                              "assets/pressure_img.webp",
                                              height: screenHeight * 0.05,
                                              width: screenWidth * 0.15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Pressure",
                                            style: GoogleFonts.poppins(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${weatherData.mainData["pressure"]} hPa",
                                            style: GoogleFonts.poppins(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: screenHeight * 0.15,
                                      width: screenWidth - 250,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        borderRadius:
                                            BorderRadius.circular(15.5),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Image.asset(
                                              "assets/humidity_img.png",
                                              height: screenHeight * 0.05,
                                              width: screenWidth * 0.15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Humidity",
                                            style: GoogleFonts.poppins(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${weatherData.mainData["humidity"]}%",
                                            style: GoogleFonts.poppins(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: screenHeight * 0.15,
                                      width: screenWidth - 250,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        borderRadius:
                                            BorderRadius.circular(15.5),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Image.asset(
                                              "assets/wind_img.png",
                                              height: screenHeight * 0.05,
                                              width: screenWidth * 0.15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Wind",
                                            style: GoogleFonts.poppins(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${speedKmh.toStringAsFixed(0)} km/h",
                                            style: GoogleFonts.poppins(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: screenHeight * 0.15,
                                      width: screenWidth - 250,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        borderRadius:
                                            BorderRadius.circular(15.5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: Image.asset(
                                                  "assets/sunrise_img.png",
                                                  height: screenHeight * 0.05,
                                                  width: screenWidth * 0.1,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Sunrise",
                                                style: GoogleFonts.poppins(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${formattedSunrise}",
                                                style: GoogleFonts.poppins(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: Image.asset(
                                                  "assets/sunset_img.png",
                                                  height: screenHeight * 0.05,
                                                  width: screenWidth * 0.1,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Sunset",
                                                style: GoogleFonts.poppins(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${formattedSunset}",
                                                style: GoogleFonts.poppins(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ));
  }
}
