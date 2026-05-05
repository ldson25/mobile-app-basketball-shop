import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../widgets/section_card.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  int _agentTab = 0; // 0=AI, 1=Human
  final _controller = TextEditingController();

  final _messages = <_Message>[
    _Message(
      text:
          'Welcome back to the KINETIC Gallery. I am your high-performance assistant. How can I accelerate your experience today?',
      isUser: false,
      time: 'KINETIC AI • 14:21',
    ),
    _Message(
      text: 'I need help tracking my latest order from the Signature Series.',
      isUser: true,
      time: 'YOU • 14:22',
    ),
    _Message(
      text:
          'Scanning inventory... Found order #KN-88291. It\'s currently in transit.',
      isUser: false,
      time: 'KINETIC AI • 14:23',
      hasOrderCard: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.7),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
        ),
        title: const Text(
          'KINETIC',
          style: TextStyle(
            color: AppColors.neon,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'SUPPORT STATUS',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 8,
                  letterSpacing: 1.4,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.neon,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Live Agents Online',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.pagePadding,
                12,
                AppSizes.pagePadding,
                16,
              ),
              children: [
                // ── AI Header Card ──
                SectionCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Avatar
                          Stack(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.surface3,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.smart_toy_rounded,
                                  color: AppColors.neon,
                                  size: 28,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: AppColors.neon,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.bolt_rounded,
                                    color: Colors.black,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KINETIC AI',
                                style: Theme.of(context).textTheme.displayLarge
                                    ?.copyWith(fontSize: 20),
                              ),
                              const Text(
                                'Powered by Neural Motion™',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Tab switcher
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            AppSizes.buttonRadius,
                          ),
                        ),
                        child: Row(
                          children: [
                            _AgentTab(
                              label: 'AI ASSISTANT',
                              selected: _agentTab == 0,
                              onTap: () => setState(() => _agentTab = 0),
                            ),
                            _AgentTab(
                              label: 'HUMAN AGENT',
                              selected: _agentTab == 1,
                              onTap: () => setState(() => _agentTab = 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Timestamp ──
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppSizes.buttonRadius,
                      ),
                    ),
                    child: const Text(
                      'TODAY, 14:20',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Messages ──
                ..._messages.map((m) => _MessageBubble(message: m)),
                const SizedBox(height: 12),

                // ── Suggestion chips ──
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _SuggestionChip(
                      icon: Icons.location_on_rounded,
                      label: 'TRACK MY ORDER',
                    ),
                    _SuggestionChip(
                      icon: Icons.straighten_rounded,
                      label: 'SIZE GUIDE',
                    ),
                    _SuggestionChip(
                      icon: Icons.refresh_rounded,
                      label: 'RETURN POLICY',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Input Bar ──
          _ChatInputBar(controller: _controller),
        ],
      ),
    );
  }
}

class _AgentTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AgentTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.neon : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final String time;
  final bool hasOrderCard;

  const _Message({
    required this.text,
    required this.isUser,
    required this.time,
    this.hasOrderCard = false,
  });
}

class _MessageBubble extends StatelessWidget {
  final _Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser ? AppColors.neon : AppColors.surface2,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: message.isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.black
                          : AppColors.textPrimary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  if (message.hasOrderCard) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.surface3,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.sports_basketball_rounded,
                              color: AppColors.neon,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'KINETIC BOLT V1',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  'ESTIMATED ARRIVAL: TOMORROW',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 9,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.local_shipping_rounded,
                            color: AppColors.neon,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message.time,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SuggestionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        border: Border.all(color: AppColors.border.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.neon, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;

  const _ChatInputBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
      color: AppColors.background.withOpacity(0.9),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface3,
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file_rounded,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.neon,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.send_rounded,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
