import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/Cubits/weather_cubit/weather_cubit.dart';
import 'package:weather_app/Cubits/weather_cubit/weather_state.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/search_page.dart';



class HomePage extends StatelessWidget {


  WeatherModel? weatherData;
  @override
  Widget build(BuildContext context) {


    return
      Scaffold(
      appBar:
      AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchPage(

                );
              }));
            },
            icon: Icon(Icons.search),
          ),
        ],
        title: Text('Weather App'),
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
         builder: (BuildContext context, state) {

           if(state is WeatherLoading){
             return Center(child: CircularProgressIndicator());
           } else if(state is WeatherSuccess){
             return  successBody(weatherData: state.weatherModel);
           } else if (state is WeatherFailure){
             return defultBody();
           } else
           {
             return Center(
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Text(
                   'there is no weather 😔 start',
                   style: TextStyle(
                     fontSize: 30,
                   ),
                 ),
                 Text(
                   'searching now 🔍',
                   style: TextStyle(
                     fontSize: 30,
                   ),
                 )
               ],
             ),
           );
           }
         },
      ),

    );
  }
}

class defultBody extends StatelessWidget {
  const defultBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Something is wrong try agin... ',style:TextStyle(fontSize: 25)));
  }
}

class successBody extends StatelessWidget {
  const successBody({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  final WeatherModel? weatherData;

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              weatherData!.getThemeColor(),
              weatherData!.getThemeColor()[300]!,
              weatherData!.getThemeColor()[100]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 3,
              ),
              Text(
                BlocProvider.of<WeatherCubit>(context).cityName!,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'updated at : ${weatherData!.date.hour.toString()}:${weatherData!.date.minute.toString()}',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(weatherData!.getImage()),
                  Text(
                    weatherData!.temp.toInt().toString(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: [
                      Text('maxTemp :${weatherData!.maxTemp.toInt()}'),
                      Text('minTemp : ${weatherData!.minTemp.toInt()}'),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Text(
                weatherData!.weatherStateName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(
                flex: 5,
              ),
            ],
          ),
        );
  }
}
