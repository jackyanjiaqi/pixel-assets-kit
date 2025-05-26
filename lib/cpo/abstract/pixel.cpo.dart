import 'package:flutter/material.dart';
import 'package:ketchup_ui/ketchup_ui.dart';

import '../../basic.dart';
import '../../model.dart';
import 'container.cpo.dart';

enum PixelInlineAlign { left, middle, right }

abstract class PixelCPO extends ContainerCPO{
  
  Pixel get pixel;
  final double? _pixelSize;
  final Size? _scaledPixelSize;
  PixelInlineAlign inlineAlign;
  Size _ctxSize = Size.zero;
  final Color? color;
  final Color? bgColor;
  @override
  Anchor anchor;
  Anchor paintRectAnchor;
  final bool drawBlank;
  PixelCPO({this.ctxAccessor, 
            Alignment? alignment = Alignment.topLeft,
            this.anchor = Anchor.topLeft, 
            this.paintRectAnchor = Anchor.topLeft,
            this.inlineAlign = PixelInlineAlign.left,
            this.color,
            this.drawBlank = false,
            this.bgColor,
            Size? scaledPixelSize,
            double? pixelSize, this.paintRect }): _pixelSize = pixelSize, _scaledPixelSize = scaledPixelSize {
            paintRectAnchor = anchor = switch(alignment){ 
              Alignment.topLeft => Anchor.topLeft, Alignment.topCenter => Anchor.topCenter, Alignment.topRight => Anchor.topRight, 
              Alignment.centerLeft => Anchor.centerLeft, Alignment.center => Anchor.center, Alignment.centerRight => Anchor.centerRight, 
              Alignment.bottomLeft => Anchor.bottomLeft, Alignment.bottomCenter => Anchor.bottomCenter, Alignment.bottomRight => Anchor.bottomRight, 
              _ => anchor,
            };
  } 

  @override
  Size get size => Size(pixel.size.width * scaledPixelSize.width, pixel.size.height * scaledPixelSize.height);

  SizedBox toSizedWidget([Widget? child]){
    return SizedBox.fromSize(size: size, child: CustomPaint(painter: this, child: child,));
  }
  
  // SizedBox toExpandWidget([Widget? child]){
  //   return SizedBox.expand(child: CustomPaint(painter: this,child: child,));
  // }

  @override
  Rect get containerRect => paintRect ?? Rect.fromLTWH(0, 0, ctxSize.width, ctxSize.height);

  @override
  Anchor get containerAnchor => paintRectAnchor;

  double get pixelSize => _pixelSize ?? (paintRect?.width ?? ctxSize.width) / pixel.size.width;

  Size get scaledPixelSize => _scaledPixelSize ?? Size.square(pixelSize);

  bool get isPixelScaled => _scaledPixelSize != null;

  Size get ctxSize => _ctxSize;

  @override
  final Rect? paintRect;

  @override
  ContextAccessor? ctxAccessor;

  @override
  PainterCall? givePainterCall(ContextAccessor? ctxAccessor) {
    return null;
  }

  void paintPixel(String instructStr, int xIndex, int yIndex, Canvas ctxCanvas, Rect paintRect);

