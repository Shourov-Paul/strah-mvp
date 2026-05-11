import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class S7TrackingScreen extends StatefulWidget {
  const S7TrackingScreen({super.key});

  @override
  State<S7TrackingScreen> createState() => _S7TrackingScreenState();
}

class _S7TrackingScreenState extends State<S7TrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _moveCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _moveAnim;
  late Animation<double> _pulseAnim;
  int _etaMinutes = 8;
  bool _called = false;
  bool _messaged = false;

  @override
  void initState() {
    super.initState();
    _moveCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
    _moveAnim = CurvedAnimation(parent: _moveCtrl, curve: Curves.easeInOut);
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _etaMinutes > 0) {
        setState(() => _etaMinutes--);
        _startCountdown();
      }
    });
  }

  @override
  void dispose() {
    _moveCtrl.dispose();
    _pulseCtrl.dispose();
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
        title: const Text('Track Worker'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/feedback'),
            child: Text('Skip', style: GoogleFonts.poppins(color: AppTheme.primary, fontSize: 13)),
          ),
        ],
      ),
      body: Column(
        children: [
          _StepBanner(step: 7),
          Expanded(
            child: Column(
              children: [
                Expanded(flex: 3, child: _MapView(moveAnim: _moveAnim, pulseAnim: _pulseAnim)),
                Expanded(flex: 2, child: _InfoPanel(
                  etaMinutes: _etaMinutes,
                  called: _called,
                  messaged: _messaged,
                  onCall: () {
                    setState(() => _called = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Calling Aisha K...', style: GoogleFonts.poppins()),
                        backgroundColor: AppTheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  onMessage: () {
                    setState(() => _messaged = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening chat with Aisha K...', style: GoogleFonts.poppins()),
                        backgroundColor: AppTheme.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  onComplete: () => Navigator.pushNamed(context, '/feedback'),
                )),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StrahBottomNav(currentIndex: 3),
    );
  }
}

class _MapView extends StatelessWidget {
  final Animation<double> moveAnim;
  final Animation<double> pulseAnim;
  const _MapView({required this.moveAnim, required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, double.infinity),
          painter: _MapPainter(),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: moveAnim,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      (moveAnim.value - 0.5) * 60,
                      (math.sin(moveAnim.value * math.pi) - 0.5) * 40,
                    ),
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: pulseAnim,
                          builder: (context, child) => Transform.scale(
                            scale: pulseAnim.value,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: AppTheme.primary.withValues(alpha: 0.4), blurRadius: 16, spreadRadius: 4),
                                ],
                              ),
                              child: const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                              ),
                            ),
                          ),
                        ),
                        CustomPaint(
                          size: const Size(12, 8),
                          painter: _PinTailPainter(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            children: [
              _MapBtn(icon: Icons.add_rounded),
              const SizedBox(height: 8),
              _MapBtn(icon: Icons.remove_rounded),
              const SizedBox(height: 8),
              _MapBtn(icon: Icons.my_location_rounded),
            ],
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 8, color: AppTheme.green),
                const SizedBox(width: 6),
                Text('Live Tracking', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE8F4F8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final roadH = Paint()..color = const Color(0xFFFFFFFF)..strokeWidth = 22..strokeCap = StrokeCap.round;
    final roadH2 = Paint()..color = const Color(0xFFFFFFFF)..strokeWidth = 14..strokeCap = StrokeCap.round;
    final block = Paint()..color = const Color(0xFFD1E8D1);

    canvas.drawRect(Rect.fromLTWH(size.width * 0.1, size.height * 0.1, size.width * 0.35, size.height * 0.3), block);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.55, size.height * 0.1, size.width * 0.35, size.height * 0.3), block);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.1, size.height * 0.55, size.width * 0.35, size.height * 0.3), block);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.55, size.height * 0.55, size.width * 0.35, size.height * 0.3), block);

    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), roadH);
    canvas.drawLine(Offset(size.width * 0.48, 0), Offset(size.width * 0.48, size.height), roadH2);

    final route = Paint()
      ..color = AppTheme.primary.withValues(alpha: 0.6)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.85, size.height * 0.8)
      ..lineTo(size.width * 0.85, size.height * 0.45)
      ..lineTo(size.width * 0.48, size.height * 0.45)
      ..lineTo(size.width * 0.48, size.height * 0.3);
    canvas.drawPath(path, route);

    final destPaint = Paint()..color = AppTheme.green;
    canvas.drawCircle(Offset(size.width * 0.48, size.height * 0.3), 8, destPaint);
    canvas.drawCircle(Offset(size.width * 0.48, size.height * 0.3), 14, destPaint..color = AppTheme.green.withValues(alpha: 0.25));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppTheme.primary;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MapBtn extends StatelessWidget {
  final IconData icon;
  const _MapBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6)],
      ),
      child: Icon(icon, size: 18, color: AppTheme.textDark),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final int etaMinutes;
  final bool called, messaged;
  final VoidCallback onCall, onMessage, onComplete;
  const _InfoPanel({required this.etaMinutes, required this.called, required this.messaged, required this.onCall, required this.onMessage, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Color(0x12000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: Column(
        children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 14),
          Text('Your Support Worker is on the way',
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textDark),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(radius: 22, backgroundColor: AppTheme.primary, child: Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Aisha K.', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark)),
                    Text('Support Worker', style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textGray)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppTheme.primarySurface, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text('ETA', style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.textGray)),
                    Text('$etaMinutes min',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCall,
                  icon: Icon(Icons.call_rounded, size: 16, color: called ? AppTheme.green : AppTheme.primary),
                  label: Text(called ? 'Calling...' : 'Call'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: called ? AppTheme.green : AppTheme.primary),
                    foregroundColor: called ? AppTheme.green : AppTheme.primary,
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onMessage,
                  icon: Icon(Icons.message_rounded, size: 16, color: messaged ? AppTheme.green : AppTheme.primary),
                  label: Text(messaged ? 'Sent!' : 'Message'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: messaged ? AppTheme.green : AppTheme.primary),
                    foregroundColor: messaged ? AppTheme.green : AppTheme.primary,
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onComplete,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                child: const Text('Done'),
              ),
            ],
          ),
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
