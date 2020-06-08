import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logic/main.dart';
import 'package:turt/common/colors.dart';
import 'package:turt/common/dialogs.dart';
import 'package:turt/common/dimens.dart';

enum AnyChangeableButtonResult {
  success,
  error
}

class AnyChangeableButton extends StatefulWidget {
  final Widget button;
  final AnyChangeableButtonBloc bloc;
  final Function onTap;
  final Function(AnyChangeableButtonResult) onAnimFinish;
  final Widget progress;
  final Widget error;
  final Widget success;

  const AnyChangeableButton({Key key, @required this.button, @required this.bloc, this.onTap, this.onAnimFinish, this.progress, this.error, this.success}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnyChangeableButtonState();
}

class _AnyChangeableButtonState extends State<AnyChangeableButton> {
  @override
  Widget build(BuildContext context) => BlocListener(
    bloc: widget.bloc,
    listener: (context, state) {
      if (state is ErrorAnyChangeableButtonState) {
        ConnectionErrorDialog.error(context, state.error).show(context);
      }
    },
    child: BlocConsumer(
        bloc: widget.bloc,
        listener: (context, state) {
          if(state is ErrorAnyChangeableButtonState) {
            ConnectionErrorDialog.error(context, state.error).show(context);
          }
        },
        builder: (context, state) {
          return ChangeAbleButton(
            button: widget.button,
            success: widget.success,
            error: widget.error,
            progress: widget.progress,
            onTap: widget.onTap ?? () => widget.bloc.add(ChangeableButtonEvent()),
            onAnimFinish: () {
              widget.bloc.add(ResetChangeableButtonEvent());
              if(widget.onAnimFinish != null) {
                widget.onAnimFinish(getResultForState(state));
              }
            },
            duration: iconAnimation300Duration,
            state: anyChangeableButtonState(state),
          );
        }
    ),
  );

  AnyChangeableButtonResult getResultForState(AnyChangeableButtonState state) {
    if(state is SuccessAnyChangeableButtonState) {
      return AnyChangeableButtonResult.success;
    } else {
      return AnyChangeableButtonResult.error;
    }
  }
}

AnimatedButtonStates anyChangeableButtonState(AnyChangeableButtonState state) {
  if (state is SuccessAnyChangeableButtonState) {
    return AnimatedButtonStates.success;
  } else if (state is InitialAnyChangeableButtonState) {
    return AnimatedButtonStates.button;
  } else if (state is ProgressAnyChangeableButtonState) {
    return AnimatedButtonStates.progress;
  } else if (state is ErrorAnyChangeableButtonState) {
    return AnimatedButtonStates.error;
  } else {
    return AnimatedButtonStates.button;
  }
}


class ChangeAbleButton extends StatefulWidget {
  final Function onTap;
  final Function onAnimFinish;
  final Widget progress;
  final Widget error;
  final Widget success;
  final Widget button;
  final Duration duration;
  final AnimatedButtonStates state;
  final LinearGradient primaryGradient;
  final bool enabled;
  final BoxShadow shadow;
  final Color successfulColor;

  const ChangeAbleButton(
      {Key key,
        @required this.onTap,
        this.progress,
        this.error,
        this.success,
        @required this.button,
        @required this.state,
        this.duration,
        @required this.onAnimFinish,
        this.primaryGradient,
        this.enabled = true,
        this.shadow,
        this.successfulColor})
      : super(key: key);

  @override
  _ChangeAbleButtonState createState() => _ChangeAbleButtonState();

  static Widget defaultButton(String text, {TextStyle style}) {
    return _textWidget(text, style: style);
  }

  static Widget buttonWithIcon(Widget icon, String text, {TextStyle style}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(padding: EdgeInsets.only(right: 6.0), child: icon),
        Container(
            padding: EdgeInsets.only(left: 6.0),
            child: _textWidget(text, style: style))
      ],
    );
  }

  static Widget _textWidget(String text, {TextStyle style}) => Text(
    text,
    style: style ??
        TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}

