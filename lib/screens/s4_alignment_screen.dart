import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class S4AlignmentScreen extends StatefulWidget {
  const S4AlignmentScreen({super.key});

  @override
  State<S4AlignmentScreen> createState() => _S4AlignmentScreenState();
}

class _S4AlignmentScreenState extends State<S4AlignmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  int? _selectedGoal;

  final List<_Goal> _goals = [
    _Goal(title: 'Improve daily independence', status: GoalStatus.onTrack, progress: 0.85, support: 'Core Supports'),
    _Goal(title: 'Build social connections', status: GoalStatus.onTrack, progress: 0.70, support: 'Capacity Building'),
    _Goal(title: 'Gain employment skills', status: GoalStatus.onTrack, progress: 0.60, support: 'Capacity Building'),
    _Goal(title: 'Home modification setup', status: GoalStatus.atRisk, progress: 0.20, support: 'Capital Supports'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
        title: const Text('Goal Alignment'),
      ),
      body: Column(
        children: [
          _StepBanner(step: 4),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _CircularProgressCard(anim: _anim, goals: _goals),
                const SizedBox(height: 16),
                _SummaryRow(goals: _goals),
                const SizedBox(height: 16),
                Text('Your Goals',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppTheme.textDark)),
                const SizedBox(height: 10),
                ...List.generate(_goals.length, (i) => _GoalCard(
                      goal: _goals[i],
                      isSelected: _selectedGoal == i,
                      onTap: () => setState(() =>
                          _selectedGoal = _selectedGoal == i ? null : i),
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/workers'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Find Support Workers'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
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

class _CircularProgressCard extends StatelessWidget {
  final Animation<double> anim;
  final List<_Goal> goals;
  const _CircularProgressCard({required this.anim, required this.goals});

  @override
  Widget build(BuildContext context) {
    final onTrack = goals.where((g) => g.status == GoalStatus.onTrack).length;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: anim,
            builder: (context, child) => CustomPaint(
              size: const Size(160, 160),
              painter: _CirclePainter(progress: 0.75 * anim.value),
              child: SizedBox(
                width: 160,
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(75 * anim.value).round()}%',
                      style: GoogleFonts.poppins(
                          fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.primary),
                    ),
                    Text('On Track',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textGray)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You are on track with $onTrack of ${goals.length} goals',
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  _CirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final radius = (size.width - 20) / 2;
    final bg = Paint()
      ..color = AppTheme.primarySurface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, cy), radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter old) => old.progress != progress;
}

class _SummaryRow extends StatelessWidget {
  final List<_Goal> goals;
  const _SummaryRow({required this.goals});

  @override
  Widget build(BuildContext context) {
    final onTrack = goals.where((g) => g.status == GoalStatus.onTrack).length;
    final atRisk = goals.where((g) => g.status == GoalStatus.atRisk).length;
    final notAligned = goals.where((g) => g.status == GoalStatus.notAligned).length;
    return Row(
      children: [
        _SummaryChip(label: 'On Track', count: onTrack, color: AppTheme.green),
        const SizedBox(width: 8),
        _SummaryChip(label: 'At Risk', count: atRisk, color: AppTheme.orange),
        const SizedBox(width: 8),
        _SummaryChip(label: 'Not Aligned', count: notAligned, color: AppTheme.red),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _SummaryChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text('$count',
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label,
                style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final _Goal goal;
  final bool isSelected;
  final VoidCallback onTap;
  const _GoalCard({required this.goal, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = goal.status == GoalStatus.onTrack
        ? AppTheme.green
        : goal.status == GoalStatus.atRisk
            ? AppTheme.orange
            : AppTheme.red;
    final label = goal.status == GoalStatus.onTrack
        ? 'On Track'
        : goal.status == GoalStatus.atRisk
            ? 'At Risk'
            : 'Not Aligned';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSelected ? color.withValues(alpha: 0.5) : AppTheme.border),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(goal.title,
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 10),
              Text('Funded by: ${goal.support}',
                  style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textGray)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: goal.progress,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 4),
              Text('${(goal.progress * 100).round()}% complete',
                  style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.textGray)),
            ],
          ],
        ),
      ),
    );
  }
}

enum GoalStatus { onTrack, atRisk, notAligned }

class _Goal {
  final String title, support;
  final GoalStatus status;
  final double progress;
  const _Goal({required this.title, required this.status, required this.progress, required this.support});
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
