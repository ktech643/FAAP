import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class PrimaryInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final String? labelText;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? focusBorderColor;
  final Color? enabledBorderColor;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool filled;
  final Color? fillColor;
  final VoidCallback? onPrefixIconTap;
  final VoidCallback? onSuffixIconTap;
  final bool? ReadOnly;
  final String? Function(String?)? validator;
  // new: optional focus node for this field
  final FocusNode? focusNode;
  // new: optional focus node to move focus to when 'next' is requested
  final FocusNode? nextFocusNode;
  // new: when true -> 'next', when false -> 'done', when null -> no automatic action
  final bool? nextOrDone;
  // new: optional callback for when the field is submitted
  final ValueChanged<String>? onFieldSubmitted;

  const PrimaryInputField({
    this.controller,
    this.hintText,
    this.initialValue,
    this.labelText,
    this.labelStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.focusBorderColor,
    this.enabledBorderColor,
    this.keyboardType,
    this.isPassword = false,
    this.filled = false,
    this.fillColor,
    this.onPrefixIconTap,
    this.onSuffixIconTap,
    this.ReadOnly,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
    this.nextOrDone,
    this.onFieldSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  _PrimaryInputFieldState createState() => _PrimaryInputFieldState();
}

class _PrimaryInputFieldState extends State<PrimaryInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon == null) return null;
    if (widget.isPassword && widget.onPrefixIconTap == null) {
      return GestureDetector(
        onTap: _toggleObscureText,
        child: widget.prefixIcon,
      );
    }
    if (widget.onPrefixIconTap != null) {
      return GestureDetector(
        onTap: widget.onPrefixIconTap,
        child: widget.prefixIcon,
      );
    }
    return widget.prefixIcon;
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon == null) return null;
    if (widget.isPassword && widget.onSuffixIconTap == null) {
      return GestureDetector(
        onTap: _toggleObscureText,
        child: widget.suffixIcon,
      );
    }
    if (widget.onSuffixIconTap != null) {
      return GestureDetector(
        onTap: widget.onSuffixIconTap,
        child: widget.suffixIcon,
      );
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator,
      readOnly: widget.ReadOnly ?? false,
      focusNode: widget.focusNode,
      textInputAction:
          widget.nextOrDone == null
              ? null
              : (widget.nextOrDone!
                  ? TextInputAction.next
                  : TextInputAction.done),
      onFieldSubmitted: (value) {
        // preserve existing automatic next/done behavior
        if (widget.nextOrDone != null) {
          if (widget.nextOrDone == true) {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            } else {
              FocusScope.of(context).nextFocus();
            }
          } else {
            FocusScope.of(context).unfocus();
          }
        }
        // call user-provided callback if any
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(value);
        }
      },
      decoration: InputDecoration(
        filled: widget.ReadOnly ?? false ? true : widget.filled,
        fillColor:
            widget.ReadOnly ?? false ? Colors.grey[200] : widget.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color:
                widget.ReadOnly ?? false
                    ? Colors.grey[400]!
                    : (widget.enabledBorderColor ?? const Color(0xFFe2e8f0)),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color:
                widget.ReadOnly ?? false
                    ? Colors.grey[400]!
                    : (widget.enabledBorderColor ?? const Color(0xFFe2e8f0)),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color:
                widget.ReadOnly ?? false
                    ? Colors.grey[400]!
                    : (widget.focusBorderColor ?? AppColors.primary),
          ),
        ),
        labelText: widget.labelText,
        labelStyle:
            widget.ReadOnly ?? false
                ? TextStyle(color: Colors.grey[600])
                : widget.labelStyle,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color:
              widget.ReadOnly ?? false
                  ? Colors.grey[600]
                  : const Color(0xFF64748b),
        ),
        prefixIcon: _buildPrefixIcon(),
        suffixIcon: _buildSuffixIcon(),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      ),
      style: TextStyle(
        color:
            widget.ReadOnly ?? false
                ? Colors.grey[600]
                : const Color(0xFF0f172a),
      ),
    );
  }
}

class UniversalInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final String? labelText;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? focusBorderColor;
  final Color? enabledBorderColor;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool isPassword;
  final bool filled;
  final Color? fillColor;
  final VoidCallback? onPrefixIconTap;
  final VoidCallback? onSuffixIconTap;
  final String? Function(String?)? validator;
  // new focus handling props
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  // new: optional callback for when the field is submitted
  final ValueChanged<String>? onFieldSubmitted;

  const UniversalInputField({
    this.controller,
    this.hintText,
    this.initialValue,
    this.labelText,
    this.labelStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.focusBorderColor,
    this.enabledBorderColor,
    this.keyboardType,
    this.maxLines,
    this.isPassword = false,
    this.filled = false,
    this.fillColor,
    this.onPrefixIconTap,
    this.onSuffixIconTap,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  _UniversalInputFieldState createState() => _UniversalInputFieldState();
}

class _UniversalInputFieldState extends State<UniversalInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon == null) return null;
    if (widget.isPassword && widget.onPrefixIconTap == null) {
      return GestureDetector(
        onTap: _toggleObscureText,
        child: widget.prefixIcon,
      );
    }
    if (widget.onPrefixIconTap != null) {
      return GestureDetector(
        onTap: widget.onPrefixIconTap,
        child: widget.prefixIcon,
      );
    }
    return widget.prefixIcon;
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon == null) return null;
    if (widget.isPassword && widget.onSuffixIconTap == null) {
      return GestureDetector(
        onTap: _toggleObscureText,
        child: widget.suffixIcon,
      );
    }
    if (widget.onSuffixIconTap != null) {
      return GestureDetector(
        onTap: widget.onSuffixIconTap,
        child: widget.suffixIcon,
      );
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      obscureText: _obscureText,
      validator: widget.validator,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (value) {
        // preserve automatic next/done behavior based on textInputAction
        if (widget.textInputAction == TextInputAction.next) {
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          } else {
            FocusScope.of(context).nextFocus();
          }
        } else if (widget.textInputAction == TextInputAction.done) {
          FocusScope.of(context).unfocus();
        }
        // call user-provided callback if any
        if (widget.onFieldSubmitted != null) widget.onFieldSubmitted!(value);
      },
      decoration: InputDecoration(
        filled: widget.filled,
        fillColor: widget.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: widget.enabledBorderColor ?? const Color(0xFFe2e8f0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: widget.enabledBorderColor ?? const Color(0xFFe2e8f0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: widget.focusBorderColor ?? AppColors.primary,
          ),
        ),
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color(0xFF64748b)),
        prefixIcon: _buildPrefixIcon(),
        suffixIcon: _buildSuffixIcon(),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      ),
      style: const TextStyle(color: Color(0xFF0f172a)),
    );
  }
}
