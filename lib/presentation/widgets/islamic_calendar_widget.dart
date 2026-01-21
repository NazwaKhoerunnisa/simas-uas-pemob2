import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class IslamicCalendarWidget extends StatefulWidget {
  const IslamicCalendarWidget({super.key});

  @override
  State<IslamicCalendarWidget> createState() => _IslamicCalendarWidgetState();
}

class _IslamicCalendarWidgetState extends State<IslamicCalendarWidget> {
  late int currentHijriMonth;
  late int currentHijriYear;
  int? selectedDay; // Track selected day

  @override
  void initState() {
    super.initState();
    // Today's Hijri date (approximate for demo)
    currentHijriMonth = 7; // Rajab
    currentHijriYear = 1447;
    selectedDay = 15; // Default selection
  }

  final List<String> hijriMonths = [
    'Muharram',
    'Safar',
    'Rabi\'ul Awal',
    'Rabi\'ul Akhir',
    'Jumada Al-Awwal',
    'Jumada Al-Akhir',
    'Rajab',
    'Syakban',
    'Ramadan',
    'Syawal',
    'Dzulqa\'dah',
    'Dzulhijjah',
  ];

  final List<String> dayNames = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  
  final Map<int, int> monthDays = {
    1: 30, 2: 29, 3: 30, 4: 29, 5: 30, 6: 29,
    7: 30, 8: 29, 9: 30, 10: 29, 11: 30, 12: 29
  };

  void _previousMonth() {
    setState(() {
      currentHijriMonth--;
      if (currentHijriMonth < 1) {
        currentHijriMonth = 12;
        currentHijriYear--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      currentHijriMonth++;
      if (currentHijriMonth > 12) {
        currentHijriMonth = 1;
        currentHijriYear++;
      }
    });
  }

  // Get events for specific day
  List<Map<String, String>> _getEventsForDay(int day) {
    final events = _getAllEvents();
    return events.where((e) {
      final parts = e['date']!.split(' ');
      final eventDay = int.tryParse(parts[0]) ?? 0;
      final eventMonth = hijriMonths.indexWhere((m) => m == parts[1]) + 1;
      return eventDay == day && eventMonth == currentHijriMonth;
    }).toList();
  }

  // All Islamic events throughout the year
  List<Map<String, String>> _getAllEvents() {
    return [
      {'name': 'Tahun Baru Hijriyah', 'date': '1 Muharram'},
      {'name': 'Hari Ashura', 'date': '10 Muharram'},
      {'name': 'Kelahiran Nabi Muhammad', 'date': '12 Rabi\'ul Awal'},
      {'name': 'Awal Ramadan', 'date': '1 Ramadan'},
      {'name': 'Nuzul Al-Quran', 'date': '17 Ramadan'},
      {'name': 'Idul Fitri', 'date': '1 Syawal'},
      {'name': 'Arafah', 'date': '9 Dzulhijjah'},
      {'name': 'Idul Adha', 'date': '10 Dzulhijjah'},
    ];
  }

  // Build selected event info widget
  Widget _buildSelectedEventInfo() {
    final eventsOnSelectedDay = selectedDay != null ? _getEventsForDay(selectedDay!) : [];
    
    if (eventsOnSelectedDay.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada perayaan pada tanggal $selectedDay',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perayaan pada tanggal ini:',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...eventsOnSelectedDay.map((event) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              border: Border.all(color: AppColors.accent, width: 1.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event['date']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  // Check if today is highlighted

  // Event Hijriyah penting
  @override
  Widget build(BuildContext context) {
    final monthName = hijriMonths[currentHijriMonth - 1];
    final totalDays = monthDays[currentHijriMonth] ?? 29;
    
    // Calculate starting day (simplified - 4 means Thursday for month start)
    int startingDay = (currentHijriMonth + 3) % 7;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLight, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with month/year and navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
                color: AppColors.primary,
              ),
              Column(
                children: [
                  Text(
                    monthName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '$currentHijriYear H',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Day names
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 7,
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  dayNames[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 42, // 6 weeks * 7 days
            itemBuilder: (context, index) {
              final dayNumber = index - startingDay + 1;
              final isCurrentMonth = dayNumber > 0 && dayNumber <= totalDays;
              final isSelected = isCurrentMonth && dayNumber == selectedDay;
              
              // Events marking pada tanggal tertentu
              final eventsOnDay = _getEventsForDay(dayNumber);
              final hasEvent = eventsOnDay.isNotEmpty;

              return GestureDetector(
                onTap: isCurrentMonth
                    ? () {
                        setState(() {
                          selectedDay = dayNumber;
                        });
                      }
                    : null,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : isCurrentMonth
                                ? AppColors.primaryLight
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          isCurrentMonth ? dayNumber.toString() : '',
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    // Event indicator dot
                    if (hasEvent)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          
          // Event info below calendar - only show selected day's events
          const SizedBox(height: AppSpacing.lg),
          if (selectedDay != null && selectedDay! > 0)
            _buildSelectedEventInfo(),
        ],
      ),
    );
  }
}
