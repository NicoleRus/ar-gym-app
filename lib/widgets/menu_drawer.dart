// lib/widgets/nav_drawer.dart
import 'package:flutter/material.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import 'package:visa_nova_icons_flutter/visa_nova_icons_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return VNavDrawer(
      header: Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(color: Colors.transparent),
        ),
        child: SizedBox(
          height: MediaQuery.paddingOf(context).top + 130,
          child: DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 4, 0),
                  child: Row(
                    children: [
                      const Spacer(),
                      Material(
                        color: VColors.transparent,
                        child: InkWell(
                          highlightColor: VColors.transparent,
                          customBorder: const CircleBorder(),
                          splashColor: VColors.defaultSurfaceLowlight,
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(14),
                            child: VIcon(
                              svgIcon: VIcons.closeTiny,
                              iconColor: VColors.defaultActiveSubtle
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(20, 0, 18, 0),
                  child: Text(
                    "AR Fitness",
                    style: defaultVTheme.textStyles.subtitle1.copyWith(
                      color: VColors.defaultActive,
                      height: 1.2778,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      vNavDrawerSections: [
        VNavDrawerSection(
          title: 'SECTION TITLE',
          items: [
            VNavDrawerItem(label: "L1 label 1"),
            VNavDrawerItem(label: "L1 label 2"),
            VNavDrawerItem(label: "L1 label 3"),
          ],
        ),
        VNavDrawerSection(
          title: 'SECTION TITLE',
          items: [
            VNavDrawerItem(label: "L1 label 4"),
            VNavDrawerItem(label: "L1 label 5"),
          ],
        ),
      ],
      bottomItems: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: VDivider(dividerType: VDividerType.decorative),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListTile(
              horizontalTitleGap: 10,
              minLeadingWidth: 10,
              leading: const VIcon(
                iconHeight: 20,
                iconWidth: 20,
                svgIcon: VIcons.accountTiny,
                iconColor: VColors.defaultActive,
              ),
              title: Text(
                user?.userMetadata?['full_name'] ?? user?.email,
                style: defaultVTheme.textStyles.uiLabelLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: VDivider(dividerType: VDividerType.decorative),
          ),
          ListTile(
            horizontalTitleGap: 10,
            minLeadingWidth: 10,
            leading: const VIcon(
              iconHeight: 20,
              iconWidth: 20,
              svgIcon: VIcons.exportHigh,
              iconColor: VColors.defaultActive,
            ),
            title: Text("Logout", style: defaultVTheme.textStyles.uiLabelLarge),
            onTap: () async {
              final navigator = Navigator.of(context); // grab it early

              await Supabase.instance.client.auth.signOut();

              navigator.pop(); // safe to pop after
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
      onTap: (int i) {},
    );
  }
}