class _ChangeAbleButtonState extends State<ChangeAbleButton>
    with SingleTickerProviderStateMixin {
  static final maxRadius = 32.0;
  static final buttonHeight = 48.0;
  static final _redColor = Color( 0xffd32f2f );

  Duration _duration;
  Widget _progress;
  Widget _error;
  Widget _success;
  Widget _button;
  AnimatedButtonStates _state;
  AnimationController _animationController;
  LinearGradient _defaultColor;

  Animation _buttonSize;
  Animation _buttonColor1;
  Animation _buttonColor2;
  Animation _textOpacity;
  Animation _progressOpacity;
  Animation _errorIconOpacity;
  Animation _checkIconOpacity;
  double width;
  Tween buttonToCircle;
  Tween buttonToRectangle;
  Tween buttonCircle;
  double measuredButtonWidth;
  AnimationStatusListener _statusListener;
  Color successfulColor;
  GlobalKey _buttonKey = GlobalKey();
  GlobalKey _parentKey = GlobalKey();

  @override
  void initState() {
    _progress = widget.progress ??
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
            ));

    _error = widget.error ??
        Icon(
          Icons.clear,
          color: Colors.white,
        );
    _success = widget.success ??
        Icon(
          Icons.check,
          color: Colors.white,
        );
    successfulColor = widget.successfulColor ?? Color(0xff27ae60);
    _button = widget.button;
    _defaultColor = widget.primaryGradient ??
        LinearGradient(colors: [
          primaryColor,
          primaryColor
        ]);
    _duration = widget.duration ?? Duration(milliseconds: 300);
    prepareAnimationController();
    _statusListener = (status) => onAnimationStatusChange(status);
    _animationController.addStatusListener(_statusListener);
    _state = widget.state;
    changeAnimAndPlay(_state, null);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    final RenderBox parent = _parentKey.currentContext.findRenderObject();
    measuredButtonWidth = parent.size.width;

    buttonToCircle = Tween(begin: measuredButtonWidth, end: buttonHeight);
    buttonToRectangle = Tween(begin: buttonHeight, end: measuredButtonWidth);
    buttonCircle = Tween(begin: buttonHeight, end: buttonHeight);

    _buttonSize = buttonToCircle.animate(_animationController)
      ..addListener(() {
        setState(() {
          width = _buttonSize.value;
        });
      });

    setState(() {
      width = measuredButtonWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _parentKey,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          key: _buttonKey,
          width: width,
          height: buttonHeight,
          child: CustomButton(
            shadow: widget.shadow,
            height: buttonHeight,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            gradient: LinearGradient(colors: [
              _buttonColor1.value,
              _buttonColor2.value,
            ]),
            child: childs(),
            onTap: widget.onTap,
          ),
        ),
      ],
    );
  }

  Widget childs() {
    var progressSize = buttonHeight - 20.0;
    return Stack(
      children: <Widget>[
        Center(
          child: FadeTransition(
            opacity: _textOpacity,
            child: _button,
          ),
        ),
        Center(
            child: FadeTransition(
              opacity: _progressOpacity,
              child: Container(
                  height: buttonHeight,
                  width: buttonHeight,
                  child: Center(
                    child: Container(
                        width: progressSize,
                        height: progressSize,
                        child: _progress),
                  )),
            )),
        Center(
          child: FadeTransition(
            opacity: _errorIconOpacity,
            child: _error,
          ),
        ),
        Center(
          child: FadeTransition(
            opacity: _checkIconOpacity,
            child: _success,
          ),
        )
      ],
    );
  }

  @override
  void didUpdateWidget(ChangeAbleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error != oldWidget.error && widget.error != null) {
      _error = widget.error;
    }
    if (widget.progress != oldWidget.progress && widget.progress != null) {
      _progress = widget.progress;
    }
    if (widget.success != oldWidget.success && widget.success != null) {
      _success = widget.success;
    }
    if (widget.button != oldWidget.button && widget.button != null) {
      _button = widget.button;
    }
    if (widget.duration != oldWidget.duration) _duration = widget.duration;
    if (widget.primaryGradient != oldWidget.primaryGradient) {
      _defaultColor = widget.primaryGradient;
    }
    if (widget.state != oldWidget.state && widget.state != null) {
      print(
          'Anim Button ------ next State is ${widget.state}, old state ${oldWidget.state}');
      var play = changeAnimAndPlay(widget.state, oldWidget.state);
      if (play) _playAnimation();
      _state = widget.state;
    }
  }

  bool changeAnimAndPlay(
      AnimatedButtonStates newState, AnimatedButtonStates oldState) {
    switch (newState) {
      case AnimatedButtonStates.progress:
        if (oldState == null) {
          prepareWaitingToNone();
        } else {
          prepareNoneToWaiting();
        }
        return true;
        break;
      case AnimatedButtonStates.error:
        prepareWaitingToError();
        return true;
        break;
      case AnimatedButtonStates.success:
        prepareWaitingToSuccessful();
        return true;
        break;
      case AnimatedButtonStates.button:
        if (oldState == AnimatedButtonStates.error) {
          prepareErrorToNone();
          return true;
        } else if (oldState == AnimatedButtonStates.success) {
          prepareSuccessfulToNone();
          return true;
        } else {
          prepareNoneToWaiting();
        }
        break;
    }
    return false;
  }

  Future<Null> _playAnimation() async {
    try {
      await _animationController.forward();
    } on TickerCanceled {}
  }

  void onAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_state == AnimatedButtonStates.error ||
          _state == AnimatedButtonStates.success) {
        Future.delayed(Duration(seconds: 1), () => widget.onAnimFinish());
      }
    }
  }

  void prepareNoneToWaiting() {
    _animationController.reset();
    if (buttonToCircle != null) {
      _buttonSize = buttonToCircle.animate(_animationController);
      width = measuredButtonWidth;
    }
    _textOpacity = fadeOutAnimation().animate(_animationController);
    _progressOpacity = fadeInAnimation().animate(_animationController);
    _buttonColor1 = colorDefault1ToDefault1().animate(_animationController);
    _buttonColor2 = colorDefault2ToDefault2().animate(_animationController);
    _errorIconOpacity = hideOpacity().animate(_animationController);
    _checkIconOpacity = hideOpacity().animate(_animationController);
  }

  void prepareWaitingToNone() {
    _animationController.reset();
    if (buttonToCircle != null) {
      _buttonSize = buttonToRectangle.animate(_animationController);
      width = buttonHeight;
    }
    _textOpacity = fadeInAnimation().animate(_animationController);
    _progressOpacity = fadeOutAnimation().animate(_animationController);
    _buttonColor1 = colorDefault1ToDefault1().animate(_animationController);
    _buttonColor2 = colorDefault2ToDefault2().animate(_animationController);
    _errorIconOpacity = hideOpacity().animate(_animationController);
    _checkIconOpacity = hideOpacity().animate(_animationController);
  }

  void prepareWaitingToError() {
    _animationController.reset();
    if (buttonCircle != null) {
      _buttonSize = buttonCircle.animate(_animationController);
      width = buttonHeight;
    }
    _textOpacity = hideOpacity().animate(_animationController);
    _buttonColor1 = colorDefault1ToRed().animate(_animationController);
    _buttonColor2 = colorDefault2ToRed().animate(_animationController);
    _progressOpacity = fadeOutAnimation().animate(_animationController);
    _errorIconOpacity = fadeInAnimation().animate(_animationController);
    _checkIconOpacity = hideOpacity().animate(_animationController);
  }

  void prepareErrorToNone() {
    _animationController.reset();
    if (buttonToRectangle != null) {
      _buttonSize = buttonToRectangle.animate(_animationController);
      width = buttonHeight;
    }
    _textOpacity = fadeInAnimation().animate(_animationController);
    _buttonColor1 = colorRedToDefault1().animate(_animationController);
    _buttonColor2 = colorRedToDefault1().animate(_animationController);
    _progressOpacity = hideOpacity().animate(_animationController);
    _errorIconOpacity = fadeOutAnimation().animate(_animationController);
    _checkIconOpacity = hideOpacity().animate(_animationController);
  }

  void prepareWaitingToSuccessful() {
    _animationController.reset();
    if (buttonCircle != null) {
      _buttonSize = buttonCircle.animate(_animationController);
      width = buttonHeight;
    }
    _textOpacity = hideOpacity().animate(_animationController);
    _buttonColor1 = colorDefault1ToSuccessful().animate(_animationController);
    _buttonColor2 = colorDefault2ToSuccessful().animate(_animationController);
    _progressOpacity = fadeOutAnimation().animate(_animationController);
    _errorIconOpacity = hideOpacity().animate(_animationController);
    _checkIconOpacity = fadeInAnimation().animate(_animationController);
  }

  void prepareSuccessfulToNone() {
    _animationController.reset();
    if (buttonToRectangle != null) {
      _buttonSize = buttonToRectangle.animate(_animationController);
      width = buttonHeight;
    }
    _textOpacity = fadeInAnimation().animate(_animationController);
    _buttonColor1 = colorSuccessfulToDefault1().animate(_animationController);
    _buttonColor2 = colorSuccessfulToDefault2().animate(_animationController);
    _progressOpacity = hideOpacity().animate(_animationController);
    _errorIconOpacity = hideOpacity().animate(_animationController);
    _checkIconOpacity = fadeOutAnimation().animate(_animationController);
  }

  void prepareAnimationController() {
    _animationController = AnimationController(
      duration: _duration,
      vsync: this,
    );
  }

  Tween<double> fadeInAnimation() => Tween(begin: 0.0, end: 1.0);

  Tween<double> fadeOutAnimation() => Tween(begin: 1.0, end: 0.0);

  Tween<double> hideOpacity() => Tween(begin: 0.0, end: 0.0);

  Tween colorDefault1ToRed() =>
      ColorTween(begin: _defaultColor.colors[0], end: _redColor);

  Tween colorDefault2ToRed() =>
      ColorTween(begin: _defaultColor.colors[1], end: _redColor);

  Tween colorRedToDefault1() =>
      ColorTween(begin: _redColor, end: _defaultColor.colors[0]);

  Tween colorRedToDefault2() =>
      ColorTween(begin: _redColor, end: _defaultColor.colors[1]);

  Tween colorDefault1ToSuccessful() =>
      ColorTween(begin: _defaultColor.colors[0], end: successfulColor);

  Tween colorDefault2ToSuccessful() =>
      ColorTween(begin: _defaultColor.colors[1], end: successfulColor);

  Tween colorSuccessfulToDefault1() =>
      ColorTween(begin: successfulColor, end: _defaultColor.colors[0]);

  Tween colorSuccessfulToDefault2() =>
      ColorTween(begin: successfulColor, end: _defaultColor.colors[1]);

  Tween colorDefault1ToDefault1() => ConstantTween(_defaultColor.colors[0]);

  Tween colorDefault2ToDefault2() => ConstantTween(_defaultColor.colors[1]);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

