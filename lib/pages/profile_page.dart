import 'package:ar_app/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import '../services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true, _isSaving = false;
  String? _error;
  Profile? _profile;

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await ProfileService.fetchProfile();
      _firstNameCtrl.text = p.firstName ?? '';
      _lastNameCtrl.text = p.lastName ?? '';
      _birthDateCtrl.text =
          p.birthDate?.toIso8601String().split('T').first ?? '';
      _phoneCtrl.text = p.phone ?? '';
      _addressCtrl.text = p.address ?? '';
      setState(() {
        _profile = p;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      final updated = await ProfileService.updateProfile(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        birthDate:
            _birthDateCtrl.text.isNotEmpty
                ? DateTime.parse(_birthDateCtrl.text)
                : null,
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
      );
      setState(() {
        _profile = updated;
        _isSaving = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: VProgressLinear());
    }

    return MainLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Profile', style: defaultVTheme.textStyles.headline4),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              VSectionMessage(
                sectionMessageState: SectionMessageState.error,
                title: 'Error',
                description: _error!,
              ),
            const SizedBox(height: 16),

            VListItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Name", style: defaultVTheme.textStyles.subtitle2),
                  Text(
                    '${_profile!.firstName ?? ''} ${_profile!.lastName ?? ''}',
                    style: defaultVTheme.textStyles.uiLabelLarge,
                  ),
                ],
              ),
            ),
            VListItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Email", style: defaultVTheme.textStyles.subtitle2),
                  Text(
                    _profile!.email,
                    style: defaultVTheme.textStyles.uiLabel,
                  ),
                ],
              ),
            ),
            VListItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Birth date", style: defaultVTheme.textStyles.subtitle2),
                  Text(
                    _profile!.birthDate != null
                        ? MaterialLocalizations.of(
                          context,
                        ).formatCompactDate(_profile!.birthDate!)
                        : '',
                    style: defaultVTheme.textStyles.uiLabel,
                  ),
                ],
              ),
            ),

            VListItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Phone", style: defaultVTheme.textStyles.subtitle2),
                  Text(
                    _profile!.phone ?? '',
                    style: defaultVTheme.textStyles.uiLabel,
                  ),
                ],
              ),
            ),

            VListItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Address", style: defaultVTheme.textStyles.subtitle2),
                  Text(
                    _profile!.address ?? '',
                    style: defaultVTheme.textStyles.uiLabel,
                  ),
                ],
              ),
            ),

            // VListItem(
            //   hasTrailingIcon: true,
            //   onTap: () {},
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Text("Label", style: defaultVTheme.textStyles.baseTextStyle),
            //       VIcon(
            //         svgIcon: VIcons.securityLow,
            //         iconHeight: 24,
            //         iconWidth: 24,
            //         iconColor: VColors.defaultActiveSubtle.withOpacity(0.50),
            //       ),
            //     ],
            //   ),
            // ),

            // // Phone
            // VInput(myLocalController: _phoneCtrl, topLabelText: 'Phone'),
            // const SizedBox(height: 16)r,

            // // Address
            // VInput(myLocalController: _addressCtrl, topLabelText: 'Address'),
            // const SizedBox(height: 24),
            VButton(
              onPressed: _isSaving ? null : _save,
              child: Text(_isSaving ? 'Saving…' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
