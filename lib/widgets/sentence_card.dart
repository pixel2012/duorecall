import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import '../constants/app_colors.dart';
import '../constants/scene_categories.dart';

/// 句子卡片组件
@UseCase(name: 'Default', type: SentenceCard)
Widget sentenceCardDefault(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: AppColors.background,
    child: SentenceCard(
      chineseText: '我今天早上吃了一碗面条',
      englishText: 'I ate a bowl of noodles this morning',
      scene: 'daily_life',
      reviewCount: 5,
      onTap: () {},
    ),
  );
}

@UseCase(name: 'Long Text', type: SentenceCard)
Widget sentenceCardLongText(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: AppColors.background,
    child: SentenceCard(
      chineseText: '如果明天天气好的话，我们一起去公园野餐吧，我可以准备一些三明治和饮料',
      englishText: 'If the weather is nice tomorrow, let\'s go for a picnic in the park together. I can prepare some sandwiches and drinks.',
      scene: 'entertainment',
      reviewCount: 12,
      onTap: () {},
    ),
  );
}

@UseCase(name: 'No Review', type: SentenceCard)
Widget sentenceCardNoReview(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: AppColors.background,
    child: SentenceCard(
      chineseText: '请问洗手间在哪里？',
      englishText: 'Excuse me, where is the restroom?',
      scene: 'travel',
      reviewCount: 0,
      onTap: () {},
    ),
  );
}

class SentenceCard extends StatelessWidget {
  final String chineseText;
  final String englishText;
  final String scene;
  final int reviewCount;
  final VoidCallback? onTap;

  const SentenceCard({
    super.key,
    required this.chineseText,
    required this.englishText,
    required this.scene,
    this.reviewCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sceneCategory = SceneCategories.getByIdOrDefault(scene);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: sceneCategory.lightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  sceneCategory.icon,
                  color: sceneCategory.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chineseText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      englishText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: sceneCategory.lightColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            sceneCategory.name,
                            style: TextStyle(
                              fontSize: 11,
                              color: sceneCategory.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (reviewCount > 0)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.repeat,
                                size: 12,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '$reviewCount',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
