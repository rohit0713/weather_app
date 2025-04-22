
import 'package:dio/dio.dart';
import 'package:weather_app/constants/config.dart';
import 'package:weather_app/constants/messages.dart';
import 'exception/network_exception.dart';
import 'models/network_response_model.dart';
import 'network_service.dart';

class DioNetworkServiceImpl implements NetworkService {
  late Dio _dio;

  // Private constructor
  DioNetworkServiceImpl._internal(
      {
      Map<String, dynamic>? defaultHeaders}) {
    defaultHeaders ??= {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    BaseOptions options = BaseOptions(
      headers: defaultHeaders,
    );

    _dio = Dio(options);

    // Add interceptors or other initial setup using sessionManager if needed
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        },
        onError: (error, handler) {
          print('Error Type===${error.type.name}');
          if (error.type.name == 'connectionTimeout') {
            throw DioException(
                message: Messages.SERVER_NOT_RESPONDING,
                requestOptions: RequestOptions());
          } else if (error.type.name == 'connectionError') {
            throw DioException(
                message: Messages.NO_INTERNET,
                requestOptions: RequestOptions());
          }
          throw error;
        },
      ),
    );
  }

  static DioNetworkServiceImpl? _instance;

  factory DioNetworkServiceImpl(
      {
      Map<String, dynamic>? defaultHeaders}) {
    _instance ??= DioNetworkServiceImpl._internal(
       defaultHeaders: defaultHeaders);

    _instance!._dio.options.baseUrl = Config.BASE_URL;
    _instance!._dio.options.headers.addAll(defaultHeaders ?? {});
    _instance!._dio.options.connectTimeout = const Duration(seconds: 60);
    _instance!._dio.options.sendTimeout = const Duration(seconds: 60);
    _instance!._dio.options.receiveTimeout = const Duration(seconds: 60);

    return _instance!;
  }

  NetworkResponseModel _buildNetworkResponseModel(Response response) {
    return NetworkResponseModel(
      requestOptions: response.requestOptions,
      data: response.data,
      extra: response.extra,
      headers: response.headers,
      isRedirect: response.isRedirect,
      redirects: response.redirects,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<NetworkResponseModel> delete(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      Response response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
      );
      return _buildNetworkResponseModel(response);
    } on DioException catch (e) {
      throw NetworkServiceException(
        message: e.response?.data?['message'] ?? e.message,
        statusCode: e.response!.statusCode!,
        responseData: e.response?.data,
      );
    } catch (e) {
      throw NetworkServiceException(message: e.toString());
    }
  }

  @override
  Future<NetworkResponseModel> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _buildNetworkResponseModel(response);
    } on DioException catch (e) {
      throw NetworkServiceException(
        message: e.response?.data['message'] ?? e.message,
        statusCode: e.response?.statusCode,
        responseData: e.response?.data,
      );
    } catch (e) {
      throw NetworkServiceException(message: e.toString());
    }
  }

  @override
  Future<NetworkResponseModel> post(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _buildNetworkResponseModel(response);
    } on DioException catch (e) {
      throw NetworkServiceException(
        message: e.response?.data?['message'] ?? e.message,
        statusCode: e.response?.statusCode,
        responseData: e.response?.data,
      );
    } catch (e) {
      throw NetworkServiceException(message: e.toString());
    }
  }

  @override
  Future<NetworkResponseModel> put(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _buildNetworkResponseModel(response);
    } on DioException catch (e) {
      throw NetworkServiceException(
        message: e.response?.data['message'] ?? e.message,
        statusCode: e.response?.statusCode,
        responseData: e.response?.data,
      );
    } catch (e) {
      throw NetworkServiceException(message: e.toString());
    }
  }


}