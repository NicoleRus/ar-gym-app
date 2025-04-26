import 'package:flutter/material.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import 'package:visa_nova_icons_flutter/visa_nova_icons_flutter.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String icon;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    required this.icon,
    this.onTap,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isTapped = false;
  bool bottomBarVisible = false;

  void _handleTapDown() {
    setState(() {
      isTapped = true;
      bottomBarVisible = true;
    });
  }

  void _handleTapCancelOrUp() {
    setState(() {
      isTapped = false;
      bottomBarVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VContentCard(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapCancelOrUp,
      onTapCancel: _handleTapCancelOrUp,
      hasBottomBar: bottomBarVisible,
      onTap: () {
        // TODO: Handle tap
      },
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🛠️ This line fixes the issue
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VIcon(
            svgIcon: widget.icon,
            iconHeight: 48,
            iconWidth: 48,
            iconColor: VColors.defaultActive,
          ),
          Text(
            widget.title,
            style: defaultVTheme.textStyles.headline4.copyWith(
              color:
                  isTapped
                      ? VColors.defaultActivePressed
                      : VColors.defaultActive,
            ),
          ),
        ],
      ),
    );
  }
}
