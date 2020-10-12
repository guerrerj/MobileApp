import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

/// Represents some additional [Color]s to be used
/// across the application
class Palette {
  static final background = Color(0xff202030);
  static final background700 = Color(0xff303040);

  static final accent = Colors.deepPurpleAccent.shade200;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var textTheme = Typography.whiteMountainView.copyWith(
      headline6: Typography.whiteMountainView.headline6.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -1,
        fontSize: 28,
        color: Colors.white,
      ),
      caption: Typography.whiteMountainView.caption.copyWith(
        fontStyle: FontStyle.italic,
      ),
    );

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: textTheme,
        accentColor: Palette.accent,
        scaffoldBackgroundColor: Palette.background,
        backgroundColor: Palette.background,
      ),
      home: Root(),
    );
  }
}

/// Application root container
class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Black backdrop when outscrolling
          // the view to the top
          Container(
            color: Colors.black,
            height: 350,
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Palette.background,
                    ],
                    stops: [
                      0,
                      .2
                    ]),
              ),
              child: Column(
                children: <Widget>[
                  Toolbar(),
                  Categories(),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Quote(
                      body:
                          'It\'s still magic even if you know how it\'s done. 🔮',
                      author: 'Terry Pratchett, A Hat Full of Sky',
                    ),
                  ),
                  ProductSetout(products: firstRowProducts.values.toList()),
                  ProductSetout(products: secondRowProducts.values.toList()),
                  Container(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Cart(),
          )
        ],
      ),
    );
  }
}

class Quote extends StatelessWidget {
  final String body;
  final String author;

  const Quote({this.body, this.author});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.format_quote,
            size: 40.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$body',
                  style: textTheme.display1,
                ),
                Container(
                  height: 8.0,
                ),
                Text(
                  author,
                  style: textTheme.caption,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Category(name: 'All', selected: true),
          Category(name: 'Cards'),
          Category(name: 'Coins'),
          Category(name: 'Mentalism'),
          Category(name: 'Comedy'),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String name;
  final bool selected;

  Category({
    this.name,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32.0),
      padding: selected ? const EdgeInsets.symmetric(horizontal: 8.0) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: selected ? Colors.white : Colors.transparent,
      ),
      child: Text(
        name.toUpperCase(),
        style: Theme.of(context).textTheme.subtitle.copyWith(
            height: 1.3, color: selected ? Palette.background : Colors.white),
      ),
    );
  }
}

class Toolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 32.0),
      child: Row(children: <Widget>[
        Icon(Icons.menu),
        flexy(),
        Text('Pure Magic Inc.'.toUpperCase(),
            style: Theme.of(context).textTheme.title)
      ]),
    );
  }
}

class ProductSetout extends StatefulWidget {
  final List<Product> products;

  const ProductSetout({this.products});

  @override
  _ProductSetoutState createState() => _ProductSetoutState();
}

class _ProductSetoutState extends State<ProductSetout> {
  final Random rnd = Random();

  ScrollController controller;

