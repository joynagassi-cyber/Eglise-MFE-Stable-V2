import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import 'fire_discovery_card.dart';
import '../../domain/entities/social_post.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/router/app_routes.dart';

class SocialHorizontalFeed extends StatefulWidget {
  final List<SocialPost> posts;

  const SocialHorizontalFeed({
    super.key,
    required this.posts,
  });

  @override
  State<SocialHorizontalFeed> createState() => _SocialHorizontalFeedState();
}

class _SocialHorizontalFeedState extends State<SocialHorizontalFeed> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Feed Principal
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: widget.posts.length,
            itemBuilder: (context, index) {
              final post = widget.posts[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = (_pageController.page! - index).abs();
                    value = (1 - (value * 0.12)).clamp(0.0, 1.0);
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      child: Transform.scale(
                        scale: value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: FireDiscoveryCard(
                  post: post,
                  onTap: () {
                    context.push(
                      AppRoutes.communicationSocialDetail,
                      extra: post,
                    );
                  },
                ),
              );
            },
          ),
        ),

        // Indicateur discret (Simplicité Pro)
        const SizedBox(height: AppSpacing.md),
        _buildPageIndicator(),
        const SizedBox(
            height: AppSpacing.xxl + 20), // Espace pour la barre de navigation
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.posts.length
            .clamp(0, 5), // Limiter à 5 points max pour la simplicité
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 4,
          width: _currentPage == index ? 20 : 4,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? context.colors.brandPrimary
                : context.colors.brandPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
