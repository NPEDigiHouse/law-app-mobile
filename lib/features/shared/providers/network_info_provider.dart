import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:law_app/core/connections/network_info.dart';

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfoImpl(connectionChecker: InternetConnectionChecker()),
);
