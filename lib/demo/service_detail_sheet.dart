import 'package:flutter/material.dart';
import 'package:dcs_app/demo/app_colors.dart';
import 'package:dcs_app/demo/responsive.dart';

class ServiceDetailSheet extends StatefulWidget {
  final String title;
  final List<Map<String, String>> services;

  const ServiceDetailSheet({
    super.key,
    required this.title,
    required this.services,
  });

  @override
  State<ServiceDetailSheet> createState() => _ServiceDetailSheetState();
}

class _ServiceDetailSheetState extends State<ServiceDetailSheet> {
  final _sqftCtrl = TextEditingController();
  bool _cleanWalls  = false;
  bool _cleanPaint  = false;
  bool _removeCover = false;

  @override
  void dispose() {
    _sqftCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: R.sp(context, 16),
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_cart, size: 14),
                    label: const Text(
                      'ADD TO CART',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: AppColors.textMuted, size: 22),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),

            // Scrollable Content
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  // Sq.ft input
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'How much sq.ft. is your property? ',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _sqftCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter sq.ft.',
                      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border:        OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Checkboxes
                  _CheckItem(
                    label: 'Do you want to clean walls and ceilings?',
                    value: _cleanWalls,
                    onChanged: (v) => setState(() => _cleanWalls = v!),
                  ),
                  _CheckItem(
                    label: 'Do you want to clean paint and adhesive stains?',
                    value: _cleanPaint,
                    onChanged: (v) => setState(() => _cleanPaint = v!),
                  ),
                  _CheckItem(
                    label: 'Do you want protective film/plastic cover removed from furniture?',
                    value: _removeCover,
                    onChanged: (v) => setState(() => _removeCover = v!),
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),

                  // Services Included
                  const Text(
                    'Services Included:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.black),
                  ),
                  const SizedBox(height: 12),

                  ...widget.services.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${s['title']} : ',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.black),
                          ),
                          TextSpan(
                            text: s['desc'],
                            style: const TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  )),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 12),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.title} added to cart!'),
                            backgroundColor: AppColors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart, size: 16),
                      label: const Text(
                        'ADD TO CART',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _CheckItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.black),
            ),
          ),
        ),
      ],
    );
  }
}