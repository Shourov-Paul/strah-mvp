import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class S5WorkersScreen extends StatefulWidget {
  const S5WorkersScreen({super.key});

  @override
  State<S5WorkersScreen> createState() => _S5WorkersScreenState();
}

class _S5WorkersScreenState extends State<S5WorkersScreen> {
  int _selectedWorker = -1;
  String _filterLanguage = 'All';

  final List<_Worker> _workers = [
    _Worker(name: 'Aisha K.', language: 'Arabic', gender: 'Female', rating: 4.8, rate: 55, initials: 'AK', color: Color(0xFF7C3AED), skills: ['Daily Living', 'Community Access', 'Transport']),
    _Worker(name: 'Michael T.', language: 'English', gender: 'Male', rating: 4.7, rate: 50, initials: 'MT', color: Color(0xFF0369A1), skills: ['Personal Care', 'Household Tasks', 'Social Support']),
    _Worker(name: 'Fatima R.', language: 'Arabic', gender: 'Female', rating: 4.6, rate: 60, initials: 'FR', color: Color(0xFF059669), skills: ['Therapy Support', 'Communication', 'Daily Living']),
    _Worker(name: 'David L.', language: 'English', gender: 'Male', rating: 4.5, rate: 48, initials: 'DL', color: Color(0xFFD97706), skills: ['Employment Support', 'Life Skills', 'Transport']),
  ];

  List<_Worker> get _filtered => _filterLanguage == 'All'
      ? _workers
      : _workers.where((w) => w.language == _filterLanguage).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Recommended Workers'),
      ),
      body: Column(
        children: [
          _StepBanner(step: 5),
          _FilterBar(
            selected: _filterLanguage,
            onSelect: (v) => setState(() {
              _filterLanguage = v;
              _selectedWorker = -1;
            }),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '${_filtered.length} workers match your profile',
                  style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textGray),
                ),
                const SizedBox(height: 12),
                ..._filtered.asMap().entries.map((e) => _WorkerCard(
                      worker: e.value,
                      isSelected: _selectedWorker == e.key,
                      onTap: () => setState(() =>
                          _selectedWorker = _selectedWorker == e.key ? -1 : e.key),
                      onBook: () => Navigator.pushNamed(context, '/booking'),
                    )),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: AppTheme.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('View All Workers',
                      style: GoogleFonts.poppins(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StrahBottomNav(currentIndex: 2),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _FilterBar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: ['All', 'Arabic', 'English'].map((lang) {
          final active = selected == lang;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(lang),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: active ? AppTheme.primary : AppTheme.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(lang,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: active ? Colors.white : AppTheme.primary,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final _Worker worker;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onBook;
  const _WorkerCard({required this.worker, required this.isSelected, required this.onTap, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected ? AppTheme.primary.withValues(alpha: 0.5) : AppTheme.border),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: worker.color,
                    child: Text(worker.initials,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(worker.name,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)),
                        Text('${worker.language} · ${worker.gender}',
                            style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textGray)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                            const SizedBox(width: 2),
                            Text(worker.rating.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                            const SizedBox(width: 8),
                            Text('\$${worker.rate.toInt()}/hr',
                                style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textGray)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      _CompatBadge(score: ((worker.rating / 5) * 100).round()),
                      const SizedBox(height: 6),
                      Icon(
                        isSelected ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                        color: AppTheme.textGray, size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Skills & Experience',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: worker.skills.map((s) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primarySurface,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(s,
                                style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.primary)),
                          )).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.message_rounded, size: 14),
                            label: const Text('Message'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppTheme.primary),
                              foregroundColor: AppTheme.primary,
                              textStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onBook,
                            icon: const Icon(Icons.calendar_today_rounded, size: 14),
                            label: const Text('Book'),
                            style: ElevatedButton.styleFrom(
                              textStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompatBadge extends StatelessWidget {
  final int score;
  const _CompatBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text('$score%',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.green)),
          Text('match', style: GoogleFonts.poppins(fontSize: 8, color: AppTheme.green)),
        ],
      ),
    );
  }
}

class _Worker {
  final String name, language, gender, initials;
  final double rating, rate;
  final Color color;
  final List<String> skills;
  const _Worker({required this.name, required this.language, required this.gender, required this.rating, required this.rate, required this.initials, required this.color, required this.skills});
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
