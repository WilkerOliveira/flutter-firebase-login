import 'package:flutter/material.dart';
import 'package:summarizeddebts/ui/resources/app_color.dart';

enum DialogType { success, error, info, warning, question }

class CustomDialog extends StatelessWidget {
  static const double padding = 16.0;
  static const double avatarRadius = 36.0;
  static const double iconSize = 32.0;

  final String title, description, buttonText, buttonQuestionText;
  final Image image;
  final Color color;
  final DialogType dialogType;
  final Function onYesButtonPressed;
  final Function onNoButtonPressed;

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.buttonText,
      this.image,
      @required this.color,
      @required this.dialogType,
      this.buttonQuestionText,
      this.onYesButtonPressed,
      this.onNoButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    Icon imageType;

    switch (this.dialogType) {
      case DialogType.success:
        imageType = Icon(
          Icons.check,
          color: Colors.white,
          size: iconSize,
        );
        break;
      case DialogType.error:
        imageType = Icon(
          Icons.close,
          color: Colors.white,
          size: iconSize,
        );
        break;
      case DialogType.info:
        imageType = Icon(
          Icons.info,
          color: Colors.white,
          size: iconSize,
        );
        break;
      case DialogType.warning:
        imageType = Icon(
          Icons.warning,
          color: Colors.white,
          size: iconSize,
        );
        break;
      case DialogType.question:
        imageType = Icon(
          Icons.help,
          color: Colors.white,
          size: iconSize,
        );
        break;
    }

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: avatarRadius + padding,
            bottom: padding,
            left: padding,
            right: padding,
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: new BoxDecoration(
            color: AppColor.topHead,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  this.dialogType == DialogType.question
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: RaisedButton(
                            color: AppColor.buttonPopupColor,
                            onPressed: () {
                              this.onYesButtonPressed();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              buttonQuestionText.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      color: AppColor.buttonPopupColor,
                      onPressed: () {
                        if (this.onNoButtonPressed != null) {
                          this.onNoButtonPressed();
                        }
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            child: imageType,
            backgroundColor: this.color,
            radius: avatarRadius,
          ),
        ),
      ],
    );
  }
}
