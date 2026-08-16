import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/roommate_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class RoommateFinderScreen extends StatefulWidget {
  final AppState appState;

  const RoommateFinderScreen({super.key, required this.appState});

  @override
  State<RoommateFinderScreen> createState() => _RoommateFinderScreenState();
}

class _RoommateFinderScreenState extends State<RoommateFinderScreen> {
  String _searchQuery = '';
  String _selectedGender = 'All';
  FoodHabit? _selectedFoodHabit;
  SleepHabit? _selectedSleepHabit;

  List<RoommateModel> get _filteredRoommates {
    return widget.appState.roommates.where((rm) {
      if (_selectedGender != 'All' && rm.gender != _selectedGender) return false;
      if (_selectedFoodHabit != null && rm.foodHabit != _selectedFoodHabit) return false;
      if (_selectedSleepHabit != null && rm.sleepHabit != _selectedSleepHabit) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = rm.fullName.toLowerCase().contains(q) ||
            rm.collegeOrCompany.toLowerCase().contains(q) ||
            rm.targetLocality.toLowerCase().contains(q) ||
            rm.bio.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  void _openPostProfileSheet() {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController(text: '21');
    final collegeCtrl = TextEditingController();
    final localityCtrl = TextEditingController(text: 'Navrangpura');
    final budgetCtrl = TextEditingController(text: '10000');
    final contactCtrl = TextEditingController(text: '+91 ');
    final bioCtrl = TextEditingController();
    String gender = 'Male';
    FoodHabit food = FoodHabit.pureVeg;
    SleepHabit sleep = SleepHabit.nightOwl;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          final isDark = context.isDark;

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.appBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Post Your Flatmate Profile',
                  style: AppTypography.displaySmall(
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Connect with verified students and professionals in Ahmedabad.',
                  style: AppTypography.bodySmall(
                    color: isDark ? Colors.white60 : AppColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 16),

                // Full Name
                Text('Your Full Name', style: AppTypography.monoLabel(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                const SizedBox(height: 4),
                TextField(
                  controller: nameCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.ink),
                  decoration: const InputDecoration(hintText: 'e.g. Shreyas Patel'),
                ),
                const SizedBox(height: 12),

                // Gender & Age
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gender', style: AppTypography.monoLabel(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            children: ['Male', 'Female'].map((g) {
                              return ChoiceChip(
                                label: Text(g),
                                selected: gender == g,
                                onSelected: (val) {
                                  if (val) setSheetState(() => gender = g);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age', style: AppTypography.monoLabel(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                          const SizedBox(height: 4),
                          TextField(
                            controller: ageCtrl,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: isDark ? Colors.white : AppColors.ink),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // College or Workplace
                Text('College / Workplace', style: AppTypography.monoLabel(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                const SizedBox(height: 4),
                TextField(
                  controller: collegeCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.ink),
                  decoration: const InputDecoration(hintText: 'e.g. CEPT University, Nirma, TCS'),
                ),
                const SizedBox(height: 12),

                // Target Locality & Max Budget
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target Area', style: AppTypography.monoLabel(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                          const SizedBox(height: 4),
                          TextField(
                            controller: localityCtrl,
                            style: TextStyle(color: isDark ? Colors.white : AppColors.ink),
                            decoration: const InputDecoration(hintText: 'Navrangpura'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Max Budget (₹/mo)', style: AppTypography.monoLabel(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                          const SizedBox(height: 4),
                          TextField(
                            controller: budgetCtrl,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: isDark ? Colors.white : AppColors.ink),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Food Habit
                Text('Food Preference', style: AppTypography.monoLabel(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: FoodHabit.values.map((f) {
                    return ChoiceChip(
                      label: Text(f.name == 'pureVeg' ? 'Pure Veg' : (f.name == 'jain' ? 'Jain' : (f.name == 'vegEgg' ? 'Veg+Egg' : 'Non-Veg'))),
                      selected: food == f,
                      onSelected: (val) {
                        if (val) setSheetState(() => food = f);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Bio
                Text('About You (Habits, Preferences)', style: AppTypography.monoLabel(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                const SizedBox(height: 4),
                TextField(
                  controller: bioCtrl,
                  maxLines: 2,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.ink),
                  decoration: const InputDecoration(hintText: 'e.g. Studying for exams, looking for clean flatmate.'),
                ),
                const SizedBox(height: 12),

                // Contact
                Text('WhatsApp Contact', style: AppTypography.monoLabel(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                const SizedBox(height: 4),
                TextField(
                  controller: contactCtrl,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.ink),
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.trim().isEmpty) return;
                      final profile = RoommateModel(
                        id: 'rm_${DateTime.now().millisecondsSinceEpoch}',
                        fullName: nameCtrl.text.trim(),
                        gender: gender,
                        age: int.tryParse(ageCtrl.text) ?? 21,
                        collegeOrCompany: collegeCtrl.text.trim().isNotEmpty ? collegeCtrl.text.trim() : 'Ahmedabad University',
                        targetLocality: localityCtrl.text.trim().isNotEmpty ? localityCtrl.text.trim() : 'Navrangpura',
                        budgetMax: double.tryParse(budgetCtrl.text) ?? 10000,
                        foodHabit: food,
                        sleepHabit: sleep,
                        bio: bioCtrl.text.trim().isNotEmpty ? bioCtrl.text.trim() : 'Looking for friendly roommate.',
                        contactNumber: contactCtrl.text.trim(),
                        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80',
                        postedAt: DateTime.now(),
                      );

                      widget.appState.addRoommateProfile(profile);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Roommate profile posted successfully!'),
                          backgroundColor: AppColors.teal,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Post Profile'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final roommates = _filteredRoommates;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Roommate Matcher',
          style: AppTypography.titleMedium(color: isDark ? Colors.white : AppColors.ink),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.teal),
            tooltip: 'Post Profile',
            onPressed: _openPostProfileSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            color: context.appBg,
            child: Column(
              children: [
                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: context.appSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.appBorder),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: TextStyle(fontSize: 13, color: isDark ? Colors.white : AppColors.ink),
                    decoration: InputDecoration(
                      hintText: 'Search college, locality or name...',
                      hintStyle: AppTypography.bodySmall(color: isDark ? Colors.white38 : AppColors.inkSoft),
                      prefixIcon: Icon(Icons.search_rounded, size: 18, color: isDark ? Colors.white60 : AppColors.inkSoft),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Quick Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Gender Chips
                      for (final g in ['All', 'Male', 'Female'])
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(g),
                            selected: _selectedGender == g,
                            onSelected: (val) {
                              if (val) setState(() => _selectedGender = g);
                            },
                          ),
                        ),
                      const SizedBox(width: 6),
                      // Food Habit Chips
                      for (final f in FoodHabit.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(f.name == 'pureVeg' ? 'Pure Veg' : (f.name == 'jain' ? 'Jain' : (f.name == 'vegEgg' ? 'Veg+Egg' : 'Non-Veg'))),
                            selected: _selectedFoodHabit == f,
                            onSelected: (val) {
                              setState(() => _selectedFoodHabit = val ? f : null);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Roommate Cards List
          Expanded(
            child: roommates.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_outline_rounded, size: 48, color: AppColors.inkSoft),
                        const SizedBox(height: 12),
                        Text('No matching roommates found', style: AppTypography.titleSmall(color: isDark ? Colors.white70 : AppColors.inkSoft)),
                        const SizedBox(height: 4),
                        Text('Try adjusting your search filter or budget.', style: AppTypography.bodySmall(color: isDark ? Colors.white38 : AppColors.inkSoft)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 30),
                    itemCount: roommates.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final rm = roommates[index];
                      return _buildRoommateCard(context, rm, isDark);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openPostProfileSheet,
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Post Profile'),
      ),
    );
  }

  Widget _buildRoommateCard(BuildContext context, RoommateModel rm, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
        boxShadow: const [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  rm.avatarUrl,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 54,
                    height: 54,
                    color: AppColors.marigold.withAlpha(50),
                    child: const Icon(Icons.person_rounded, color: AppColors.navy),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${rm.fullName}, ${rm.age}',
                            style: AppTypography.titleMedium(color: isDark ? Colors.white : AppColors.ink),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (rm.isVerifiedStudent) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded, size: 16, color: AppColors.teal),
                        ],
                      ],
                    ),
                    Text(
                      rm.collegeOrCompany,
                      style: AppTypography.bodySmall(color: isDark ? Colors.white70 : AppColors.inkSoft),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Seeking PG in ${rm.targetLocality}',
                      style: AppTypography.monoBadge(color: isDark ? const Color(0xFF38BDF8) : AppColors.teal).copyWith(fontSize: 9),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(rm.budgetMax),
                    style: AppTypography.monoPrice(color: isDark ? const Color(0xFF38BDF8) : AppColors.teal).copyWith(fontSize: 13),
                  ),
                  Text('max/mo', style: AppTypography.bodySmall(color: isDark ? Colors.white38 : AppColors.inkSoft).copyWith(fontSize: 9)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Lifestyle tags
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _buildTag(rm.foodHabitLabel, Icons.restaurant_rounded, isDark),
              _buildTag(rm.sleepHabitLabel, Icons.bedtime_rounded, isDark),
              _buildTag(rm.gender, Icons.person_outline_rounded, isDark),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            rm.bio,
            style: AppTypography.bodySmall(color: isDark ? Colors.white70 : AppColors.ink),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Divider(color: context.appBorder),

          // Connect actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Posted ${DateFormat('dd MMM').format(rm.postedAt)}',
                style: AppTypography.monoLabel(color: isDark ? Colors.white38 : AppColors.inkSoft).copyWith(fontSize: 9),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Connecting to ${rm.fullName} via WhatsApp (${rm.contactNumber})'),
                          backgroundColor: const Color(0xFF25D366),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                    label: const Text('Connect'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : AppColors.cream,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: isDark ? Colors.white70 : AppColors.inkSoft),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
