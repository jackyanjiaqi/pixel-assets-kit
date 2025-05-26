import 'dart:ui';
import 'package:flutter/material.dart';

import 'assets/alphabet.pixel.dart';
import 'model.dart';
import 'assets/numbers.small.pixel.dart';
import 'assets/numbers.time.pixel.dart';

List<Pixel> characterPixels(String target){
  if(target.isEmpty) return [Pixel.empty()];
  bool hasLetter = target.contains(RegExp(r'[a-zA-Z]'));
  return target.split('').map<Pixel>((char){
      return switch(char){
        '0'=>hasLetter ? Slim8Number0.pixel : DT16Number0.pixel,
        '1'=>hasLetter ? Slim8Number1.pixel : DT16Number1.pixel,
        '2'=>hasLetter ? Slim8Number2.pixel : DT16Number2.pixel,
        '3'=>hasLetter ? Slim8Number3.pixel : DT16Number3.pixel,
        '4'=>hasLetter ? Slim8Number4.pixel : DT16Number4.pixel,
        '5'=>hasLetter ? Slim8Number5.pixel : DT16Number5.pixel,
        '6'=>hasLetter ? Slim8Number6.pixel : DT16Number6.pixel,
        '7'=>hasLetter ? Slim8Number7.pixel : DT16Number7.pixel,
        '8'=>hasLetter ? Slim8Number8.pixel : DT16Number8.pixel,
        '9'=>hasLetter ? Slim8Number9.pixel : DT16Number9.pixel,
        // '6'=>SlimNumber6.pixel,'7'=>SlimNumber7.pixel,'8'=>SlimNumber8.pixel,'9'=>SlimNumber9.pixel,
        'K'=>K16.pixel,'U'=>U16.pixel,'I'=>I12.pixel, 'A'=>A12.pixel, 'P'=>P16.pixel, 'R'=>R16.pixel,
        'O'=>O16.pixel, 'D'=>D16.pixel, 'B'=>B14.pixel, 'S'=>S16.pixel, 'G'=>G16.pixel, 'E'=>E16.pixel, 'V'=>V16.pixel, 'Y'=> Y16.pixel, 'J'=>J14.pixel, 'Q'=>Q16.pixel,
        'a'=>a14.pixel, 'o'=>o12.pixel, 'b'=>b12.pixel, 'd'=>d12.pixel, 'm'=>m14.pixel, 'r'=>r6.pixel, 'y'=>y12.pixel, 'j'=>j10.pixel, 'q'=>q12.pixel,
        'e'=>e12.pixel, 'u'=>u12.pixel, 't'=>t10.pixel, 'c'=>c12.pixel, 'h'=>h12.pixel, 'p'=>p12.pixel, 'v'=>v10.pixel,
        'i'=>i6.pixel, 'x'=>x12.pixel, 'l'=>l6.pixel, 's'=>s12.pixel, 'k'=>k12.pixel, 'w' => w14.pixel,
        'Z'=>Z16.pixel, 'z'=>z10.pixel, 'X' => X16.pixel, 'W' => W16.pixel,
        'L'=>L10.pixel, 'C'=>C16.pixel, 'n'=>n12.pixel, 'g'=>g10.pixel, 'f'=>f10.pixel, 'F'=>F16.pixel, 'H'=>H16.pixel,'T'=>T16.pixel, 'M'=>M16.pixel, 'N'=>N16.pixel,
        ':'=>hasLetter ? Colon6.pixel : DT16Colon.pixel, 
        ','=>hasLetter ? Comma6.pixel : DT16Comma.pixel, 
        '.'=>hasLetter ? Dot6.pixel : DT16Dot.pixel,
        '-'=>hasLetter ? Hyphen6.pixel : DT16Hyphen.pixel, '—'=>Dash6.pixel, '_'=>Underline6.pixel,
        '('=>OpenParenthesis6.pixel, '['=>OpenBracket6.pixel, '{'=>OpenCurlyBracket6.pixel,
        ')'=>CloseParenthesis6.pixel,  ']'=>CloseBracket6.pixel,  '}'=>CloseCurlyBracket6.pixel,
        ' '=>Blank6.pixel,
        //// 上标数字
        '⁰'=>Sup6Number0.pixel, '¹'=>Sup6Number1.pixel, '²'=>Sup6Number2.pixel, '³'=>Sup6Number3.pixel, 
        '⁴'=>Sup6Number4.pixel, '⁵'=>Sup6Number5.pixel, '⁶'=>Sup6Number6.pixel, '⁷'=>Sup6Number7.pixel, 
        '⁸'=>Sup6Number8.pixel, '⁹'=>Sup6Number9.pixel, 
        //// 下标数字
        '₀'=>Sub6Number0.pixel, '₁'=>Sub6Number1.pixel, '₂'=>Sub6Number2.pixel, '₃'=>Sub6Number3.pixel, 
        '₄'=>Sub6Number4.pixel, '₅'=>Sub6Number5.pixel, '₆'=>Sub6Number6.pixel, '₇'=>Sub6Number7.pixel, 
        '₈'=>Sub6Number8.pixel, '₉'=>Sub6Number9.pixel, 
        
        _=>Unknown16.pixel
      };
    }).toList();
}

