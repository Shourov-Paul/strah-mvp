import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class S6BookingScreen extends StatefulWidget {
  const S6BookingScreen({super.key});

  @override
  State<S6BookingScreen> createState() => _S6BookingScreenState();
}

class _S6BookingScreenState extends State<S6BookingScreen> {
  DateTime _selectedDate = DateTime(2025, 5, 25);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  double _duration = 2;
  String _selectedCategory = 'Core Supports';
  bool _confirmed = false;

  final List<String> _categories = ['Core Supports', 'Capacity Building', 'Capital Supports'];

  String get _workerName => 'Aisha K.';
  String get _rate => '\$55/hr';
  double get _totalCost => _duration * 55;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _confirm() {
    setState(() => _confirmed = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.pushNamed(context, '/tracking');
    });
  }

  String _fmtDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _fmtTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Book a Service'),
      ),
      body: Column(
        children: [
          _StepBanner(step: 6),
          Expanded(
            child: _confirmed
                ? _SuccessView(workerName: _workerName)
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _WorkerSummaryCard(name: _workerName, rate: _rate),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'Date & Time',
                        child: Column(
                          children: [
                            _TappableField(
                              icon: Icons.calendar_today_rounded,
                              label: 'Date',
                              value: _fmtDate(_selectedDate),
                              onTap: _pickDate,
                            ),
                            const SizedBox(height: 10),
                            _TappableField(
                              icon: Icons.access_time_rounded,
                              label: 'Time',
                              value: _fmtTime(_selectedTime),
                              onTap: _pickTime,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        title: 'Duration',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${_duration.toInt()} hour${_duration > 1 ? "s" : ""}',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: AppTheme.primary)),
                                Text('Total: \$${_totalCost.toStringAsFixed(0)}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textDark)),
                              ],
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppTheme.primary,
                                thumbColor: AppTheme.primary,
                                inactiveTrackColor: AppTheme.primarySurface,
                                overlayColor: AppTheme.primary.withValues(alpha: 0.12),
                              ),
                              child: Slider(
                                value: _duration,
                                min: 1,
                                max: 8,
                                divisions: 7,
                                onChanged: (v) => setState(() => _duration = v),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('1 hr', style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.textGray)),
                                Text('8 hrs', style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.textGray)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        title: 'Fund Category',
                        child: Column(
                          children: _categories.map((c) => GestureDetector(
                                onTap: () => setState(() => _selectedCategory = c),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _selectedCategory == c
                                        ? AppTheme.primarySurface
                                        : AppTheme.background,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: _selectedCategory == c
                                            ? AppTheme.primary
                                            : AppTheme.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _selectedCategory == c
                                            ? Icons.radio_button_checked_rounded
                                            : Icons.radio_button_off_rounded,
                                        color: _selectedCategory == c
                                            ? AppTheme.primary
                                            : AppTheme.textGray,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(c,
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: _selectedCategory == c
                                                  ? AppTheme.primary
                                                  : AppTheme.textDark,
                                              fontWeight: _selectedCategory == c
                                                  ? FontWeight.w600
                                                  : FontWeight.w400)),
                                    ],
                                  ),
                                ),
                              )).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        title: 'Location',
                        child: _TappableField(
                          icon: Icons.location_on_rounded,
                          label: 'Location',
                          value: 'Brisbane, QLD',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(height: 20),
                      _CostSummary(duration: _duration, rate: 55, category: _selectedCategory),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _confirm,
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Confirm Booking'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const StrahBottomNav(currentIndex: 0),
    );
  }
}

class _WorkerSummaryCard extends StatelessWidget {
  final String name, rate;
  const _WorkerSummaryCard({required this.name, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: AppTheme.primary,
            child: Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)),
                Text('Support Worker · $rate', style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textGray)),
              ],
            ),
          ),
          const Icon(Icons.verified_rounded, color: AppTheme.primary, size: 20),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textDark)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TappableField extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final VoidCallback onTap;
  const _TappableField({required this.icon, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(value,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textDark)),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textGray, size: 18),
          ],
        ),
      ),
    );
  }
}

class _CostSummary extends StatelessWidget {
  final double duration, rate;
  final String category;
  const _CostSummary({required this.duration, required this.rate, required this.category});

  @override
  Widget build(BuildContext context) {
    final total = duration * rate;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.greenLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _Row(label: 'Duration', value: '${duration.toInt()} hours'),
          const SizedBox(height: 4),
          _Row(label: 'Rate', value: '\$${rate.toInt()}/hr'),
          const SizedBox(height: 4),
          _Row(label: 'Fund Category', value: category),
          const Divider(),
          _Row(label: 'Total Cost', value: '\$${total.toStringAsFixed(0)}', bold: true),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _Row({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textGray)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: bold ? AppTheme.green : AppTheme.textDark)),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String workerName;
  const _SuccessView({required this.workerName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(color: AppTheme.green, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
          ),
          const SizedBox(height: 20),
          Text('Booking Confirmed!',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
          const SizedBox(height: 8),
          Text('$workerName is on her way.',
              style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textGray)),
          const SizedBox(height: 4),
          Text('Redirecting to tracking...',
              style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textGray)),
        ],
      ),
    );
  }
}

class _StepBanner extends StatelessWidget {
  final int step;
  const _StepBanner({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppTheme.primarySurface,
      child: Row(
        children: [
          ...List.generate(8, (i) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i < step ? AppTheme.primary : AppTheme.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )),
          const SizedBox(width: 8),
          Text('$step/8',
              style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
