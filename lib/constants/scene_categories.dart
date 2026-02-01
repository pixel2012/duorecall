import 'package:flutter/material.dart';
import 'app_colors.dart';

class SceneCategory {
  final String id;
  final String name;
  final String englishName;
  final IconData icon;
  final Color color;
  final Color lightColor;

  const SceneCategory({
    required this.id,
    required this.name,
    required this.englishName,
    required this.icon,
    required this.color,
    required this.lightColor,
  });
}

class SceneCategories {
  SceneCategories._();

  static const List<SceneCategory> all = [
    SceneCategory(
      id: 'daily_life',
      name: '日常生活',
      englishName: 'Daily Life',
      icon: Icons.home,
      color: AppColors.primary,
      lightColor: AppColors.primaryLight,
    ),
    SceneCategory(
      id: 'restaurant',
      name: '餐厅用餐',
      englishName: 'Restaurant',
      icon: Icons.restaurant,
      color: AppColors.restaurant,
      lightColor: Color(0xFFFFF0E6),
    ),
    SceneCategory(
      id: 'shopping',
      name: '购物消费',
      englishName: 'Shopping',
      icon: Icons.shopping_bag,
      color: AppColors.shopping,
      lightColor: Color(0xFFF5EBF9),
    ),
    SceneCategory(
      id: 'travel',
      name: '旅行出行',
      englishName: 'Travel',
      icon: Icons.flight,
      color: AppColors.travel,
      lightColor: Color(0xFFEBF3FC),
    ),
    SceneCategory(
      id: 'workplace',
      name: '工作职场',
      englishName: 'Workplace',
      icon: Icons.work,
      color: AppColors.workplace,
      lightColor: Color(0xFFE8F4FC),
    ),
    SceneCategory(
      id: 'education',
      name: '学校教育',
      englishName: 'Education',
      icon: Icons.school,
      color: AppColors.education,
      lightColor: Color(0xFFFCE4EC),
    ),
    SceneCategory(
      id: 'healthcare',
      name: '医疗健康',
      englishName: 'Healthcare',
      icon: Icons.local_hospital,
      color: AppColors.healthcare,
      lightColor: Color(0xFFFFEBEE),
    ),
    SceneCategory(
      id: 'transportation',
      name: '交通出行',
      englishName: 'Transportation',
      icon: Icons.directions_car,
      color: AppColors.transportation,
      lightColor: Color(0xFFECEFF1),
    ),
    SceneCategory(
      id: 'accommodation',
      name: '住宿酒店',
      englishName: 'Accommodation',
      icon: Icons.hotel,
      color: AppColors.accommodation,
      lightColor: Color(0xFFEFEBE9),
    ),
    SceneCategory(
      id: 'banking',
      name: '银行金融',
      englishName: 'Banking',
      icon: Icons.account_balance,
      color: AppColors.banking,
      lightColor: Color(0xFFE8F5E9),
    ),
    SceneCategory(
      id: 'post_office',
      name: '邮局快递',
      englishName: 'Post Office',
      icon: Icons.local_post_office,
      color: AppColors.postOffice,
      lightColor: Color(0xFFFFF3E0),
    ),
    SceneCategory(
      id: 'telephone',
      name: '电话通讯',
      englishName: 'Telephone',
      icon: Icons.phone,
      color: AppColors.telephone,
      lightColor: Color(0xFFE0F7FA),
    ),
    SceneCategory(
      id: 'weather',
      name: '天气气候',
      englishName: 'Weather',
      icon: Icons.wb_sunny,
      color: AppColors.weather,
      lightColor: Color(0xFFFFFDE7),
    ),
    SceneCategory(
      id: 'time_date',
      name: '时间日期',
      englishName: 'Time & Date',
      icon: Icons.access_time,
      color: AppColors.timeDate,
      lightColor: Color(0xFFF3E5F5),
    ),
    SceneCategory(
      id: 'family',
      name: '家庭亲情',
      englishName: 'Family',
      icon: Icons.family_restroom,
      color: AppColors.family,
      lightColor: Color(0xFFFCE4EC),
    ),
    SceneCategory(
      id: 'friendship',
      name: '朋友社交',
      englishName: 'Friendship',
      icon: Icons.people,
      color: AppColors.friendship,
      lightColor: Color(0xFFE3F2FD),
    ),
    SceneCategory(
      id: 'romance',
      name: '爱情约会',
      englishName: 'Romance',
      icon: Icons.favorite,
      color: AppColors.romance,
      lightColor: Color(0xFFFFEBEE),
    ),
    SceneCategory(
      id: 'sports',
      name: '运动健身',
      englishName: 'Sports',
      icon: Icons.fitness_center,
      color: AppColors.sports,
      lightColor: Color(0xFFE8F5E9),
    ),
    SceneCategory(
      id: 'entertainment',
      name: '娱乐休闲',
      englishName: 'Entertainment',
      icon: Icons.movie,
      color: AppColors.entertainment,
      lightColor: Color(0xFFEDE7F6),
    ),
    SceneCategory(
      id: 'music_art',
      name: '音乐艺术',
      englishName: 'Music & Art',
      icon: Icons.music_note,
      color: AppColors.musicArt,
      lightColor: Color(0xFFFCE4EC),
    ),
    SceneCategory(
      id: 'reading',
      name: '阅读书籍',
      englishName: 'Reading',
      icon: Icons.menu_book,
      color: AppColors.reading,
      lightColor: Color(0xFFEFEBE9),
    ),
    SceneCategory(
      id: 'technology',
      name: '科技网络',
      englishName: 'Technology',
      icon: Icons.computer,
      color: AppColors.technology,
      lightColor: Color(0xFFECEFF1),
    ),
    SceneCategory(
      id: 'nature',
      name: '自然环境',
      englishName: 'Nature',
      icon: Icons.park,
      color: AppColors.nature,
      lightColor: Color(0xFFE8F5E9),
    ),
    SceneCategory(
      id: 'animals',
      name: '动物宠物',
      englishName: 'Animals',
      icon: Icons.pets,
      color: AppColors.animals,
      lightColor: Color(0xFFFFF3E0),
    ),
    SceneCategory(
      id: 'festivals',
      name: '节日庆典',
      englishName: 'Festivals',
      icon: Icons.celebration,
      color: AppColors.festivals,
      lightColor: Color(0xFFFFEBEE),
    ),
    SceneCategory(
      id: 'news_media',
      name: '新闻媒体',
      englishName: 'News & Media',
      icon: Icons.newspaper,
      color: AppColors.newsMedia,
      lightColor: Color(0xFFECEFF1),
    ),
    SceneCategory(
      id: 'legal_affairs',
      name: '法律政务',
      englishName: 'Legal Affairs',
      icon: Icons.gavel,
      color: AppColors.legalAffairs,
      lightColor: Color(0xFFE8EAF6),
    ),
    SceneCategory(
      id: 'job_interview',
      name: '面试求职',
      englishName: 'Job Interview',
      icon: Icons.assignment_ind,
      color: AppColors.jobInterview,
      lightColor: Color(0xFFE0F2F1),
    ),
    SceneCategory(
      id: 'housing',
      name: '租房买房',
      englishName: 'Housing',
      icon: Icons.house,
      color: AppColors.housing,
      lightColor: Color(0xFFF1F8E9),
    ),
    SceneCategory(
      id: 'others',
      name: '其他场景',
      englishName: 'Others',
      icon: Icons.category,
      color: AppColors.others,
      lightColor: Color(0xFFF5F5F5),
    ),
  ];

  static SceneCategory? getById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  static SceneCategory getByIdOrDefault(String id) {
    return getById(id) ?? all.last;
  }
}
