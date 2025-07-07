// Visa Nova Flutter Demo AppBar Page
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visa_nova_icons_flutter/visa_nova_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';

class VAppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final bool showHamburger;

  const VAppBarDefault({super.key, this.showHamburger = true});
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return VAppBar(
      backButtonAction: () {
        Navigator.pop(context);
      },
      leading:
          showHamburger && user != null
              ? // 🔥 only show if allowed
              Semantics(
                label: "Menu",
                button: true,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: VColors.defaultSurfaceLowlight,
                  child: Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(16),
                    child: const ExcludeSemantics(
                      child: VIcon(
                        iconColor: VColors.defaultActive,
                        svgIcon: VIcons.menuLow,
                        iconHeight: 24,
                        iconWidth: 24,
                      ),
                    ),
                  ),
                  onTap: () => Scaffold.of(context).openDrawer(),
                ),
              )
              : const SizedBox.shrink(),
      title: Stack(
        alignment: Alignment.center,
        children: [
          Semantics(
            label: 'AR Fitness Logo',
            child: Image.asset(
              'assets/ARFitnessLogoFinal_Red-Bk.png',
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      // actionList: [
      //   Padding(
      //     padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      //     child: Semantics(
      //       label: "Search",
      //       button: true,
      //       child: InkWell(
      //         customBorder: const CircleBorder(),
      //         splashColor: VColors.defaultSurfaceLowlight,
      //         child: Container(
      //           width: 44,
      //           height: 44,
      //           padding: const EdgeInsets.all(10),
      //           child: const ExcludeSemantics(
      //             child: VIcon(
      //               svgIcon: VIcons.searchLow,
      //               iconHeight: 24,
      //               iconWidth: 24,
      //             ),
      //           ),
      //         ),
      //         onTap: () {},
      //       ),
      //     ),
      //   ),
      //   Padding(
      //     padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      //     child: Semantics(
      //       label: "Profile",
      //       button: true,
      //       child: InkWell(
      //         customBorder: const CircleBorder(),
      //         splashColor: VColors.defaultSurfaceLowlight,
      //         child: Container(
      //           width: 44,
      //           height: 44,
      //           padding: const EdgeInsets.all(10),
      //           child: const ExcludeSemantics(
      //             child: VIcon(
      //               svgIcon: VIcons.accountLow,
      //               iconColor: VColors.defaultActive,
      //               iconHeight: 24,
      //               iconWidth: 24,
      //             ),
      //           ),
      //         ),
      //         onTap: () {},
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}
