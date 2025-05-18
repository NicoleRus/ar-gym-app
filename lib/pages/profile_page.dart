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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: defaultVTheme.textStyles.headline4),
          const SizedBox(height: 16),
          if (_error != null)
            VSectionMessage(
              sectionMessageState: SectionMessageState.error,
              title: 'Error',
              description: _error!,
            ),
          const SizedBox(height: 16),

          // Read-only email
          Text('Email', style: defaultVTheme.textStyles.subtitle2),
          const SizedBox(height: 4),
          VInput(
            myLocalController: TextEditingController(text: _profile!.email),
            isReadOnly: true,
          ),
          const SizedBox(height: 16),

          // First Name
          VInput(myLocalController: _firstNameCtrl, topLabelText: 'First Name'),
          const SizedBox(height: 16),

          // Last Name
          VInput(myLocalController: _lastNameCtrl, topLabelText: 'Last Name'),
          const SizedBox(height: 16),

          // Birth Date
          VInput(
            myLocalController: _birthDateCtrl,
            topLabelText: 'Birth Date',
            isReadOnly: true,
            tapped: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _profile?.birthDate ?? DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _birthDateCtrl.text = picked.toIso8601String().split('T').first;
              }
            },
          ),
          const SizedBox(height: 16),

          // Phone
          VInput(myLocalController: _phoneCtrl, topLabelText: 'Phone'),
          const SizedBox(height: 16),

          // Address
          VInput(myLocalController: _addressCtrl, topLabelText: 'Address'),
          const SizedBox(height: 24),

          VButton(
            onPressed: _isSaving ? null : _save,
            child: Text(_isSaving ? 'Saving…' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
