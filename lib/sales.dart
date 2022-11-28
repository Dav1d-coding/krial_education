import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:krial_education/temp.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Sales extends StatelessWidget {
  const Sales({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Scaffold(
          body: Center(
            child: ExampleParallax(),
          ),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/LOGO.png"),
                    fit: BoxFit.contain
                )
              ),
              child: Text('Krial Education'),
            ),
            ListTile(
              title: const Text('Продукция'),
              onTap: () {
                // Update the state of the app
                Navigator.pushNamed(context, '/products');
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Стадии сделки'),
              onTap: () {
                // Update the state of the app
                Navigator.pushNamed(context, '/sales');
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Новости'),
              onTap: () {
                // Update the state of the app
                Navigator.pushNamed(context, '/news');
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}



class ExampleParallax extends StatelessWidget {
  const ExampleParallax({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final sales in sale_informations)
            SalesListItem(
              imageUrl: sales.imageUrl,
              name: sales.name,
              country: sales.place,
              routeName: sales.routeName,
            ),
        ],
      ),
    );
  }
}

class SalesListItem extends StatelessWidget{
  SalesListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
    required this.routeName,
  });

  final String imageUrl;
  final String name;
  final String country;
  final String routeName;
  final GlobalKey _backgroundImageKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
              // ElevatedButton(child: const Text('Перейти'),
              //   onPressed:() {
              //     Navigator.pushNamed(context, '/products/dgy');
              //   },
              // ),
              GestureDetector(
                onTap: (){
                  String res = '/sales/$routeName';
                  Navigator.pushNamed(context, res);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context)!,
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// class StateTest extends State<LocationListItem> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Test(title: 'test',),
//           ),
//         );
//       },
//       child: Container(
//         width: 200.0,
//         height: 200.0,
//       ),
//     );
//   }
//
// }

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);


  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
    (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
    verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
      Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

class Parallax extends SingleChildRenderObjectWidget {
  const Parallax({
    super.key,
    required Widget background,
  }) : super(child: background);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(scrollable: Scrollable.of(context)!);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderParallax renderObject) {
    renderObject.scrollable = Scrollable.of(context)!;
  }
}

class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Force the background to take up all available width
    // and then scale its height based on the image's aspect ratio.
    final background = child!;
    final backgroundImageConstraints =
    BoxConstraints.tightFor(width: size.width);
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // Set the background's local offset, which is zero.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the size of the scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this list item.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset =
    localToGlobal(size.centerLeft(Offset.zero), ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final scrollFraction =
    (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final background = child!;
    final backgroundSize = background.size;
    final listItemSize = size;
    final childRect =
    verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
        background,
        (background.parentData as ParallaxParentData).offset +
            offset +
            Offset(0.0, childRect.top));
  }
}

class SaleInfo {
  const SaleInfo({
    required this.name,
    required this.place,
    required this.imageUrl,
    required this.routeName,
  });

  final String name;
  final String place;
  final String imageUrl;
  final String routeName;
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const sale_informations = [
  SaleInfo(
    name: 'Этапы продаж',
    place: 'Этапы продаж',
    imageUrl: 'https://i.ytimg.com/vi/ImXLxL3fYjc/maxresdefault.jpg',
    routeName: 'parts',
  ),
  SaleInfo(
    name: 'Проектные продажи',
    place: 'Проектные продажи',
    imageUrl: 'https://static.tildacdn.com/tild6436-3533-4436-b164-376435396336/proekt-menedzher-dly.jpg',
    routeName: 'dgy',
  ),
  SaleInfo(
    name: 'Алгоритм обработки лида',
    place: 'Работа с лидами',
    imageUrl: 'https://eyenewton.ru/u/blog_photos/5fba7a335534f.jpg',
    routeName: 'dgy',
  ),
  SaleInfo(
    name: 'Типы клиентов',
    place: 'Какие бывают клиенты',
    imageUrl: 'https://primusinpelagus.com/blog/wp-content/uploads/2020/07/types_of_clients.jpg',
    routeName: 'dgy',
  ),
  SaleInfo(
    name: 'Фишки продаж',
    place: 'Фишки продаж',
    imageUrl: 'https://academy-of-capital.ru/upload/medialibrary/b3e/b3e944001f6165f8e539bed8bf603255.jpg',
    routeName: 'dgy',
  ),
  SaleInfo(
    name: 'Виды возражений',
    place: 'Работа с возражениями',
    imageUrl: 'https://pic.rutubelist.ru/video/25/6e/256ee3bb4d22b1a6d8df187f47ed4ccf.png',
    routeName: 'dgy',
  ),
  SaleInfo(
    name: 'Дополнительная информация',
    place: 'Дополнительная информация',
    imageUrl: 'http://boguchany-selsovet.ru/tinybrowser/images/news/info-553638_1280.jpg',
    routeName: 'dgy',
  ),
];