import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import '../models/Constants.dart';

const Color _kAppBackgroundColor = const Color(0xFFCCCBCB); //侧条和整个板块的底背景色
const Duration _kScrollDuration = const Duration(milliseconds: 400);
const Curve _kScrollCurve = Curves.fastOutSlowIn;
const double _kAppBarMinHeight = 60.0;
const double kSectionIndicatorWidth = 32.0;
// The AppBar's max height depends on the screen, see _AnimationDemoHomeState._buildBody()

// Initially occupies the same space as the status bar and gets smaller as
// the primary scrollable scrolls upwards.
// TODO(hansmuller): it would be worth adding something like this to the framework.
class _RenderStatusBarPaddingSliver extends RenderSliver {
  _RenderStatusBarPaddingSliver({
    @required double maxHeight,
    @required double scrollFactor,
  })  : assert(maxHeight != null && maxHeight >= 0.0),
        assert(scrollFactor != null && scrollFactor >= 1.0),
        _maxHeight = maxHeight,
        _scrollFactor = scrollFactor;

  // The height of the status bar
  double get maxHeight => _maxHeight;
  double _maxHeight;
  set maxHeight(double value) {
    assert(maxHeight != null && maxHeight >= 0.0);
    if (_maxHeight == value) return;
    _maxHeight = value;
    markNeedsLayout();
  }

  // That rate at which this renderer's height shrinks when the scroll
  // offset changes.
  double get scrollFactor => _scrollFactor;
  double _scrollFactor;
  set scrollFactor(double value) {
    assert(scrollFactor != null && scrollFactor >= 1.0);
    if (_scrollFactor == value) return;
    _scrollFactor = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final double height =
    (maxHeight - constraints.scrollOffset / scrollFactor).clamp(0.0, maxHeight);
    geometry = new SliverGeometry(
      paintExtent: math.min(height, constraints.remainingPaintExtent),
      scrollExtent: maxHeight,
      maxPaintExtent: maxHeight,
    );
  }
}

class _StatusBarPaddingSliver extends SingleChildRenderObjectWidget {
  const _StatusBarPaddingSliver({
    Key key,
    @required this.maxHeight,
    this.scrollFactor: 5.0,
  })  : assert(maxHeight != null && maxHeight >= 0.0),
        assert(scrollFactor != null && scrollFactor >= 1.0),
        super(key: key);

  final double maxHeight;
  final double scrollFactor;

  @override
  _RenderStatusBarPaddingSliver createRenderObject(BuildContext context) {
    return new _RenderStatusBarPaddingSliver(
      maxHeight: maxHeight,
      scrollFactor: scrollFactor,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderStatusBarPaddingSliver renderObject) {
    renderObject
      ..maxHeight = maxHeight
      ..scrollFactor = scrollFactor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(new DoubleProperty('maxHeight', maxHeight));
    description.add(new DoubleProperty('scrollFactor', scrollFactor));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }

  @override
  String toString() => '_SliverAppBarDelegate';
}

class _AllSectionsLayout extends MultiChildLayoutDelegate {
  _AllSectionsLayout({
    this.translation,
    this.tColumnToRow,
    this.cardCount,
    this.selectedIndex,
  });

  final Alignment translation;
  final double tColumnToRow;
  final int cardCount;
  final double selectedIndex;

  Rect _interpolateRect(Rect begin, Rect end) {
    return Rect.lerp(begin, end, tColumnToRow);
  }

  Offset _interpolatePoint(Offset begin, Offset end) {
    return Offset.lerp(begin, end, tColumnToRow);
  }

