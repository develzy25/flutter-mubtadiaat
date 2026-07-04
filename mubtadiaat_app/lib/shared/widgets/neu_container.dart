import 'package:flutter/material.dart';

class NeuContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;
  final double shadowBlur;
  final double shadowOffset;

  const NeuContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 20.0,
    this.color,
    this.shadowBlur = 10.0,
    this.shadowOffset = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? const Color(0xFFF0F3F8); // Very light bluish grey

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-shadowOffset, -shadowOffset),
            blurRadius: shadowBlur,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(shadowOffset, shadowOffset),
            blurRadius: shadowBlur,
          ),
        ],
      ),
      child: child,
    );
  }
}
