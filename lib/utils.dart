import 'dart:ui';
import 'package:flutter/material.dart';

import 'assets/alphabet.pixel.dart';
import 'model.dart';
import 'assets/numbers.small.pixel.dart';
import 'assets/numbers.time.pixel.dart';

PixelImage characterPixelImage(String char, [bool hasLetter = false]){
  return switch(char){
        '0'=>hasLetter ? Slim8Number0 : DT16Number0,
        '1'=>hasLetter ? Slim8Number1 : DT16Number1,
        '2'=>hasLetter ? Slim8Number2 : DT16Number2,
        '3'=>hasLetter ? Slim8Number3 : DT16Number3,
        '4'=>hasLetter ? Slim8Number4 : DT16Number4,
        '5'=>hasLetter ? Slim8Number5 : DT16Number5,
        '6'=>hasLetter ? Slim8Number6 : DT16Number6,
        '7'=>hasLetter ? Slim8Number7 : DT16Number7,
        '8'=>hasLetter ? Slim8Number8 : DT16Number8,
        '9'=>hasLetter ? Slim8Number9 : DT16Number9,
        // '6'=>SlimNumber6,'7'=>SlimNumber7,'8'=>SlimNumber8,'9'=>SlimNumber9,
        'K'=>K16,'U'=>U16,'I'=>I12, 'A'=>A12, 'P'=>P16, 'R'=>R16,
        'O'=>O16, 'D'=>D16, 'B'=>B14, 'S'=>S16, 'G'=>G16, 'E'=>E16, 'V'=>V16, 'Y'=> Y16, 'J'=>J14, 'Q'=>Q16,
        'a'=>a14, 'o'=>o12, 'b'=>b12, 'd'=>d12, 'm'=>m14, 'r'=>r6, 'y'=>y12, 'j'=>j10, 'q'=>q12,
        'e'=>e12, 'u'=>u12, 't'=>t10, 'c'=>c12, 'h'=>h12, 'p'=>p12, 'v'=>v10,
        'i'=>i6, 'x'=>x12, 'l'=>l6, 's'=>s12, 'k'=>k12, 'w' => w14,
        'Z'=>Z16, 'z'=>z10, 'X' => X16, 'W' => W16,
        'L'=>L10, 'C'=>C16, 'n'=>n12, 'g'=>g10, 'f'=>f10, 'F'=>F16, 'H'=>H16,'T'=>T16, 'M'=>M16, 'N'=>N16,
        ':'=>hasLetter ? Colon6 : DT16Colon, 
        ','=>hasLetter ? Comma6 : DT16Comma, 
        '.'=>hasLetter ? Dot6 : DT16Dot,
        '-'=>hasLetter ? Hyphen6 : DT16Hyphen, '—'=>Dash6, '_'=>Underline6,
        '('=>OpenParenthesis6, '['=>OpenBracket6, '{'=>OpenCurlyBracket6,
        ')'=>CloseParenthesis6,  ']'=>CloseBracket6,  '}'=>CloseCurlyBracket6,
        ' '=>Blank6,
        //// 上标数字
        '⁰'=>Sup6Number0, '¹'=>Sup6Number1, '²'=>Sup6Number2, '³'=>Sup6Number3, 
        '⁴'=>Sup6Number4, '⁵'=>Sup6Number5, '⁶'=>Sup6Number6, '⁷'=>Sup6Number7, 
        '⁸'=>Sup6Number8, '⁹'=>Sup6Number9, 
        //// 下标数字
        '₀'=>Sub6Number0, '₁'=>Sub6Number1, '₂'=>Sub6Number2, '₃'=>Sub6Number3, 
        '₄'=>Sub6Number4, '₅'=>Sub6Number5, '₆'=>Sub6Number6, '₇'=>Sub6Number7, 
        '₈'=>Sub6Number8, '₉'=>Sub6Number9, 
        
        _=>Unknown16
      };
}

bool hasUnknownChars(String target) => target.split('').any((char)=>characterPixelImage(char) == Unknown16);

List<Pixel> characterPixels(String target){
  if(target.isEmpty) return [Pixel.empty()];
  bool hasLetter = target.contains(RegExp(r'[a-zA-Z]'));
  return target.split('').map<Pixel>((char){
      return characterPixelImage(char, hasLetter).pixel;
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