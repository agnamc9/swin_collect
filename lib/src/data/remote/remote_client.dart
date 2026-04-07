import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

import '../../../main.dart';
import '../model/model.dart';
import '../local/local_storage.dart';

part 'remote_client.g.dart';

final remoteClientProvider = Provider((ref) {
  final dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      enabled: kDebugMode,
    ),
  );

  final localStorage = ref.read(localStorageProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (option, handler) async {
        option.headers['JWT_PASSPHRASE'] = '5j409A203E';
        var token = localStorage.getToken();
        if (token != null) {
          option.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(option);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          var data = error.response?.data;
          if (data != null && data['message'] == 'Expired JWT Token') {}
          localStorage.deleteSession();
          eventBus.fire(LogoutEvent());
        }
        return handler.reject(error);
      },
    ),
  );

  return RemoteClient(dio, baseUrl: "https://tax.softwin.ci/api");
});

@RestApi()
abstract class RemoteClient {
  factory RemoteClient(Dio dio, {String? baseUrl}) = _RemoteClient;

  @POST("/authenticate")
  Future<LoginResponse> authenticate(@Body() User user);

  @GET("/taxe/collection/list")
  Future<List<TaxCollect>> getTaxCollects();

  @GET("/taxe/collection/amountCollector")
  Future<num> getAmountCollector();

  @GET("/contribuable/{id}/taxes")
  Future<num> getContribuableTax(@Path("id") int id);

  @GET("/contribuable/list")
  Future<List<Contribuable>> getContribuables();

  @GET("/contribuable/{id}")
  Future<Contribuable> getContribuable(@Path("id") int id);

  @POST("/taxe/collection/create")
  Future<TaxCollect> collectTax(@Body() Map<String, dynamic> requuest);

  @GET("/tax/list")
  Future<List<Tax>> getTaxes();

  @GET("/identity-type/list")
  Future<List<IdentityType>> getIdentityTypes();

  @POST("/contribuable/create")
  Future<List<Contribuable>> createContribuable(
    @Body() Map<String, Object> map,
  );

  @POST("/journal-caisse/cloturer")
  Future<CashierStatus> closeCashier(@Body() Map<String, Object> map);

  @GET("/journal-caisse/today")
  Future<CashierStatus> getCashierStatus();
}
