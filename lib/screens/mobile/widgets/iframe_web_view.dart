import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

class IframeWebView extends StatefulWidget {
  final String url;
  final String title;

  const IframeWebView({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<IframeWebView> createState() => _IframeWebViewState();
}

class _IframeWebViewState extends State<IframeWebView> {
  late String viewId;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Generate a unique ID for the iframe
    viewId = const Uuid().v4();
    _setupIframe();
  }

  void _setupIframe() {
    // Register the view
    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = widget.url
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%'
          ..allowFullscreen = true
          // Add additional attributes that might help with some sites
          ..setAttribute('allow',
              'fullscreen; autoplay; clipboard-write; encrypted-media; picture-in-picture')
          ..setAttribute('sandbox',
              'allow-forms allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox allow-presentation')
          ..setAttribute('referrerpolicy', 'no-referrer');

        // Add load event listener to track when the iframe is loaded
        iframe.onLoad.listen((event) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });

        // Add error event listener
        iframe.onError.listen((event) {
          if (mounted) {
            setState(() {
              hasError = true;
              errorMessage =
                  'Failed to load content. The site may be blocking embedding.';
              isLoading = false;
            });
          }
        });

        return iframe;
      },
    );
  }

  void _openInNewTab() async {
    final Uri url = Uri.parse(widget.url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: '_blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (!hasError)
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: HtmlElementView(viewType: viewId),
            ),
          if (hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _openInNewTab,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open in New Tab'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isLoading && !hasError)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
