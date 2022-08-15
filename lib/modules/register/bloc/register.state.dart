import 'package:equatable/equatable.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';

class RegisterState extends Equatable {
  final int? currentStep;
  final AccountType? accountType;
  final String? phone;
  final int? phoneId;
  final List<CityModel>? areas;
  final List<CityModel>? cities;
  RegisterState({
    this.currentStep,
    this.accountType,
    this.phone,
    this.phoneId,
    this.areas,
    this.cities,
  });

  RegisterState copyWith({
    int? currentStep,
    AccountType? accountType,
    String? phone,
    int? phoneId,
    List<CityModel>? areas,
    List<CityModel>? cities,
    List<CategoryModel>? categories,
  }) =>
      RegisterState(
        currentStep: currentStep ?? this.currentStep,
        accountType: accountType ?? this.accountType,
        phone: phone ?? this.phone,
        phoneId: phoneId ?? this.phoneId,
        areas: areas ?? this.areas,
        cities: cities ?? this.cities,
      );

  @override
  List<Object?> get props => [
        currentStep,
        accountType,
        phone,
        phoneId,
        areas,
        cities,
      ];
}
