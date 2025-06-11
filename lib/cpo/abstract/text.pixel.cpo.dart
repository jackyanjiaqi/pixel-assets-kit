import 'package:flutter/widgets.dart';

import 'pixel.cpo.dart';
import '../../model.dart';
import '../../utils.dart';

final DEFAULT_LINE_PIXEL_NUM = 13;

abstract class TextPixel extends PixelCPO{
  
  final String lnString;

  double? _lineHeight;
  
  TextPixel(this.lnString, {
    PixelInlineAlign textAlign = PixelInlineAlign.left, 
    super.ctxAccessor, super.alignment, double? lineHeight, super.pixelSize, super.anchor, super.bgColor, super.paintRect, super.scaledPixelSize,
    super.color, super.paintRectAnchor}): _lineHeight = lineHeight, super(inlineAlign: textAlign);

  @override
  Pixel get pixel => textPixelInfo.$2;

  (int, Pixel) get textPixelInfo => finalMultilinePixel(lnString.split('\n'));

  int get lineNum => textPixelInfo.$1;

  int get linePixelNum => lnString.isNotEmpty ? characterPixels(lnString[0])[0].size.height : DEFAULT_LINE_PIXEL_NUM;

  double get lineHeight => _lineHeight ?? (scaledPixelSize.height * linePixelNum);

  @override
  double get pixelSize => _lineHeight != null ? (_lineHeight! / linePixelNum) : super.pixelSize;
}

abstract class WordWrapTextPixel extends TextPixel{

  final List<double> columnConstraints;

  WordWrapTextPixel(super.lnString, {
    required this.columnConstraints, 
    super.pixelSize, 
    super.lineHeight, 
    super.scaledPixelSize, 
    super.textAlign, 
    super.ctxAccessor, 
    super.alignment,  
    super.anchor, 
    super.bgColor, 
    super.paintRect, 
    super.paintRectAnchor, 
    super.color}): 
    assert(columnConstraints.isNotEmpty), 
    assert(pixelSize != null || lineHeight != null || scaledPixelSize != null);
  
  @override
  (int, Pixel) get textPixelInfo => finalWordWrapPixel(lnString.split('\n'), columnConstraints, pixelSize);

  // Widget toLayoutWidget(){
  //   return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints){
  //     return CustomPaint()
  //   });
  // }
}