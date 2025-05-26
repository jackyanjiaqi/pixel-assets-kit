import 'dart:ui';
//// 像素连接种类
enum PixelCombineMode {
  LR, TB, RL, BT,
  LR_OFFSET,
  TB_OFFSET,
  RL_OFFSET,
  BT_OFFSET
}

class Pixel{
  final ({int width, int height}) size;
  final List<String> data;
  const Pixel({required this.size, required this.data});
  factory Pixel.empty()=>Pixel(size: (width: 0, height: 0), data: []);
  
  bool get isEmpty => data.isEmpty;

  bool get isNotEmpty => data.isNotEmpty;

  String lineAt(int xAt, int yLine){
    return data[yLine][xAt];
  }

  String sizedAt(int xAt, int ySized){
    return data[(ySized * size.width + xAt).toInt()];
  }

  @override
  toString(){
    return '(${size.width},${size.height}):${['', ...data].join('\n')}';
  }
}

class PixelImage{
  final String data;
  const PixelImage(this.data);
  
  /// 去掉占位行信息
  List<String> get pure => data.split('\n').where((pure)=>pure.isNotEmpty).toList();

  Pixel pixelRepeat([int times = 1]){
    final pureLinedData = times == 1 ? pure : pure.map((expand)=>List.generate(times, (_)=>expand).join()).toList();
    final maxLength = pureLinedData.fold<int>(0, (length, line)=>line.length > length ? line.length : length);
    return Pixel(size: (width: maxLength, height: pureLinedData.length), data: pureLinedData); 
  }

  Pixel get pixel => pixelRepeat(1);
}