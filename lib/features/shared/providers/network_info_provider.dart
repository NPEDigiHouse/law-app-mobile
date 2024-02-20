import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:law_app/core/connections/network_info.dart';

part 'network_info_provider.g.dart';

@riverpod
NetworkInfo networkInfo(NetworkInfoRef ref) {
  return NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
}
