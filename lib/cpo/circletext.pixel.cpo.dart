import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'abstract/text.pixel.cpo.dart';

mixin CircleTextPixelPainter on TextPixel{

  double get radiusRatio;
  
  @override
  void paintPixel(String instructStr, int xIndex, int yIndex, Canvas ctxCanvas, Rect paintRect) {
    var drawRect = Rect.fromCenter(center: paintRect.center, width: paintRect.width * radiusRatio, height: paintRect.height * radiusRatio);
    var pixelXIndex = xIndex;
    var pixelYIndex = yIndex;
    var paintFill = Paint()..color = (color ?? Colors.white) ..style = PaintingStyle.fill;
    var paintStroke = Paint()..color = (color ?? Colors.white) ..style = PaintingStyle.stroke;
    if(instructStr == ' ' && drawBlank){
      ctxCanvas.drawRect(drawRect, paintStroke);
    }else 
    if(instructStr != ' '){
      // Rect viceRect = Rect.fromCircle(center: viceCenter, radius: viceRadius);
      
      // if(!isBlank(x+1, y) && !isBlank(x, y+1)){
      //   ctxCanvas.drawCircle(viceCenter, viceRadius, vicePaint);
      // }
      /// 45度边缘模式
      if(instructStr == 'U' && isBlank(pixelXIndex-1, pixelYIndex) && isBlank(pixelXIndex, pixelYIndex-1) ||
        instructStr == 'O' && !isBlank(pixelXIndex+1, pixelYIndex) && !isBlank(pixelXIndex, pixelYIndex+1)){
        ctxCanvas.drawArc(drawRect, pi * 3 / 4,  - pi, true, paintFill);
      } else
      if(instructStr == 'U' && isBlank(pixelXIndex-1, pixelYIndex) && !isBlank(pixelXIndex, pixelYIndex-1) ||
        instructStr == 'O' && !isBlank(pixelXIndex+1, pixelYIndex) && isBlank(pixelXIndex, pixelYIndex+1)){
        ctxCanvas.drawArc(drawRect, pi / 4, - pi, true, paintFill);
      } else
      if(instructStr == 'U' && !isBlank(pixelXIndex-1, pixelYIndex) && !isBlank(pixelXIndex, pixelYIndex-1) ||
        instructStr == 'O' && isBlank(pixelXIndex+1, pixelYIndex) && isBlank(pixelXIndex, pixelYIndex+1)){
        ctxCanvas.drawArc(drawRect, pi * 3 / 4, pi, true, paintFill);
      } else
      if(instructStr == 'U' && !isBlank(pixelXIndex-1, pixelYIndex) && isBlank(pixelXIndex, pixelYIndex-1) ||
        instructStr == 'O' && isBlank(pixelXIndex+1, pixelYIndex) && !isBlank(pixelXIndex, pixelYIndex+1)){
        ctxCanvas.drawArc(drawRect, pi / 4,  pi, true, paintFill);
      } else
      /// 60度边缘模式
      if(instructStr == 'V' && isBlank(pixelXIndex-1, pixelYIndex) && isBlank(pixelXIndex, pixelYIndex-1) ||
        instructStr == 'A' && !isBlank(pixelXIndex+1, pixelYIndex) && !isBlank(pixelXIndex, pixelYIndex+1)){
        ctxCanvas.drawArc(drawRect, pi * 2 / 3,  - pi, true, paintFill);
      } else
      if(instructStr == 'V' && isBlank(pixelXIndex-1, pixelYIndex) && !isBlank(pixelXIndex, pixelYIndex-1) ||
        instructStr == 'A' && !isBlank(pixelXIndex+1, pixelYIndex) && isBlank(pixelXIndex, pixelYIndex+1)){
        ctxCanvas.drawArc(drawRect, pi / 3, - pi, true, paintFill);
      } else
      if(instructStr == 'V' && !isBlank(pixelXIndex-1, pixelYIndex) && !isBlank(pixelXIndex, pixelYIndex-1) ||
        instructStr == 'A' && isBlank(pixelXIndex+1, pixelYIndex) && isBlank(pixelXIndex, pixelYIndex+1)){
        ctxCanvas.drawArc(drawRect, pi * 2 / 3, pi, true, paintFill);
      } else
      if(instructStr == 'V' && !isBlank(pixelXIndex-1, pixelYIndex) && isBlank(pixelXIndex, pixelYIndex-1) ||
        instructStr == 'A' && isBlank(pixelXIndex+1, pixelYIndex) && !isBlank(pixelXIndex, pixelYIndex+1)){
        ctxCanvas.drawArc(drawRect, pi / 3,  pi, true, paintFill);
      } else{
        switch(instructStr){
          /// 右边缘
          case 'R':
            ctxCanvas.drawArc(drawRect, pi / 2,  pi, true, paintFill);
            break;
          /// 左边缘
          case 'L':
            ctxCanvas.drawArc(drawRect, pi * 3 / 2,  pi, true, paintFill);
            break;
          /// 下边缘
          case 'B':
            ctxCanvas.drawArc(drawRect, pi,  pi, true, paintFill);
            break;
          /// 上边缘
          case 'T':
            ctxCanvas.drawArc(drawRect, 0,  pi, true, paintFill);
            break;
          default: 
            isPixelScaled ? ctxCanvas.drawOval(drawRect, paintFill) : ctxCanvas.drawCircle(drawRect.center, drawRect.width / 2, paintFill);
        }
      }
    }
  }

  bool isBlank(int x, int y){
    if(x <0 || y<0 || y >= pixel.data.length || x>= pixel.data[y].length )return true;
    return pixel.data[y][x] == ' ';
  }
  
} 

