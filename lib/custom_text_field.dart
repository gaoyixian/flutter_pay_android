import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.scrollController,
    this.keyboardAppearance,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.scrollPhysics,
    this.selectionControls,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.cursorHeight,
    this.cursorColor,
    this.style,
    this.enableInteractiveSelection,
    this.onTap,
    this.decoration,
    this.onEditingComplete,
    this.onAppPrivateCommand,
    this.onSubmitted,
    this.onChanged,
    this.inputFormatters,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.textAlignVertical,
    this.obscuringCharacter = '•',
    this.obscureText = false,
  }) : super(key: key);
  final bool autofocus;
  final TextAlign textAlign;
  final ScrollController? scrollController;
  final Brightness? keyboardAppearance;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ScrollPhysics? scrollPhysics;
  final TextSelectionControls? selectionControls;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final double? cursorHeight;
  final Color? cursorColor;
  final TextStyle? style;
  final bool? enableInteractiveSelection;
  final GestureTapCallback? onTap;
  final InputDecoration? decoration;
  final VoidCallback? onEditingComplete;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets scrollPadding;
  final TextAlignVertical? textAlignVertical;
  final bool obscureText;
  final String obscuringCharacter;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.autofocus,
      textAlign: widget.textAlign,
      controller: widget.controller,
      keyboardAppearance: widget.keyboardAppearance,
      focusNode: widget.focusNode,
      scrollController: widget.scrollController,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      scrollPhysics: widget.scrollPhysics,
      selectionControls: widget.selectionControls,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      minLines: widget.minLines,
      cursorHeight: setCursorHeight(),
      cursorColor: widget.cursorColor,
      style: widget.style,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      onTap: widget.onTap,
      decoration: widget.decoration,
      onEditingComplete: widget.onEditingComplete,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      scrollPadding: widget.scrollPadding,
      textAlignVertical: widget.textAlignVertical,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
    );
  }

  double? setCursorHeight() {
    if (widget.cursorHeight != null) {
      return widget.cursorHeight;
    }
    if (UniversalPlatform.isIOS) {
      if (widget.style != null && widget.style!.fontSize != null) {
        return widget.style!.fontSize!;
      }
    }
    return null;
  }
}
