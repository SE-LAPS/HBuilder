import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  // IMPORTANT: Replace this with your own valid Google AI API key
  // Get your API key from: https://aistudio.google.com/app/apikey
  static const String _apiKey = '';

  GenerativeModel? _model;
  ChatSession? _chat;
  bool _isInitialized = false;
  String? _initializationError;

  AIService() {
    _initializeModel();
  }

  /// Check if the service is ready to use
  bool get isReady => _isInitialized && _chat != null;

  /// Get initialization error if any
  String? get initializationError => _initializationError;

  void _initializeModel() {
    try {
      // Validate API key format
      if (_apiKey.isEmpty || _apiKey.length < 20) {
        _initializationError =
            'Invalid API key format. Please check your Google AI API key.';
        _isInitialized = false;
        if (kDebugMode) {
          print('❌ AI Service: $_initializationError');
        }
        return;
      }

      if (kDebugMode) {
        print('🔄 Initializing AI Service with Gemini 1.5 Flash...');
      }

      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.9,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        ),
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          SafetySetting(
            HarmCategory.sexuallyExplicit,
            HarmBlockThreshold.medium,
          ),
          SafetySetting(
            HarmCategory.dangerousContent,
            HarmBlockThreshold.medium,
          ),
        ],
      );

      // Initialize chat with context about Washtron car wash app
      _chat = _model!.startChat(
        history: [
          Content.text(_getSystemContext()),
          Content.model([TextPart(_getSystemResponse())]),
        ],
      );

      _isInitialized = true;
      _initializationError = null;

      if (kDebugMode) {
        print('✅ AI Service initialized successfully!');
        print('📝 Model: gemini-1.5-flash');
      }
    } catch (e) {
      _isInitialized = false;
      _initializationError = 'Failed to initialize AI service: ${e.toString()}';

      if (kDebugMode) {
        print('❌ Error initializing AI Service: $e');
        print('   Error type: ${e.runtimeType}');
      }
    }
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
    if (!_isInitialized || _chat == null) {
      if (kDebugMode) {
        print('⚠️ AI Service not initialized.');
        if (_initializationError != null) {
          print('   Initialization error: $_initializationError');
        }
      }

      if (_initializationError != null &&
          _initializationError!.contains('API key')) {
        return '''I apologize, but the AI assistant is not properly configured. 

🔧 **Action Required:**
The API key needs to be verified or updated. Please contact the app administrator.

Meanwhile, you can:
• Visit our service centers directly
• Call our support hotline
• Email us at support@washtron.com

We apologize for the inconvenience!''';
      }

      return _getFallbackResponse();
    }

    try {
      if (kDebugMode) {
        print('📤 Sending message to AI: "$userMessage"');
      }

      final response = await _chat!.sendMessage(Content.text(userMessage));
      final text = response.text;

      if (kDebugMode) {
        if (text != null && text.isNotEmpty) {
          final preview = text.length > 100
              ? '${text.substring(0, 100)}...'
              : text;
          print('📥 AI Response received: "$preview"');
          print('   Response length: ${text.length} characters');
        } else {
          print('⚠️ AI Response is empty or null');
        }
      }

      if (text == null || text.isEmpty) {
        if (kDebugMode) {
          print('❌ Empty response from AI, using fallback');
        }
        return _getFallbackResponse();
      }

      return text;
    } on GenerativeAIException catch (e) {
      if (kDebugMode) {
        print('❌ Generative AI Exception: ${e.message}');
        print('   Error type: ${e.runtimeType}');
      }
      return _getErrorResponse(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting AI response: $e');
        print('   Error type: ${e.runtimeType}');
        print('   Stack trace: ${StackTrace.current}');
      }
      return _getErrorResponse(e);
    }
  }

  /// Stream responses for real-time chat experience
  Stream<String> sendMessageStream(String userMessage) async* {
    if (!_isInitialized || _chat == null) {
      yield _getFallbackResponse();
      return;
    }

    try {
      final response = _chat!.sendMessageStream(Content.text(userMessage));

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

  String _getErrorResponse(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (kDebugMode) {
      print('🔍 Analyzing error: $errorString');
    }

    // API Key related errors
    if (errorString.contains('api_key_invalid') ||
        errorString.contains('api key not valid') ||
        errorString.contains('invalid_api_key')) {
      return '''I apologize, but there's an issue with the AI service configuration.

🔑 **Issue**: Invalid API key

**What you can do:**
• Contact the app support team
• Try again in a few moments
• Visit our service centers for immediate assistance

**Contact**: support@washtron.com''';
    }

    // Quota/Rate limit errors
    if (errorString.contains('quota') ||
        errorString.contains('limit') ||
        errorString.contains('resource_exhausted')) {
      return '''I've reached my usage limit for now.

⏱️ **Temporary Limit Reached**

**What you can do:**
• Try again in a few minutes
• Contact our support team directly:
  📞 Call: +1 (555) 123-4567
  📧 Email: support@washtron.com
• Visit our service centers

We apologize for the inconvenience!''';
    }

    // Network related errors
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('failed host lookup')) {
      return '''I'm having trouble connecting to the internet.

🌐 **Connection Issue**

**Please check:**
• Your internet connection is active
• You have a stable network signal
• Try switching between WiFi and mobile data

Then try sending your message again!''';
    }

    // Permission errors
    if (errorString.contains('permission') ||
        errorString.contains('forbidden')) {
      return '''I don't have the necessary permissions to process your request.

🔒 **Permission Issue**

**What you can do:**
• Contact app support for assistance
• Email: support@washtron.com
• Visit our service centers for help

We apologize for the inconvenience!''';
    }

    return _getFallbackResponse();
  }

  String _getFallbackResponse() {
    return '''Thank you for reaching out! 

While I'm experiencing some technical difficulties, here's how you can get help:

**📞 Direct Support:**
• Call: +1 (555) 123-4567
• Email: support@washtron.com

**🚗 Service Centers:**
• Use the app's map to find nearby locations
• Visit any Washtron center for assistance

**💡 Quick Tips:**
• Check the FAQ in Settings
• Try rephrasing your question
• Ensure you have a stable internet connection

We're here to help!''';
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
