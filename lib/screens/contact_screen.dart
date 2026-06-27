// lib/screens/contact_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/providers/auth_provider.dart';
import 'package:dcs_app/services/contact_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _mobileCtrl  = TextEditingController();  // ✅ FIX: phone → mobile
  final _serviceCtrl = TextEditingController();  // ✅ FIX: 'service' field add केला
  final _msgCtrl     = TextEditingController();
  bool _isLoading    = false;

  final ContactService _contactService = ContactService();

  // ✅ Service options for dropdown
  final List<String> _services = [
    'Home Cleaning',
    'Office Cleaning',
    'Flat Cleaning',
    'Bungalow Cleaning',
    'Society Cleaning',
    'Restaurant Cleaning',
    'Car Wash',
    'Other',
  ];
  String? _selectedService;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(authProvider).user;
      if (user != null) {
        _nameCtrl.text   = (user['name']   ?? '').toString();
        _emailCtrl.text  = (user['email']  ?? '').toString();
        _mobileCtrl.text = (user['mobile'] ?? user['phone'] ?? '').toString();
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _serviceCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // ✅ FIX: phone → mobile, service field add
      await _contactService.sendMessage(
        name:    _nameCtrl.text.trim(),
        email:   _emailCtrl.text.trim(),
        mobile:  _mobileCtrl.text.trim(),
        service: _selectedService ?? _serviceCtrl.text.trim(),
        message: _msgCtrl.text.trim(),
      );

      if (mounted) {
        _msgCtrl.clear();
        setState(() => _selectedService = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Message sent successfully!'),
            backgroundColor: AppColors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact Us',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: AppColors.primary,
              child: Column(
                children: [
                  const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Get In Touch',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "We'd love to hear from you!",
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                  ),
                ],
              ),
            ),

            // ── Contact Details ───────────────────
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _ContactItem(icon: Icons.phone_outlined, color: AppColors.primary,   label: 'Phone',    value: '+91 7558634862',              onTap: () => _launchUrl('tel:+917558634862')),
                  _ContactItem(icon: Icons.email_outlined, color: AppColors.secondary, label: 'Email',    value: 'contact@suvarnarajgroup.com', onTap: () => _launchUrl('mailto:contact@suvarnarajgroup.com')),
                  _ContactItem(icon: Icons.location_on_outlined, color: AppColors.primary, label: 'Address', value: 'Pune, Maharashtra',        onTap: () => _launchUrl('https://maps.google.com/?q=Pune,Maharashtra')),
                  _ContactItem(icon: Icons.chat_outlined, color: AppColors.green,       label: 'WhatsApp', value: '+91 7558634862', isLast: true, onTap: () => _launchUrl('https://wa.me/917558634862')),
                ],
              ),
            ),

            // ── Message Form ──────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send a Message',
                      style: TextStyle(fontSize: R.sp(context, 15), fontWeight: FontWeight.w700, color: AppColors.black),
                    ),
                    const SizedBox(height: 12),
                    _InputField(ctrl: _nameCtrl,   hint: 'Your Name',    validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 10),
                    _InputField(ctrl: _emailCtrl,  hint: 'Your Email',   keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 10),
                    // ✅ FIX: phone → mobile
                    _InputField(ctrl: _mobileCtrl, hint: 'Mobile Number', keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 10),
                    // ✅ FIX: Service dropdown add केला
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedService,
                          hint: const Text('Select Service', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
                          items: _services.map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s, style: const TextStyle(fontSize: 13)),
                          )).toList(),
                          onChanged: (v) => setState(() => _selectedService = v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _InputField(ctrl: _msgCtrl, hint: 'Your Message...', maxLines: 4, validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Send Message', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, value;
  final bool isLast;
  final VoidCallback? onTap;

  const _ContactItem({required this.icon, required this.color, required this.label, required this.value, this.isLast = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 13, color: AppColors.black, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (onTap != null) const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _InputField({required this.ctrl, required this.hint, this.maxLines = 1, this.keyboardType, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        filled: true,
        fillColor: AppColors.surface,
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder:   OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.secondary)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