Pixel combinePixels(List<Pixel> pixels, {PixelCombineMode combineMode = PixelCombineMode.LR, Offset? offset}){
  if(combineMode == PixelCombineMode.RL || combineMode == PixelCombineMode.BT){
    pixels = pixels.reversed.toList();
  }
  var data = pixels.fold<List<String>>([], (fold, pixel){
      if(pixel.isEmpty){
        return fold;
      }else
      if(fold.isEmpty){
        return fold..addAll(pixel.data);
      }else{
        if(combineMode == PixelCombineMode.LR || combineMode == PixelCombineMode.RL){
          //// 各行相加
          return fold.indexed.map<String>((indexed)=>indexed.$2 + pixel.data[indexed.$1]).toList();
        } else
        if(combineMode == PixelCombineMode.TB || combineMode == PixelCombineMode.BT){
          //// 直接加列数据
          return fold ..addAll(pixel.data);
        } else {
          //// 暂未实现
          return fold;
        }
      }
    });
  if(data.isEmpty) return Pixel.empty();
  var width = data.fold<int>(0, (width, line)=>line.length > width ? line.length : width);
  return Pixel(size: (width: width, height: data.length), data: data);
}

Pixel finalSinglelinePixel(String singleLine, {PixelCombineMode combineMode = PixelCombineMode.LR}){
  return combinePixels(characterPixels(singleLine), combineMode: combineMode);
}

(int, Pixel) finalMultilinePixel(List<String> multiLines, {PixelCombineMode horzMode = PixelCombineMode.LR, PixelCombineMode vertMode = PixelCombineMode.TB}){
  /// 纵向叠加像素块
  return (multiLines.length, combinePixels(multiLines.map<Pixel>((singleLine)=>finalSinglelinePixel(singleLine, combineMode: horzMode)).toList(), combineMode: vertMode));
}

/// 仅支持 LR模式
List<Pixel> processSinglelineWordWrapPixels(String singleLine, List<double> columnConstraints, double gridSize, { bool lineMerge = true}){
  int column = 0;
  int constraintIndex = 0;
  return characterPixels(singleLine).fold<List<Pixel>>([], (fold, char){
    if((column + char.size.width) * gridSize <= columnConstraints[constraintIndex] ){
      column += char.size.width;
      if(fold.isNotEmpty){
        var combined = combinePixels([fold.last, char]);
        return fold..replaceRange(fold.length - 1, fold.length, [combined]);
      }else{
        return [char];
      }
    }else{
      var padding = (columnConstraints[constraintIndex] / gridSize).ceil() - column;
      column += padding + char.size.width;
      var needMerge = lineMerge;
      if(constraintIndex + 1 >= columnConstraints.length){
        needMerge = lineMerge && !needMerge;
        column = char.size.width;
      }
      constraintIndex = (constraintIndex + 1) % columnConstraints.length;
      if(fold.isNotEmpty){
        var paddingCombined = combinePixels([fold.last, Blank1.pixelRepeat(padding), if(needMerge) char]);
        return fold..replaceRange(fold.length - 1, fold.length, [paddingCombined, if(!needMerge) char]);
      }else{
        return needMerge ? [ combinePixels([Blank1.pixelRepeat(padding), char]) ] :
                           [Blank1.pixelRepeat(padding), char ];
      }
    }
  });
}

(int, Pixel) finalWordWrapPixel(List<String> multiLines, List<double> columnConstraints, double gridSize, {PixelCombineMode vertMode = PixelCombineMode.TB}){
  /// 纵向叠加像素块
  final lines = multiLines.expand<Pixel>((singleLine)=>processSinglelineWordWrapPixels(singleLine, columnConstraints, gridSize)).toList();
  return (lines.length, combinePixels(lines, combineMode: vertMode));
}