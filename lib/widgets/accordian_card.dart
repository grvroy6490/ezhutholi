import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:flutter/material.dart';

class AccordionCard extends StatefulWidget {
  final String title;
  final Widget content;
  final bool initiallyExpanded;

  const AccordionCard({
    super.key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  State<AccordionCard> createState() => _AccordionCardState();
}

class _AccordionCardState extends State<AccordionCard> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final surface = getFigmaColor(context, 'Surface', 'Surface Container');
    final header = getFigmaColor(context, 'Surface', 'Surface Container High');
    final onSurface = getFigmaColor(context, 'Primary', 'Dark');
    final muted = getFigmaColor(context, 'Secondary', 'Main');

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        color: surface,
        child: Column(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                width: double.infinity,
                color: header,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTypography.titleMedium().copyWith(
                          color: onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: muted.withValues(alpha: 0.5)),
                      ),
                      child: Icon(
                        isExpanded ? Icons.remove : Icons.add,
                        size: 18,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                width: double.infinity,
                color: surface,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: widget.content,
              ),
              secondChild: const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
