import 'dart:math';

List<ColorToName> colorChoices = <ColorToName>[];

final preProcessedColorStrings = colorFile.split('\n');

void initState() {
  for (var colorStr in preProcessedColorStrings) {
    var split = colorStr.split('\t');
    final name = split[split.length - 1];
    var colors = colorStr.replaceAll('\t', ' ').split(' ')
      ..removeWhere((str) {
        return int.tryParse(str) == null;
      });
    colorChoices.add(ColorToName(name, int.parse(colors[0]), int.parse(colors[1]), int.parse(colors[2])));
  }
}

String predictColorName(int red, int green, int blue) {
  if (colorChoices.isEmpty) initState();

  double dist = double.infinity;
  String closestName = '';
  for (var choice in colorChoices) {
    if (red == choice.red && blue == choice.blue && green == choice.green) {
      return choice.name;
    } else {
      double colorDist = sqrt(pow((choice.red - red), 2) + pow((choice.green - green), 2) + pow((choice.blue - blue), 2));
      if (colorDist < dist) {
        dist = colorDist;
        closestName = choice.name;
      }
    }
  }
  return closestName;
}

class ColorToName {
  String name;
  int red;
  int green;
  int blue;
  ColorToName(this.name, this.red, this.green, this.blue);

  @override
  String toString() {
    return "($red,$green,$blue) = $name";
  }
}

const colorFile = """
255 218 185		Peach
255 250 205		Lemon
245 255 250		Mint
240 255 255		Azure
255 228 225		Rose
255 255 255		White
250 128 114		Salmon
220  20  60		Crimson
  0   0   0		Black
 47  79  79		Dark grey
105 105 105		Dim grey
211 211 211		Light gray
  0   0 128		Navy blue
  0   0 255		Blue
 64 224 208		Turquoise
  0 255 255		Cyan
  0 255   0		Green
 50 205  50		Lime
255 255   0		Yellow
255 215   0 	Gold
165  42  42		Brown
255 165   0		Orange
255   0   0		Red
 75   0 130   Indigo
255 192 203		Pink
176  48  96		Maroon
255   0 255		Magenta
238 130 238		Violet
221 160 221		Plum
160  32 240		Purple
169 169 169		Dark grey
  0   0 139   Dark blue
  0 139 139   Dark cyan
139   0   0		Dark red
144 238 144		Light green""";
