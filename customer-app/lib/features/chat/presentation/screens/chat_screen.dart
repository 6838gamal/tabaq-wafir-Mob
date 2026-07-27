import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _messages = <_Msg>[
    _Msg('Hi! Your order is being prepared.', false, '2:48 PM'),
    _Msg('How long will it take?', true, '2:49 PM'),
    _Msg('About 15 minutes, then our driver will pick it up.', false, '2:49 PM'),
    _Msg('Can you add extra sauce please?', true, '2:50 PM'),
    _Msg('Of course! Done 👍', false, '2:51 PM'),
  ];

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Burger District'),
          Text('Usually replies in minutes', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined))],
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (_, i) => _BubbleTile(msg: _messages[i]),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
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
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Msg(text, true, 'Now'));
      _controller.clear();
    });
  }
}

class _BubbleTile extends StatelessWidget {
  final _Msg msg;
  const _BubbleTile({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Align(
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
}

class _Msg {
  final String text, time;
  final bool isMe;
  const _Msg(this.text, this.isMe, this.time);
}
