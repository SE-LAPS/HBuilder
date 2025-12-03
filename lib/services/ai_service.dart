import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static const String _apiKey = 'AIzaSyBdkmGFhdjOKUMxr8i6kQ0R3eclfsyFeLY';
  late final GenerativeModel _model;
  late final ChatSession _chat;

  AIService() {
    _initializeModel();
  }

  void _initializeModel() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );

    // Initialize chat with context about Washtron car wash app
    _chat = _model.startChat(
      history: [
        Content.text(_getSystemContext()),
        Content.model([TextPart(_getSystemResponse())]),
      ],
    );
  }

  String _getSystemContext() {
    return '''You are a helpful customer support assistant for Washtron, a car wash service management mobile app in Sri Lanka. 

Washtron App Services and Features:
- Find nearby car wash service centers in Sri Lanka (especially in Colombo district)
- Three membership card packages:
  1. Monthly Card: 30 days for \$159
  2. Seasonal Card: 90 days for \$299 (originally \$1080)
  3. Annual Card: 360 days for \$498 (originally \$6220)
- QR/Barcode scanning for quick access
- Vehicle management (add, view, delete vehicles)
- Service center details with locations, business hours, and contact numbers
- Tap-to-call functionality for service centers
- Real-time distance calculation to nearest service centers
- Franchise application system
- User profile management
- Purchase history tracking
- Google Sign-In and email authentication

Service Centers Information:
- Located across Sri Lanka with focus on Colombo district
- Business hours: Typically 08:00 - 20:00
- All centers offer premium car wash services
- Membership cards valid at all participating centers

Answer customer questions accurately based on this information. Be helpful, friendly, and concise. If asked about something not related to car wash services or this app, politely redirect to relevant topics.''';
  }

  String _getSystemResponse() {
    return 'I understand. I\'m ready to help Washtron customers with questions about our car wash services, membership cards, locations in Sri Lanka, and app features.';
  }

  /// Send a message and get AI response
  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await _chat.sendMessage(Content.text(userMessage));
      final text = response.text;

      if (text == null || text.isEmpty) {
        return _getFallbackResponse();
      }

      return text;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting AI response: $e');
      }
      return _getFallbackResponse();
    }
  }

  /// Stream responses for real-time chat experience
  Stream<String> sendMessageStream(String userMessage) async* {
    try {
      final response = _chat.sendMessageStream(Content.text(userMessage));

      await for (final chunk in response) {
        final text = chunk.text;
        if (text != null) {
          yield text;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error streaming AI response: $e');
      }
      yield _getFallbackResponse();
    }
  }

  String _getFallbackResponse() {
    return 'Thank you for your message. Our customer support team will assist you shortly. You can also try rephrasing your question.';
  }

  /// Get pre-defined quick suggestions for common questions
  List<String> getQuickSuggestions() {
    return [
      'What membership cards do you offer?',
      'How can I find nearby car wash centers?',
      'What are your operating hours?',
      'How do I add my vehicle?',
      'Can I use my card at all locations?',
    ];
  }
}
