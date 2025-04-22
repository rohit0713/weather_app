
import 'models/network_response_model.dart';

/// An abstract class representing a network service.
///
/// This class defines the common methods for making HTTP requests.
/// Implementations of this class should provide the necessary logic
/// to send GET, POST, PUT, and DELETE requests.
abstract class NetworkService {
  /// Sends a GET request to the specified [url].
  ///
  /// Optional [queryParameters] can be provided to include query parameters
  /// in the request URL. Optional [headers] can be provided to include
  /// additional headers in the request.
  ///
  /// Returns a [Future] that completes with a [NetworkResponseModel]
  /// representing the response of the request.
  Future<NetworkResponseModel> get(String url,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers});

  /// Sends a POST request to the specified [url].
  ///
  /// The [data] parameter represents the body of the request.
  /// Optional [queryParameters] can be provided to include query parameters
  /// in the request URL. Optional [headers] can be provided to include
  /// additional headers in the request.
  ///
  /// Returns a [Future] that completes with a [NetworkResponseModel]
  /// representing the response of the request.
  Future<NetworkResponseModel> post(String url,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers});

  /// Sends a PUT request to the specified [url].
  ///
  /// The [data] parameter represents the body of the request.
  /// Optional [queryParameters] can be provided to include query parameters
  /// in the request URL. Optional [headers] can be provided to include
  /// additional headers in the request.
  ///
  /// Returns a [Future] that completes with a [NetworkResponseModel]
  /// representing the response of the request.
  Future<NetworkResponseModel> put(String url,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers});

  /// Sends a DELETE request to the specified [url].
  ///
  /// The [data] parameter represents the body of the request.
  /// Optional [queryParameters] can be provided to include query parameters
  /// in the request URL. Optional [headers] can be provided to include
  /// additional headers in the request.
  ///
  /// Returns a [Future] that completes with a [NetworkResponseModel]
  /// representing the response of the request.
  Future<NetworkResponseModel> delete(String url,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers});

}