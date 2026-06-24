import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/providers/auth_provider.dart';
import 'package:dcs_app/services/enquiry_service.dart';

class EnquiryFormScreen extends ConsumerStatefulWidget {
  final String serviceName;
  const EnquiryFormScreen({super.key, required this.serviceName});

  @override
  ConsumerState<EnquiryFormScreen> createState() => _EnquiryFormScreenState();
}

class _EnquiryFormScreenState extends ConsumerState<EnquiryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _mobileCtrl    = TextEditingController();
  final _addressCtrl   = TextEditingController();
  final _stateCtrl     = TextEditingController();
  final _cityCtrl      = TextEditingController();
  final _areaCtrl      = TextEditingController();

  String? _selectedService;
  String? _selectedTime;
  DateTime? _selectedDate;
  bool _orderInspection = false;
  bool _isLoading       = false;

  final EnquiryService _enquiryService = EnquiryService();

  final List<String> _services = [
    'Flat Cleaning',
    'Bungalow Cleaning',
    'Office Cleaning',
    'Society Cleaning',
    'Restaurant Cleaning',
    'Shop Cleaning',
    'School Cleaning',
    'Car Wash',
  ];

  final List<String> _timeSlots = [
    '10:00 AM', '11:00 AM', '12:00 PM',
    '1:00 PM',  '2:00 PM',  '3:00 PM',
    '4:00 PM',  '5:00 PM',
  ];

  @override
  void initState() {
    super.initState();

    // Service auto select
    _selectedService = widget.serviceName.contains('Flat')        ? 'Flat Cleaning'
        : widget.serviceName.contains('Bungalow')   ? 'Bungalow Cleaning'
        : widget.serviceName.contains('Office')     ? 'Office Cleaning'
        : widget.serviceName.contains('Society')    ? 'Society Cleaning'
        : widget.serviceName.contains('Restaurant') ? 'Restaurant Cleaning'
        : widget.serviceName.contains('Shop')       ? 'Shop Cleaning'
        : widget.serviceName.contains('School')     ? 'School Cleaning'
        : widget.serviceName.contains('Car')        ? 'Car Wash'
        : null;

    // Logged in user data auto fill
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
    _stateCtrl.dispose();
    _cityCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatDateForApi(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _submitEnquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _enquiryService.submitEnquiry(
        firstName:       _firstNameCtrl.text.trim(),
        lastName:        _lastNameCtrl.text.trim(),
        email:           _emailCtrl.text.trim(),
        mobile:          _mobileCtrl.text.trim(),
        address:         _addressCtrl.text.trim(),
        state:           _stateCtrl.text.trim(),
        city:            _cityCtrl.text.trim(),
        serviceType:     _selectedService ?? '',
        sqft:            _areaCtrl.text.isNotEmpty ? double.tryParse(_areaCtrl.text) : null,
        orderInspection: _orderInspection,
        inspectionDate:  _selectedDate != null ? _formatDateForApi(_selectedDate!) : null,
        inspectionTime:  _selectedTime,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Enquiry submitted successfully!'),
            backgroundColor: AppColors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
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
          'Submit an Enquiry',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Name Row ──────────────────────
              Row(
                children: [
                  Expanded(child: _FormField(ctrl: _firstNameCtrl, hint: 'First Name', validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 10),
                  Expanded(child: _FormField(ctrl: _lastNameCtrl,  hint: 'Last Name',  validator: (v) => v!.isEmpty ? 'Required' : null)),
                ],
              ),
              const SizedBox(height: 10),

              // ── Email & Mobile ─────────────────
              Row(
                children: [
                  Expanded(child: _FormField(ctrl: _emailCtrl, hint: 'Email', keyboardType: TextInputType.emailAddress)),
                  const SizedBox(width: 10),
                  Expanded(child: _FormField(
                    ctrl: _mobileCtrl,
                    hint: 'Mobile (10 digits)',
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.length != 10 ? '10 digits required' : null,
                  )),
                ],
              ),
              const SizedBox(height: 10),

              // ── Address ────────────────────────
              _FormField(ctrl: _addressCtrl, hint: 'Address', maxLines: 2),
              const SizedBox(height: 10),

              // ── State & City ───────────────────
              Row(
                children: [
                  Expanded(child: _FormField(ctrl: _stateCtrl, hint: 'State')),
                  const SizedBox(width: 10),
                  Expanded(child: _FormField(ctrl: _cityCtrl,  hint: 'City')),
                ],
              ),
              const SizedBox(height: 10),

              // ── Service Dropdown ───────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedService,
                    hint: const Text('Choose Service', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
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

              // ── Total Area ─────────────────────
              const Text(
                'Total Area in Sq. Ft. (if known)',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              _FormField(ctrl: _areaCtrl, hint: '', keyboardType: TextInputType.number),
              const SizedBox(height: 14),

              // ── Inspection Checkbox ────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _orderInspection ? AppColors.primary : AppColors.border),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _orderInspection,
                          onChanged: (v) => setState(() => _orderInspection = v!),
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        const Expanded(
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                              text: 'Order inspection at just Rs 200/- ',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black),
                            ),
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700),
                            ),
                          ])),
                        ),
                      ],
                    ),
                    if (_orderInspection) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFFE082)),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Color(0xFF795548)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Note: You will be redirected to PhonePe payment gateway to complete the Rs 200 payment for inspection scheduling.',
                                style: TextStyle(fontSize: 11, color: Color(0xFF795548), height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Schedule Inspection ────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Schedule Your Inspection',
                          style: TextStyle(
                            fontSize: R.sp(context, 14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        // Date Picker
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Inspection Date *',
                                style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: _pickDate,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedDate != null ? _formatDate(_selectedDate!) : 'dd/mm/yyyy',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: _selectedDate != null ? AppColors.black : AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.calendar_today, size: 16, color: AppColors.textMuted),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'You can select dates starting from tomorrow',
                                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Time Picker
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Inspection Time *',
                                style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedTime,
                                    hint: const Text('Select Time', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                    isExpanded: true,
                                    icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textMuted),
                                    items: _timeSlots.map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t, style: const TextStyle(fontSize: 12)),
                                    )).toList(),
                                    onChanged: (v) => setState(() => _selectedTime = v),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Available between 10:00 AM - 5:00 PM',
                                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Submit Button ──────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitEnquiry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    _orderInspection ? 'Proceed to Payment (Rs 200)' : 'Submit Enquiry',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.ctrl,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 13, color: AppColors.black),
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