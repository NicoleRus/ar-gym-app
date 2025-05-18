// lib/widgets/nav_drawer.dart
import 'package:flutter/material.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import 'package:visa_nova_icons_flutter/visa_nova_icons_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NavDrawerPage extends StatefulWidget {
  const NavDrawerPage({super.key});

  @override
  State<NavDrawerPage> createState() => NavDrawerPageState();
}

class NavDrawerPageState extends State<NavDrawerPage> {
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final firstName = user?.userMetadata?['first_name'] ?? '';
    final lastName = user?.userMetadata?['last_name'] ?? '';
    String profileName = '$firstName $lastName';
    int selectedIndex = 0;

    if (profileName.isEmpty) {
      profileName = user?.email ?? '';
    }

    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

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
                        child: MergeSemantics(
                          child: Semantics(
                            label: "Close",
                            button: true,
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
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   padding: const EdgeInsets.fromLTRB(20, 0, 11, 12),
                //   child: Semantics(
                //     label: "visa",
                //     child: const VIconAsset(
                //       svgIcon: "assets/icons/visa.svg",
                //       iconHeight: 23,
                //       iconWidth: 71,
                //     ),
                //   ),
                // ),
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
      // Drawer items
      vNavDrawerSections: [
        VNavDrawerSection(
          title: 'SECTION TITLE 1',
          items: [
            VNavDrawerItem(label: "L1 label 1"),
            VNavDrawerItem(label: "L1 label 2"),
            VNavDrawerItem(label: "L1 label 3"),
          ],
        ),
        VNavDrawerSection(
          title: 'SECTION TITLE 2',
          items: [
            VNavDrawerItem(label: "L1 label 4"),
            VNavDrawerItem(label: "L1 label 5"),
          ],
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      // Example of bottom items
      bottomItems: MergeSemantics(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: VDivider(dividerType: VDividerType.decorative),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              // ─── Profile section ───────────
              child: ExpansionTile(
                leading: const VIcon(svgIcon: VIcons.accountTiny),
                title: Text(
                  profileName,
                  style: defaultVTheme.textStyles.bodyText2,
                ),
                childrenPadding: const EdgeInsets.only(left: 16),
                children: [
                  ListTile(
                    horizontalTitleGap: 10,
                    minLeadingWidth: 10,
                    title: Text(
                      'View/Edit Profile',
                      style: defaultVTheme.textStyles.bodyText2,
                    ),
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                  ListTile(
                    horizontalTitleGap: 10,
                    minLeadingWidth: 10,
                    title: Text(
                      'Memberships',
                      style: defaultVTheme.textStyles.bodyText2,
                    ),
                    onTap: () => Navigator.pushNamed(context, '/memberships'),
                  ),
                  ListTile(
                    horizontalTitleGap: 10,
                    minLeadingWidth: 10,
                    title: Text(
                      'Payment History',
                      style: defaultVTheme.textStyles.bodyText2,
                    ),
                    onTap: () => Navigator.pushNamed(context, '/payments'),
                  ),
                  ListTile(
                    horizontalTitleGap: 10,
                    minLeadingWidth: 10,
                    title: Text(
                      "Logout",
                      style: defaultVTheme.textStyles.bodyText2,
                    ),
                    trailing: const VIcon(
                      iconHeight: 20,
                      iconWidth: 20,
                      svgIcon: VIcons.exportTiny,
                      iconColor: VColors.defaultActive,
                    ),
                    onTap: () async {
                      final navigator = Navigator.of(context); // grab it early
                      await Supabase.instance.client.auth.signOut();
                      navigator.pop(); // safe to pop after
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
