import 'package:flutter/material.dart';

double iconSize = 30;

CarList carList = CarList(cars: [
  Car(offerDetails: [
    {Icon(Icons.bluetooth, size: iconSize,color: Colors.white,): "Board"},
    {Icon(Icons.airline_seat_individual_suite, size: iconSize,color: Colors.white,): "Family"},
    {Icon(Icons.pin_drop, size: iconSize,color: Colors.white,): "Events"},
  ],
  ),

]);

class CarList {
  List<Car> cars;
  CarList({
    @required this.cars,
  });
}

class Car {
  List<Map<Icon, String>> offerDetails;
  Car({
    @required this.offerDetails,
  });
}
