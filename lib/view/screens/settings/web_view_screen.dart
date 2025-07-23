import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/my_color.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final Function(String invoiceId)? onSuccess;

  const WebViewScreen({
    super.key,
    required this.url,
    this.onSuccess,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  String url = "";

  bool isWasConnectionLoss = false;
  bool mIsPermissionGrant = false;

  InAppWebViewGroupOptions inAppWebViewGroupOptions = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      supportZoom: false,
      userAgent:
          'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.163 Mobile Safari/537.36',
      mediaPlaybackRequiresUserGesture: false,
      allowFileAccessFromFileURLs: true,
      useOnDownloadStart: true,
      javaScriptCanOpenWindowsAutomatically: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      allowFileAccess: true,
      allowContentAccess: true,
    ),
    ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
  );

  bool check(List<String> list, String item) {
    for (String i in list) {
      if (item.contains(i)) return true;
    }
    return false;
  }

  String? invoiceId;

  void extractInvoiceId(String htmlContent) {
    RegExp regex = RegExp(r'<p class="text-\[#6D7F9A\] text-sm select-all">([^<]+)</p>');
    Match? match = regex.firstMatch(htmlContent);
    if (match != null) {
      setState(() {
        invoiceId = match.group(1);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: MyColor.yellow, enabled: true),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialOptions: inAppWebViewGroupOptions,
        pullToRefreshController: pullToRefreshController,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          setState(() {
            this.url = url.toString();
          });
          if (url!.toString().contains('/payment/success')) {
            Navigator.of(context).pop();
            if(widget.onSuccess!=null) {
              widget.onSuccess!(invoiceId!);
            }
          }
        },
        onLoadStop: (controller, url) async {
          pullToRefreshController?.endRefreshing();
          String htmlContent = await webViewController?.evaluateJavascript(
              source: 'document.documentElement.outerHTML');
          extractInvoiceId(htmlContent);
        },
        onLoadError: (controller, url, code, message) {
          pullToRefreshController!.endRefreshing();
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          setState(() {
            this.url = url.toString();
          });
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          Uri uri = navigationAction.request.url!;
          var url = navigationAction.request.url.toString();

          if (Platform.isAndroid && url.contains("intent")) {
            if (url.contains("maps")) {
              var newURL = url.replaceAll("intent://", "https://");
              if (await canLaunchUrl(Uri.parse(newURL))) {
                await launchUrl(Uri.parse(newURL));
                return NavigationActionPolicy.CANCEL;
              }
            } else {
              var newURL = url.replaceAll("intent://", "https://");
              launchUrl(Uri.parse(newURL),
                  mode: LaunchMode.externalApplication);
              // await StoreRedirect.redirect(androidAppId: newURL);
              return NavigationActionPolicy.CANCEL;
            }
          } else if (!["http", "https", "chrome", "data", "javascript", "about"]
              .contains(uri.scheme)) {
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);

              return NavigationActionPolicy.CANCEL;
            }
          } else if (url.contains(RegExp(
              r"(linkedin\.com|market:\/\/|whatsapp:\/\/|truecaller:\/\/|pinterest\.com|snapchat\.com|youtube\.com|spotify\.com|instagram\.com|play\.google\.com|mailto:|tel:|share=telegram|messenger\.com)"))) {
            Uri parsedUrl = Uri.parse(url);
            switch (parsedUrl.host) {
              case "api.whatsapp.com":
                if (parsedUrl.queryParameters.containsKey("phone") &&
                    parsedUrl.queryParameters["phone"] == "+") {
                  url = url.replaceFirst("=+", "=");
                }
                break;
              case "whatsapp://send":
                if (parsedUrl.queryParameters.containsKey("phone") &&
                    parsedUrl.queryParameters["phone"] == "%20") {
                  url = url.replaceFirst("/?phone=%20", "/?phone=");
                }
                break;
              default:
                if (!url.contains("whatsapp://")) {
                  url = Uri.encodeFull(url);
                }
            }

            try {
              if (await canLaunchUrl(Uri.parse(url))) {
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              } else {
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
            } catch (e) {
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            }

            return NavigationActionPolicy.CANCEL;
          }

          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}