  @override
  void performLayout(Size size) {
    final double columnCardX = size.width / 5.0;
    final double columnCardWidth = size.width - columnCardX;
    final double columnCardHeight = size.height / cardCount;
    final double rowCardWidth = size.width;
    final double rowCardHeight = size.height;
    final Offset offset = translation.alongSize(size);
    double columnCardY = 0.0;
    double rowCardX = -(selectedIndex * rowCardWidth);

    final double columnTitleX = size.width / 10.0;
    final double rowTitleWidth = size.width / 2.0;
    double rowTitleX = (size.width - rowTitleWidth) / 2.0 - selectedIndex * rowTitleWidth;

    // When tCollapsed > 0, the indicators move closer together
    //final double rowIndicatorWidth = 48.0 + (1.0 - tCollapsed) * (rowTitleWidth - 48.0);
    const double paddedSectionIndicatorWidth = kSectionIndicatorWidth + 8.0;
    double rowIndicatorX = (size.width - paddedSectionIndicatorWidth) / 2.0 -
        selectedIndex * paddedSectionIndicatorWidth;

    // Compute the size and origin of each card, title, and indicator for the maxHeight
    // "column" layout, and the midHeight "row" layout. The actual layout is just the
    // interpolated value between the column and row layouts for t.
    for (int index = 0; index < cardCount; index++) {
      // Layout the card for index.
      final Rect columnCardRect =
      new Rect.fromLTWH(columnCardX, columnCardY, columnCardWidth, columnCardHeight);
      final Rect rowCardRect = new Rect.fromLTWH(rowCardX, 0.0, rowCardWidth, rowCardHeight);
      final Rect cardRect = _interpolateRect(columnCardRect, rowCardRect).shift(offset);
      final String cardId = 'card$index';
      if (hasChild(cardId)) {
        layoutChild(cardId, new BoxConstraints.tight(cardRect.size));
        positionChild(cardId, cardRect.topLeft);
      }

      // Layout the title for index.
      final Size titleSize = layoutChild('title$index', new BoxConstraints.loose(cardRect.size));
      final double columnTitleY = columnCardRect.centerLeft.dy - titleSize.height / 2.0;
      final double rowTitleY = rowCardRect.centerLeft.dy - titleSize.height / 2.0;
      final double centeredRowTitleX = rowTitleX + (rowTitleWidth - titleSize.width) / 2.0;
      final Offset columnTitleOrigin = new Offset(columnTitleX, columnTitleY);
      final Offset rowTitleOrigin = new Offset(centeredRowTitleX, rowTitleY);
      final Offset titleOrigin = _interpolatePoint(columnTitleOrigin, rowTitleOrigin);
      positionChild('title$index', titleOrigin + offset);

      // Layout the selection indicator for index.
      final Size indicatorSize =
      layoutChild('indicator$index', new BoxConstraints.loose(cardRect.size));
      final double columnIndicatorX = cardRect.centerRight.dx - indicatorSize.width - 16.0;
      final double columnIndicatorY = cardRect.bottomRight.dy - indicatorSize.height - 16.0;
      final Offset columnIndicatorOrigin = new Offset(columnIndicatorX, columnIndicatorY);
      final Rect titleRect = new Rect.fromPoints(titleOrigin, titleSize.bottomRight(titleOrigin));
      final double centeredRowIndicatorX =
          rowIndicatorX + (paddedSectionIndicatorWidth - indicatorSize.width) / 2.0;
      final double rowIndicatorY = titleRect.bottomCenter.dy + 16.0;
      final Offset rowIndicatorOrigin = new Offset(centeredRowIndicatorX, rowIndicatorY);
      final Offset indicatorOrigin = _interpolatePoint(columnIndicatorOrigin, rowIndicatorOrigin);
      positionChild('indicator$index', indicatorOrigin + offset);

      columnCardY += columnCardHeight;
      rowCardX += rowCardWidth;
      rowTitleX += rowTitleWidth;
      rowIndicatorX += paddedSectionIndicatorWidth;
    }
  }

  @override
  bool shouldRelayout(_AllSectionsLayout oldDelegate) {
    return tColumnToRow != oldDelegate.tColumnToRow ||
        cardCount != oldDelegate.cardCount ||
        selectedIndex != oldDelegate.selectedIndex;
  }
}

class _AllSectionsView extends AnimatedWidget {
  _AllSectionsView({
    Key key,
    this.sectionIndex,
    @required this.sections,
    @required this.selectedIndex,
    this.minHeight,
    this.maxHeight,
    this.sectionCards: const <Widget>[],
  })  : assert(sections != null),
        assert(sectionCards != null),
        assert(sectionCards.length == sections.length),
        assert(sectionIndex >= 0 && sectionIndex < sections.length),
        assert(selectedIndex != null),
        assert(selectedIndex.value >= 0.0 && selectedIndex.value < sections.length.toDouble()),
        super(key: key, listenable: selectedIndex);

  final int sectionIndex;
  final List<CardSection> sections;
  final ValueNotifier<double> selectedIndex;
  final double minHeight;
  final double maxHeight;
  final List<Widget> sectionCards;

