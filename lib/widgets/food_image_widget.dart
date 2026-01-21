import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:free_cal_counter1/models/food.dart';
import 'package:free_cal_counter1/services/image_storage_service.dart';

class FoodImageWidget extends StatelessWidget {
  final Food food;
  final double? size;
  final VoidCallback? onTap;

  const FoodImageWidget({super.key, required this.food, this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Priority: local image > OFF thumbnail > emoji > placeholder
    if (food.isLocalImage()) {
      // Local image
      return _buildLocalImage(context);
    } else if (food.thumbnail != null && food.thumbnail!.isNotEmpty) {
      // OFF thumbnail URL
      return _buildNetworkImage(context);
    } else if (food.emoji != null && food.emoji!.isNotEmpty) {
      // Emoji
      return _buildEmoji(context);
    } else {
      // Placeholder
      return _buildPlaceholder(context);
    }
  }

  Widget _buildLocalImage(BuildContext context) {
    final guid = food.getLocalImageGuid();
    if (guid == null) {
      return _buildPlaceholder(context);
    }

    return FutureBuilder<String>(
      future: ImageStorageService.instance.getImagePath(guid!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildPlaceholder(context);
        }

        final imagePath = snapshot.data!;
        final imageFile = File(imagePath);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNetworkImage(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: food.thumbnail!,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildPlaceholder(context),
            errorWidget: (context, url, error) => _buildPlaceholder(context),
          ),
        ),
      ),
    );
  }

  Widget _buildEmoji(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            food.emoji!,
            style: TextStyle(fontSize: size != null ? size! * 0.6 : 32),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            Icons.restaurant,
            size: size != null ? size! * 0.6 : 32,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
