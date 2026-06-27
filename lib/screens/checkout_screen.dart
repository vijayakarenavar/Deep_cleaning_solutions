// lib/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/providers/cart_provider.dart';
import 'package:dcs_app/providers/order_provider.dart';
import 'package:dcs_app/providers/auth_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey         = GlobalKey<FormState>();
  final _firstNameCtrl   = TextEditingController();
  final _lastNameCtrl    = TextEditingController();
  final _emailCtrl       = TextEditingController();
  final _mobileCtrl      = TextEditingController();
  final _addressCtrl     = TextEditingController();
  final _cityCtrl        = TextEditingController();
  final _stateCtrl       = TextEditingController();
  final _zipCtrl         = TextEditingController();

  // ✅ API: country = int (country_id from /checkout/init → countries list)
  // Default: 33 (Pune area — checkout/init response मध्ये येतो)
  int _selectedCountryId = 33;

  String? _selectedDate;
  String? _selectedTime;
  bool _isAdvancePayment = false;
  bool _isPlacingOrder   = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(authProvider).user;
      if (user != null) {
        final name = (user['name'] ?? '').toString().split(' ');
        _firstNameCtrl.text = name.isNotEmpty ? name[0] : '';
        _lastNameCtrl.text  = name.length > 1 ? name.sublist(1).join(' ') : '';
        _emailCtrl.text     = (user['email']  ?? '').toString();
        _mobileCtrl.text    = (user['mobile'] ?? user['phone'] ?? '').toString();
      }
    });
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate:   DateTime.now(),
      lastDate:    DateTime.now().add(const Duration(days: 30)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
      // ✅ Date select झाल्यावर time slots fetch करा
      if (mounted) {
        ref.read(orderProvider.notifier).getTimeSlots(date: _selectedDate!);
      }
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select booking date'), backgroundColor: AppColors.secondary),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select booking time'), backgroundColor: AppColors.secondary),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      bool success = false;

      if (_isAdvancePayment) {
        // ✅ FIX: complete parameters
        success = await ref.read(orderProvider.notifier).processAdvanceOrder(
          firstName:   _firstNameCtrl.text.trim(),
          lastName:    _lastNameCtrl.text.trim(),
          email:       _emailCtrl.text.trim(),
          country:     _selectedCountryId,
          address:     _addressCtrl.text.trim(),
          city:        _cityCtrl.text.trim(),
          state_:      _stateCtrl.text.trim(),
          zip:         _zipCtrl.text.trim(),
          mobile:      _mobileCtrl.text.trim(),
          bookingDate: _selectedDate!,
          bookingTime: _selectedTime!,
        );
      } else {
        // ✅ FIX: complete parameters
        success = await ref.read(orderProvider.notifier).processOrder(
          firstName:   _firstNameCtrl.text.trim(),
          lastName:    _lastNameCtrl.text.trim(),
          email:       _emailCtrl.text.trim(),
          country:     _selectedCountryId,
          address:     _addressCtrl.text.trim(),
          city:        _cityCtrl.text.trim(),
          state_:      _stateCtrl.text.trim(),
          zip:         _zipCtrl.text.trim(),
          mobile:      _mobileCtrl.text.trim(),
          bookingDate: _selectedDate!,
          bookingTime: _selectedTime!,
        );
      }

      if (success) {
        ref.read(cartProvider.notifier).clearCart();

        // ✅ redirect_url आल्यावर PhonePe वर redirect करा
        final redirectUrl = ref.read(orderProvider).redirectUrl;
        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          final uri = Uri.parse(redirectUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: AppColors.green,
            ),
          );
          context.go('/orders');
        }
      } else {
        final error = ref.read(orderProvider).error ?? 'Order failed';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: AppColors.secondary),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState  = ref.watch(cartProvider);
    final orderState = ref.watch(orderProvider);

    if (cartState.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Your cart is empty')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Personal Details ─────────────────
              _SectionTitle('Personal Details'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildField(_firstNameCtrl, 'First Name', validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildField(_lastNameCtrl, 'Last Name',   validator: (v) => v!.isEmpty ? 'Required' : null)),
                ],
              ),
              const SizedBox(height: 10),
              _buildField(_emailCtrl,  'Email',        keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 10),
              _buildField(_mobileCtrl, 'Mobile Number', keyboardType: TextInputType.phone,       validator: (v) => v!.length != 10 ? '10 digits required' : null),

              const SizedBox(height: 20),

              // ── Service Location ─────────────────
              _SectionTitle('Service Location'),
              const SizedBox(height: 10),
              _buildField(_addressCtrl, 'Full Address', maxLines: 2, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildField(_cityCtrl,  'City',  validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildField(_stateCtrl, 'State', validator: (v) => v!.isEmpty ? 'Required' : null)),
                ],
              ),
              const SizedBox(height: 10),
              _buildField(_zipCtrl, 'PIN Code', keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),

              const SizedBox(height: 20),

              // ── Booking Date ─────────────────────
              _SectionTitle('Booking Schedule'),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate ?? 'Select Booking Date',
                        style: TextStyle(
                          color: _selectedDate != null ? AppColors.black : AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Time Slots ───────────────────────
              if (_selectedDate != null) ...[
                const SizedBox(height: 12),
                if (orderState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (orderState.timeSlots.isNotEmpty) ...[
                  const Text('Select Time Slot', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: orderState.timeSlots.entries.map((entry) {
                      final key   = entry.key;
                      final label = entry.value is Map ? (entry.value['label'] ?? key) : key;
                      final time  = entry.value is Map ? (entry.value['time'] ?? key) : key;
                      final isSelected = _selectedTime == key;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTime = key),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                          ),
                          child: Column(
                            children: [
                              Text(label.toString(), style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : AppColors.textMuted)),
                              Text(time.toString(),  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.black)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ] else
                  const Text('No time slots available for this date', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              ],

              const SizedBox(height: 20),

              // ── Payment Type ─────────────────────
              _SectionTitle('Payment Type'),
              const SizedBox(height: 10),
              _PaymentOption(
                label:      'Full Payment',
                subtitle:   'Pay complete amount now',
                value:      false,
                groupValue: _isAdvancePayment,
                onChanged:  (v) => setState(() => _isAdvancePayment = v),
              ),
              const SizedBox(height: 8),
              _PaymentOption(
                label:      'Advance Payment',
                subtitle:   'Pay 10% advance, rest on service day',
                value:      true,
                groupValue: _isAdvancePayment,
                onChanged:  (v) => setState(() => _isAdvancePayment = v),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount', style: TextStyle(color: AppColors.textMuted)),
                Text(
                  '₹${cartState.finalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPlacingOrder ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isPlacingOrder
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Place Order', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller:   ctrl,
      maxLines:     maxLines,
      keyboardType: keyboardType,
      validator:    validator,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder:   OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.secondary)),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.black),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label, subtitle;
  final bool value, groupValue;
  final Function(bool) onChanged;

  const _PaymentOption({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              activeColor: AppColors.primary,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
