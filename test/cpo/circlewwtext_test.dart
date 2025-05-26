import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_assets_kit/pixel_assets_kit.dart';
import 'package:pixel_assets_kit/utils.dart';

void main(){
  group('Test screen model', (){
    var circletext = CircleWWTextPixel('auther:jackyanjiaqi@gmail.com', pixelSize: 3.0, columnConstraints: [180]);
    // var circletext = CircleWWTextPixel('auther:jackyanjiaqi@gmail.com', gridSize: 3.0, columnConstraints: [80, 180, 340], paintRect: Rect.fromLTWH(0, 0, 180, 340));
    // var pixels = finalWordWrapPixel(['auther:jackyanjiaqi@gmail.com'], [360, 720], 3.0);
    // var pixels = finalWordWrapPixel(['A-BMCDEFG'], [80, 180], 3.0);
    var single = processSinglelineWordWrapPixels('A-BMCDEFG', [80, 180], 3.0, lineMerge: false);

    test('ScreenContext.screenPTColumnsLR', (){
      // expect(circletext.pixelSize, 3);
      // expect(circletext.containerRect.toString(), 'Rect.fromLTRB(0.0, 0.0, 720.0, 340.0)');
      // expect(single,  '');
      // expect(pixels, '');
      expect(circletext.pixel.toString(), '');
      // expect(circletext.pixel.size, 'Rect()');
    });
  });
}