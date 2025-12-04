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
    return '''You are a helpful customer support assistant for Washtron, a premium car wash service management mobile app in Sri Lanka. 

Washtron App Services and Features:
- Find nearby car wash service centers in Sri Lanka (especially in Colombo district)
- Interactive map with location-based filtering (All, Within 5km, 10km, 20km)
- Three membership card packages:
  1. Monthly Card: 30 days for \$159 (best for regular users)
  2. Seasonal Card: 90 days for \$299 (originally \$1080 - save 72%!)
  3. Annual Card: 360 days for \$498 (originally \$6220 - save 92%!)
- QR/Barcode scanning for quick check-in at service centers
- Vehicle management (add, view, delete multiple vehicles)
- Service center details with locations, business hours, and contact numbers
- Tap-to-call functionality for service centers
- Real-time distance calculation to nearest service centers
- Franchise application system for business opportunities
- User profile management with photo upload
- Purchase history tracking
- Google Sign-In and email authentication
- AI-powered customer support (that's me!)

Service Centers Information:
- Located across Sri Lanka with primary focus on Colombo district
- Business hours: Typically 08:00 AM - 08:00 PM (may vary by location)
- All centers offer premium car wash services
- Membership cards valid at all participating centers
- Self-operation stores with professional staff
- Real-time availability status

How to Use the App:
1. Sign in with Google or email
2. Add your vehicle(s) to your profile
3. Find nearby service centers using the map
4. Purchase a membership card for savings
5. Scan QR code at service center for quick access
6. Track your purchase history

Answer customer questions accurately, helpfully, and concisely. Provide step-by-step guidance when needed. If asked about something not related to car wash services or this app, politely redirect to relevant topics. Always be friendly and professional.''';
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
