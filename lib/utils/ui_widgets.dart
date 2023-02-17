import 'package:flutter/material.dart';

import 'constants.dart';

class MyButton extends StatefulWidget {
  final bool isLoading;
  double? width = double.infinity;
  final String text;
  final Color? lightColor;
  final Color? darkColor;
  Widget? icon;
  final EdgeInsetsGeometry? padding;

  final GestureTapCallback? onTap;
  MyButton(
      {Key? key,
      this.width,
      this.icon,
      required this.text,
      required this.onTap,
      this.padding,
      this.lightColor,
      this.darkColor,
      this.isLoading = false})
      : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double r = width / 400;

    return InkWell(
      onTap: widget.isLoading ? null : widget.onTap,
      child: Center(
        child: AnimatedContainer(
            width: widget.isLoading ? 70 : null,
            // height: widget.isLoading ? 100 : null,
            decoration: BoxDecoration(
              // color: Colors.green,
              gradient: LinearGradient(colors: [
                widget.darkColor ?? Colors.indigo,
                widget.lightColor ?? const Color(0xff00B3EE)
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              borderRadius: BorderRadius.circular(3 * r),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2 * r),
                  color: Colors.blueGrey.shade300.withOpacity(0.5),
                  blurRadius: 3 * r,
                ),
              ],
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            child: SizedBox(
              width: widget.width,
              child: Center(
                child: Padding(
                  padding:
                      widget.padding ?? EdgeInsets.symmetric(vertical: 3.0 * r),
                  // padding: EdgeInsets.zero,
                  child: widget.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.icon != null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: widget.icon,
                                  )
                                : const SizedBox(),
                            Text(widget.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .apply(color: Colors.white)),
                          ],
                        ),
                ),
              ),
            )),
      ),
    );
  }
}

getSearchButton(
    {required String labelText,
    required String hintText,
    required void Function(String) onChanged}) {
  return TextFormField(
    style: TextStyle(color: Colors.white),
    onChanged: (value) {
      onChanged.call(value);
    },
    decoration: InputDecoration(
      isDense: true,
      labelStyle: TextStyle(color: Colors.white),
      hintStyle: const TextStyle(fontSize: 15, color: Colors.white54),
      labelText: labelText,
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.white)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(color: Colors.white),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
  );
}

getInputDecoration(
        {required String labelText,
        required String hintText,
        bool isMaxLines = false}) =>
    InputDecoration(
        isDense: true,
        labelStyle: TextStyle(color: Constants.primaryColor),
        hintStyle: const TextStyle(fontSize: 15),
        labelText: labelText,
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isMaxLines ? 10 : 50),
            borderSide: BorderSide(color: Constants.primaryColor)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMaxLines ? 10 : 50),
        ));
