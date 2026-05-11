import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class S3FundsScreen extends StatefulWidget {
  const S3FundsScreen({super.key});

  @override
  State<S3FundsScreen> createState() => _S3FundsScreenState();
}

class _S3FundsScreenState extends State<S3FundsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _anim;

  final List<_Fund> _funds = [
    _Fund(
        title: 'Core Supports',
        spent: 12450,
        total: 15000,
        color: AppTheme.orange,
        icon: Icons.favorite_rounded),
    _Fund(
        title: 'Capacity Building',
        spent: 3250,
        total: 8500,
        color: AppTheme.green,
        icon: Icons.trending_up_rounded),
    _Fund(
        title: 'Capital Supports',
        spent: 2100,
        total: 5000,
        color: AppTheme.primaryLight,
        icon: Icons.home_work_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalSpent = _funds.fold(0.0, (s, f) => s + f.spent);
    final totalBudget = _funds.fold(0.0, (s, f) => s + f.total);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Funds Overview'),
      ),
      body: Column(
        children: [
          _StepBanner(step: 3),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    const Icon(Icons.update_rounded,
                        size: 14, color: AppTheme.textGray),
                    const SizedBox(width: 4),
                    Text('Updated: Today',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppTheme.textGray)),
                  ],
                ),
                const SizedBox(height: 16),
                _TotalCard(spent: totalSpent, total: totalBudget, anim: _anim),
                const SizedBox(height: 16),
                ...List.generate(_funds.length,
                    (i) => _FundProgressCard(fund: _funds[i], anim: _anim)),
                const SizedBox(height: 8),
                _SpendingHistory(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/alignment'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Check Goal Alignment'),
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
      bottomNavigationBar: const StrahBottomNav(currentIndex: 1),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final double spent;
  final double total;
  final Animation<double> anim;

  const _TotalCard(
      {required this.spent, required this.total, required this.anim});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Budget',
              style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
          const SizedBox(height: 4),
          Text('\$${_fmt(total)}',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: anim,
            builder: (context, child) => ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (spent / total) * anim.value,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Spent: \$${_fmt(spent)}',
                  style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12)),
              Text(
                  'Remaining: \$${_fmt(total - spent)}',
                  style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

class _FundProgressCard extends StatelessWidget {
  final _Fund fund;
  final Animation<double> anim;

  const _FundProgressCard({required this.fund, required this.anim});

  @override
  Widget build(BuildContext context) {
    final pct = fund.spent / fund.total;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: fund.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(fund.icon, color: fund.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fund.title,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppTheme.textDark)),
                    Text(
                        '\$${_fmt(fund.spent)} of \$${_fmt(fund.total)}',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppTheme.textGray)),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: anim,
                builder: (context, child) => Text(
                  '${(pct * 100 * anim.value).round()}%',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: fund.color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: anim,
            builder: (context, child) => ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: pct * anim.value,
                backgroundColor: fund.color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(fund.color),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Spent',
                  style: GoogleFonts.poppins(
                      fontSize: 10, color: AppTheme.textGray)),
              Text('\$${_fmt(fund.total - fund.spent)} remaining',
                  style: GoogleFonts.poppins(
                      fontSize: 10, color: AppTheme.textGray)),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

class _SpendingHistory extends StatelessWidget {
  final List<_Tx> _txs = const [
    _Tx(title: 'Daily Support - Tuesday', category: 'Core', amount: 145, date: 'Today'),
    _Tx(title: 'Support Coordination', category: 'Capacity', amount: 220, date: 'Yesterday'),
    _Tx(title: 'Transport Support', category: 'Core', amount: 65, date: '8 May'),
    _Tx(title: 'Skills Training', category: 'Capacity', amount: 180, date: '7 May'),
  ];

  const _SpendingHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Spending',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textDark)),
          const SizedBox(height: 12),
          ..._txs.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: t.category == 'Core'
                            ? AppTheme.orangeLight
                            : AppTheme.greenLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        t.category == 'Core'
                            ? Icons.favorite_rounded
                            : Icons.trending_up_rounded,
                        size: 16,
                        color: t.category == 'Core'
                            ? AppTheme.orange
                            : AppTheme.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textDark)),
                          Text(t.date,
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: AppTheme.textGray)),
                        ],
                      ),
                    ),
                    Text('-\$${t.amount}',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.orange)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _Tx {
  final String title, category, date;
  final double amount;
  const _Tx(
      {required this.title,
      required this.category,
      required this.amount,
      required this.date});
}

class _Fund {
  final String title;
  final double spent, total;
  final Color color;
  final IconData icon;
  const _Fund(
      {required this.title,
      required this.spent,
      required this.total,
      required this.color,
      required this.icon});
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
          ...List.generate(
              8,
              (i) => Expanded(
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
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
