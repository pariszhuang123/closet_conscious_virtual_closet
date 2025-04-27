import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_text_form.dart';
import '../../../../../core/widgets/form/custom_drop_down_form.dart';
import '../../../../core/data/models/calendar_metadata.dart';

class MonthlyCalendarMetadata extends StatefulWidget {
  final TextEditingController eventNameController;
  final ThemeData theme;
  final CalendarMetadata metadata;
  final void Function(String) onEventNameChanged;
  final void Function(String) onFeedbackChanged;
  final void Function(String) onOutfitActiveChanged;

  const MonthlyCalendarMetadata({
    super.key,
    required this.eventNameController,
    required this.theme,
    required this.metadata,
    required this.onEventNameChanged,
    required this.onFeedbackChanged,
    required this.onOutfitActiveChanged,
  });

  @override
  State<MonthlyCalendarMetadata> createState() => _MonthlyCalendarMetadataState();
}

class _MonthlyCalendarMetadataState extends State<MonthlyCalendarMetadata> with TickerProviderStateMixin {
  bool isExpanded = false;

  late final AnimationController _rotationController;
  late final Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.17,
                child: Scrollbar( // ✅ Add scrollbar
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Name Input
                        CustomTextFormField(
                          controller: widget.eventNameController,
                          labelText: S.of(context).eventName,
                          hintText: S.of(context).filterEventName,
                          labelStyle: widget.theme.textTheme.bodyMedium,
                          hintStyle: widget.theme.textTheme.bodyMedium,
                          focusedBorderColor: widget.theme.colorScheme.primary,
                          enabledBorderColor: widget.theme.colorScheme.secondary,
                          onChanged: widget.onEventNameChanged,
                        ),
                        const SizedBox(height: 8),

                        // Feedback Dropdown
                        CustomDropdownFormField<String>(
                          value: widget.metadata.feedback,
                          items: [
                            DropdownMenuItem(value: 'all', child: Text(S.of(context).allFeedback)),
                            DropdownMenuItem(value: 'like', child: Text(S.of(context).like)),
                            DropdownMenuItem(value: 'alright', child: Text(S.of(context).alright)),
                            DropdownMenuItem(value: 'dislike', child: Text(S.of(context).dislike)),
                          ],
                          labelText: S.of(context).feedback,
                          focusedBorderColor: widget.theme.colorScheme.primary,
                          enabledBorderColor: widget.theme.colorScheme.secondary,
                          labelStyle: widget.theme.textTheme.bodyMedium,
                          resultStyle: widget.theme.textTheme.bodyMedium,
                          onChanged: (value) {
                            if (value != null) {
                              widget.onFeedbackChanged(value);
                            }
                          },
                        ),
                        const SizedBox(height: 8),

                        // Outfit Active Dropdown
                        CustomDropdownFormField<String>(
                          value: widget.metadata.isOutfitActive,
                          items: [
                            DropdownMenuItem(value: 'all', child: Text(S.of(context).outfitsAll)),
                            DropdownMenuItem(value: 'active', child: Text(S.of(context).outfitActive)),
                            DropdownMenuItem(value: 'inactive', child: Text(S.of(context).outfitInactive)),
                          ],
                          labelText: S.of(context).outfitStatus,
                          focusedBorderColor: widget.theme.colorScheme.primary,
                          enabledBorderColor: widget.theme.colorScheme.secondary,
                          labelStyle: widget.theme.textTheme.bodyMedium,
                          resultStyle: widget.theme.textTheme.bodyMedium,
                          onChanged: (value) {
                            if (value != null) {
                              widget.onOutfitActiveChanged(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 8),

            // Expand/Collapse Button
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                  if (isExpanded) {
                    _rotationController.forward();
                  } else {
                    _rotationController.reverse();
                  }
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isExpanded ? S
                        .of(context)
                        .showLess : S
                        .of(context)
                        .showMore,
                    style: widget.theme.textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(width: 4),
                  RotationTransition(
                    turns: _iconRotation,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}