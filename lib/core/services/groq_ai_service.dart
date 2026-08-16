import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pgcity/core/config/env_config.dart';
import 'package:pgcity/data/models/pg_model.dart';

class AiChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;
  final List<String> referencedPGIds;

  AiChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
    this.referencedPGIds = const [],
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'isError': isError,
    'referencedPGIds': referencedPGIds,
  };

  factory AiChatMessage.fromMap(Map<String, dynamic> map) => AiChatMessage(
    id: map['id'] ?? '',
    text: map['text'] ?? '',
    isUser: map['isUser'] ?? false,
    timestamp: map['timestamp'] != null
        ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
        : DateTime.now(),
    isError: map['isError'] ?? false,
    referencedPGIds: List<String>.from(map['referencedPGIds'] ?? []),
  );
}

class GroqAiService {
  static final GroqAiService instance = GroqAiService._internal();

  GroqAiService._internal();

  /// Sends the conversation history to Groq LLaMA 3.3 and returns the assistant's reply
  Future<AiChatMessage> sendMessage({
    required String userMessage,
    required List<AiChatMessage> conversationHistory,
    required List<PGModel> availablePGs,
  }) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 15);

    try {
      final url = Uri.parse(EnvConfig.groqBaseUrl);
      final request = await client.postUrl(url);

      request.headers.set('Authorization', 'Bearer ${EnvConfig.groqApiKey}');
      request.headers.set('Content-Type', 'application/json');

      final systemPrompt = _buildSystemPrompt(availablePGs);

      // Build message list for Groq OpenAI compatible format
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': systemPrompt},
      ];

      // Include recent 8 messages for contextual awareness
      final recentHistory = conversationHistory.length > 8
          ? conversationHistory.sublist(conversationHistory.length - 8)
          : conversationHistory;

      for (final msg in recentHistory) {
        messages.add({
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.text,
        });
      }

      messages.add({'role': 'user', 'content': userMessage});

      final payload = {
        'model': EnvConfig.groqModel,
        'messages': messages,
        'temperature': 0.6,
        'max_tokens': 1024,
      };

      final bodyBytes = utf8.encode(jsonEncode(payload));
      request.add(bodyBytes);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final content =
              choices[0]['message']?['content'] as String? ??
              'No response received.';

          // Find any mentioned PG IDs in the response
          final matchedPGs = <String>[];
          for (final pg in availablePGs) {
            if (content.toLowerCase().contains(pg.name.toLowerCase()) ||
                content.toLowerCase().contains(pg.locality.toLowerCase())) {
              matchedPGs.add(pg.id);
            }
          }

          return AiChatMessage(
            id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
            text: content.trim(),
            isUser: false,
            timestamp: DateTime.now(),
            referencedPGIds: matchedPGs.take(3).toList(),
          );
        }
      }

      // If API returned error status code, fallback gracefully
      return _generateOfflineFallback(userMessage, availablePGs);
    } catch (e) {
      if (kDebugMode) {
        print('Groq API Error: $e');
      }
      return _generateOfflineFallback(userMessage, availablePGs);
    } finally {
      client.close();
    }
  }

  String _buildSystemPrompt(List<PGModel> pgs) {
    final pgSummaries = pgs
        .map(
          (p) =>
              '- **${p.name}** (ID: ${p.id}): ${p.type.label}, ${p.locality}, ₹${p.monthlyRent}/month. Meals: ${p.foodOption}, Sharing: ${p.sharingType}. Amenities: ${p.amenities.take(5).join(", ")}.',
        )
        .join('\n');

    return '''
You are "PGCity AI Assistant", an expert student & professional co-living advisor for Ahmedabad and Gandhinagar, Gujarat.
You help users find the best Paying Guest (PG) accommodation, compare options, understand meal plans (Kathiyawadi, Gujarati, Pure Veg, Jain), local commute (Metro, BRTS, AMTS), rental agreements (11-month lock-in, security deposits), and finding compatible roommates.

Here is the live verified PGCity PG inventory in Ahmedabad:
$pgSummaries

Key Localities & Hubs:
- Navrangpura / University Road: Best for LD College, CEPT, Ahmedabad University, GLS.
- Satellite / Vastrapur: Close to IIM-A, Alpha One Mall, corporate offices.
- SG Highway / Bodakdev: Ideal for IT professionals, Nirma University, SGVP.
- Kudasan / Infocity (Gandhinagar): Ideal for DAIICT, PDPU, TCS, GIFT City.

Guidelines:
1. Always be polite, concise, structured, and helpful.
2. Recommend specific PGs from the list above when relevant, mentioning exact rents and amenities.
3. Use bullet points and emojis for easy mobile reading.
4. Keep replies within 2-4 concise paragraphs.
''';
  }

  AiChatMessage _generateOfflineFallback(String query, List<PGModel> pgs) {
    final q = query.toLowerCase();
    final matches = pgs
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.locality.toLowerCase().contains(q) ||
              (q.contains('girl') && p.type == PGType.girls) ||
              (q.contains('boy') && p.type == PGType.boys),
        )
        .toList();

    String reply;
    final topPgs = matches.isNotEmpty ? matches : pgs.take(3).toList();

    if (q.contains('girl') || q.contains('female')) {
      final list = topPgs
          .map(
            (p) =>
                '• **${p.name}** in ${p.locality} — ₹${p.monthlyRent}/mo (${p.foodOption})',
          )
          .join('\n');
      reply =
          'Here are our top rated, verified Girls PGs in Ahmedabad with biometric security & pure veg food:\n\n$list\n\nWould you like to schedule a visit or take a 360° virtual tour?';
    } else if (q.contains('boy') || q.contains('male')) {
      final list = topPgs
          .map(
            (p) =>
                '• **${p.name}** in ${p.locality} — ₹${p.monthlyRent}/mo (${p.foodOption})',
          )
          .join('\n');
      reply =
          'Here are the best Boys PGs near major colleges and IT corridors:\n\n$list\n\nAll of these include high-speed Wi-Fi and power backup!';
    } else if (q.contains('deposit') ||
        q.contains('rent') ||
        q.contains('notice')) {
      reply =
          '💡 **Standard PG Rental Terms in Ahmedabad:**\n\n'
          '• **Security Deposit:** Usually 1 to 2 months rent (100% refundable at move-out).\n'
          '• **Notice Period:** Mandatory 30 days written notice before vacating.\n'
          '• **Lock-in Period:** Standard 11-month tenancy contract.\n'
          '• **Electricity:** Typically ₹8 to ₹9 per unit split among roommates.';
    } else {
      final list = topPgs
          .map((p) => '• **${p.name}** in ${p.locality} — ₹${p.monthlyRent}/mo')
          .join('\n');
      reply =
          'Based on your query, here are recommended PG options in Ahmedabad:\n\n$list\n\nLet me know if you need help with meal plans, roommate matching, or location advice!';
    }

    return AiChatMessage(
      id: 'ai_fallback_${DateTime.now().millisecondsSinceEpoch}',
      text: reply,
      isUser: false,
      timestamp: DateTime.now(),
      referencedPGIds: topPgs.map((p) => p.id).toList(),
    );
  }
}