  @override
  void initState() {
    controller = ScrollController(
      initialScrollOffset: rnd.nextInt(500).toDouble(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: 380),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        controller: controller,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: widget.products
            .map<Widget>((product) => ProductCard(product: product))
            .toList(),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Palette.background700,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 16),
            color: Colors.black26,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              foregroundDecoration: BoxDecoration(
                color: Colors.grey.withOpacity(.5),
                backgroundBlendMode: BlendMode.saturation,
              ),
              child: Image.network(
                product.photo,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.8],
                  colors: [Colors.transparent, Palette.background700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  flexy(),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Container(
                    height: 8.0,
                  ),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Container(
                    height: 16.0,
                  ),
                  OutlineButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('\$${product.price}',
                              style: Theme.of(context).textTheme.title),
                        ],
                      ),
                    ),
                    onPressed: () {
                      print('Adding $product to cart!');
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white24,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                flexy(),
                OutlineButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      'Checkout',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  onPressed: () {
                    print('Checking out all items in the cart!');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget flexy() {
  return Expanded(
    child: Container(),
  );
}

class Product {
  final String name;
  final String description;
  final String photo;
  final double price;

  Product({this.name, this.description, this.photo, this.price});

  @override
  String toString() => 'Product($name)';
}

final Map<String, Product> firstRowProducts = {
  'vanishingCoins': Product(
    name: 'Bitcoin',
    description: 'Make money instantly vanish in your hand!',
    photo:
        'https://cdn.pixabay.com/photo/2017/02/11/10/24/bitcoin-2057405__340.jpg',
    price: 59.99,
  ),
  'diamondsCard': Product(
    name: 'Hand of midas',
    description: 'Do not pet your dog with it!',
    photo:
        'https://www.smashinglists.com/wp-content/uploads/2010/07/Hand-of-Midas1-600x399.jpg',
    price: 99.99,
  ),
  'flyingCarpter': Product(
    name: 'Flying Carpet',
    description: 'You best last mile transport. Works for any other mile too!',
    price: 499.99,
    photo:
        'https://www.smashinglists.com/wp-content/uploads/2010/07/flying-carpet-600x330.jpg',
  ),
};

final Map<String, Product> secondRowProducts = {
  'magicLamp': Product(
    name: 'Magic Lamp',
    description: 'Rub with caution, do not shake.',
    price: 69.99,
    photo:
        'https://www.smashinglists.com/wp-content/uploads/2010/07/magic-lamp-600x416.jpg',
  ),
  'theRing': Product(
    name: 'The Ring',
    description:
        'Just a ring. Nothing special about it. Just move on. Do not look. Skip it.',
    price: 89.99,
    photo:
        'https://www.smashinglists.com/wp-content/uploads/2010/07/onering-600x431.jpg',
  ),
  'philosophersStone': Product(
      name: 'Philosopher\'s stone',
      description:
          'Philosopher didn\'t tell what the stone is for. Should be useful.',
      price: 129.99,
      photo:
          'https://static1.therichestimages.com/wordpress/wp-content/uploads/2016/11/pottermore.jpg?q=50&fit=crop&w=963&h=617'),
};

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
mixin Drawable {
  void draw(Canvas canvas, Size size);
}

mixin Updatable {
  void update(Animation animation);
}

enum FadingDirection { fadeIn, fadeOut }

mixin Fading on Updatable {
  FadingDirection direction = FadingDirection.fadeOut;
  double opacity;

  @override
  void update(Animation controller) {
    if (direction == FadingDirection.fadeOut) {
      opacity = (1 - controller.value);
    } else {
      opacity = controller.value;
    }
  }
}

mixin Scaling on Updatable {
  double from = 0;
  double to = 1;
  double current;

  @override
  void update(Animation animation) {
    current = lerpDouble(from, to, animation.value);
  }
}

mixin Tweened on Updatable {
  Tween tween;
  double current;

  @override
  void update(Animation animation) {
    super.update(tween.animate(animation));
  }
}

mixin Curved on Updatable {
  Curve curve;

  @override
  void update(Animation animation) {
    super.update(
      CurveTween(curve: curve).animate(animation),
    );
  }
}

mixin Moving on Updatable {
  Offset from;
  Offset to;
  Offset current;

  @override
  void update(Animation animation) {
    current = Offset.lerp(from, to, animation.value);
  }
}

typedef ParticlesWidgetBuilder = Widget Function(
  BuildContext context,
  AnimationController controller,
);

class Particles extends StatefulWidget {
  final Duration duration;
  final Particle particle;
  final ParticlesWidgetBuilder builder;
  final Curve curve;

  const Particles({
    @required this.particle,
    @required this.builder,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.linear,
  });

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    animation = CurvedAnimation(curve: widget.curve, parent: controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          child: child,
          painter: ParticlePainter(
            animation: animation,
            particle: widget.particle,
          ),
        );
      },
      child: widget.builder(context, controller),
    );
  }
}

abstract class Particle implements Drawable, Updatable {
  @override
  void draw(Canvas canvas, Size size) {
    // Does nothing by default
  }

  @override
  void update(Animation controller) {
    // Does nothing by default
  }
}

mixin NestedParticle on Particle {
  Particle child;

  @override
  void draw(Canvas canvas, Size size) {
    super.draw(canvas, size);
    child.draw(canvas, size);
  }

  @override
  void update(Animation controller) {
    super.update(controller);
    child.update(controller);
  }
}

mixin CompositeParticle on Particle {
  List<Particle> children;

  @override
  void draw(Canvas canvas, Size size) {
    super.draw(canvas, size);

    for (var child in children) {
      child.draw(canvas, size);
    }
  }

  @override
  void update(Animation animation) {
    super.update(animation);

    for (var child in children) {
      child.update(animation);
    }
  }
}

class Aligned extends Particle with NestedParticle {
  final Alignment alignment;

  Aligned({
    this.alignment = Alignment.center,
    @required Particle child,
  }) {
    this.child = child;
  }

