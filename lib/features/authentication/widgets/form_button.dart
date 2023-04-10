import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';

class FormButton extends StatelessWidget {
  final bool enabled;
  final void Function(BuildContext context)? onClick;

  const FormButton({
    super.key,
    required this.enabled,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => enabled ? onClick?.call(context) : null,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
          decoration: BoxDecoration(
            color:
                enabled ? Theme.of(context).primaryColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(Sizes.size5),
          ),
          duration: const Duration(milliseconds: 200),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: enabled ? Colors.white : Colors.grey.shade400,
              fontWeight: FontWeight.w600,
            ),
            child: const Text(
              'Next',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
