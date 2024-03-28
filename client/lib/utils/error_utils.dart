
import 'package:client/classes/utilizable_state.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Unfortunately this class not available for all platforms
class HttpStatus {
  HttpStatus(this.code);

  final int? code;

  static const int continue_ = 100;
  static const int switchingProtocols = 101;
  static const int processing = 102;
  static const int earlyHints = 103;
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int nonAuthoritativeInformation = 203;
  static const int noContent = 204;
  static const int resetContent = 205;
  static const int partialContent = 206;
  static const int multiStatus = 207;
  static const int alreadyReported = 208;
  static const int imUsed = 226;
  static const int multipleChoices = 300;
  static const int movedPermanently = 301;
  static const int found = 302;
  static const int movedTemporarily = 302; // Common alias for found.
  static const int seeOther = 303;
  static const int notModified = 304;
  static const int useProxy = 305;
  static const int switchProxy = 306;
  static const int temporaryRedirect = 307;
  static const int permanentRedirect = 308;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int paymentRequired = 402;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int notAcceptable = 406;
  static const int proxyAuthenticationRequired = 407;
  static const int requestTimeout = 408;
  static const int conflict = 409;
  static const int gone = 410;
  static const int lengthRequired = 411;
  static const int preconditionFailed = 412;
  static const int requestEntityTooLarge = 413;
  static const int requestUriTooLong = 414;
  static const int unsupportedMediaType = 415;
  static const int requestedRangeNotSatisfiable = 416;
  static const int expectationFailed = 417;
  static const int imATeapot = 418;
  static const int misdirectedRequest = 421;
  static const int unprocessableEntity = 422;
  static const int locked = 423;
  static const int failedDependency = 424;
  static const int tooEarly = 425;
  static const int upgradeRequired = 426;
  static const int preconditionRequired = 428;
  static const int tooManyRequests = 429;
  static const int requestHeaderFieldsTooLarge = 431;
  static const int connectionClosedWithoutResponse = 444;
  static const int unavailableForLegalReasons = 451;
  static const int clientClosedRequest = 499;
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
  static const int httpVersionNotSupported = 505;
  static const int variantAlsoNegotiates = 506;
  static const int insufficientStorage = 507;
  static const int loopDetected = 508;
  static const int notExtended = 510;
  static const int networkAuthenticationRequired = 511;
  static const int networkConnectTimeoutError = 599;

  bool get connectionError => code == null;

  bool get isUnauthorized => code == unauthorized;

  bool get isForbidden => code == forbidden;

  bool get isNotFound => code == notFound;

  bool get isServerError =>
      between(internalServerError, networkConnectTimeoutError);

  bool between(int begin, int end) {
    return !connectionError && code! >= begin && code! <= end;
  }

  bool get isOk => between(200, 299);

  bool get hasError => !isOk;

  @override
  String toString() => "$code";
}


class ClientError {

  final String originMessage;
  final String localizedMessage;

  const ClientError(this.originMessage, [String? localizedMessage]) :
        localizedMessage = localizedMessage ?? originMessage;

  @override
  String toString() {
    return "ClientError('$originMessage', '$localizedMessage')";
  }
}

class ResponseError extends ClientError {

  final HttpStatus status;

  const ResponseError(this.status, super.originMessage, [super.localizedMessage]);

  @override
  String toString() {
    return "ResponseError('$status', '$originMessage', '$localizedMessage')";
  }

}

class KnownError extends ResponseError {

  final String knownCode;

  const KnownError(super.status, this.knownCode, super.originMessage, [super.localizedMessage]);

  @override
  String toString() {
    return "KnownError('$status', '$knownCode', '$originMessage', '$localizedMessage')";
  }
}


abstract class ErrorUtils {

  static String toLocalizedMessage(dynamic error) =>
      define(error).localizedMessage;

  static RxStatus toErrorStatus(dynamic error) =>
    RxStatus.error(toLocalizedMessage(error));

  /// Converting any error, error message or error container to ClientError
  static ClientError define(dynamic error) {

    if (error == null) {
      return ClientError('UnexpectedError', '_unexpectedError'.T);
    }

    if (error is String) {
      return StringUtils.isEmpty(error) ? define(null) : ClientError(error);
    }

    if (error is Response<dynamic>) {

      HttpStatus status = HttpStatus(error.status.code);

      String? localized;
      if (error.status.isUnauthorized) {
        localized = '_unauthorizedError'.T;
      } else if (error.status.isNotFound) {
        localized = '_notFoundError'.T;
      }

      String message = StringUtils.isEmpty(error.statusText) ? "${status.code}" : error.statusText!;

      return ResponseError(status, message, localized);

    }

    if (error is Error) {
      debugPrintStack(stackTrace: error.stackTrace, label: "$error");
    }

    return ClientError("$error");
  }
}


extension StateMixinExtension on UtilizableRxState {
  Function(dynamic) get onError => (e) => change(null, ErrorUtils.toErrorStatus(e));
}