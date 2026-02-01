import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/app_provider.dart';
import '../services/storage_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              _buildHeader(context, provider),
              _buildStatsGrid(context, provider),
              _buildSettingsList(context, provider),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider provider) {
    return SliverToBoxAdapter(
      child: Container(
        height: 160,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '学习者',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '已学习 0 天 · 掌握 0 个句子',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, AppProvider provider) {
    return SliverToBoxAdapter(
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAchievementItem(
                  value: provider.totalCards.toString(),
                  label: '总卡片',
                  icon: Icons.style,
                  color: AppColors.primary,
                ),
                _buildAchievementItem(
                  value: provider.masteredCards.toString(),
                  label: '已掌握',
                  icon: Icons.check_circle,
                  color: AppColors.success,
                ),
                _buildAchievementItem(
                  value: provider.streakDays.toString(),
                  label: '连续天数',
                  icon: Icons.local_fire_department,
                  color: AppColors.streak,
                ),
                _buildAchievementItem(
                  value: '0h',
                  label: '总学习',
                  icon: Icons.access_time,
                  color: AppColors.travel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context, AppProvider provider) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsGroup(
              title: '学习设置',
              items: [
                _buildSettingsItem(
                  icon: Icons.lightbulb_outline,
                  title: '提示模式',
                  subtitle: '部分有序',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.flag,
                  title: '每日目标',
                  subtitle: '${provider.settings.dailyGoal} 张/天',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsGroup(
              title: '数据管理',
              items: [
                _buildSettingsItem(
                  icon: Icons.cloud_download_outlined,
                  title: '导出数据',
                  onTap: () => _showExportDialog(context),
                ),
                _buildSettingsItem(
                  icon: Icons.cloud_upload_outlined,
                  title: '导入数据',
                  onTap: () => _showImportDialog(context),
                ),
                _buildSettingsItem(
                  icon: Icons.cached,
                  title: '清除缓存',
                  subtitle: '计算中...',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsGroup(
              title: 'API设置',
              items: [
                _buildSettingsItem(
                  icon: Icons.key,
                  title: '硅基流动API密钥',
                  subtitle: provider.settings.siliconFlowApiKey != null ? '已设置' : '未设置',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsGroup(
              title: '关于',
              items: [
                _buildSettingsItem(
                  icon: Icons.help_outline,
                  title: '使用帮助',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: '隐私政策',
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.info_outline,
                  title: '关于我们',
                  subtitle: 'v1.0.0',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => _showClearDataDialog(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('清除所有数据'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                '选择导出格式',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('JSON'),
              subtitle: const Text('用于备份和迁移'),
              onTap: () async {
                Navigator.pop(context);
                final storage = StorageService();
                final path = await storage.exportToJson();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已导出到: $path')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('CSV'),
              subtitle: const Text('用于Excel查看'),
              onTap: () async {
                Navigator.pop(context);
                final storage = StorageService();
                final path = await storage.exportToCsv();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已导出到: $path')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                '选择导入格式',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('JSON'),
              onTap: () async {
                Navigator.pop(context);
                final storage = StorageService();
                final result = await storage.importFromJson();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result.message)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('数据库文件'),
              onTap: () async {
                Navigator.pop(context);
                final storage = StorageService();
                final result = await storage.importFromDatabase();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result.message)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除所有数据'),
        content: const Text('此操作不可恢复，确定要清除所有数据吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final storage = StorageService();
              await storage.clearAllData();
              if (context.mounted) {
                context.read<AppProvider>().loadStats();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('所有数据已清除')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
