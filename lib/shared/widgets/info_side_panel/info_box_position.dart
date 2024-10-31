import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';

enum InfoBoxPosition {
  top,
  bottom,
  middle,
  isSingleItem;

  ShapeBorder get shape => RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: this == InfoBoxPosition.top ||
                  this == InfoBoxPosition.isSingleItem
              ? Radii.small
              : Radii.extraSmall,
          bottom: this == InfoBoxPosition.bottom ||
                  this == InfoBoxPosition.isSingleItem
              ? Radii.small
              : Radii.extraSmall,
        ),
      );
}
