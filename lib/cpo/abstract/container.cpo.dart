import 'dart:ui';
import 'package:ketchup_ui/ketchup_ui.dart';
import '../../basic.dart';

abstract class ContainerCPO extends ContextPainterObject{
  Size get size;
  Anchor get anchor;
  Anchor get containerAnchor;
  Rect get containerRect;
  
  double get offsetX => containerRect.left + containerAnchor.x * containerRect.width - anchor.x * size.width;
  double get offsetY => containerRect.top + containerAnchor.y * containerRect.height - anchor.y * size.height;
}