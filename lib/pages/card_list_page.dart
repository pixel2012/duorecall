import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/scene_categories.dart';
import '../providers/sentence_provider.dart';
import '../models/sentence.dart';

class CardListPage extends StatelessWidget {
  const CardListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('卡片库'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Consumer<SentenceProvider>(
        builder: (context, provider, child) {
          if (provider.sentences.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              _buildFilterChips(context, provider),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.sentences.length,
                  itemBuilder: (context, index) {
                    final sentence = provider.sentences[index];
                    return _buildCardItem(context, sentence);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.style_outlined,
            size: 80,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            '暂无卡片',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '导入多邻国截图开始学习吧',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, SentenceProvider provider) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterChip(
            label: const Text('全部'),
            selected: provider.selectedScene == null && provider.selectedTense == null,
            onSelected: (_) => provider.clearFilters(),
          ),
          const SizedBox(width: 8),
          ...SceneCategories.all.take(5).map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category.name),
                selected: provider.selectedScene == category.id,
                onSelected: (selected) {
                  provider.filterByScene(selected ? category.id : null);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, Sentence sentence) {
    final sceneCategory = SceneCategories.getByIdOrDefault(sentence.scene);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    sentence.chineseText,
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
                    sentence.englishText,
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
                      if (sentence.reviewCount > 0)
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
                              '${sentence.reviewCount}',
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
    );
  }
}
