import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Widget? icon;
  final MainAxisAlignment? iconAlignment;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.icon,
    this.iconAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;
    
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: textColor ?? theme.primaryColor,
            side: BorderSide(
              color: isEnabled 
                  ? (backgroundColor ?? theme.primaryColor)
                  : theme.disabledColor,
            ),
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
            minimumSize: Size(width ?? double.infinity, height ?? 48),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: isEnabled 
                ? (backgroundColor ?? theme.primaryColor)
                : theme.disabledColor,
            foregroundColor: textColor ?? Colors.white,
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
            minimumSize: Size(width ?? double.infinity, height ?? 48),
          );

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isEnabled ? onPressed : null,
              style: buttonStyle,
              child: _buildButtonContent(context),
            )
          : ElevatedButton(
              onPressed: isEnabled ? onPressed : null,
              style: buttonStyle,
              child: _buildButtonContent(context),
            ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined 
                ? (textColor ?? Theme.of(context).primaryColor)
                : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: iconAlignment ?? MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isOutlined 
                  ? (textColor ?? Theme.of(context).primaryColor)
                  : Colors.white,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: isOutlined 
            ? (textColor ?? Theme.of(context).primaryColor)
            : Colors.white,
      ),
    );
  }
}
