import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pg_model.dart';
import '../seed_data/pg_seed_data.dart';

class PGRepository {
  static const String _storageKey = 'pgcity_pg_list_v1';
  static const String _likedKey = 'pgcity_liked_pg_ids_v1';
  static const String _unlockedKey = 'pgcity_unlocked_pg_ids_v1';

  final SharedPreferences _prefs;

  PGRepository(this._prefs);

  Future<List<PGModel>> getAllPGs() async {
    final rawJson = _prefs.getString(_storageKey);
    if (rawJson == null) {
      final initial = PGSeedData.getInitialPGs();
      await saveAllPGs(initial);
      return initial;
    }

    try {
      final list = jsonDecode(rawJson) as List;
      return list.map((e) => PGModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      final initial = PGSeedData.getInitialPGs();
      await saveAllPGs(initial);
      return initial;
    }
  }

  Future<void> saveAllPGs(List<PGModel> pgs) async {
    final raw = jsonEncode(pgs.map((e) => e.toJson()).toList());
    await _prefs.setString(_storageKey, raw);
  }

  Future<PGModel?> getPGById(String id) async {
    final all = await getAllPGs();
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addOrUpdatePG(PGModel pg) async {
    final all = await getAllPGs();
    final index = all.indexWhere((e) => e.id == pg.id);
    if (index >= 0) {
      all[index] = pg;
    } else {
      all.insert(0, pg);
    }
    await saveAllPGs(all);
  }

  Future<void> deletePG(String id) async {
    final all = await getAllPGs();
    all.removeWhere((e) => e.id == id);
    await saveAllPGs(all);
  }

  // Liked PGs set management
  Set<String> getLikedPGIds() {
    final list = _prefs.getStringList(_likedKey);
    return list != null ? list.toSet() : {};
  }

  Future<bool> toggleLike(String pgId) async {
    final liked = getLikedPGIds();
    bool isLiked;
    if (liked.contains(pgId)) {
      liked.remove(pgId);
      isLiked = false;
    } else {
      liked.add(pgId);
      isLiked = true;
    }
    await _prefs.setStringList(_likedKey, liked.toList());

    // Update PG likesCount in repository
    final all = await getAllPGs();
    final index = all.indexWhere((e) => e.id == pgId);
    if (index >= 0) {
      final cur = all[index];
      final newCount = (cur.likesCount + (isLiked ? 1 : -1)).clamp(0, 999999);
      all[index] = cur.copyWith(likesCount: newCount);
      await saveAllPGs(all);
    }

    return isLiked;
  }

  // Unlocked Contacts
  Set<String> getUnlockedPGIds() {
    final list = _prefs.getStringList(_unlockedKey);
    return list != null ? list.toSet() : {};
  }

  Future<void> unlockPGContact(String pgId) async {
    final unlocked = getUnlockedPGIds();
    if (!unlocked.contains(pgId)) {
      unlocked.add(pgId);
      await _prefs.setStringList(_unlockedKey, unlocked.toList());

      // Increment unlock count on PG
      final all = await getAllPGs();
      final index = all.indexWhere((e) => e.id == pgId);
      if (index >= 0) {
        final cur = all[index];
        all[index] = cur.copyWith(contactUnlocksCount: cur.contactUnlocksCount + 1);
        await saveAllPGs(all);
      }
    }
  }

  Future<void> resetToSeedData() async {
    await _prefs.remove(_storageKey);
    await _prefs.remove(_likedKey);
    await _prefs.remove(_unlockedKey);
    final initial = PGSeedData.getInitialPGs();
    await saveAllPGs(initial);
  }
}