class CircleTextPixel extends TextPixel with CircleTextPixelPainter{

  @override
  final double radiusRatio;

  CircleTextPixel(super.lnString, 
    {super.pixelSize, 
    super.lineHeight,
    super.scaledPixelSize,
    this.radiusRatio = 3 / 4, 
    super.ctxAccessor, 
    super.alignment, 
    super.textAlign, 
    super.anchor, 
    super.bgColor, 
    super.color, 
    super.paintRect, 
    super.paintRectAnchor});
}

class CircleWWTextPixel extends WordWrapTextPixel with CircleTextPixelPainter{

  @override
  final double radiusRatio;
  
  CircleWWTextPixel(super.lnString, 
    {required super.columnConstraints, 
    super.pixelSize, 
    super.lineHeight,
    super.scaledPixelSize,
    this.radiusRatio = 3 / 4,
    super.ctxAccessor, 
    super.alignment, 
    super.textAlign,
    super.anchor, 
    super.bgColor, 
    super.color, 
    super.paintRect, 
    super.paintRectAnchor});
} 

class CircleWWTextPixelWidget extends LeafRenderObjectWidget {
  final List<double>? columnConstraints;
  final String lnString;
  final double? pixelSize;
  final double? lineHeight;
  final Size? scaledPixelSize;
  final Rect? paintRect;
  final Color? color;
  const CircleWWTextPixelWidget(this.lnString, {super.key, this.pixelSize, this.lineHeight, this.scaledPixelSize, this.paintRect, this.columnConstraints, this.color});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CircleWWTextPixelRenderBox(lnString, 
      pixelSize: pixelSize,
      lineHeight: lineHeight,
      scaledPixelSize: scaledPixelSize, 
      paintRect: paintRect, columnConstraints: columnConstraints, color: color);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _CircleWWTextPixelRenderBox renderObject) {
    renderObject.update(lnString, columnConstraints, paintRect, pixelSize, lineHeight, scaledPixelSize, color);
  }
}

class _CircleWWTextPixelRenderBox extends RenderBox {
  List<double>? columnConstraints;
  String lnString;
  double? pixelSize;
  double? lineHeight;
  Size? scaledPixelSize;
  Rect? paintRect;
  Color? color;
  _CircleWWTextPixelRenderBox(this.lnString, {this.pixelSize, this.lineHeight, this.scaledPixelSize, this.paintRect, this.columnConstraints, this.color});

  WordWrapTextPixel? _pixel;

  void update(String lnString, List<double>? columnConstraints, Rect? paintRect, double? pixelSize, double? lineHeight, Size? scaledPixelSize, Color? color){
    _pixel = CircleWWTextPixel(lnString, 
      pixelSize: pixelSize,
      lineHeight: lineHeight,
      scaledPixelSize: scaledPixelSize, 
      paintRect: paintRect, color: color, columnConstraints: columnConstraints ?? [constraints.maxWidth]);
    markNeedsLayout();
  }

  // set pixel(WordWrapTextPixel value) {
  //   if (_pixel != value) {
  //     _pixel = value;
  //     markNeedsPaint();
  //   }
  // }

  // double _calculatedHeight = 0;

  @override
  void performLayout() {
    // 限制宽度来自父布局（maxWidth）
    // double width = constraints.maxWidth;
    
    // 动态内容高度计算（示例：根据宽度计算高度）
    // _calculatedHeight = width * 2; // 自定义逻辑，例如绘制一个横向长条或文字行高
    // _calculatedHeight = _pixel.size.height; // 自定义逻辑，例如绘制一个横向长条或文字行高

    // 设置最终尺寸
    // size = Size(width, _calculatedHeight);
    size = constraints.constrain((_pixel ??= CircleWWTextPixel(lnString, pixelSize: pixelSize, paintRect: paintRect, color: color, columnConstraints: columnConstraints ?? [constraints.maxWidth])).size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    _pixel?.paintContext(null, canvas, size);
    // final Paint paint = Paint()
    //   ..color = _pixel
    //   ..style = PaintingStyle.fill;

    // // 绘制内容
    // canvas.drawRect(offset & size, paint);
  }
}
