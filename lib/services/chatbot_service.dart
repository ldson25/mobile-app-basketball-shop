import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants/api_keys.dart';
import 'product_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatbotService extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  // Lưu lại lịch sử chat cho API
  final List<Content> _apiHistory = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  ChatbotService() {
    _initChat();
  }

  void _initChat() {
    final apiKey = ApiKeys.geminiApiKey;
    if (apiKey == 'YOUR_GEMINI_API_KEY' || apiKey.isEmpty) {
      _errorMessage = 'Vui lòng thiết lập API Key trong lib/core/constants/api_keys.dart';
      _messages.add(ChatMessage(text: _errorMessage, isUser: false));
      notifyListeners();
      return;
    }

    _messages.add(ChatMessage(
      text: 'Chào bạn! Mình là nhân viên tư vấn của Kinetic. Bạn đang tìm mua giày, quần áo hay phụ kiện bóng rổ ạ? Hãy cho mình biết kinh phí và sở thích của bạn nhé!',
      isUser: false,
    ));
    
    // Thêm lời chào vào lịch sử API để AI có ngữ cảnh
    _apiHistory.add(Content.model([TextPart(_messages.last.text)]));
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    final apiKey = ApiKeys.geminiApiKey;
    if (apiKey == 'YOUR_GEMINI_API_KEY' || apiKey.isEmpty) {
      _errorMessage = 'Chưa thiết lập API Key.';
      notifyListeners();
      return;
    }

    _messages.add(ChatMessage(text: text, isUser: true));
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    // Danh sách các model để thử nghiệm (fallback lần lượt nếu lỗi)
    final modelsToTry = [
      'gemini-3.5-flash',
      'gemini-3.1-flash-lite',
      'gemini-2.5-flash',
      'gemini-2.5-flash-lite',
    ];

    bool success = false;
    String lastError = '';

    for (String modelName in modelsToTry) {
      try {
        final productListStr = ProductService().products
            .map((p) => "- ${p.name} (ID: ${p.id}, Giá: ${p.price}đ)")
            .join('\n');

        final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
          systemInstruction: Content.system(
            'Bạn là một nhân viên tư vấn bán hàng chuyên nghiệp tại cửa hàng đồ thể thao Kinetic (chuyên đồ bóng rổ). '
            'Bạn cần giúp khách hàng chọn được sản phẩm phù hợp nhất. '
            'Khi gợi ý một sản phẩm cụ thể, hãy ĐỊNH DẠNG tên sản phẩm dưới dạng link với cú pháp: [Tên sản phẩm](product:ID_Sản_Phẩm). Tuyệt đối không dùng dấu cách trong phần ID_Sản_Phẩm. '
            'Hãy hỏi thăm về kinh phí, sở thích màu sắc, vị trí thi đấu (nếu là giày) hoặc nhu cầu cụ thể của họ. '
            'Trả lời ngắn gọn, thân thiện, nhiệt tình như một nhân viên bán hàng xuất sắc. Không trả lời các chủ đề ngoài thể thao và bóng rổ.\n\n'
            'QUAN TRỌNG: Dưới đây là danh sách CÁC SẢN PHẨM HIỆN CÓ TẠI CỬA HÀNG. CHỈ ĐƯỢC PHÉP gợi ý các sản phẩm nằm trong danh sách này. Tuyệt đối KHÔNG gợi ý sản phẩm ngoài danh sách:\n'
            '$productListStr'
          ),
        );

        final chat = model.startChat(history: _apiHistory.toList());
        final response = await chat.sendMessage(Content.text(text));
        final responseText = response.text;
        
        if (responseText != null) {
          _messages.add(ChatMessage(text: responseText, isUser: false));
          // Cập nhật lịch sử thành công
          _apiHistory.add(Content.text(text));
          _apiHistory.add(Content.model([TextPart(responseText)]));
          success = true;
          break; // Thoát vòng lặp, không cần thử model tiếp theo
        }
      } catch (e) {
        lastError = e.toString();
        // Lỗi xảy ra (hết token, không hỗ trợ, server quá tải...) -> Tiếp tục vòng lặp
        debugPrint('Model \$modelName failed: \$lastError');
        continue;
      }
    }

    if (!success) {
      _errorMessage = 'Tất cả các model đều gặp lỗi: \$lastError';
      _messages.add(ChatMessage(text: 'Hiện tại hệ thống đang quá tải hoặc hết token. Xin bạn thông cảm thử lại sau.', isUser: false));
    }

    _isLoading = false;
    notifyListeners();
  }
}
