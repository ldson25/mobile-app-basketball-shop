import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import '../../../services/chatbot_service.dart';
import '../../../services/product_service.dart';
import '../../products/presentation/product_detail_screen.dart';
import '../../discover/results_discover_screen.dart' as doanltdd_discover;

class _ProductLinkBuilder extends MarkdownElementBuilder {
  final BuildContext context;

  _ProductLinkBuilder(this.context);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final href = element.attributes['href'];
    final textContent = element.textContent;

    if (href != null && href.startsWith('product:')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ElevatedButton.icon(
          onPressed: () {
            final productId = href.substring(8);
            final product = context.read<ProductService>().getProductById(productId);
            
            if (product != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            } else {
              // Fallback to searching if ID not found (e.g. legacy chat history)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => doanltdd_discover.ResultsDiscoverScreen(
                    categoryName: 'all',
                    itemCount: 0,
                    searchKeyword: textContent,
                    onRequireAuth: () async => false, // Default auth fallback
                  ),
                ),
              );
            }
          },
          icon: const Icon(Icons.shopping_bag_outlined, size: 18),
          label: Text(
            textContent,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        // Fallback or external link handler if needed
      },
      child: Text(
        textContent,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class ChatbotBottomSheet extends StatefulWidget {
  const ChatbotBottomSheet({super.key});

  @override
  State<ChatbotBottomSheet> createState() => _ChatbotBottomSheetState();
}

class _ChatbotBottomSheetState extends State<ChatbotBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    context.read<ChatbotService>().sendMessage(text);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final chatbotService = context.watch<ChatbotService>();
    final messages = chatbotService.messages;

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.sports_basketball, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Nhân viên tư vấn Kinetic AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          if (chatbotService.errorMessage.isNotEmpty &&
              !chatbotService.errorMessage.contains('API Key'))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                chatbotService.errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          if (chatbotService.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'AI đang trả lời...',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn của bạn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: chatbotService.isLoading
                        ? null
                        : _handleSubmitted,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: chatbotService.isLoading
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: chatbotService.isLoading
                        ? null
                        : () => _handleSubmitted(_textController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: message.isUser
                ? const Radius.circular(0)
                : const Radius.circular(20),
            bottomLeft: !message.isUser
                ? const Radius.circular(0)
                : const Radius.circular(20),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: message.isUser
            ? Text(message.text, style: const TextStyle(color: Colors.white))
            : MarkdownBody(
                data: message.text,
                selectable: true,
                onTapLink: (text, href, title) {
                  // Fallback for onTapLink just in case
                  if (href != null && href.startsWith('product:')) {
                    final productId = href.substring(8);
                    final product = context.read<ProductService>().getProductById(productId);
                    if (product != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    }
                  }
                },
                builders: {
                  'a': _ProductLinkBuilder(context),
                },
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 15,
                  ),
                  strong: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                  listBullet: TextStyle(color: Theme.of(context).primaryColor),
                  h3: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
