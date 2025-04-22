import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import 'package:visa_nova_icons_flutter/visa_nova_icons_flutter.dart';

class MainLayout extends StatelessWidget {
  final Widget child; // This is the content of the current page

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final user =
        Supabase
            .instance
            .client
            .auth
            .currentUser; // Get the current signed-in user

    return Scaffold(
      backgroundColor: VColors.defaultSurface1,
      appBar: AppBar(
        backgroundColor: VColors.defaultSurface1,
        title: Center(
          child: Semantics(
            label: 'AR Fitness Logo',
            child: Image.asset(
              'assets/ARFitnessLogoFinal_Red-Bk.png',
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
        ),
        // ),
        leading:
            user != null
                ? Builder(
                  builder:
                      (context) => Semantics(
                        label: "Open navigation menu",
                        button: true,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          splashColor: VColors.defaultSurfaceLowlight,
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(14),
                            child: const ExcludeSemantics(
                              child: VIcon(
                                svgIcon: VIcons.menuTiny,
                                iconHeight: 24,
                                iconWidth: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                )
                : null,
      ),
      drawer: user != null ? _buildDrawer(context) : null,
      body: Container(
        color: VColors.defaultSurface1,
        child: SingleChildScrollView(child: child),
      ), // This is where the child content (home page, auth page) gets inserted
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return VNavDrawer(
      header: Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(color: Colors.transparent),
        ),
        // Example of Visa style drawer header
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
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 11, 12),
                  child: const VIcon(svgIcon: VIcons.successHigh),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(20, 0, 18, 0),
                  child: Text(
                    "Application Name",
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
      // Example of bottom items
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
                "Alex Miller",
                style: defaultVTheme.textStyles.uiLabelLarge,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
      onTap: (int i) {},
    );
  }

  // Widget _buildUserHeader() {
  //   final user = Supabase.instance.client.auth.currentUser;
  //   return UserAccountsDrawerHeader(
  //     accountName: Text(user?.email ?? 'Guest'),
  //     accountEmail: Text(user?.id ?? 'No ID'),
  //     currentAccountPicture: CircleAvatar(
  //       backgroundImage: NetworkImage(user?.userMetadata['avatar_url'] ?? ''),
  //     ),
  //   );
  // }
}
