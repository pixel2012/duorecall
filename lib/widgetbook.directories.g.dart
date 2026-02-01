// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:duorecall/widgets/app_header.dart'
    as _duorecall_widgets_app_header;
import 'package:duorecall/widgets/category_card.dart'
    as _duorecall_widgets_category_card;
import 'package:duorecall/widgets/quick_start_button.dart'
    as _duorecall_widgets_quick_start_button;
import 'package:duorecall/widgets/sentence_card.dart'
    as _duorecall_widgets_sentence_card;
import 'package:duorecall/widgets/stat_card.dart'
    as _duorecall_widgets_stat_card;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'widgets',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'AppHeader',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _duorecall_widgets_app_header.appHeaderDefault,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Without Notification',
            builder: _duorecall_widgets_app_header.appHeaderWithoutNotification,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'CategoryCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _duorecall_widgets_category_card.categoryCardDefault,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Multiple',
            builder: _duorecall_widgets_category_card.categoryCardMultiple,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'QuickStartButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _duorecall_widgets_quick_start_button.quickStartButtonDefault,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SentenceCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _duorecall_widgets_sentence_card.sentenceCardDefault,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Long Text',
            builder: _duorecall_widgets_sentence_card.sentenceCardLongText,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'No Review',
            builder: _duorecall_widgets_sentence_card.sentenceCardNoReview,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'StatCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _duorecall_widgets_stat_card.statCardDefault,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Empty',
            builder: _duorecall_widgets_stat_card.statCardEmpty,
          ),
        ],
      ),
    ],
  ),
];