  @override
  void paintContext(ContextAccessor? ctxAccessor, Canvas ctxCanvas, Size ctxSize) {
    _ctxSize = ctxSize;
    // var pixelSize = this.pixelSize;
  
    // var viceRadius = (0.707 * paintPixelSize - paintPixelRadius) * 0.618;
    
    // var vicePaint = Paint() ..color = Colors.black;

    // var nowTime = DateTime.now();
    // var willDrawPixels = toPixel('Ketchup');
    // var willDrawPixels = toPixel('UI');
    // var willDrawPixels = toPixel('v0.0.3');
    // var willDrawPixels = toPixel('Kit');
    // var willDrawPixels = toPixel('KUIAPRRP');
    // var willDrawPixels = toPixel('ODODOD');

    // var willDrawPixels = toPixel('Simple');
    // var willDrawPixels = toPixel('Gridbased');

    // var pixel = this.pixel;

    // var willDrawPixels = toPixel('Game');
    // var willDrawPixels = toPixel('K.O.');
    // var willDrawPixels = toPixel('RiskRiskRisk');
    
    // var willDrawPixels = toPixel('Pixel');
    // var willDrawPixels = toPixel('Assets');
    // var willDrawPixels = toPixel('ssssss');
    // var willDrawPixels = toPixel('AAAAAAA');
    // var willDrawPixels = toPixel('lllll');
    // var willDrawPixels = toPixel('PPPPPPP');
    // var willDrawPixels = toPixel('tttttttt');
    // var willDrawPixels = toPixel('ppppppp');
    // var willDrawPixels = toPixel('hhhhhhh');
    // var willDrawPixels = toPixel('ccccccc');
    // var willDrawPixels = toPixel('eeeeeee');
    // var willDrawPixels = toPixel('${nowTime.year}${nowTime.month}${nowTime.day}-${nowTime.hour}:${nowTime.minute}:${nowTime.second}.${nowTime.millisecond}');
    // var willDrawPixels = toPixel('000:0-0.0');
    // var willDrawPixels = toPixel('000000');
    // var willDrawPixels = toPixel('1111111');
    // var willDrawPixels = toPixel('2222222');
    // var willDrawPixels = toPixel('3333333');
    // var willDrawPixels = toPixel('4444444');
    // var willDrawPixels = toPixel('5555555');
    // var willDrawPixels = toPixel('6666666');
    // var willDrawPixels = toPixel('7777777');
    // var willDrawPixels = toPixel('8888888');
    // var willDrawPixels = toPixel('9999999');
    // var willDrawPixels = toPixel('0123456789');
    // var willDrawPixels = toPixel('0:123456789');
    // var willDrawPixels = toPixel('0-123456789');
    // var willDrawPixels = toPixel('0.123456789');

    // double targetWidth = willDrawPixels.size.width * paintPixelSize;
    // double targetHeight = willDrawPixels.size.height * paintPixelSize;
    Rect drawingRect = Rect.fromLTWH(offsetX, offsetY, size.width, size.height);

    // if(paintRect != null){
    //   ctxCanvas.drawRect(paintRect!, Paint()..color = Colors.yellowAccent.darken(0.7));
    // }

    /// 绘制像素背景(用于确定占屏大小)
    if(bgColor != null){
      ctxCanvas.drawRect(drawingRect, Paint()..color = bgColor!);
    }

    final pixelSizeWidth = scaledPixelSize.width;
    final pixelSizeHeight = scaledPixelSize.height;
    
    for (var pixelYIndexed in pixel.data.indexed) {
      pixelYIndexed.$2.split('').indexed.forEach((pixelXIndexed){
        var pixelXIndex = pixelXIndexed.$1;
        var pixelOffsetXIndex = switch(inlineAlign){
          PixelInlineAlign.left => pixelXIndex,
          PixelInlineAlign.right => pixel.size.width - pixelYIndexed.$2.length + pixelXIndex,
          PixelInlineAlign.middle => ((pixel.size.width - pixelYIndexed.$2.length) / 2).toInt() + pixelXIndex,
        };
        var pixelYIndex = pixelYIndexed.$1;
        var pixelOffsetYIndex = pixelYIndex;
          
        // Offset drawStartCenter = Offset(
        //   drawingRect.left + pixelOffsetXIndex * pixelSizeWidth + .5 * pixelSizeWidth , 
        //   drawingRect.top + pixelOffsetYIndex * pixelSizeHeight + .5 * pixelSizeHeight);

        // Rect drawRect = Rect.fromCircle(center: drawStartCenter, radius: paintPixelRadius);
        Rect drawRect = Offset(drawingRect.left + pixelOffsetXIndex * pixelSizeWidth, drawingRect.top + pixelOffsetYIndex * pixelSizeHeight ) & scaledPixelSize;
        // Offset viceCenter = drawStartCenter + Offset( .5 * pixelSize, .5 * pixelSize );
        
        String text = pixelXIndexed.$2;
        paintPixel(text, pixelXIndex, pixelYIndex, ctxCanvas, drawRect);
      });
      }
  }
  
}