enum AnimatedButtonStates { progress, error, success, button }

class CustomButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final Color backgroundColor;
  final Function onTap;
  final String text;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double height;
  final BoxShadow shadow;

  const CustomButton({
    Key key,
    this.child,
    this.gradient,
    @required this.onTap,
    this.text,
    this.padding,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BoxShadow> sha = shadow != null ? [shadow] : [
      BoxShadow(
          color: Theme.of(context).disabledColor,
          blurRadius: 0.0,
          spreadRadius: 0.0
      )
    ];
    BoxDecoration decoration;
    if (backgroundColor != null) {
      decoration = BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          boxShadow: sha,
          color: backgroundColor);
    } else {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        gradient:
        onTap != null ? gradient ?? LinearGradient(colors: [Theme.of(context).primaryColor]) : LinearGradient(colors: [Theme.of(context).disabledColor]),
        boxShadow: sha,
      );
    }
    return Container(
      height: height ?? 52.0,
      decoration: decoration,
      child: Material(
        shadowColor: Theme.of(context).disabledColor,
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
            onTap: onTap,
            child: Container(
              padding: padding ??
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              child: Center(
                child: child ??
                    Text(
                      text ?? "Put name here",
                      style: textStyle ??
                          TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal),
                    ),
              ),
            )),
      ),
    );
  }
}
