import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class Data extends StatelessWidget {
  const Data({super.key, required this.title});

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
          for (final location in locations)
            LocationListItem(
              imageUrl: location.imageUrl,
              name: location.name,
              country: location.place,
              routeName: location.routeName,
            ),
        ],
      ),
    );
  }
}

class LocationListItem extends StatelessWidget{
  LocationListItem({
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
                  String res = '/products/$routeName';
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
          fit: BoxFit.cover,)
        // Image.network(
        //   imageUrl,
        //   key: _backgroundImageKey,
        //   fit: BoxFit.cover,
        // ),
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

class Location {
  const Location({
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
const locations = [
  Location(
    name: 'ДГУ',
    place: 'Дизельно генераторные установки',
    imageUrl: 'https://cloud.krialenergo.ru/apps/files_sharing/publicpreview/YsEyWcTz9MDkRsY?file=/kozh.png&fileId=10660&x=1920&y=1200&a=true',
    routeName: 'dgy',
    //imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  Location(
    name: 'Холод',
    place: 'Промышленные системы охлаждения',
    imageUrl: 'https://downloader.disk.yandex.ru/preview/493ded1100b2f189b8e0d90abbc367c47d3fd74245cfe9633178b4ddf1924d7e/6380a1bd/nlMnXGq66aMn4JeGN6s8sZfFboq_1hYaFsUoNTXJsXCWtrxk3i68Ft5MmgGs2Fj2sK-FTe1BINCN-lFdxRs0hg%3D%3D?uid=0&filename=Градирня_4.jpg&disposition=inline&hash=&limit=0&content_type=image%2Fjpeg&owner_uid=0&tknv=v2&size=1838x1047',
    routeName: 'dgy',
  ),
  Location(
    name: 'Газ',
    place: 'Газоразделительное оборудование',
    imageUrl: 'https://cloud.krialenergo.ru/apps/files_sharing/publicpreview/YsEyWcTz9MDkRsY?file=/gaz.png&fileId=10670&x=1920&y=1200&a=true',
    routeName: 'dgy',
  ),
  Location(
    name: 'ПБК',
    place: 'Промышленные блок-контейнеры',
    imageUrl: 'https://cloud.krialenergo.ru/apps/files_sharing/publicpreview/YsEyWcTz9MDkRsY?file=/pbk.png&fileId=10680&x=1920&y=1200&a=true',
    routeName: 'dgy',
  ),
  Location(
    name: 'Компрессоры',
    place: 'Компрессорное оборудование',
    imageUrl: 'https://cloud.krialenergo.ru/apps/files_sharing/publicpreview/YsEyWcTz9MDkRsY?file=/kompr.png&fileId=10691&x=1920&y=1200&a=true',
    routeName: 'dgy',
  ),
  Location(
    name: 'ИБП',
    place: 'Источники бесперебойного питания',
    imageUrl: 'https://cloud.krialenergo.ru/apps/files_sharing/publicpreview/YsEyWcTz9MDkRsY?file=/ИБП_1.png&fileId=10701&x=1920&y=1200&a=true',
    routeName: 'dgy',
  ),
  Location(
    name: 'Котельные',
    place: 'Котельные',
    imageUrl: 'https://cloud.krialenergo.ru/apps/files_sharing/publicpreview/JzGi2jDznwsKH7H?x=1845&y=610&a=true&file=kotelnye.png&scalingup=0',
    routeName: 'dgy',
  ),
];