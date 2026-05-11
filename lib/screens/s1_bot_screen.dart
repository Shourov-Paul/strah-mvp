import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class S1BotScreen extends StatefulWidget {
  const S1BotScreen({super.key});

  @override
  State<S1BotScreen> createState() => _S1BotScreenState();
}

class _S1BotScreenState extends State<S1BotScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  bool _isListening = false;
  final TextEditingController _textCtrl = TextEditingController();
  final List<_Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.18,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _textCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _messages.add(
          _Message(
            text:
                'I can help you understand your NDIS plan. Would you like to view your Plan Summary?',
            isUser: false,
          ),
        );
      });
    });
  }

  void _toggleMic() {
    setState(() => _isListening = !_isListening);
    if (_isListening) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isListening) {
          setState(() {
            _isListening = false;
            _messages.add(
              _Message(text: 'Show me my plan summary', isUser: true),
            );
          });
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _messages.add(
                  _Message(
                    text:
                        'Of course! Tap below to view your Plan Summary with all fund details.',
                    isUser: false,
                  ),
                );
              });
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'S-TRAH',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primarySurface,
            child: Text(
              'S',
              style: GoogleFonts.poppins(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          _StepBanner(step: 1, label: 'Ask the AI Bot'),
          Expanded(
            child: _messages.isEmpty
                ? _WelcomeView(
                    isListening: _isListening,
                    pulseAnim: _pulseAnim,
                    onMicTap: _toggleMic,
                  )
                : _ChatView(messages: _messages),
          ),
          _InputBar(
            controller: _textCtrl,
            isListening: _isListening,
            onMicTap: _toggleMic,
            onSend: _sendMessage,
            onNext: () => Navigator.pushNamed(context, '/plan'),
          ),
        ],
      ),
      bottomNavigationBar: const StrahBottomNav(currentIndex: 0),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  final bool isListening;
  final Animation<double> pulseAnim;
  final VoidCallback onMicTap;

  const _WelcomeView({
    required this.isListening,
    required this.pulseAnim,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: AppTheme.primarySurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primary,
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hi Shourov,',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  'How can I help you today?',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AppTheme.textGray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          AnimatedBuilder(
            animation: pulseAnim,
            builder: (context, _) => Transform.scale(
              scale: isListening ? pulseAnim.value : 1.0,
              child: GestureDetector(
                onTap: onMicTap,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isListening
                        ? AppTheme.primaryDark
                        : AppTheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(
                          alpha: isListening ? 0.5 : 0.3,
                        ),
                        blurRadius: isListening ? 28 : 14,
                        spreadRadius: isListening ? 8 : 3,
                      ),
                    ],
                  ),
                  child: Icon(
                    isListening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isListening ? 'Listening...' : 'Tap to speak or type',
              key: ValueKey(isListening),
              style: GoogleFonts.poppins(
                color: isListening ? AppTheme.primary : AppTheme.textGray,
                fontSize: 13,
                fontWeight: isListening ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _QuickChip(label: 'My plan summary'),
              const SizedBox(width: 8),
              _QuickChip(label: 'Track my funds'),
              const SizedBox(width: 8),
              _QuickChip(label: 'Find a worker'),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  const _QuickChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/plan'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.primarySurface,
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  final List<_Message> messages;
  const _ChatView({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, i) {
        final m = messages[i];
        return Align(
          alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: m.isUser ? AppTheme.primary : AppTheme.primarySurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              m.text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: m.isUser ? Colors.white : AppTheme.textDark,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isListening;
  final VoidCallback onMicTap;
  final ValueChanged<String> onSend;
  final VoidCallback onNext;

  const _InputBar({
    required this.controller,
    required this.isListening,
    required this.onMicTap,
    required this.onSend,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      color: AppTheme.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: onMicTap,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isListening ? AppTheme.primary : AppTheme.primarySurface,
              ),
              child: Icon(
                Icons.mic_rounded,
                color: isListening ? Colors.white : AppTheme.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type your question...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppTheme.textGray,
                ),
                filled: true,
                fillColor: AppTheme.primarySurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                isDense: true,
              ),
              style: GoogleFonts.poppins(fontSize: 13),
              onSubmitted: onSend,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onSend(controller.text),
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onNext,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Next',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  _Message({required this.text, required this.isUser});
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
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$step/8',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
