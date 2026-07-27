import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String ticketId;
  const ChatScreen({super.key, required this.ticketId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _msgs = <_Msg>[
    _Msg('Hello! How can we help you today?', false, '10:00 AM'),
    _Msg('I haven\'t received payment for my deliveries from yesterday.', true, '10:01 AM'),
    _Msg('We\'re looking into this. Can you confirm your bank IBAN?', false, '10:02 AM'),
    _Msg('SA29 0000 0000 0000 0000 1234', true, '10:03 AM'),
    _Msg('Thank you! Our finance team will process it within 24 hours.', false, '10:05 AM'),
  ];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ticket ${widget.ticketId}'),
          const Text('Support Agent', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _msgs.length,
            itemBuilder: (_, i) => _Bubble(msg: _msgs[i]),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  onPressed: _send,
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() { _msgs.add(_Msg(text, true, 'Now')); _ctrl.clear(); });
  }
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  const _Bubble({required this.msg});
  @override
  Widget build(BuildContext context) => Align(
    alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.7),
      decoration: BoxDecoration(
        color: msg.isMe ? AppColors.primary : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
        Text(msg.text, style: TextStyle(color: msg.isMe ? Colors.white : null)),
        const SizedBox(height: 4),
        Text(msg.time, style: TextStyle(fontSize: 10, color: msg.isMe ? Colors.white54 : Colors.grey)),
      ]),
    ),
  );
}

class _Msg {
  final String text, time;
  final bool isMe;
  const _Msg(this.text, this.isMe, this.time);
}
