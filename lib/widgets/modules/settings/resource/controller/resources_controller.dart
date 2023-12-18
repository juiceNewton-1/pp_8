import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_8/helpers/constants.dart';
import 'package:pp_8/models/currency_uint.dart';
import 'package:pp_8/models/resources/resource.dart';
import 'package:pp_8/services/repositories/currency_uint_repository.dart';
import 'package:pp_8/services/resources_api_service.dart';

class ResourcesController extends ValueNotifier<ResourcesState> {
  ResourcesController() : super(ResourcesState.initial()) {
    _init();
  }
  final _resourcesApiService = GetIt.instance<ResourcesApiService>();
  final _currencyUintRepository = GetIt.instance<CurrencyUintRepository>();

  CurrencyUint get currencyUint => _currencyUintRepository.value.currencyUint!;

  Future<void> _init() async {
    try {
      value = value.copyWith(isLoading: true);
      List<Resource> resources = [];
      for (var resourceQuery in Constants.reourseQueries) {
        final resource = await _resourcesApiService.getResource(
          resourceQuery,
          currency: currencyUint.symbol ?? 'USD',
        );
        resources.add(resource);
      }
      value = value.copyWith(isLoading: false, resources: resources);
    } catch (e) {
      log(e.toString());
      value = value.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void refresh() => _init();
}

class ResourcesState {
  final List<Resource> resources;
  final bool isLoading;
  final String? errorMessage;
  const ResourcesState({
    required this.resources,
    required this.isLoading,
    this.errorMessage,
  });

  factory ResourcesState.initial() => ResourcesState(
        resources: [],
        isLoading: false,
      );

  ResourcesState copyWith({
    bool? isLoading,
    List<Resource>? resources,
    String? errorMessage,
  }) =>
      ResourcesState(
        resources: resources ?? this.resources,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
