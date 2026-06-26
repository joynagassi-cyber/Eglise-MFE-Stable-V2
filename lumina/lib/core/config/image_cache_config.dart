import 'package:flutter/painting.dart';

class ImageCacheConfig {
  static void configure() {
    PaintingBinding.instance.imageCache.maximumSize = 200;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20; // 100 MB
  }
}
