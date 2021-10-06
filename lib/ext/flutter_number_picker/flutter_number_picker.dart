/*
https://github.com/phuongtinhbien/flutter_number_picker v1.0.1

Modified to add:
- Use decimal instead of num (fix floating point precision issue)
- Customized add/subtract speed
- Fix long press adding/subtracting once more than expected
- Conditionally grey out min/max buttons if min/max reached
*/

import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDecimalNumberPicker extends StatefulWidget {
  final ShapeBorder? shape;
  final TextStyle? valueTextStyle;
  final Function(Decimal) onValue;
  final Widget? customAddButton;
  final Widget? customMinusButton;
  final Decimal maxValue;
  final Decimal minValue;
  final Decimal initialValue;
  final Decimal step;
  final int? roundingPlaces;
  final int? incrementSpeedMilliseconds;

  ///default vale true
  final bool enable;

  CustomDecimalNumberPicker(
      {Key? key,
      this.shape,
      this.valueTextStyle,
      required this.onValue,
      required this.initialValue,
      required this.maxValue,
      required this.minValue,
      required this.step,
      this.roundingPlaces,
      this.customAddButton,
      this.customMinusButton,
      this.incrementSpeedMilliseconds,
      this.enable = true})
      : assert(initialValue.runtimeType != String),
        assert(maxValue.runtimeType == initialValue.runtimeType),
        assert(minValue.runtimeType == initialValue.runtimeType),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomDecimalNumberPickerState();
  }
}

class CustomDecimalNumberPickerState extends State<CustomDecimalNumberPicker> {
  late Decimal _initialValue;
  late Decimal _maxValue;
  late Decimal _minValue;
  late Decimal _step;
  late int? _roundingPlaces;
  late int? _incrementSpeedMilliseconds;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = widget.initialValue;
    _maxValue = widget.maxValue;
    _minValue = widget.minValue;
    _step = widget.step;

    _roundingPlaces = widget.roundingPlaces;
    _incrementSpeedMilliseconds = widget.incrementSpeedMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return IgnorePointer(
      ignoring: !widget.enable,
      child: Card(
        shadowColor: Colors.transparent,
        elevation: 0.0,
        semanticContainer: true,
        color: Colors.transparent,
        shape: widget.shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0)), side: BorderSide(width: 1.0, color: Color(0xffF0F0F0))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              onTap: () => minus(false),
              onLongPress: () => onLongPress(DoAction.MINUS),
              onLongPressUp: () => _timer?.cancel(),
              onTapCancel: () => _timer?.cancel(),
              child: widget.customMinusButton ??
                  Padding(
                    padding: EdgeInsets.only(left: 6, right: 6, bottom: 6, top: 6),
                    child: SvgPicture.asset(
                      "packages/snacktrack/ext/flutter_number_picker/images/ic_minus.svg",
                      height: 15,
                      color: _initialValue == _minValue ? Colors.grey[500] : Colors.black,
                    ),
                  ),
            ),
            Container(
              width: _textSize(widget.valueTextStyle ?? TextStyle(fontSize: 14)).width,
              child: Text(
                _initialValue.toStringAsFixed(_roundingPlaces ?? 2),
                style: widget.valueTextStyle ?? TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () => add(false),
              onLongPress: () => onLongPress(DoAction.ADD),
              onLongPressUp: () => _timer?.cancel(),
              onTapCancel: () => _timer?.cancel(),
              child: widget.customAddButton ??
                  Padding(
                    padding: EdgeInsets.only(left: 6, right: 6, bottom: 6, top: 6),
                    child: SvgPicture.asset(
                      "packages/snacktrack/ext/flutter_number_picker/images/ic_add.svg",
                      height: 15,
                      color: _initialValue == _maxValue ? Colors.grey[500] : Colors.black,
                    ),
                  ),
            )
          ],
        ),
      ),
    );
  }

  Size _textSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(
      //text: TextSpan(text: _maxValue.toString(), style: style),
      text: TextSpan(text: "xxx.x", style: style), // Hardcode length due to Decimal limitations
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        //maxWidth: _maxValue.toString().length * style.fontSize!,
        maxWidth: "xxx.x".length * style.fontSize! // Hardcode length due to Decimal limitations
        );
    return textPainter.size;
  }

  void minus(bool timerMustBeActive) {
    if (canDoAction(DoAction.MINUS) && (!timerMustBeActive || _timer?.isActive == true)) {
      setState(() {
        _initialValue -= _step;
      });
    }
    widget.onValue(_initialValue);
  }

  void add(bool timerMustBeActive) {
    if (canDoAction(DoAction.ADD) && (!timerMustBeActive || _timer?.isActive == true)) {
      setState(() {
        _initialValue += _step;
      });
    }
    widget.onValue(_initialValue);
  }

  void onLongPress(DoAction action) {
    var timer = Timer.periodic(Duration(milliseconds: _incrementSpeedMilliseconds ?? 300), (t) {
      action == DoAction.MINUS ? minus(true) : add(true);
    });
    setState(() {
      _timer = timer;
    });
  }

  bool canDoAction(DoAction action) {
    if (action == DoAction.MINUS) {
      return _initialValue - _step >= _minValue;
    }
    if (action == DoAction.ADD) {
      return _initialValue + _step <= _maxValue;
    }
    return false;
  }
}

enum DoAction { MINUS, ADD }
