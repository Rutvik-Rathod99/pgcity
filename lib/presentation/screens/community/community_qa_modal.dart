import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class CommunityQAModal extends StatefulWidget {
  final AppState appState;
  final String? pgName;

  const CommunityQAModal({super.key, required this.appState, this.pgName});

  @override
  State<CommunityQAModal> createState() => _CommunityQAModalState();
}

class _CommunityQAModalState extends State<CommunityQAModal> {
  final TextEditingController _questionController = TextEditingController();

  final List<Map<String, dynamic>> _qaList = [
    {
      'question':
          'How is the Wi-Fi speed during evening hours and online exams?',
      'asker': 'Priya P. (LD College)',
      'date': '2 days ago',
      'upvotes': 14,
      'answers': [
        {
          'text':
              'We have dual 300 Mbps Airtel Fiber lines with separate mesh routers on each floor. Speed remains 180+ Mbps even in peak hours.',
          'responder': 'Property Warden (Verified Staff)',
          'isStaff': true,
        },
        {
          'text':
              'I study CS and do coding tests; ping is usually under 15ms. Never faced disconnects during submissions.',
          'responder': 'Meera S. (Current Resident, Room 204)',
          'isStaff': false,
        },
      ],
    },
    {
      'question':
          'Are late-night food deliveries like Zomato / Swiggy allowed after gate closing?',
      'asker': 'Rohan M. (Nirma Univ)',
      'date': '5 days ago',
      'upvotes': 9,
      'answers': [
        {
          'text':
              'Yes! Night security guard collects deliveries at the front gate intercom counter up to 2:00 AM.',
          'responder': 'Security Supervisor',
          'isStaff': true,
        },
      ],
    },
    {
      'question': 'Is hot water available 24/7 or only during morning hours?',
      'asker': 'Sneha K. (CEPT Univ)',
      'date': '1 week ago',
      'upvotes': 18,
      'answers': [
        {
          'text':
              'Solar water heating operates 6 AM to 11 AM, and individual instantaneous electric geysers are fitted in every attached bathroom for 24/7 hot water.',
          'responder': 'Property Manager',
          'isStaff': true,
        },
      ],
    },
    {
      'question': 'What is the policy for weekend home visits or staying out?',
      'asker': 'Aarav G.',
      'date': '2 weeks ago',
      'upvotes': 7,
      'answers': [
        {
          'text':
              'Just fill the quick night-out digital log in the PGCity app or inform the warden WhatsApp group by 8 PM.',
          'responder': 'Dev Patel (Senior Resident)',
          'isStaff': false,
        },
      ],
    },
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _submitQuestion() {
    final text = _questionController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _qaList.insert(0, {
        'question': text,
        'asker': widget.appState.currentUser?.fullName ?? 'Anonymous Student',
        'date': 'Just now',
        'upvotes': 1,
        'answers': [
          {
            'text':
                'Your question has been posted to current residents and property managers. Expect a reply within 2 hours.',
            'responder': 'PGCity Community Bot',
            'isStaff': true,
          },
        ],
      });
      _questionController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Question submitted to resident forum!'),
        backgroundColor: AppColors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white24
                    : AppColors.inkSoft.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.forum_rounded,
                        color: AppColors.teal,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resident Community Q&A',
                          style: AppTypography.titleLarge(
                            color: isDark ? Colors.white : AppColors.ink,
                          ),
                        ),
                        Text(
                          widget.pgName != null
                              ? 'Q&A for ${widget.pgName}'
                              : 'Verified Tenant Discussions',
                          style: AppTypography.bodySmall(
                            color: isDark ? Colors.white60 : AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: context.appBorder),

          // Ask Question Input Box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : AppColors.cream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.appBorder),
                    ),
                    child: TextField(
                      controller: _questionController,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : AppColors.ink,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Ask residents about Wi-Fi, food, warden...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submitQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Post', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _qaList.length,
              itemBuilder: (context, index) {
                final qa = _qaList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.appBorder),
                    boxShadow: const [AppColors.softShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question title
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.marigold.withAlpha(40),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Q',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.marigoldDark,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              qa['question'],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Asked by ${qa['asker']} · ${qa['date']}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white38 : AppColors.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(color: context.appBorder),

                      // Answers
                      for (final ans in (qa['answers'] as List))
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : AppColors.cream,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      ans['isStaff']
                                          ? Icons.verified_user_rounded
                                          : Icons.person_pin_rounded,
                                      size: 14,
                                      color: ans['isStaff']
                                          ? AppColors.teal
                                          : AppColors.marigoldDark,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      ans['responder'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: ans['isStaff']
                                            ? (isDark
                                                  ? const Color(0xFF38BDF8)
                                                  : AppColors.teal)
                                            : (isDark
                                                  ? Colors.white70
                                                  : AppColors.ink),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ans['text'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white70
                                        : AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