  @override
  void draw(Canvas canvas, Size size) {
    var offset = alignment.alongSize(size);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    super.draw(canvas, size);
    canvas.restore();
  }
}

class FadingRect extends Particle with Fading {
  Size size;

  FadingRect({
    this.size = const Size(50, 50),
  });

  @override
  void draw(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset.zero,
          width: this.size.width,
          height: this.size.height),
      Paint()..color = Colors.white.withOpacity(opacity),
    );
  }
}

/// Helpers for randomized dimensions
class Randoms {
  static final rnd = Random();

  /// Returns a random [Offset] from the "center" point of given size
  static Offset offsetFromSize(Size size) {
    return Offset(
      (rnd.nextDouble() * size.width) - (size.width / 2),
      (rnd.nextDouble() * size.height) - (size.height / 2),
    );
  }

  static Alignment alignment() {
    return Alignment(
      rnd.nextDouble() * 2 - 1,
      rnd.nextDouble() * 2 - 1,
    );
  }
}

/// [Burst] takes a list of children [Particle],
/// and wraps each one of them with [MovingParticle] in a random direction
/// from the center of the canvas, within specified [Size]
class Burst extends Particle with CompositeParticle {
  List<Particle> children;

  Burst({
    @required List<Particle> children,
    Size size = const Size(100, 100),
  }) {
    this.children = children
        .map<Particle>(
          (particle) => CurvedParticle(
            curve: Interval(
              Randoms.rnd.nextDouble() * .3,
              Randoms.rnd.nextDouble() * .4 + .6,
            ),
            child: MovingParticle(
              from: Offset.zero,
              to: Randoms.offsetFromSize(size),
              child: particle,
            ),
          ),
        )
        .toList();
  }
}

/// A function which returns [Particle] when called
typedef ParticleProvider = Particle Function(int i);

/// A [CompositeParticle] which allows to use [ParticleProvider]
/// generator functions as source for children particles
///
/// ```dart
/// // 10 plain fading circles
/// ParticleGenerator(10, (i) => FadingCircle());
///
/// // 10 randomly sized fading circles
/// ParticleGenerator(10, (i) => FadingCircle(radius: Randoms.rnd.nextDouble() * 10));
///
/// // 5 small and 5 large fading circles
/// ParticleGenerator(10, (i) => FadingCircle(radius: i < 5 ? 10 : 20));
/// ```
class ParticleGenerator extends Particle with CompositeParticle {
  List<Particle> children;

  ParticleGenerator(
    int count,
    ParticleProvider generator,
  ) {
    this.children = List<Particle>.generate(count, generator);
  }
}

class FadingCircle extends Particle with Fading {
  final double radius;
  final Color color;

  FadingCircle({
    this.radius = 10,
    this.color = Colors.white,
  });

  @override
  void draw(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = color.withOpacity(opacity),
    );
  }
}

/// Just a container for parameters
/// allowing to draw a circle on a [Canvas] later
class CircleParameters {
  double radius;
  Offset offset;

  CircleParameters({@required this.radius, @required this.offset});
}

/// Renders certain amount of circles on a [Canvas],
/// as per given [CircleParameters] list.
class Circles extends Particle with Fading {
  final List<CircleParameters> circles;

  /// Generates randomly positioned circles in
  /// given count with radius between given bounds.
  factory Circles.random({
    int count = 10,
    double maxRadius = 10,
    double minRadius,
  }) {
    if (minRadius == null) {
      minRadius = maxRadius * .1;
    }

    return Circles(
      circles: List<CircleParameters>.generate(
        count,
        (i) => CircleParameters(
          radius: Randoms.rnd.nextDouble() * maxRadius + minRadius,
          offset: Randoms.offsetFromSize(
            Size(maxRadius, maxRadius),
          ),
        ),
      ),
    );
  }

  Circles({this.circles});

  @override
  void draw(Canvas canvas, Size size) {
    for (var circle in circles) {
      canvas.drawCircle(
        circle.offset,
        circle.radius,
        Paint()..color = Colors.white.withOpacity(opacity),
      );
    }
  }
}

class MovingParticle extends Particle with Moving, NestedParticle {
  MovingParticle({
    @required Offset from,
    @required Offset to,
    @required Particle child,
  }) {
    this.from = from;
    this.to = to;
    this.child = child;
  }

  @override
  void draw(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(current.dx, current.dy);
    super.draw(canvas, size);
    canvas.restore();
  }
}

