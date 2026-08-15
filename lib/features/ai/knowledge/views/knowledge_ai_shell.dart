import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../search/theme/search_ai_theme.dart';
import '../../../search/views/widgets/search_ambient_orbs.dart';

class KnowledgeAiScaffold extends StatelessWidget {
  const KnowledgeAiScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ai.overlayStyle,
      child: Scaffold(
        backgroundColor: ai.pageGradient.last,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: ai.appBarBg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 8,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ai.aiBadgeGradient,
                  boxShadow: [
                    BoxShadow(
                      color: SearchAiTheme.cyan.withValues(alpha: 0.35),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: ai.text,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: ai.text),
          actions: actions,
        ),
        floatingActionButton: floatingActionButton,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: ai.pageGradient,
                  ),
                ),
              ),
            ),
            const Positioned.fill(child: SearchAmbientOrbs()),
            Positioned(
              top: 40,
              right: -50,
              child: IgnorePointer(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: ai.orbCyanGradient,
                  ),
                ),
              ),
            ),
            Positioned.fill(child: body),
          ],
        ),
      ),
    );
  }
}

class KnowledgeAiCard extends StatelessWidget {
  const KnowledgeAiCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(14),
    this.expand = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    final card = Container(
      width: double.infinity,
      height: expand ? double.infinity : null,
      padding: padding,
      decoration: BoxDecoration(
        color: ai.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ai.cardBorder),
        boxShadow: ai.cardShadow,
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      ),
    );
  }
}

InputDecoration knowledgeAiInput(BuildContext context, String label) {
  final ai = SearchAiTheme.of(context);
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: ai.cardBorder),
  );
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: ai.textSecondary),
    hintStyle: TextStyle(color: ai.textSecondary.withValues(alpha: 0.8)),
    filled: true,
    fillColor: ai.searchBarBg,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: SearchAiTheme.cyan, width: 1.4),
    ),
    border: border,
  );
}

ButtonStyle knowledgeAiPrimaryButton() {
  return FilledButton.styleFrom(
    backgroundColor: SearchAiTheme.brandRed,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
  );
}