  double _selectedIndexDelta(int index) {
    return (index.toDouble() - selectedIndex.value).abs().clamp(0.0, 1.0);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final Size size = constraints.biggest;

    // The layout's progress from from a column to a row. Its value is
    // 0.0 when size.height equals the maxHeight, 1.0 when the size.height
    // equals the minHeight.
    // The layout's progress from from a column to a row. Its value is
    // 0.0 when size.height equals the maxHeight, 1.0 when the size.height
    // equals the minHeight.
    final double tColumnToRow =
        1.0 - ((size.height - minHeight) / (maxHeight - minHeight)).clamp(0.0, 1.0);
    double _indicatorOpacity(int index) {
      return 1.0 - _selectedIndexDelta(index) * 0.5;
    }

    double _titleOpacity(int index) {
      return 1.0 - _selectedIndexDelta(index) * tColumnToRow * 0.5;
    }

    double _titleScale(int index) {
      return 1.0 - _selectedIndexDelta(index) * tColumnToRow * 0.15;
    }

    final List<Widget> children = new List<Widget>.from(sectionCards);

    for (int index = 0; index < sections.length; index++) {
      final CardSection section = sections[index];
      children.add(new LayoutId(
        id: 'title$index',
        child: new SectionTitle(
          section: section,
          scale: _titleScale(index),
          opacity: _titleOpacity(index),
        ),
      ));
    }

    for (int index = 0; index < sections.length; index++) {
      children.add(new LayoutId(
        id: 'indicator$index',
        child: new SectionIndicator(
          opacity: _indicatorOpacity(index),
        ),
      ));
    }

    return new CustomMultiChildLayout(
      delegate: new _AllSectionsLayout(
        translation: new Alignment((selectedIndex.value - sectionIndex) * 2.0 - 1.0, -1.0),
        tColumnToRow: tColumnToRow,
        cardCount: sections.length,
        selectedIndex: selectedIndex.value,
      ),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: _build);
  }
}

// Support snapping scrolls to the midScrollOffset: the point at which the
// app bar's height is _kAppBarMidHeight and only one section heading is
// visible.
// 决定是展开还是收缩
class _SnappingScrollPhysics extends ClampingScrollPhysics {
  const _SnappingScrollPhysics({
    ScrollPhysics parent,
    @required this.minScrollOffset,
  })  : assert(minScrollOffset != null),
        super(parent: parent);

  final double minScrollOffset;

  @override
  _SnappingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return new _SnappingScrollPhysics(
        parent: buildParent(ancestor), minScrollOffset: minScrollOffset);
  }

  Simulation _toMinScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return new ScrollSpringSimulation(spring, offset, minScrollOffset, velocity,
        tolerance: tolerance);
  }

  Simulation _toZeroScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return new ScrollSpringSimulation(spring, offset, 0.0, velocity, tolerance: tolerance);
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double dragVelocity) {
    final Simulation simulation = super.createBallisticSimulation(position, dragVelocity);
    final double offset = position.pixels;

    if (simulation != null) {
      // The drag ended with sufficient velocity to trigger creating a simulation.
      // If the simulation is headed up towards minScrollOffset but will not reach it,
      // then snap it there. Similarly if the simulation is headed down past
      // minScrollOffset but will not reach zero, then snap it to zero.
      final double simulationEnd = simulation.x(double.infinity);
      if (simulationEnd >= minScrollOffset) return simulation;
      if (dragVelocity > 0.0) return _toMinScrollOffsetSimulation(offset, dragVelocity);
      if (dragVelocity < 0.0) return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    } else {
      // The user ended the drag with little or no velocity. If they
      // didn't leave the offset above minScrollOffset, then
      // snap to minScrollOffset if they're more than halfway there,
      // otherwise snap to zero.
      final double snapThreshold = minScrollOffset / 2.0;
      if (offset >= snapThreshold && offset < minScrollOffset)
        return _toMinScrollOffsetSimulation(offset, dragVelocity);
      if (offset > 0.0 && offset < snapThreshold)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    }
    return simulation;
  }
}

class AnimateTabNavigation extends StatefulWidget {
  const AnimateTabNavigation({Key key, @required this.sectionList}) : super(key: key);
  final List<CardSection> sectionList;
  static const String routeName = '/animation';

  @override
  _AnimateTabNavigationState createState() =>
      new _AnimateTabNavigationState(sectionList: sectionList);
}

