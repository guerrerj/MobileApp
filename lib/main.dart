import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() => runApp(PSETester());

class PSETester extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Virtual Study Groups",
        home: Scaffold(
            appBar: AppBar(title: Text("Virtual Study Groups")),
            body: CardWidget(
              child: FlutterLogo(size: 128),
            )));
  }
}


/*
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message "),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text)))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextComposer();
  }
}

class CardWidget extends StatefulWidget {
  final Widget child;
  CardWidget({this.child});

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<CardWidget> with SingleTickerProviderStateMixin {
  // Setup animation controller to animate alignment
  // of card when dragged away from the center
  AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment> _animation;

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller
        .drive(AlignmentTween(begin: _dragAlignment, end: Alignment.center));

    // Calculate the velocity
    // final doesnt change but is assigned at runtime
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(mass: 30, stiffness: 1, damping: 1);
    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
    _controller
        .addListener(() => setState(() => {_dragAlignment = _animation.value}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) => {_controller.stop()},
      onPanUpdate: (details) => {
        setState(() {
          _dragAlignment += Alignment(details.delta.dx / (size.width / 2),
              details.delta.dy / (size.height / 2));
        })
      },
      onPanEnd: (details) =>
          {_runAnimation(details.velocity.pixelsPerSecond, size)},
      child: Align(
        alignment: _dragAlignment,
        child: Card(child: widget.child),
      ),
    );
  }
}
*/
/*
class Align extends StatelessWidget {
  const Align({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final CardWidget widget;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Card(
        child: widget.child,
      )
    );
  }
}*/
//Flare , adaptive setting for widgets, get_it, provider
// widgets- wrap direction axis.vertical, safearea, RichText add TextSpan with style and children
// with other TextSpan with style, wrap image with ClipRRect give container clips
// border radius, media query of context to get size brightness , futurebuilder takes a future and
// snapshot in builder can return progress indicator or
// flexible - give first widget as flex 1 and takes all the flexes remove heights
// sizedbox - give a perfect width and height can give double.infinity expanded
// align property - aligment.bottomright
//animationcontroller transform and stack
// start with sketch - google
// play around colors and features
// design parts in rive using flat shapes
// rigging - think before start rigging
// front image moves a little more than back parallax - 3d effect
// using flareactor
// use provider - disposables provider has dispose callback
// use changenotifierprovider
// use multiprovider - listen to parrts
//

// flutter run -d chrome --web-port=8080 --web-hostname=127.0.0.1
