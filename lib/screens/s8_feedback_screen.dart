import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class S8FeedbackScreen extends StatefulWidget {
  const S8FeedbackScreen({super.key});

  @override
  State<S8FeedbackScreen> createState() => _S8FeedbackScreenState();
}

class _S8FeedbackScreenState extends State<S8FeedbackScreen>
    with SingleTickerProviderStateMixin {
  int _rating = 0;
  int _hoveredStar = 0;
  final TextEditingController _commentCtrl = TextEditingController();
  bool _submitted = false;
  late AnimationController _successCtrl;
  late Animation<double> _scaleAnim;

  final List<String> _quickTags = [
    'Very professional',
    'On time',
    'Great communication',
    'Caring',
    'Highly skilled',
  ];
  final Set<String> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    _successCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _successCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a star rating first.',
              style: GoogleFonts.poppins()),
          backgroundColor: AppTheme.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() => _submitted = true);
    _successCtrl.forward();
  }

  String get _ratingLabel {
    switch (_rating) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Very Good';
      case 5: return 'Excellent!';
      default: return 'Tap a star to rate';
    }
  }

  Color get _ratingColor {
    if (_rating <= 2) return AppTheme.red;
    if (_rating == 3) return AppTheme.orange;
    return AppTheme.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: _submitted
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Navigator.pop(context),
              ),
        automaticallyImplyLeading: false,
        title: const Text('Provide Feedback'),
      ),
      body: Column(
        children: [
          _StepBanner(step: 8),
          Expanded(
            child: _submitted ? _SuccessView(rating: _rating, scaleAnim: _scaleAnim) : _FeedbackForm(
              rating: _rating,
              hoveredStar: _hoveredStar,
              ratingLabel: _ratingLabel,
              ratingColor: _ratingColor,
              commentCtrl: _commentCtrl,
              quickTags: _quickTags,
              selectedTags: _selectedTags,
              onStarHover: (i) => setState(() => _hoveredStar = i),
              onStarTap: (i) => setState(() => _rating = i),
              onTagToggle: (tag) => setState(() {
                if (_selectedTags.contains(tag)) {
                  _selectedTags.remove(tag);
                } else {
                  _selectedTags.add(tag);
                }
              }),
              onSubmit: _submit,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StrahBottomNav(currentIndex: 0),
    );
  }
}

class _FeedbackForm extends StatelessWidget {
  final int rating, hoveredStar;
  final String ratingLabel;
  final Color ratingColor;
  final TextEditingController commentCtrl;
  final List<String> quickTags;
  final Set<String> selectedTags;
  final ValueChanged<int> onStarHover, onStarTap;
  final ValueChanged<String> onTagToggle;
  final VoidCallback onSubmit;

  const _FeedbackForm({
    required this.rating,
    required this.hoveredStar,
    required this.ratingLabel,
    required this.ratingColor,
    required this.commentCtrl,
    required this.quickTags,
    required this.selectedTags,
    required this.onStarHover,
    required this.onStarTap,
    required this.onTagToggle,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.primary,
                child: Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              const SizedBox(height: 10),
              Text('How was your service?',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
              Text('with Aisha K.',
                  style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textGray)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final starIdx = i + 1;
                  final filled = starIdx <= (hoveredStar > 0 ? hoveredStar : rating);
                  return GestureDetector(
                    onTap: () => onStarTap(starIdx),
                    child: MouseRegion(
                      onEnter: (_) => onStarHover(starIdx),
                      onExit: (_) => onStarHover(0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          filled ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: filled ? const Color(0xFFF59E0B) : AppTheme.border,
                          size: filled ? 44 : 38,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  ratingLabel,
                  key: ValueKey(rating),
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: rating > 0 ? ratingColor : AppTheme.textGray),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (rating >= 4) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What did you like?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textDark)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: quickTags.map((tag) {
                    final sel = selectedTags.contains(tag);
                    return GestureDetector(
                      onTap: () => onTagToggle(tag),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: sel ? AppTheme.primary : AppTheme.primarySurface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: sel ? AppTheme.primary : AppTheme.border),
                        ),
                        child: Text(tag,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: sel ? Colors.white : AppTheme.primary,
                                fontWeight: FontWeight.w500)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Share your experience (optional)',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textDark)),
              const SizedBox(height: 10),
              TextField(
                controller: commentCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tell us about your experience...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textGray),
                  filled: true,
                  fillColor: AppTheme.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded, size: 18),
              SizedBox(width: 8),
              Text('Submit Feedback'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
          child: Text('Skip for now',
              style: GoogleFonts.poppins(color: AppTheme.textGray, fontSize: 13)),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final int rating;
  final Animation<double> scaleAnim;
  const _SuccessView({required this.rating, required this.scaleAnim});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: scaleAnim,
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(color: AppTheme.green, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
              ),
            ),
            const SizedBox(height: 24),
            Text('Thank You!',
                style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
            const SizedBox(height: 8),
            Text('Your feedback helps improve S-TRAH for all participants.',
                style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textGray),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => Icon(
                    i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: i < rating ? const Color(0xFFF59E0B) : AppTheme.border,
                    size: 32,
                  )),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
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
