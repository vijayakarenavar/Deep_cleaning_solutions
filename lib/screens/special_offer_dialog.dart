import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dcs_app/utils/app_colors.dart';

/// Special offer popup — shows a first-order discount coupon.
/// Use: SpecialOfferDialog.show(context, code: 'NEW10', ...);
class SpecialOfferDialog extends StatelessWidget {
  final String tag;
  final String amountText;   // e.g. "₹2999/-"
  final String discountText; // e.g. "10% OFF"
  final String subText;      // e.g. "on your first order"
  final String code;         // e.g. "NEW10"
  final String note;         // e.g. "Login to Use Discount Coupon"
  final VoidCallback? onShopNow;
  final VoidCallback? onMaybeLater;

  const SpecialOfferDialog({
    super.key,
    this.tag = 'SPECIAL OFFER',
    this.amountText = '₹2999/-',
    this.discountText = '10% OFF',
    this.subText = 'on your first order',
    this.code = 'NEW10',
    this.note = 'Login to Use Discount Coupon',
    this.onShopNow,
    this.onMaybeLater,
  });

  /// Convenience helper to show this as a dialog.
  static Future<void> show(
      BuildContext context, {
        String tag = 'SPECIAL OFFER',
        String amountText = '₹2999/-',
        String discountText = '10% OFF',
        String subText = 'on your first order',
        String code = 'NEW10',
        String note = 'Login to Use Discount Coupon',
        VoidCallback? onShopNow,
        VoidCallback? onMaybeLater,
      }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => SpecialOfferDialog(
        tag: tag,
        amountText: amountText,
        discountText: discountText,
        subText: subText,
        code: code,
        note: note,
        onShopNow: onShopNow,
        onMaybeLater: onMaybeLater,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF3A1F6E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: tag pill + close button
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🎉', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            tag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Headline
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.35,
                ),
                children: [
                  const TextSpan(text: 'Order Upto '),
                  TextSpan(
                    text: amountText,
                    style: const TextStyle(color: Color(0xFFFFD93D)),
                  ),
                  const TextSpan(text: '\n& Get '),
                  TextSpan(
                    text: discountText,
                    style: const TextStyle(color: Color(0xFFFFD93D)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),

            // Discount code
            Text(
              'Use Discount Code:',
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.content_paste, color: Colors.white70, size: 16),
              ],
            ),
            const SizedBox(height: 16),

            // Copy button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Code "$code" copied!'), duration: const Duration(seconds: 2)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD93D),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('Copy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 18),

            // Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: const Border(left: BorderSide(color: Color(0xFFFFD93D), width: 3)),
              ),
              child: Row(
                children: [
                  const Text('📝', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 12.5, color: Colors.white),
                        children: [
                          const TextSpan(text: 'Note: ', style: TextStyle(fontWeight: FontWeight.w700)),
                          TextSpan(text: note),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bottom buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).maybePop();
                      // ✅ NEW: navigate to the login page
                      context.go('/login');
                      onShopNow?.call();
                    },
                    icon: const Icon(Icons.shopping_cart, size: 18, color: Colors.black87),
                    label: const Text('Login & Shop', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD93D),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).maybePop();
                      onMaybeLater?.call();
                    },
                    icon: const Icon(Icons.access_time, size: 18, color: Colors.white),
                    label: const Text('Maybe Later', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}