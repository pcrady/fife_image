import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownFormMenu<T> extends StatelessWidget {
  final double? width;
  final String hintText;
  final TextEditingController controller;
  final List<DropdownMenuEntry<T>> entries;
  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;
  final T? value;

  const DropdownFormMenu({
    this.width,
    required this.hintText,
    required this.controller,
    required this.entries,
    this.onSaved,
    this.value,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: onSaved,
      validator: validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu<T>(
              width: width,
              hintText: hintText,
              controller: controller,
              dropdownMenuEntries: entries,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: state.hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: state.hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: state.hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).inputDecorationTheme.focusColor ?? Colors.blue,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
            state.hasError
                ? Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      state.errorText ?? '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12.0,
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
