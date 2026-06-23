import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.backgroundColor,
    this.height = kToolbarHeight,
    this.titleText,
    this.titleColor,
    this.titleStyle,
    this.actions,
    this.onTap,
    this.iconColor,
    this.foregroundColor,
    this.isCrossIcon = false,
    this.showIcon = true,
    this.leading,
    this.leadingWidth,
    this.titleSpacing,
    this.centerTitle = false,
    this.showDivider = false,
    this.dividerThickness = 1.0,
    this.dividerColor,
    this.isBackButtonVisible = true,
    this.title,
    this.showActions = false,
    this.bottom,
  });

  final Color? backgroundColor;
  final double height;
  final String? titleText;
  final Color? titleColor;
  final List<Widget>? actions;
  final TextStyle? titleStyle;
  final Color? iconColor;
  final Color? foregroundColor;
  final void Function()? onTap;
  final bool isCrossIcon;
  final Widget? leading;
  final bool showIcon;
  final double? leadingWidth;
  final double? titleSpacing;
  final bool centerTitle;
  final bool showDivider;
  final double dividerThickness;
  final Color? dividerColor;
  final bool isBackButtonVisible;
  final Widget? title;
  final bool showActions;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize {
    double bottomHeight = bottom?.preferredSize.height ?? 0.0;
    if (showDivider && bottom == null) {
      bottomHeight = dividerThickness;
    }
    return Size.fromHeight(height + bottomHeight);
  }

  SystemUiOverlayStyle _systemOverlayStyle(BuildContext context, Color bgColor) {
    final useLightStatusBarIcons = bgColor.computeLuminance() < 0.5;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // usually better to be transparent for modern apps
      statusBarIconBrightness:
          useLightStatusBarIcons ? Brightness.light : Brightness.dark,
      statusBarBrightness:
          useLightStatusBarIcons ? Brightness.dark : Brightness.light,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Resolve colors based on theme if not provided
    final resolvedBgColor = backgroundColor ?? Colors.transparent;
    final resolvedIconColor = iconColor ?? foregroundColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
    final resolvedTitleColor = titleColor ?? foregroundColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
    final resolvedDividerColor = dividerColor ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: resolvedBgColor,
      systemOverlayStyle: _systemOverlayStyle(context, resolvedBgColor == Colors.transparent ? (isDark ? AppColors.darkBgBase : AppColors.lightBgBase) : resolvedBgColor),
      leadingWidth: isBackButtonVisible ? (leadingWidth ?? 56.0) : 0,
      titleSpacing: titleSpacing ?? NavigationToolbar.kMiddleSpacing,
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      
      leading: isBackButtonVisible
          ? (leading ??
              (showIcon
                  ? IconButton(
                      icon: Icon(
                        isCrossIcon ? LucideIcons.x : LucideIcons.arrowLeft,
                        color: resolvedIconColor,
                      ),
                      onPressed: onTap ?? () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          Navigator.maybePop(context);
                        }
                      },
                    )
                  : const SizedBox.shrink()))
          : const SizedBox.shrink(),

      titleTextStyle: titleStyle?.copyWith(color: resolvedTitleColor) ??
          Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: resolvedTitleColor) ??
          TextStyle(
            color: resolvedTitleColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

      title: titleText != null
          ? Text(titleText!)
          : title ?? const SizedBox.shrink(),

      actions: actions,

      bottom: showDivider
          ? PreferredSize(
              preferredSize: Size.fromHeight(dividerThickness),
              child: Container(
                width: double.infinity,
                height: dividerThickness,
                color: resolvedDividerColor,
              ),
            )
          : bottom,
    );
  }
}
