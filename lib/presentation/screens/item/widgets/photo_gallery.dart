import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';

/// Galeria de fotos do item (até 10 imagens, conforme briefing) com Hero na
/// primeira foto para continuar a transição iniciada no card da listagem.
class ItemPhotoGallery extends StatefulWidget {
  final String itemId;
  final List<String> photoUrls;

  const ItemPhotoGallery({super.key, required this.itemId, required this.photoUrls});

  @override
  State<ItemPhotoGallery> createState() => _ItemPhotoGalleryState();
}

class _ItemPhotoGalleryState extends State<ItemPhotoGallery> {
  final _controller = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final photos = widget.photoUrls.isEmpty ? [''] : widget.photoUrls;

    return Stack(
      children: [
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: _controller,
            itemCount: photos.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) {
              final url = photos[index];
              final image = url.isEmpty
                  ? Container(
                      color: AppColors.beigeSoft,
                      child: const Icon(Icons.image_not_supported_outlined, size: 48, color: AppColors.greyText),
                    )
                  : CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, _) => Shimmer.fromColors(
                        baseColor: AppColors.beigeSoft,
                        highlightColor: AppColors.beige,
                        child: Container(color: AppColors.beigeSoft),
                      ),
                      errorWidget: (context, _, __) => Container(
                        color: AppColors.beigeSoft,
                        child: const Icon(Icons.image_not_supported_outlined, color: AppColors.greyText),
                      ),
                    );

              return index == 0
                  ? Hero(tag: 'item_photo_${widget.itemId}', child: image)
                  : image;
            },
          ),
        ),
        if (photos.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(photos.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        if (photos.length > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_page + 1}/${photos.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}
