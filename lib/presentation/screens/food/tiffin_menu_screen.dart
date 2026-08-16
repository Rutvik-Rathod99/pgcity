import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class TiffinMenuScreen extends StatefulWidget {
  final AppState appState;
  final String? pgName;

  const TiffinMenuScreen({super.key, required this.appState, this.pgName});

  @override
  State<TiffinMenuScreen> createState() => _TiffinMenuScreenState();
}

class _TiffinMenuScreenState extends State<TiffinMenuScreen> {
  int _selectedDayIndex = 0;
  final Map<String, bool> _mealRsvp = {
    'Breakfast': true,
    'Lunch': true,
    'High Tea': true,
    'Dinner': true,
  };

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final Map<String, Map<String, dynamic>> _weeklyMenu = {
    'Monday': {
      'Breakfast': {
        'items': 'Poha, Sprouts, Banana, Chai / Milk',
        'time': '7:30 AM - 9:30 AM',
        'jain': true,
      },
      'Lunch': {
        'items':
            'Paneer Butter Masala, Roti, Dal Fry, Jeera Rice, Salad, Buttermilk',
        'time': '12:30 PM - 2:30 PM',
        'jain': true,
      },
      'High Tea': {
        'items': 'Samosa / Biscuits, Ginger Tea, Coffee',
        'time': '5:00 PM - 6:30 PM',
        'jain': false,
      },
      'Dinner': {
        'items': 'Sev Tameta Nu Shaak, Bhakri, Khichdi Kadhi, Papad, Pickle',
        'time': '7:30 PM - 9:30 PM',
        'jain': true,
      },
    },
    'Tuesday': {
      'Breakfast': {
        'items': 'Idli Sambhar, Coconut Chutney, Chai / Coffee',
        'time': '7:30 AM - 9:30 AM',
        'jain': true,
      },
      'Lunch': {
        'items':
            'Aloo Gobi, Gujarati Kadhi, Phulka Roti, Steamed Rice, Sweet Lassi',
        'time': '12:30 PM - 2:30 PM',
        'jain': true,
      },
      'High Tea': {
        'items': 'Khaman Dhokla, Mint Chutney, Tea',
        'time': '5:00 PM - 6:30 PM',
        'jain': true,
      },
      'Dinner': {
        'items': 'Chole Bhature / Roti, Veg Pulao, Raita, Gulab Jamun',
        'time': '7:30 PM - 9:30 PM',
        'jain': false,
      },
    },
    'Wednesday': {
      'Breakfast': {
        'items': 'Aloo Paratha, Curd, Pickle, Tea / Milk',
        'time': '7:30 AM - 9:30 AM',
        'jain': false,
      },
      'Lunch': {
        'items': 'Mix Veg Subji, Dal Tadka, Roti, Rice, Boondi Raita, Salad',
        'time': '12:30 PM - 2:30 PM',
        'jain': true,
      },
      'High Tea': {
        'items': 'Puff Pastry, Maskabun, Masala Chai',
        'time': '5:00 PM - 6:30 PM',
        'jain': false,
      },
      'Dinner': {
        'items':
            'Kathiyawadi Undhiyu / Ringan Bhartu, Bajra Rotla, Garlic Chutney, Buttermilk',
        'time': '7:30 PM - 9:30 PM',
        'jain': true,
      },
    },
    'Thursday': {
      'Breakfast': {
        'items': 'Upma, Coconut Chutney, Seasonal Fruits, Chai',
        'time': '7:30 AM - 9:30 AM',
        'jain': true,
      },
      'Lunch': {
        'items': 'Rajma Masala, Steamed Basmati Rice, Roti, Onion Salad, Curd',
        'time': '12:30 PM - 2:30 PM',
        'jain': true,
      },
      'High Tea': {
        'items': 'Methi Gota / Pakoda, Sweet Chutney, Tea',
        'time': '5:00 PM - 6:30 PM',
        'jain': false,
      },
      'Dinner': {
        'items':
            'Palak Paneer, Tawa Roti, Veg Biryani, Mirchi Ka Salan, Ice Cream',
        'time': '7:30 PM - 9:30 PM',
        'jain': true,
      },
    },
    'Friday': {
      'Breakfast': {
        'items': 'Methi Thepla, Chhunda, Curd, Masala Chai',
        'time': '7:30 AM - 9:30 AM',
        'jain': true,
      },
      'Lunch': {
        'items':
            'Bhindi Masala, Gujarati Dal, Phulka Roti, Steamed Rice, Buttermilk',
        'time': '12:30 PM - 2:30 PM',
        'jain': true,
      },
      'High Tea': {
        'items': 'Veg Sandwich / Toast, Coffee / Tea',
        'time': '5:00 PM - 6:30 PM',
        'jain': true,
      },
      'Dinner': {
        'items': 'Pav Bhaji (Jain & Regular), Pulao, Roasted Papad, Rasgulla',
        'time': '7:30 PM - 9:30 PM',
        'jain': true,
      },
    },
    'Saturday': {
      'Breakfast': {
        'items': 'Uttapam, Sambhar, Tomato Chutney, Chai / Milk',
        'time': '8:00 AM - 10:00 AM',
        'jain': true,
      },
      'Lunch': {
        'items': 'Dal Makhani, Butter Roti, Jeera Rice, Cucumber Salad, Chaas',
        'time': '12:30 PM - 2:30 PM',
        'jain': true,
      },
      'High Tea': {
        'items': 'Bhel Puri / Khakhra, Green Tea / Chai',
        'time': '5:00 PM - 6:30 PM',
        'jain': true,
      },
      'Dinner': {
        'items': 'Dum Aloo, Laccha Paratha, Veg Pulao, Moong Dal Halwa',
        'time': '7:30 PM - 9:30 PM',
        'jain': false,
      },
    },
    'Sunday': {
      'Breakfast': {
        'items': 'Special Sunday Puri Bhaji, Shrikhand, Hot Jalebi, Masala Tea',
        'time': '8:00 AM - 10:30 AM',
        'jain': true,
      },
      'Lunch': {
        'items':
            'Gujarati Special Thali (Farsan, 2 Subjis, Dal, Rice, Puri, Sweet)',
        'time': '12:30 PM - 3:00 PM',
        'jain': true,
      },
      'High Tea': {
        'items': 'Cookies & Dry Snacks, Chai / Filter Coffee',
        'time': '5:00 PM - 6:30 PM',
        'jain': true,
      },
      'Dinner': {
        'items': 'Special Veg Hakka Noodles, Manchurian / Khichdi Kadhi',
        'time': '7:30 PM - 9:30 PM',
        'jain': true,
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final activeDay = _days[_selectedDayIndex];
    final dayMenu = _weeklyMenu[activeDay] ?? {};

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.ink,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Tiffin & Meal Menu',
              style: AppTypography.titleMedium(
                color: isDark ? Colors.white : AppColors.ink,
              ),
            ),
            Text(
              widget.pgName ?? 'Ahmedabad Verified Kitchens',
              style: AppTypography.bodySmall(
                color: isDark ? Colors.white60 : AppColors.inkSoft,
              ).copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          // 1. Kitchen Hygiene & Certified Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0F3934), const Color(0xFF1E293B)]
                    : [AppColors.tealLight, AppColors.paper],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.teal),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'FSSAI Certified 4.8★ Kitchen',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.ink,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: AppColors.teal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '100% Pure Veg with Dedicated Jain & Swaminarayan counters.',
                        style: AppTypography.bodySmall(
                          color: isDark ? Colors.white70 : AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Day Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_days.length, (idx) {
                final isSelected = idx == _selectedDayIndex;
                final day = _days[idx];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDayIndex = idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppColors.marigold : AppColors.navy)
                            : context.appSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? (isDark ? AppColors.marigold : AppColors.navy)
                              : context.appBorder,
                        ),
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? (isDark ? AppColors.navy : Colors.white)
                              : (isDark ? Colors.white70 : AppColors.inkSoft),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 18),

          // 3. Meals List for Selected Day
          for (final mealName in ['Breakfast', 'Lunch', 'High Tea', 'Dinner'])
            if (dayMenu.containsKey(mealName)) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getMealIcon(mealName),
                              size: 18,
                              color: AppColors.marigoldDark,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              mealName,
                              style: AppTypography.titleMedium(
                                color: isDark ? Colors.white : AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (dayMenu[mealName]['jain'] == true)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.tealLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'JAIN AVAILABLE',
                                  style: TextStyle(
                                    color: AppColors.teal,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Text(
                              dayMenu[mealName]['time'],
                              style: AppTypography.monoLabel(
                                color: isDark
                                    ? Colors.white60
                                    : AppColors.inkSoft,
                              ).copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dayMenu[mealName]['items'],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(color: context.appBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Attending this meal?',
                          style: AppTypography.bodySmall(
                            color: isDark ? Colors.white60 : AppColors.inkSoft,
                          ),
                        ),
                        Row(
                          children: [
                            ChoiceChip(
                              label: const Text(
                                'Yes',
                                style: TextStyle(fontSize: 11),
                              ),
                              selected: _mealRsvp[mealName] == true,
                              selectedColor: AppColors.teal,
                              labelStyle: TextStyle(
                                color: _mealRsvp[mealName] == true
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : AppColors.ink),
                              ),
                              onSelected: (val) {
                                setState(() => _mealRsvp[mealName] = true);
                              },
                            ),
                            const SizedBox(width: 6),
                            ChoiceChip(
                              label: const Text(
                                'Skipping',
                                style: TextStyle(fontSize: 11),
                              ),
                              selected: _mealRsvp[mealName] == false,
                              selectedColor: AppColors.error,
                              labelStyle: TextStyle(
                                color: _mealRsvp[mealName] == false
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : AppColors.ink),
                              ),
                              onSelected: (val) {
                                setState(() => _mealRsvp[mealName] = false);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }

  IconData _getMealIcon(String meal) {
    switch (meal) {
      case 'Breakfast':
        return Icons.wb_sunny_rounded;
      case 'Lunch':
        return Icons.soup_kitchen_rounded;
      case 'High Tea':
        return Icons.local_cafe_rounded;
      case 'Dinner':
        return Icons.nights_stay_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }
}
