// lib/core/services/websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/app_config.dart';
import '../constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final webSocketServiceProvider =
    Provider<WebSocketService>((ref) => WebSocketService());

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool get isConnected => _channel != null;

  Future<void> connect() async {
    if (_channel != null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.keyAccessToken);

    final uri = Uri.parse('${AppConfig.wsBaseUrl}/driver/ws?token=$token');
    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      (data) {
        try {
          final json = jsonDecode(data as String) as Map<String, dynamic>;
          _messageController.add(json);
        } catch (_) {}
      },
      onDone: _onDisconnected,
      onError: (_) => _onDisconnected(),
    );
  }

  void send(Map<String, dynamic> message) {
    _channel?.sink.add(jsonEncode(message));
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void _onDisconnected() {
    _channel = null;
    // Reconnect after a short delay
    Future.delayed(const Duration(seconds: 5), connect);
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
