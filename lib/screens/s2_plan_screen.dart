import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class S2PlanScreen extends StatefulWidget {
  const S2PlanScreen({super.key});

  @override
  State<S2PlanScreen> createState() => _S2PlanScreenState();
}

class _S2PlanScreenState extends State<S2PlanScreen> {
  int _expanded = -1;

  final List<_FundCategory> _categories = [
    _FundCategory(
      title: 'Core Supports',
      amount: 13450,
      icon: Icons.favorite_rounded,
      color: AppTheme.primary,
      description: 'Supports for daily activities, transport, and consumables.',
      items: ['Daily Activities \$8,200', 'Transport \$2,750', 'Consumables \$2,500'],
    ),
    _FundCategory(
      title: 'Capacity Building',
      amount: 8500,
      icon: Icons.trending_up_rounded,
      color: AppTheme.green,
      description: 'Supports to build your independence and skills.',
      items: ['Support Coordination \$3,500', 'Employment \$2,500', 'Life Skills \$2,500'],
    ),
    _FundCategory(
      title: 'Capital Supports',
      amount: 5000,
      icon: Icons.home_work_rounded,
      color: AppTheme.orange,
      description: 'Higher-cost items like assistive technology and home mods.',
      items: ['Assistive Technology \$3,000', 'Home Modifications \$2,000'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Your Plan Summary'),
      ),
      body: Column(
        children: [
          _StepBanner(step: 2, label: 'Understand Plan'),
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
                ...List.generate(_categories.length, (i) {
                  final cat = _categories[i];
                  return _ExpandableFundCard(
                    category: cat,
                    isExpanded: _expanded == i,
                    onTap: () =>
                        setState(() => _expanded = _expanded == i ? -1 : i),
                  );
                }),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.greenLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppTheme.green.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppTheme.green, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You have \$12,450 available in Core Supports for daily living.',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppTheme.green,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/funds'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Track My Funds'),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StrahBottomNav(currentIndex: 4),
    );
  }
}

class _ExpandableFundCard extends StatelessWidget {
  final _FundCategory category;
  final bool isExpanded;
  final VoidCallback onTap;

  const _ExpandableFundCard({
    required this.category,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded
                ? category.color.withValues(alpha: 0.4)
                : AppTheme.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(category.icon,
                        color: category.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.title,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppTheme.textDark)),
                        Text(category.description,
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: AppTheme.textGray),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${_fmt(category.amount)}',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: category.color),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: AppTheme.textGray,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              const Divider(height: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: category.items
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 6, color: category.color),
                                const SizedBox(width: 8),
                                Text(item,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: AppTheme.textDark)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _fmt(double v) =>
      v.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

class _FundCategory {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final String description;
  final List<String> items;

  _FundCategory({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.description,
    required this.items,
  });
}

class _StepBanner extends StatelessWidget {
  final int step;
  final String label;
  const _StepBanner({required this.step, required this.label});

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