class ScalingParticle extends Particle with Scaling, NestedParticle {
  double from;
  double to;
  Particle child;

  ScalingParticle({
    this.from = 0.0,
    this.to = 1.0,
    @required this.child,
  });

  @override
  void draw(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(current);
    super.draw(canvas, size);
    canvas.restore();
  }
}

class TweenedParticle extends Particle with NestedParticle, Tweened {
  Tween tween;
  Particle child;

  TweenedParticle({
    @required this.tween,
    @required this.child,
  });
}

class CurvedParticle extends Particle with NestedParticle, Curved {
  Curve curve;
  Particle child;

  CurvedParticle({
    @required this.curve,
    @required this.child,
  });
}

class DrawablePainter extends CustomPainter {
  final Drawable child;

  DrawablePainter({this.child});

  @override
  void paint(Canvas canvas, Size size) {
    child.draw(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ParticlePainter extends CustomPainter {
  final Animation animation;
  final Particle particle;

  ParticlePainter({@required this.animation, @required this.particle}) {
    particle.update(animation);
  }

  @override
  void paint(Canvas canvas, Size size) {
    particle.draw(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      !(animation.isCompleted && animation.isDismissed);
}

class Puff extends Particle with NestedParticle {
  Particle child;

  Puff() {
    // Will generate 50 nested particles
    this.child = ParticleGenerator(
      50,
      // Each of which would be positioned randomly
      // within enclosing canvas
      (i) => Aligned(
        alignment: Randoms.alignment(),
        // And with equal possibility would be either
        child: Randoms.rnd.nextDouble() > .5
            // Burst of large white circles flowing
            // slightly upwards
            ? CurvedParticle(
                curve: Interval(
                  .3,
                  1,
                ),
                child: Burst(
                  children: List<Particle>.generate(
                    2,
                    (_) => MovingParticle(
                      child: ScalingParticle(
                        child: Circles.random(count: 2, maxRadius: 50),
                      ),
                      from: Offset.zero,
                      to: Offset(0, -30),
                    ),
                  ),
                ),
              )
            // Or a circle appearing slightly lately
            // and not moving anywhere
            : CurvedParticle(
                curve: Interval(
                  Randoms.rnd.nextDouble() * .5 + .5,
                  1.0,
                  curve: Curves.fastOutSlowIn,
                ),
                child: ScalingParticle(
                  child: FadingCircle(
                    // Of either of two given colors
                    color: Randoms.rnd.nextDouble() > .5
                        ? Palette.accent
                        : Colors.purpleAccent,
                  ),
                ),
              ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;

  const OutlineButton({
    @required this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(32.0);

    return Particles(
      curve: Curves.easeOutQuint,
      duration: const Duration(milliseconds: 1400),
      builder: (context, controller) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: RawMaterialButton(
            onPressed: () {
              controller.reset();
              controller.forward();

              onPressed();
            },
            child: Container(
              child: child,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  color: Colors.white,
                  width: 3.0,
                ),
              ),
            ),
          ),
        );
      },
      // particle: Aligned(
      //   child: Burst(
      //     children: List<Particle>.generate(
      //       5,
      //       (i) => Burst(
      //         children: List<Particle>.generate(
      //           5,
      //           (i) => Randoms.rnd.nextDouble() > .5
      //               ? FadingCircle(radius: Randoms.rnd.nextDouble() * 10)
      //               : FadingRect(
      //                   size: Size(
      //                   Randoms.rnd.nextDouble() * 10,
      //                   Randoms.rnd.nextDouble() * 10,
      //                 )),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      particle: ParticleGenerator(
        50,
        (i) => Aligned(
          alignment: Randoms.alignment(),
          child: Randoms.rnd.nextDouble() > .5
              ? CurvedParticle(
                  curve: Interval(
                    .3,
                    1,
                  ),
                  child: Burst(
                    children: List<Particle>.generate(
                      2,
                      (_) => MovingParticle(
                        child: ScalingParticle(
                          child: Circles.random(count: 2, maxRadius: 50),
                        ),
                        from: Offset.zero,
                        to: Offset(0, -30),
                      ),
                    ),
                  ),
                )
              : CurvedParticle(
                  curve: Interval(
                    Randoms.rnd.nextDouble() * .5 + .5,
                    1.0,
                    curve: Curves.fastOutSlowIn,
                  ),
                  child: ScalingParticle(
                    child: FadingCircle(
                      color: Randoms.rnd.nextDouble() > .5
                          ? Palette.accent
                          : Colors.purpleAccent,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
