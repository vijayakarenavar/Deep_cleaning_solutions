import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dcs_app/utils/app_colors.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  Timer? _hideTimer1;
  Timer? _hideTimer2;

  static const String _termsUrl = 'https://deepcleaningsolutions.in/terms';

  // ✅ Header, footer, hamburger menu, search icon, cart icon, WhatsApp button
  // ani chat widget — sagळे hide karणारा JS. Website cha navigation la touch
  // na karता fakt visually hide karto, so user फक्त policy content baघेल.
  static const String _hideNavJs = '''
    (function() {
      var style = document.getElementById('__hide_style__');
      if (!style) {
        style = document.createElement('style');
        style.id = '__hide_style__';
        document.head.appendChild(style);
      }
      style.innerHTML = `
        header, nav, footer { display: none !important; }
      `;

      // Common top-bar / mobile-header selectors (hamburger, logo, search, cart)
      var topBarSelectors = [
        '.site-header', '.mobile-header', '.top-header', '.topbar',
        '.navbar', '.navbar-mobile', '.header-mobile', '.main-header',
        '.header-wrapper', '.header-top', '.mobile-nav', '.offcanvas',
        '[class*="header"]', '[id*="header"]'
      ];
      topBarSelectors.forEach(function(sel) {
        document.querySelectorAll(sel).forEach(function(el) {
          el.style.setProperty('display', 'none', 'important');
        });
      });

      // Hamburger menu, search icon, cart icon (individually, in case parent not caught)
      var iconSelectors = [
        '.hamburger', '.menu-toggle', '.navbar-toggler', '[class*="hamburger"]',
        '.search-icon', '[class*="search-icon"]', 'a[href*="search"]',
        '.cart-icon', '[class*="cart-icon"]', 'a[href*="cart"]',
        '.header-icons', '.header-actions'
      ];
      iconSelectors.forEach(function(sel) {
        document.querySelectorAll(sel).forEach(function(el) {
          el.style.setProperty('display', 'none', 'important');
        });
      });

      // WhatsApp link hide
      document.querySelectorAll('a[href*="wa.me"]').forEach(function(el) {
        var container = el.closest('div');
        if (container) container.style.setProperty('display', 'none', 'important');
        el.style.setProperty('display', 'none', 'important');
      });

      // Chat widgets hide (Tawk.to, Crisp, Tidio, Chatwoot etc.)
      var chatSelectors = ['#tawkchat-container', 'iframe[title*="chat"]',
        'iframe[id*="chat"]', 'div[class*="chat-widget"]', 'div[id*="crisp"]',
        'div[class*="tidio"]', '.woot-widget-bubble', '.woot-widget-holder',
        'iframe[title*="whatsapp"]', 'div[class*="whatsapp"]'];
      chatSelectors.forEach(function(sel) {
        document.querySelectorAll(sel).forEach(function(el) {
          el.style.setProperty('display', 'none', 'important');
        });
      });

      // Fallback 1: fixed-position floating buttons (bottom-right corner)
      document.querySelectorAll('*').forEach(function(el) {
        var pos = window.getComputedStyle(el).position;
        if (pos === 'fixed') {
          var rect = el.getBoundingClientRect();
          if (rect.width > 0 && rect.width < 100 && rect.bottom > window.innerHeight - 200 &&
              rect.right > window.innerWidth - 200) {
            el.style.setProperty('display', 'none', 'important');
          }
        }
      });

      // Fallback 2: sagळ्यात पहिला top full-width bar (structural heuristic)
      var candidates = document.body.querySelectorAll('div, header');
      for (var i = 0; i < candidates.length; i++) {
        var el = candidates[i];
        var rect = el.getBoundingClientRect();
        if (rect.top <= 5 && rect.width > window.innerWidth * 0.9 && rect.height > 30 && rect.height < 150) {
          el.style.setProperty('display', 'none', 'important');
          break;
        }
      }
    })();
  ''';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) async {
            await _controller.runJavaScript(_hideNavJs);
            setState(() => _isLoading = false);

            // ✅ Chat/WhatsApp widgets third-party script asल्यामुळे late-load
            // hotात, mhणून थोड्या delay नंतर पुन्हा JS run kara.
            _hideTimer1?.cancel();
            _hideTimer2?.cancel();
            _hideTimer1 = Timer(const Duration(milliseconds: 800), () {
              _controller.runJavaScript(_hideNavJs);
            });
            _hideTimer2 = Timer(const Duration(milliseconds: 2000), () {
              _controller.runJavaScript(_hideNavJs);
            });
          },
          onNavigationRequest: (request) {
            // ✅ Fakt policy page cha URL allow, baki sagळे links block
            if (request.url.startsWith(_termsUrl)) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(_termsUrl));
  }

  @override
  void dispose() {
    _hideTimer1?.cancel();
    _hideTimer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Terms & Conditions'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}