class _AnimateTabNavigationState extends State<AnimateTabNavigation> {
  _AnimateTabNavigationState({Key key, @required this.sectionList});
  final List<CardSection> sectionList;
  final ScrollController _scrollController = new ScrollController();
  final PageController _headingPageController = new PageController();
  final PageController _detailsPageController = new PageController();
  ScrollPhysics _headingScrollPhysics = const NeverScrollableScrollPhysics();
  ValueNotifier<double> selectedIndex = new ValueNotifier<double>(0.0);
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: _kAppBackgroundColor,
      body: new Builder(
        // Insert an element so that _buildBody can find the PrimaryScrollController.
        builder: _buildBody,
      ),
    );
  }

  void _handleBackButton(double midScrollOffset) {
    if(_scrollController.offset >= midScrollOffset)
      _scrollController.animateTo(0.0, curve: _kScrollCurve, duration: _kScrollDuration);
    else
      _scrollController.animateTo(556.0, curve: _kScrollCurve, duration: _kScrollDuration);
  }

  // Only enable paging for the heading when the user has scrolled to midScrollOffset.
  // Paging is enabled/disabled by setting the heading's PageView scroll physics.
  bool _handleScrollNotification(ScrollNotification notification, double minScrollOffset) {
    if (notification is ScrollUpdateNotification) {
      _expanded = _scrollController.position.pixels >= minScrollOffset;
      final ScrollPhysics physics =
      _expanded ? const PageScrollPhysics() : const NeverScrollableScrollPhysics();
      if (physics != _headingScrollPhysics) {
        setState(() {
          _headingScrollPhysics = physics;
        });
      }
    }
    return false;
  }

  void _maybeScroll(double minScrollOffset, int pageIndex, double xOffset, int totalPageCount) {
    if (_scrollController.offset < minScrollOffset) {
      // Scroll the overall list to the point where only one section card shows.
      // At the same time scroll the PageViews to the page at pageIndex.
      _headingPageController.animateToPage(pageIndex,
          curve: _kScrollCurve, duration: _kScrollDuration);
      _scrollController.animateTo(minScrollOffset,
          curve: _kScrollCurve, duration: _kScrollDuration);
    } else {
      // One one section card is showing: scroll one page forward or back.
      final double centerX = _headingPageController.position.viewportDimension / 2.0;

      int newPageIndex = pageIndex;
      if (xOffset - centerX > 40 && pageIndex < totalPageCount - 1) {
        newPageIndex++;
      } else if (centerX - xOffset > 40 && pageIndex > 0) {
        newPageIndex--;
      }
      _headingPageController.animateToPage(newPageIndex,
          curve: _kScrollCurve, duration: _kScrollDuration);
    }
  }

  bool _handlePageNotification(
      ScrollNotification notification, PageController leader, PageController follower) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      selectedIndex.value = leader.page;
      if (follower.position.pixels != leader.position.pixels) {
        follower.position
            .jumpToWithoutSettling(leader.position.pixels); // ignore: deprecated_member_use
      }
    }
    return false;
  }

  Iterable<Widget> _allHeadingItems(double maxHeight, double minHeight, double minScrollOffset) {
    final List<Widget> sectionCards = <Widget>[];
    for (int index = 0; index < sectionList.length; index++) {
      sectionCards.add(new LayoutId(
        id: 'card$index',
        child: new GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: new SectionCard(section: sectionList[index]),
            onTapUp: (TapUpDetails details) {
              final double xOffset = details.globalPosition.dx;
              setState(() {
                _maybeScroll(minScrollOffset, index, xOffset, sectionList.length);
              });
            }),
      ));
    }

    final List<Widget> headings = <Widget>[];
    for (int index = 0; index < sectionList.length; index++) {
      headings.add(new Container(
        color: _kAppBackgroundColor,
        child: new ClipRect(
          child: new _AllSectionsView(
            sectionIndex: index,
            sections: sectionList,
            selectedIndex: selectedIndex,
            minHeight: minHeight,
            maxHeight: maxHeight,
            sectionCards: sectionCards,
          ),
        ),
      ));
    }
    return headings;
  }

  Widget _buildBody(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double statusBarHeight = mediaQueryData.padding.top;
    final double screenHeight = mediaQueryData.size.height;
    final double appBarMaxHeight = screenHeight - statusBarHeight;

    // The scroll offset that reveals the appBarMinHeight appbar.
    final double appBarMinScrollOffset = appBarMaxHeight - _kAppBarMinHeight;
    final double appBodyHeight = appBarMinScrollOffset;

    return new SizedBox.expand(
      child: new Stack(
        children: <Widget>[
          new NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              return _handleScrollNotification(notification, appBarMinScrollOffset);
            },
            child: new CustomScrollView(
              controller: _scrollController,
              physics: new _SnappingScrollPhysics(minScrollOffset: appBarMinScrollOffset),
              slivers: <Widget>[
                // Start out below the status bar, gradually move to the top of the screen.
                new _StatusBarPaddingSliver(
                  maxHeight: statusBarHeight,
                  scrollFactor: 7.0,
                ),
                // Section Headings
                new SliverPersistentHeader(
                  pinned: true,
                  delegate: new _SliverAppBarDelegate(
                    minHeight: _kAppBarMinHeight,
                    maxHeight: appBarMaxHeight,
                    child: new NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        return _handlePageNotification(
                            notification, _headingPageController, _detailsPageController);
                      },
                      child: new PageView(
                        physics: _headingScrollPhysics,
                        controller: _headingPageController,
                        children: _allHeadingItems(appBarMaxHeight,
                            _kAppBarMinHeight + statusBarHeight, appBarMinScrollOffset),
                      ),
                    ),
                  ),
                ),
                // Details
                new SliverToBoxAdapter(
                  child: new SizedBox(
                    height: appBodyHeight,
                    child: new NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        return _handlePageNotification(
                            notification, _detailsPageController, _headingPageController);
                      },
                      child: new PageView(
                        controller: _detailsPageController,
                        children: sectionList.map((CardSection section) {
                          return Container(
//                            color: Colors.green,
                              child: section.child);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Positioned(
            top: statusBarHeight,
            left: 0.0,
            child: new IconTheme(
              data: const IconThemeData(color: Colors.white),
              child: new SafeArea(
                top: false,
                bottom: false,
                child: new IconButton(
                    icon: _expanded ? new Icon(Icons.view_carousel) : new Icon(Icons.format_list_bulleted),
//                    tooltip: 'Back',
                    onPressed: () {
                      _handleBackButton(appBarMinScrollOffset);
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardSection {
  CardSection({this.title, this.leftColor, this.rightColor, this.child});

  final String title;
  final Color leftColor;
  final Color rightColor;
  final Widget child;

  @override
  bool operator ==(Object other) {
    if (other is! CardSection) return false;
    final CardSection otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}

// The card for a single section. Displays the section's gradient and background image.
class SectionCard extends StatelessWidget {
  const SectionCard({Key key, @required this.section})
      : assert(section != null),
        super(key: key);

  final CardSection section;

  @override
  Widget build(BuildContext context) {
    return new Semantics(
      label: section.title,
      button: true,
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              section.leftColor,
              section.rightColor,
            ],
          ),
        ),
      ),
    );
  }
}

// The title is rendered with two overlapping text widgets that are vertically
// offset a little. It's supposed to look sort-of 3D.
class SectionTitle extends StatelessWidget {
  static const TextStyle sectionTitleStyle = const TextStyle(
    fontFamily: 'Raleway',
    inherit: false,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    textBaseline: TextBaseline.alphabetic,
  );

  static final TextStyle sectionTitleShadowStyle = sectionTitleStyle.copyWith(
    color: const Color(0x19000000),
  );

  const SectionTitle({
    Key key,
    @required this.section,
    @required this.scale,
    @required this.opacity,
  })  : assert(section != null),
        assert(scale != null),
        assert(opacity != null && opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  final CardSection section;
  final double scale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return new IgnorePointer(
      child: new Opacity(
        opacity: opacity,
        child: new Transform(
          transform: new Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: new Stack(
            children: <Widget>[
              new Positioned(
                top: 4.0,
                child: new Text(section.title, style: sectionTitleShadowStyle),
              ),
              new Text(section.title, style: sectionTitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}

// Small horizontal bar that indicates the selected section.
class SectionIndicator extends StatelessWidget {
  const SectionIndicator({Key key, this.opacity: 1.0}) : super(key: key);

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return new IgnorePointer(
      child: new Container(
        width: kSectionIndicatorWidth,
        height: 3.0,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}


class TopsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TopsPageState();
}

class TopsPageState extends State<TopsPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: new AnimateTabNavigation(
          sectionList: allSections,
        ),
      ),
    );
  }
}




//test datas
const Color _mariner = const Color(0xFF3B5F8F);
const Color _mediumPurple = const Color(0xFF8266D4);
const Color _tomato = const Color(0xFFF95B57);
const Color _mySin = const Color(0xFFF3A646);

List<Color> topTilesBgcolor = [
  Color(0xFF3B5F8F),
  Color(0xFF8266D4),
  Color(0xFFF95B57),
  Color(0xFFF3A646),
  Color(0xFF077678),
  Color(0xFF4A90E2),
  Color(0xFF89A601),
  Color(0xFFA715A4),
  Color(0xFF640F09),
  Color(0xFFFFF77C),
];

List<CardSection> allSections = <CardSection>[
  new CardSection(
      title: 'Swift',
      leftColor: _mediumPurple,
      rightColor: _mediumPurple,
      child: SingleChildScrollView(
        child: Column(
          children: createToptiles(topTilestext0),
        ),
      )
  ),
  new CardSection(
      title: '科技',
      leftColor: _mySin,
      rightColor: _mySin,
      child: SingleChildScrollView(
        child: Column(
          children: createToptiles(topTilestext1),
        ),
      )),
  new CardSection(
      title: 'Python',
      leftColor: _tomato,
      rightColor: _tomato,
      child: SingleChildScrollView(
        child: Column(
          children: createToptiles(topTilestext2),
        ),
      )),
//  new CardSection(
//      title: 'Forth Page',
//      leftColor: _tomato,
//      rightColor: Colors.pinkAccent,
//      contentWidget: Center(child: new Text('第四页'))),
//  new CardSection(
//      title: 'Fifth Page',
//      leftColor: Colors.blue,
//      rightColor: _mediumPurple,
//      contentWidget: Center(child: new Text('第五页'))),
//  new CardSection(
//      title: 'Sixth Page',
//      leftColor: Colors.grey,
//      rightColor: _mediumPurple,
//      contentWidget: Center(child: new Text('第五页'))),
];

List<Widget> createToptiles (List<String> topTilestext){
  int n = topTilestext.length;

  List<Widget> result = [];

  for(int i = 0; i < n; i++){
    result.add(ListTile(
      leading: CircleAvatar(child: Text((i + 1).toString(),style: TextStyle(color: Colors.white),),backgroundColor: topTilesBgcolor[i],),
      title: Text(topTilestext[i],overflow: TextOverflow.ellipsis,),
    ));
  }

  return result;
}

List<String> topTilestext1 = [
  "中国移动首张5G元素电话卡",
  "游戏适龄提示倡议",
  "5G室内基站",
  "你每天用来涨知识的App有哪些",
  "如何解读《EVA》",
  "苹果 6 月 4 日凌晨举行年度开发者大会，今年产品会有哪些新变化?",
  "大公司头条：英国芯片公司 ARM 停止与华为合作，影响后续研发",
  "Facebook 想用人工智能审核不良内容，CTO 认为这并不能解决问题",
  "Google Glass 企业版第二代发布，支持 Android 移动设备管理",
  "亚马逊股东向公司施压，试图禁止向政府销售面部识别相关产品",
];

List<String> topTilestext2 = [
  "The Meson Build System mesonbuild/meson",
  "Interactive Web Plotting for Python bokeh/bokeh",
  "DinoMan/speech-driven-animation",
  "增强版WeblogicScan、检测结果更精确、插件化、添加CVE-2019-2618，CVE-2019-2729检测，Python3支持 dr0op/WeblogicScan",
  "Official Python low-level client for Elasticsearch. elastic/elasticsearch-py",
  "AV元数据抓取工具，配合kodi,emby等本地媒体管理工具使用 wenead99/AV_Data_Capture",
  "Google Sheets Python API burnash/gspread"

];

List<String> topTilestext0 = [
  "SwiftUI & Combine app using MovieDB API. With a custom Flux (Redux) implementation. Dimillian/MovieSwiftUI",
  "NFCPassportReader for iOS 13 AndyQ/NFCPassportReader",
  "Cuberto/liquid-swipe",
  "Swift for TensorFlow Deep Learning Library tensorflow/swift-apis",
  "A Swift web framework and HTTP server. IBM-Swift/Kitura",
  "Turn On your VPN like a hero. lexrus/VPNOn"
  "I Am Poor Skeleton Project for iOS App Development Bootcamp londonappbrewery/I-Am-Poor-iOS12",
  "Курс «Разработка под iOS.Начинаем» ya-on-ios/course1"

];

