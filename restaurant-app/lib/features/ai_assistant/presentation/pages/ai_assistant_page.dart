import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});
  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _thinking = false;

  final List<_Message> _messages = [
    _Message(false, 'Welcome to Restaurant Copilot AI! I\'m analyzing your restaurant data in real-time.\n\nAsk me anything — from profit analysis to staff performance, inventory suggestions, and more.', DateTime.now()),
  ];

  final _suggestions = [
    'ai_assistant.sample_q1',
    'ai_assistant.sample_q2',
    'ai_assistant.sample_q3',
    'ai_assistant.sample_q4',
    'ai_assistant.sample_q5',
  ];

  @override
  void dispose() { _ctrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    final msg = text.trim();
    _ctrl.clear();

    setState(() {
      _messages.add(_Message(true, msg, DateTime.now()));
      _thinking = true;
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1800));

    final reply = _getAiReply(msg);
    if (mounted) {
      setState(() {
        _thinking = false;
        _messages.add(_Message(false, reply, DateTime.now()));
      });
      _scrollToBottom();
    }
  }

  String _getAiReply(String question) {
    final q = question.toLowerCase();
    if (q.contains('profit') || q.contains('revenue') || q.contains('ربح') || q.contains('إيراد')) {
      return '📊 **Profit Analysis (Today)**\n\nYour revenue today is **SAR 18,540** with a gross margin of **31.2%**.\n\nKey drivers:\n• Grilled Chicken is your top performer (SAR 3,200 revenue)\n• Saffron Rice has the highest margin at 68%\n\n⚠️ Concerns:\n• Beverage margin dropped 4% vs yesterday\n• Waste cost SAR 310 (above the 2% target)\n\n💡 **Recommendation**: Push your high-margin items like Saffron Rice and Chocolate Lava Cake in the next 2 hours.';
    }
    if (q.contains('stock') || q.contains('order') || q.contains('buy') || q.contains('شراء') || q.contains('مخزون')) {
      return '🛒 **Purchase Recommendations for Today**\n\n**Critical — Order Now:**\n• Saffron: 12g left → Order 200g (2-day lead time)\n• Heavy Cream: 500ml left → Order 5L\n\n**Order This Week:**\n• Beef Tenderloin: 2kg left → Order 10kg\n• Cherry Tomatoes: 1.5kg → Order 8kg\n\n**Suggested Suppliers:**\n• Al-Rashidi Farms (Saffron, Tomatoes) — call +966-xxx\n• Dairy Direct (Heavy Cream) — delivery tomorrow if ordered before 2 PM';
    }
    if (q.contains('waste') || q.contains('هدر')) {
      return '♻️ **Waste Reduction Analysis**\n\nYour waste rate today is **3.2%** (SAR 310) — above the 2% target.\n\n**Top Wasted Items:**\n1. Cherry Tomatoes (over-purchased Monday)\n2. Bread Rolls (expired overnight)\n3. Grilled Chicken (overcooked batch at 6 PM)\n\n**AI Recommendations:**\n• Reduce tomato orders by 20% on weekdays\n• Implement FIFO strictly in cold storage\n• Add pre-service quality check for grill station\n• Set bread order to 70% of current quantity for dinner shifts';
    }
    if (q.contains('staff') || q.contains('employee') || q.contains('موظف')) {
      return '👥 **Staff Performance Analysis**\n\n**Top Performers This Week:**\n1. 🏆 Hassan Ali (Head Chef) — Fastest prep time, 4.9⭐ rating\n2. Ahmed Mohammed (Waiter) — Highest tip average, 0 complaints\n3. Omar Nasser (Sous Chef) — Zero waste incidents\n\n**Needs Attention:**\n• Khalid Abdullah — 2 absences this month\n• Delivery team — avg 32 min delivery vs 25 min target\n\n**Insight**: Your morning shift (6-2 PM) is 15% more efficient than the evening shift. Consider reallocating 1 senior chef to the dinner shift.';
    }
    return '🤖 **AI Analysis**\n\nBased on your current data:\n\n• Today\'s sales are **14% above target** — on track for a strong day\n• Kitchen efficiency is at **87%** — good performance\n• Customer satisfaction score: **4.6/5** — trending up\n\nIs there anything specific you\'d like to dive deeper into? I can analyze sales trends, inventory optimization, staff performance, or customer behavior patterns.';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ai_assistant.title'.tr()),
          Text('ai_assistant.subtitle'.tr(), style: TextStyle(fontSize: 11,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        ]),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(20)),
            child: const Row(children: [
              Icon(Icons.circle, color: AppColors.success, size: 8),
              SizedBox(width: 6),
              Text('Online', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(child: ListView.builder(
          controller: _scrollCtrl,
          padding: const EdgeInsets.all(16),
          itemCount: _messages.length + (_thinking ? 1 : 0) + (_messages.length == 1 ? 1 : 0),
          itemBuilder: (ctx, i) {
            // Suggestion chips after welcome message
            if (_messages.length == 1 && i == 1) {
              return _buildSuggestions();
            }
            final msgIndex = _messages.length == 1 ? i : i;
            if (i < _messages.length) {
              return _buildMessageBubble(_messages[i], isDark, theme);
            }
            return _buildThinkingBubble(isDark);
          },
        )),
        _buildInputBar(isDark),
      ]),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(spacing: 8, runSpacing: 8,
        children: _suggestions.map((s) => GestureDetector(
          onTap: () => _send(s.tr()),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.infoLight, borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.info.withOpacity(0.3))),
            child: Text(s.tr(), style: const TextStyle(fontSize: 12, color: AppColors.info)),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildMessageBubble(_Message msg, bool isDark, ThemeData theme) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isUser ? null : Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            fontSize: 14,
            color: isUser ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildThinkingBubble(bool isDark) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16), bottomRight: Radius.circular(16), bottomLeft: Radius.circular(4)),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('ai_assistant.thinking'.tr(), style: const TextStyle(fontSize: 13, color: AppColors.primary)),
          const SizedBox(width: 8),
          const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.primary)),
        ]),
      ),
    );
  }

  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Row(children: [
        Expanded(child: TextField(
          controller: _ctrl,
          decoration: InputDecoration(
            hintText: 'ai_assistant.placeholder'.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          onSubmitted: _send,
          maxLines: null,
        )),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _send(_ctrl.text),
          child: Container(
            width: 44, height: 44,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
          ),
        ),
      ]),
    );
  }
}

class _Message {
  final bool isUser; final String text; final DateTime time;
  _Message(this.isUser, this.text, this.time);
}
