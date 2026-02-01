import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/scene_categories.dart';
import '../constants/tense_categories.dart';
import 'review_page.dart';

class ReviewSelectionPage extends StatefulWidget {
  final int initialTab;

  const ReviewSelectionPage({super.key, this.initialTab = 0});

  @override
  State<ReviewSelectionPage> createState() => _ReviewSelectionPageState();
}

class _ReviewSelectionPageState extends State<ReviewSelectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('选择复习方式'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '按场景'),
            Tab(text: '按时态'),
            Tab(text: '按时间'),
            Tab(text: '全部随机'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSceneList(),
          _buildTenseList(),
          _buildTimeList(),
          _buildRandomView(),
        ],
      ),
    );
  }

  Widget _buildSceneList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: SceneCategories.all.length,
      itemBuilder: (context, index) {
        final category = SceneCategories.all[index];
        return _buildCategoryItem(
          icon: category.icon,
          iconBackground: category.lightColor,
          iconColor: category.color,
          title: category.name,
          subtitle: category.englishName,
          count: '0',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReviewPage(
                  filterType: 'scene',
                  filterValue: category.id,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTenseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: TenseCategories.all.length,
      itemBuilder: (context, index) {
        final category = TenseCategories.all[index];
        return _buildCategoryItem(
          icon: category.icon,
          iconBackground: AppColors.background,
          iconColor: category.color,
          title: category.name,
          subtitle: category.englishName,
          count: '0',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReviewPage(
                  filterType: 'tense',
                  filterValue: category.id,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimeList() {
    final timeRanges = [
      {'name': '今天', 'value': 'today'},
      {'name': '最近7天', 'value': 'week'},
      {'name': '最近30天', 'value': 'month'},
      {'name': '全部', 'value': 'all'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: timeRanges.length,
      itemBuilder: (context, index) {
        final range = timeRanges[index];
        return _buildCategoryItem(
          icon: Icons.calendar_today,
          iconBackground: AppColors.background,
          iconColor: AppColors.primary,
          title: range['name']!,
          subtitle: '按导入时间筛选',
          count: '0',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReviewPage(
                  filterType: 'time',
                  filterValue: range['value']!,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRandomView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shuffle,
            size: 80,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          const Text(
            '随机复习模式',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '从所有卡片中随机抽取',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReviewPage(
                    filterType: 'random',
                    filterValue: '',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('开始随机复习'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String count,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
