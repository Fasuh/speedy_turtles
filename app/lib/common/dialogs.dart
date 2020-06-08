import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ConnectionErrorDialog {
  static Flushbar error(BuildContext context, Error error) {
//    if (error is IncorrectEmailOrPassword)
//      return errorDialog(
//          S.of(context).errorText, S.of(context).incorrectEmailOrPasswordError);
//    else if (error is RegistrationError)
//      return errorDialog(
//          S.of(context).errorText, S.of(context).accountAlreadyExistsError);
//    else if (error is AccountDoesntExist)
//      return errorDialog(
//          S.of(context).errorText, S.of(context).accountDoesntExistError);
//    else if (error is AccountAlreadyExists)
//      return errorDialog(
//          S.of(context).errorText, S.of(context).accountAlreadyExistsError);
//    else if (error is IncorrectFormViolation)
//      return errorDialog(
//          S.of(context).errorText, S.of(context).incorrectFormViolation);
//    else TODO - internationalization
    return errorDialog("An error appeared", "There was an error");
  }
}

Flushbar errorDialog(String title, String messsage, {double maxWidth}) =>
    dialog(Text(title, style: ThemeData.light().textTheme.title),
        Text(messsage, style: ThemeData.light().textTheme.body1),
        maxWidth: maxWidth);

Flushbar dialog(Text title, Text message,
        {Duration duration,
        OnTap onTap,
        double maxWidth,
        Color cardShadow = const Color(0x40707070),
        Color backgroundColor = const Color(0xffF1E8EA),
        double borderRadius = 24.0}) =>
    Flushbar(
      maxWidth: maxWidth,
      titleText: title,
      messageText: message,
      animationDuration: Duration(milliseconds: 500),
      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 24),
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      duration: duration ?? Duration(seconds: 4),
      flushbarPosition: FlushbarPosition.TOP,
      onTap: onTap,
      boxShadows: [
        BoxShadow(
          color: cardShadow,
          blurRadius: 14.0,
        )
      ],
    );
