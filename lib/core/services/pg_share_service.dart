import 'package:flutter/services.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/pg_model.dart';

class PGShareService {
  PGShareService._();

  static String generateParentShareText(PGModel pg) {
    final buffer = StringBuffer();
    buffer.writeln('🏠 *${pg.name.toUpperCase()}*');
    buffer.writeln('📍 ${pg.address}, ${pg.locality}, ${pg.city}');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('🏷 *Type:* ${pg.type.label}');
    buffer.writeln('💰 *Monthly Rent:* ${CurrencyFormatter.format(pg.monthlyRent)}/mo');
    buffer.writeln('🔐 *Security Deposit:* ${CurrencyFormatter.format(pg.securityDeposit)}');
    buffer.writeln('🛏 *Room Sharing:* ${pg.sharingType}');
    buffer.writeln('🍽 *Food Plan:* ${pg.foodOption}');
    buffer.writeln('⚡ *Electricity:* ${pg.electricityOption}');
    buffer.writeln('⏳ *Minimum Stay:* ${pg.minimumStay}');
    buffer.writeln('');
    buffer.writeln('✨ *Top Amenities:*');
    for (final a in pg.amenities.take(6)) {
      buffer.writeln('  • $a');
    }
    buffer.writeln('');
    if (pg.nearbyLandmarks.isNotEmpty) {
      buffer.writeln('🗺 *Nearby Landmarks:*');
      for (final l in pg.nearbyLandmarks) {
        buffer.writeln('  • ${l.name} (${l.distance})');
      }
      buffer.writeln('');
    }
    buffer.writeln('🛡 *PGCity Verification:* ${pg.isVerified ? "✅ 100% Ops Verified" : "Pending Inspection"}');
    buffer.writeln('📍 *Google Maps Location:* https://maps.google.com/?q=${pg.latitude},${pg.longitude}');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('Shared via *PGCity App* — Ahmedabad’s #1 Verified Student & Co-Living Platform');

    return buffer.toString();
  }

  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
