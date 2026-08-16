import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/services/crashlytics_service.dart';
import 'package:pgcity/core/utils/app_logger.dart';

class AppLoggerScreen extends StatefulWidget {
  const AppLoggerScreen({super.key});

  @override
  State<AppLoggerScreen> createState() => _AppLoggerScreenState();
}

class _AppLoggerScreenState extends State<AppLoggerScreen> {
  AppLogLevel? _selectedFilter;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppLogger.addListener(_onNewLog);
  }

  @override
  void dispose() {
    AppLogger.removeListener(_onNewLog);
    _searchController.dispose();
    super.dispose();
  }

  void _onNewLog(LogEntry entry) {
    if (mounted) {
      setState(() {});
    }
  }

  List<LogEntry> get _filteredLogs {
    return AppLogger.logs.where((log) {
      if (_selectedFilter != null && log.level != _selectedFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchMsg = log.message.toLowerCase().contains(query);
        final matchTag = log.tag.toLowerCase().contains(query);
        final matchErr = log.error?.toString().toLowerCase().contains(query) ?? false;
        if (!matchMsg && !matchTag && !matchErr) {
          return false;
        }
      }
      return true;
    }).toList().reversed.toList();
  }

  void _copyLogsToClipboard() {
    final export = AppLogger.exportLogsAsString();
    Clipboard.setData(ClipboardData(text: export));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All logs copied to clipboard!'),
        backgroundColor: AppColors.teal,
      ),
    );
  }

  void _simulateTestError() {
    AppLogger.w('Simulating network latency test...', tag: 'NETWORK');
    CrashlyticsService.instance.simulateNonFatalError();
    AppLogger.e(
      'Simulated non-fatal exception recorded in Firebase Crashlytics pipeline',
      tag: 'CRASHLYTICS',
      error: 'Exception: Test Diagnostic Non-Fatal Error',
      stackTrace: StackTrace.current,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logs = _filteredLogs;
    final crashlytics = CrashlyticsService.instance;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.cream,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.cream,
        elevation: 0,
        title: Text(
          'App Logger & Crashlytics',
          style: AppTypography.displaySmall(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_rounded),
            tooltip: 'Copy All Logs',
            onPressed: _copyLogsToClipboard,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'Clear In-Memory Logs',
            onPressed: () {
              AppLogger.clear();
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Diagnostics & Crashlytics Status Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : AppColors.line,
              ),
              boxShadow: const [AppColors.softShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.teal,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Firebase Crashlytics: Active',
                          style: AppTypography.titleSmall(
                            color: isDark ? Colors.white : AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${AppLogger.logs.length} logs in buffer',
                      style: AppTypography.monoLabel(
                        color: isDark ? Colors.white60 : AppColors.inkSoft,
                      ).copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'User: ${crashlytics.currentUserId ?? "guest_user"} · Platform: ${crashlytics.customKeys["platform"] ?? "device"}',
                  style: AppTypography.monoLabel(
                    color: isDark ? Colors.white60 : AppColors.inkSoft,
                  ).copyWith(fontSize: 11),
                ),
                const SizedBox(height: 10),

                // Simulation Trigger Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _simulateTestError,
                        icon: const Icon(Icons.bug_report_outlined, size: 14, color: AppColors.error),
                        label: const Text('Simulate Error', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          AppLogger.i('Manual info checkpoint trigger', tag: 'CHECKPOINT');
                        },
                        icon: const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.teal),
                        label: const Text('Add Info Log', style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          foregroundColor: AppColors.teal,
                          side: const BorderSide(color: AppColors.teal),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search logs by tag, message, or error...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
            ),
          ),

          // 3. Filter Chips (ALL, DEBUG, INFO, WARN, ERROR, FATAL)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildFilterChip(null, 'ALL (${AppLogger.logs.length})', isDark),
                const SizedBox(width: 6),
                _buildFilterChip(AppLogLevel.debug, '🔍 DEBUG', isDark),
                const SizedBox(width: 6),
                _buildFilterChip(AppLogLevel.info, 'ℹ️ INFO', isDark),
                const SizedBox(width: 6),
                _buildFilterChip(AppLogLevel.warning, '⚠️ WARN', isDark),
                const SizedBox(width: 6),
                _buildFilterChip(AppLogLevel.error, '🛑 ERROR', isDark),
                const SizedBox(width: 6),
                _buildFilterChip(AppLogLevel.fatal, '💥 FATAL', isDark),
              ],
            ),
          ),

          // 4. Log List View
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long_outlined, size: 42, color: AppColors.inkSoft),
                        const SizedBox(height: 8),
                        Text(
                          'No Logs Matching Query',
                          style: AppTypography.titleSmall(
                            color: isDark ? Colors.white60 : AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: logs.length,
                    itemBuilder: (ctx, index) {
                      final item = logs[index];
                      return _buildLogCard(item, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(AppLogLevel? level, String label, bool isDark) {
    final isSelected = _selectedFilter == level;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.navy,
      backgroundColor: isDark ? const Color(0xFF1E293B) : AppColors.paper,
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.ink),
      ),
      onSelected: (_) => setState(() => _selectedFilter = level),
    );
  }

  Widget _buildLogCard(LogEntry item, bool isDark) {
    Color levelColor;
    switch (item.level) {
      case AppLogLevel.debug:
        levelColor = Colors.blueGrey;
        break;
      case AppLogLevel.info:
        levelColor = AppColors.teal;
        break;
      case AppLogLevel.warning:
        levelColor = AppColors.marigoldDark;
        break;
      case AppLogLevel.error:
      case AppLogLevel.fatal:
        levelColor = AppColors.error;
        break;
    }

    final timeStr =
        '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}:${item.timestamp.second.toString().padLeft(2, '0')}.${item.timestamp.millisecond.toString().padLeft(3, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : AppColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: levelColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${item.level.emoji} ${item.level.name}',
                  style: TextStyle(
                    color: levelColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : AppColors.cream,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.tag,
                  style: AppTypography.monoLabel(
                    color: isDark ? Colors.white70 : AppColors.navy,
                  ).copyWith(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              Text(
                timeStr,
                style: AppTypography.monoLabel(
                  color: isDark ? Colors.white38 : AppColors.inkSoft,
                ).copyWith(fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.message,
            style: AppTypography.bodySmall(
              color: isDark ? Colors.white : AppColors.ink,
            ).copyWith(fontFamily: 'JetBrains Mono', fontSize: 11),
          ),
          if (item.error != null) ...[
            const SizedBox(height: 4),
            Text(
              'Error: ${item.error}',
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 10,
                fontFamily: 'JetBrains Mono',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
