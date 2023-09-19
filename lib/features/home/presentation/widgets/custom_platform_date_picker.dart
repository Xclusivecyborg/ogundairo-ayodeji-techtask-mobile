import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_task/core/utils/extensions.dart';

class CustomPlatformDatePicker extends StatefulWidget {
  const CustomPlatformDatePicker({
    super.key,
    required this.onDateChanged,
  });
  final DateChanged onDateChanged;

  @override
  State<CustomPlatformDatePicker> createState() =>
      _CustomPlatformDatePickerState();
}

class _CustomPlatformDatePickerState extends State<CustomPlatformDatePicker> {
  bool isPickingDate = false;
  DateTime initialDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (Platform.isAndroid) {
          showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1960),
            lastDate: DateTime.now(),
          ).then((value) {
            if (value != null) initialDate = value;
            widget.onDateChanged(initialDate);
            setState(() {});
          });
          return;
        }
        setState(() {
          isPickingDate = !isPickingDate;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Lunch Date',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.black54),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        initialDate.formattedDate,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) {
                      return RotationTransition(
                        turns: child.key == const ValueKey('icon1')
                            ? Tween<double>(begin: 0.4, end: 1).animate(anim)
                            : Tween<double>(begin: 1, end: 0.25).animate(anim),
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.keyboard_arrow_up_outlined,
                      key: switch (isPickingDate) {
                        true => ValueKey('icon1'),
                        false => ValueKey('icon2'),
                      },
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            if (Platform.isIOS)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) {
                  return ScaleTransition(
                    scale: anim,
                    child: SizeTransition(
                      sizeFactor: anim,
                      child: child,
                    ),
                  );
                },
                child: switch (isPickingDate) {
                  true => SizedBox(
                      key: ValueKey('date'),
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      height: 250,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: initialDate,
                        onDateTimeChanged: (DateTime newDateTime) {
                          initialDate = newDateTime;
                          widget.onDateChanged(initialDate);
                          setState(() {});
                        },
                      ),
                    ),
                  _ => const SizedBox(),
                },
              )
          ],
        ),
      ),
    );
  }
}

typedef DateChanged = void Function(DateTime date);
