import 'package:flutter/material.dart';

class SafeNetworkImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? placeholder;

  const SafeNetworkImage({
    super.key,
    required this.url,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  String get fullUrl {
    if (url.startsWith("http")) return Uri.encodeFull(url);
    const String baseUrl = "https://apps.piit.us/new/tilmaame/";
    final combined = url.startsWith("/") ? baseUrl + url.substring(1) : baseUrl + url;
    return Uri.encodeFull(combined);
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      fullUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return placeholder ?? const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stack) {
        debugPrint("❌ Image load failed: $fullUrl");
        return placeholder ?? const Icon(Icons.car_rental, size: 60, color: Colors.grey);
      },
    );
  }
}
