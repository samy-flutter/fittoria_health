import 'dart:developer';
import 'package:flutter/foundation.dart';

/// Structured logger — all output suppressed in production (kReleaseMode).
class AppLogger {
  AppLogger._();

  static const String _reset  = '\x1B[0m';
  static const String _grey   = '\x1B[90m';
  static const String _cyan   = '\x1B[36m';
  static const String _yellow = '\x1B[33m';
  static const String _red    = '\x1B[31m';
  static const String _green  = '\x1B[32m';
  static const String _blue   = '\x1B[34m';

  static String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2,'0')}:'
           '${now.minute.toString().padLeft(2,'0')}:'
           '${now.second.toString().padLeft(2,'0')}'
           '.${now.millisecond.toString().padLeft(3,'0')}';
  }

  static void _log(String level, String color, String message, [Object? extra]) {
    if (!kDebugMode) return;
    final ts = _grey + _timestamp() + _reset;
    final lvl = color + level + _reset;
    log('$ts $lvl $message');
    if (extra != null) {
      log('$_grey   → $extra$_reset');
    }
  }

  /// Info log — general operational messages.
  static void i(String message, [Object? extra]) =>
      _log('ℹ INFO ', _cyan, message, extra);

  /// Debug log — verbose tracing.
  static void d(String message, [Object? extra]) =>
      _log('🐛 DEBUG', _blue, message, extra);

  /// Success log — positive outcomes.
  static void s(String message, [Object? extra]) =>
      _log('✅ OK   ', _green, message, extra);

  /// Warning log — non-fatal issues.
  static void w(String message, [Object? extra]) =>
      _log('⚠️  WARN ', _yellow, message, extra);

  /// Error log — exceptions and failures.
  static void e(String message, [Object? extra]) =>
      _log('🔴 ERROR', _red, message, extra);

  /// Navigation log.
  static void nav(String from, String to) {
    if (!kDebugMode) return;
    debugPrint('$_grey${_timestamp()}$_reset $_cyan🗺  NAV$_reset  $from → $to');
  }

  /// API request log.
  static void request(String method, String path, [Map<String, dynamic>? payload, String? curlCommand]) {
    if (!kDebugMode) return;
    final m = method.toUpperCase().padRight(6);
    log('$_grey${_timestamp()}$_reset $_blue➡  REQ $m$_reset $path');
    if (payload != null && payload.isNotEmpty) {
      log('$_grey   body: $payload$_reset');
    }
    if (curlCommand != null) {
      log('$_grey   cURL:\n$curlCommand$_reset');
    }
  }

  /// API response log.
  static void response(int statusCode, String path, [int? ms, dynamic responseData]) {
    if (!kDebugMode) return;
    final ok = statusCode < 400;
    final color = ok ? _green : _red;
    final ms_ = ms != null ? ' (${ms}ms)' : '';
    log(
      '$_grey${_timestamp()}$_reset '
      '$color⬅  RES $statusCode$_reset '
      '$path$_grey$ms_$_reset',
    );
    if (responseData != null) {
      log('$_grey   Response Data:\n$responseData$_reset');
    }
  }

  /// Token refresh log.
  static void tokenRefresh(String event) {
    if (!kDebugMode) return;
    debugPrint('$_grey${_timestamp()}$_reset $_yellow🔑 TOKEN$_reset $event');
  }
}
