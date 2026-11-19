import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget gambar dengan fallback, loading state, dan penanganan CORS untuk Web.
class KitsuImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  const KitsuImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  static Widget _buildError({Widget? custom}) {
    return custom ??
        Container(
          color: const Color(0xFF282828),
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white38),
          ),
        );
  }

  static Widget _buildPlaceholder({Widget? custom}) {
    return custom ??
        Container(
          color: const Color(0xFF282828),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFFF4500),
              ),
            ),
          ),
        );
  }

  /// Menyesuaikan URL gambar agar aman dari CORS di Web
  String _resolveImageUrl(String rawUrl) {
    if (kIsWeb) {
      // Pada Flutter Web (Chrome), Kitsu CDN tidak memiliki header Access-Control-Allow-Origin (*).
      // Menggunakan weserv.nl proxy agar gambar dapat dirender tanpa terblokir CORS oleh browser.
      return 'https://images.weserv.nl/?url=${Uri.encodeComponent(rawUrl)}';
    }
    return rawUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return _buildError(custom: errorWidget);
    }

    final String finalUrl = _resolveImageUrl(imageUrl!.trim());

    return Image.network(
      finalUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder(custom: placeholder);
      },
      errorBuilder: (context, error, stackTrace) {
        // Fallback jika URL utama gagal di mobile/desktop
        if (!kIsWeb) {
          return Image.network(
            'https://images.weserv.nl/?url=${Uri.encodeComponent(imageUrl!.trim())}',
            fit: fit,
            width: width,
            height: height,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildPlaceholder(custom: placeholder);
            },
            errorBuilder: (context, err, stack) => _buildError(custom: errorWidget),
          );
        }
        return _buildError(custom: errorWidget);
      },
    );
  }
}
