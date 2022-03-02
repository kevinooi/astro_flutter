import 'package:astro_flutter/widgets/article_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../config/custom_color.dart';
import '../../model/local/detail_model.dart';
import '../../widgets/ingredient_tab.dart';

class DetailScreen extends HookWidget {
  final Detail detail;
  const DetailScreen({Key? key, required this.detail}) : super(key: key);

  static const String routeName = '/detail';

  static Route route(Detail detail) {
    return MaterialPageRoute(
      builder: (_) => DetailScreen(detail: detail),
      settings: RouteSettings(name: routeName, arguments: detail),
    );
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = useTabController(
      initialLength: 3,
      initialIndex: 0,
    );

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                collapsedHeight: 300,
                // expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 80),
                  title: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: CustomColors.secondaryRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 40,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.loose,
                    children: [
                      // Background
                      Positioned.fill(
                        child: Image.network(
                          detail.meal?.strMealThumb ??
                              detail.drink?.strDrinkThumb ??
                              'https://picsum.photos/id/1000/200',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Border Radius
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.transparent,
                          height: 15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: 15,
                                decoration: const BoxDecoration(
                                  color: CustomColors.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Rating & Play button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 70),
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 20,
                                    ),
                                    Text(
                                      '4.5 \u2022 15:06',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: CustomColors.primaryText
                                                .withAlpha(200),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                floating: true,
                delegate: _MyDelegate(
                  detail: detail,
                  tabBar: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: CustomColors.secondaryRed,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: CustomColors.tertiaryText,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: 'Ingredients'),
                      Tab(text: 'Steps'),
                      Tab(text: 'Nutrition'),
                    ],
                  ),
                ),
              )
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: [
              IngredientTab(detail: detail),
              // Steps Tab
              if (detail.meal?.strInstructions?.isNotEmpty ??
                  detail.drink?.strInstructions?.isNotEmpty ??
                  false)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Steps for making ${detail.meal?.strMeal ?? detail.drink?.strDrink}',
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ArticleMarkdown(
                        markdownSource: detail.meal?.strInstructions ??
                            detail.drink?.strInstructions,
                      ),
                    ),
                  ],
                )
              else
                Center(
                  child: Text(
                    'Sorry, no instructions provided',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 20),
                  ),
                ),
              // Nutrition Tab
              Center(
                child: Text(
                  'Coming Soon',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyDelegate extends SliverPersistentHeaderDelegate {
  _MyDelegate({
    required this.detail,
    required this.tabBar,
  });
  final Detail detail;
  final TabBar tabBar;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          // Action buttons above tab bar
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                splashRadius: 16,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                iconSize: 26,
                icon: const Icon(
                  Icons.chat_outlined,
                ),
              ),
              const SizedBox(width: 3),
              Text((detail.meal?.idMeal ?? detail.drink?.idDrink).toString()),
              const Spacer(),
              IconButton(
                onPressed: () {},
                splashRadius: 16,
                padding: EdgeInsets.zero,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                iconSize: 30,
                icon: const Icon(
                  Icons.star_border_rounded,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                splashRadius: 16,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                iconSize: 30,
                icon: const Icon(
                  Icons.bookmark_outline,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                splashRadius: 16,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                iconSize: 30,
                icon: const Icon(
                  Icons.share_outlined,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.black26, height: 30, thickness: 0.5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: tabBar,
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height + 70;

  @override
  double get minExtent => tabBar.preferredSize.height + 70;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}