import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() => runApp(PSETester());

class PSETester extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        theme:
            ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
        home: FlightStepper()));
  }
}

class FlightStepper extends StatefulWidget {
  @override
  _FlightStepperState createState() => _FlightStepperState();
}

class _FlightStepperState extends State<FlightStepper> {
  int pageNumber = 1;

  @override
  Widget build(BuildContext context) {
    Widget page = pageNumber == 1
        ? Page(
            key: Key('page1'),
            onOptionSelected: () => setState(() => pageNumber = 2),
            question: 'What do you do for fun?',
            answers: <String>['Run', 'Walk', 'Eat', 'Talk'],
            number: 1)
        : Page(
            key: Key('page2'),
            onOptionSelected: () => setState(() => pageNumber = 1),
            question: 'What is your favorite time of the year?',
            answers: <String>['Summer', 'Christmas', 'Valentines', 'Easter'],
            number: 2);

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: backgroundDecoration,
      child: SafeArea(
        child: Stack(
          children: [
            ArrowIcons(),
            Plane(),
            Line(),
            Positioned.fill(
                left: 32.0 + 8.0,
                child: AnimatedSwitcher(
                  child: page,
                  duration: Duration(milliseconds: 250),
                ))
          ],
        ),
      ),
    ));
  }
}

class ArrowIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 8,
        bottom: 0,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          IconButton(icon: Icon(Icons.arrow_upward), onPressed: () => {}),
          Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                  color: Color.fromRGBO(120, 58, 183, 1),
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () => {})),
        ]));
  }
}

class Plane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 32.0 + 8,
        top: 32,
        child: RotatedBox(
            quarterTurns: 2, child: Icon(Icons.airplanemode_active, size: 64)));
  }
}

const backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(colors: [
  Color.fromRGBO(76, 61, 243, 1),
  Color.fromRGBO(120, 58, 183, 0.8)
], begin: Alignment.topCenter, end: Alignment.bottomCenter));

class Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 40.0 + 32,
        top: 40,
        bottom: 0,
        width: 1,
        child: Container(color: Colors.white.withOpacity(0.5)));
  }
}

class Page extends StatefulWidget {
  final int number;
  final String question;
  final List<String> answers;
  final VoidCallback onOptionSelected;

  const Page(
      {Key key,
      @required this.onOptionSelected,
      @required this.number,
      @required this.question,
      @required this.answers})
      : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> with SingleTickerProviderStateMixin {
  List<GlobalKey<_ItemFaderState>> keys;
  int selectedOptionKeyIndex;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    keys = List.generate(
      2 + widget.answers.length,
      (_) => GlobalKey<_ItemFaderState>(),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    onInit();
  }

  Future<void> animateDot(Offset startOffset) async {
    OverlayEntry entry = OverlayEntry(builder: (context) {
      double minTop = MediaQuery.of(context).padding.top + 52;
      return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Positioned(
              left: 26.0 + 32 + 8,
              top: minTop +
                  (startOffset.dy - minTop) * (1 - _animationController.value),
              child: child,
            );
          },
          child: Dot());
    });
    Overlay.of(context).insert(entry);
    await _animationController.forward(from: 0);
    entry.remove();
  }

  void onInit() async {
    for (GlobalKey<_ItemFaderState> key in keys) {
      await Future.delayed(Duration(milliseconds: 40));
      key.currentState.show();
    }
  }

  void onTap(int keyIndex, Offset offset) async {
    for (GlobalKey<_ItemFaderState> key in keys) {
      await Future.delayed(Duration(milliseconds: 40));
      key.currentState.hide();
      if (keys.indexOf(key) == keyIndex) {
        setState(() => selectedOptionKeyIndex = keyIndex);
        animateDot(offset).then((_) => widget.onOptionSelected());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 32),
          ItemFader(key: keys[0], child: StepNumber(number: widget.number)),
          ItemFader(
              key: keys[1], child: StepQuestion(question: widget.question)),
          Spacer(),
          ...widget.answers.map((String answer) {
            int answerIndex = widget.answers.indexOf(answer);
            int keyIndex = answerIndex + 2;
            return (ItemFader(
                key: keys[keyIndex],
                child: OptionItem(
                  name: answer,
                  onTap: (offset) => onTap(keyIndex, offset),
                  showDot: selectedOptionKeyIndex != keyIndex,
                )));
          }),
          SizedBox(height: 64)
        ]);
  }
}

class ItemFader extends StatefulWidget {
  final Widget child;
  const ItemFader({Key key, @required this.child}) : super(key: key);
  @override
  _ItemFaderState createState() => _ItemFaderState();
}

class _ItemFaderState extends State<ItemFader>
    with SingleTickerProviderStateMixin {
  // 1 means below and -1 means it is above
  int position = 1;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void show() {
    setState(() => position = 1);
    _animationController.forward();
  }

  void hide() {
    setState(() => position = -1);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        child: widget.child,
        builder: (context, child) {
          return (Transform.translate(
              offset: Offset(0, 64 * position * (1 - _animation.value)),
              child: Opacity(opacity: _animation.value, child: child)));
        });
  }
}

class OptionItem extends StatefulWidget {
  final String name;
  final void Function(Offset dotOffset) onTap;
  final bool showDot;

  const OptionItem(
      {Key key, @required this.name, @required this.onTap, this.showDot = true})
      : super(key: key);

  @override
  _OptionItemState createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          RenderBox object = context.findRenderObject();
          Offset globalPosition = object.localToGlobal(Offset.zero);
          widget.onTap(globalPosition);
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(children: <Widget>[
              SizedBox(width: 26),
              Dot(visible: widget.showDot),
              SizedBox(width: 26),
              Expanded(
                  child: Text(widget.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26)))
            ])));
  }
}

class Dot extends StatelessWidget {
  final bool visible;

  const Dot({Key key, this.visible = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: visible ? Colors.white : Colors.transparent));
  }
}

class StepNumber extends StatelessWidget {
  final int number;

  const StepNumber({Key key, @required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 64, right: 16),
        child: Text('0$number',
            style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.5))));
  }
}

class StepQuestion extends StatelessWidget {
  final String question;

  const StepQuestion({Key key, @required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 64, right: 16),
        child: Text(
          question,
          style: TextStyle(fontSize: 24),
        ));
  }
}

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
