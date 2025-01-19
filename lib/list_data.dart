import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecasting/loader/list_loader.dart';
import 'package:weather_forecasting/providers/list_provider.dart';
import 'package:weather_forecasting/utils/constants.dart';

import 'error.dart';

class ListWeatherData extends StatelessWidget {
  const ListWeatherData({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListProvider>(builder: (context, dataProvider, _) {
      if (dataProvider.listLoading) {
        return const ListLoader();
      }
      if (dataProvider.listLoaded && dataProvider.forecastResponse != null) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: SizedBox(
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Last 3 days weather forecast",
                  maxLines: 1,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: dataProvider.list.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = dataProvider.list[index];

                      return Container(
                        width: 150,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Weather icon
                            Image.network(
                              "${Constants.imgUrl}/img/wn/${item.icon}@2x.png",
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
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
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return const Icon(Icons.error,
                                    size: 50, color: Colors.red);
                              },
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 8),
                            // Temperature
                            Text(
                              item.temp,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            // Description
                            Text(
                              item.description,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              item.date,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 10,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (dataProvider.hasError) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Last 3 days weather forecast",
              maxLines: 1,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            ErrorMsg(errorMsg: dataProvider.errorMessage, height: 200.0),
          ],
        );
      }
      return const SizedBox();
    });
  }
}
