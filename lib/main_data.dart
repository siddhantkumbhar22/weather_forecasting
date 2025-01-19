import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecasting/loader/data_loader.dart';
import 'package:weather_forecasting/providers/data_provider.dart';
import 'package:weather_forecasting/providers/list_provider.dart';
import 'package:weather_forecasting/utils/constants.dart';
import 'package:weather_forecasting/utils/functions.dart';

import 'error.dart';
import 'model/location.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, _) {
      if (dataProvider.isLoading) {
        return const DataLoader();
      }
      if (dataProvider.dataLoaded) {
        return Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top:16.0,right: 16.0,left:16.0),
                child: TypeAheadField<LocationItem>(
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search City',
                        hintStyle:
                        const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 2.0,
                          ),
                        ),
                      ),
                    );
                  },
                  suggestionsCallback: (pattern) async {
                    if (pattern.isEmpty) {
                      return [];
                    }
                    return await Functions.search(
                        pattern.toLowerCase());
                  },
                  itemBuilder: (context, LocationItem suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                      subtitle: Text(
                        '${suggestion.country}${suggestion.state != null ? ' - ${suggestion.state}' : ''}',
                      ),
                    );
                  },
                  onSelected: (LocationItem value) {
                    context.read<DataProvider>().search(
                        value.lat.toString(),
                        value.lon.toString(),
                        value.name);
                    context.read<ListProvider>().search(
                        value.lat.toString(), value.lon.toString());
                  },
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Fahrenheit',
                    style: TextStyle(
                        fontSize: 10, color: Colors.white),
                  ),
                  Switch(
                    activeColor: Colors.white,
                    value: dataProvider.isCelsius,
                    onChanged: (value) {
                      context.read<DataProvider>().changeUnit();
                      context.read<ListProvider>().changeUnit();
                    },
                  ),
                  const Text(
                    'Celsius',
                    style: TextStyle(
                        fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                height: 200,
                child: Stack(
                  children: [
                    Positioned(
                      top: 20.0,
                      left: 20.0,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(dataProvider.greetings,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 40,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white)),
                          Text(
                            dataProvider.date,
                            style: const TextStyle(
                                color: Colors.black45),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -20.0,
                      right: -20.0,
                      child: Image.network(
                        '${Constants.imgUrl}/img/wn/${dataProvider.weather!.weather[0].icon}@4x.png',
                        loadingBuilder: (BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress
                                  .expectedTotalBytes !=
                                  null
                                  ? loadingProgress
                                  .cumulativeBytesLoaded /
                                  (loadingProgress
                                      .expectedTotalBytes ??
                                      1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (BuildContext context,
                            Object error, StackTrace? stackTrace) {
                          return const Icon(Icons.error,
                              size: 50, color: Colors.red);
                        },
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          dataProvider.cityName,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          dataProvider
                              .weather!.weather[0].description,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                        Text(
                          dataProvider.temperature,
                          style: const TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          "Humidity: ${dataProvider.weather!.main.humidity}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ])),
            ),
          ],
        );
      }
      if (dataProvider.hasError) {
        return ErrorMsg(errorMsg: dataProvider.errorMessage,height: 400,);
      } else {
        return ErrorMsg(errorMsg: dataProvider.errorMessage,height: MediaQuery.of(context).size.height,);
      }
    });
  }
}
