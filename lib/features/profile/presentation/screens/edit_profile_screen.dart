
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../authentication/domain/auth_failure.dart';
import '../../../authentication/presentation/providers/auth_controller.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/profile_failure.dart';
import '../providers/profile_controller.dart';
import '../widgets/profile_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.profileController,
    this.authController,
  });

  final ProfileController? profileController;
  final AuthController? authController;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color _fieldColor = Color(0xFF282A28);
  static const Color _danger = Color(0xFFE53935);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  late final ProfileController _profileController =
      widget.profileController ?? ProfileDependencies.controller;

  late final AuthController _authController =
      widget.authController ?? AuthController.firebase();

  StreamSubscription<UserProfile>? _profileSubscription;
  UserProfile? _profile;
  String? _loadError;
  int _avatarIndex = 0;
  bool _fieldsInitialized = false;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isResettingPassword = false;

  @override
  void initState() {
    super.initState();
    _observeProfile();
  }

  @override
  void dispose() {
    unawaited(_profileSubscription?.cancel());
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _observeProfile() {
    unawaited(_profileSubscription?.cancel());

    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    _profileSubscription = _profileController.observeProfile().listen(
          (profile) {
        if (!mounted) return;

        setState(() {
          _profile = profile;
          _isLoading = false;
          _loadError = null;

          if (!_fieldsInitialized) {
            _nameController.text = profile.name;
            _phoneController.text = profile.phone;
            _avatarIndex = profile.avatarIndex;
            _fieldsInitialized = true;
          }
        });
      },
      onError: (Object error) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _loadError = error is ProfileFailure
              ? error.message
              : 'Something went wrong while loading your profile.';
        });
      },
    );
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await _profileController.updateProfile(
        name: _nameController.text,
        phone: _phoneController.text,
        avatarIndex: _avatarIndex,
      );

      if (!mounted) return;

      _showMessage('Profile updated successfully.');
    } on ProfileFailure catch (failure) {
      if (!mounted) return;
      _showMessage(failure.message);
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not update your profile. Please try again.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _profile?.email.trim() ?? '';

    if (_isResettingPassword) return;

    if (email.isEmpty) {
      _showMessage('No email address is available for this account.');
      return;
    }

    setState(() => _isResettingPassword = true);

    try {
      await _authController.sendPasswordResetEmail(email);

      if (!mounted) return;

      _showMessage(
        'Password reset email sent. Check your inbox and spam folder.',
      );
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      _showMessage(failure.message);
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not send the reset email. Please try again.');
    } finally {
      if (mounted) setState(() => _isResettingPassword = false);
    }
  }

  void _showDeleteInfo() {
    _showMessage('Account deletion is not available yet.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Future<void> _pickAvatar() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: const Color(0xFF1D1D1D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final isSelected = index == _avatarIndex;

                  return InkWell(
                    onTap: () => Navigator.of(context).pop(index),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent
                            : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.accent,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(
                              alpha: 0.18,
                            ),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                            : [],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: ProfileAvatar(
                          avatarIndex: index,
                          size: 72,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() => _avatarIndex = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                ),
              );
            }

            if (_loadError != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _loadError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _observeProfile,
                        child: const Text(
                          'Try again',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 18),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 22,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: _isSaving ? null : () => context.pop(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.accent,
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                'Pick Avatar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontFamily: 'Roboto',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: InkWell(
                            onTap: _isSaving ? null : _pickAvatar,
                            borderRadius: BorderRadius.circular(60),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ProfileAvatar(
                                  avatarIndex: _avatarIndex,
                                  size: 150,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: AppColors.background,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                        _ProfileField(
                          controller: _nameController,
                          hint: 'Name',
                          icon: Icons.person,
                          enabled: !_isSaving,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _ProfileField(
                          controller: _phoneController,
                          hint: 'Phone',
                          icon: Icons.phone,
                          enabled: !_isSaving,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            final phone = value?.trim() ?? '';

                            if (phone.isNotEmpty &&
                                !RegExp(r'^\+?[0-9]{8,15}$')
                                    .hasMatch(phone)) {
                              return 'Enter a valid phone number';
                            }

                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: _isResettingPassword || _isSaving
                                ? null
                                : _resetPassword,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                            child: _isResettingPassword
                                ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: AppColors.accent,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _showDeleteInfo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _danger,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: AppColors.background,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'Update Data',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.enabled,
    required this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool enabled;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.white,
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFB6B6B6),
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: AppColors.white),
        filled: true,
        fillColor: _EditProfileScreenState._fieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
