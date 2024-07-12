/*
This file is part of Backstage.

Backstage is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Backstage is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Backstage.  If not, see <http://www.gnu.org/licenses/>.
*/
class Text extends Node {
  boolean centered, perX, perY, perW, perH;
  float nX, nY, nW, nH;
  int beginTransitionType, endTransitionType, textAlignHor, textAlignVer, textSize;
  String text, textFont;
  color bColor;

  float pX, pY, pW, pH;
  PFont font;

  Text(Text no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, no.targetable, nodes.size(), no.x + 1, no.y, no.highlight, new int[0],
    no.loop, no.beginTransition, no.endTransition, no.centered,
    no.nX, no.nY, no.nW, no.nH, no.perX, no.perY, no.perW, no.perH, no.beginTransitionDuration, no.endTransitionDuration,
    no.beginTransitionType, no.endTransitionType, no.textAlignHor, no.textAlignVer, no.textSize,
    no.text, no.textFont, no.bColor);
  }

  Text() {
    this("", "", defaultDuration, false, false, false, false, nodes.size(), -translation, trackHeight, 0, new int[0], false, false, false, true, 0, 0, 100, 100, false, false, true, true, 1, 1, 0, 0, 1, 2, 48, "", "", color(255));
  }

  Text(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, boolean targetable, int index, int x, int y, int highlight, int[] next,
  boolean loop, boolean beginTransition, boolean endTransition, boolean centered,
  float nX, float nY, float nW, float nH, boolean perX, boolean perY, boolean perW, boolean perH, float beginTransitionDuration, float endTransitionDuration,
  int beginTransitionType, int endTransitionType, int textAlignHor, int textAlignVer, int textSize,
  String text, String textFont,
  color bColor) {
    super("Text", label, notes, duration, beginPaused, endPaused, independent, targetable, index, x, y, highlight, next);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition; this.centered = centered;
    this.nX = nX; this.nY = nY; this.nW = nW; this.nH = nH; this.perX = perX; this.perY = perY; this.perW = perW; this.perH = perH;
    this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration;
    this.beginTransitionType = beginTransitionType; this.endTransitionType = endTransitionType; this.textAlignHor = textAlignHor; this.textAlignVer = textAlignVer; this.textSize = textSize;
    this.text = text; this.textFont = textFont;
    this.bColor = bColor;
  }
  
  void turn() {
    if(!playing) {
      initializeTurn();
      if(perX) pX = width * nX / 100.0; else pX = nX;
      if(perY) pY = height * nY / 100.0; else pY = nY;
      if(perW) pW = width * nW / 100.0; else pW = nW;
      if(perH) pH = height * nH / 100.0; else pH = nH;
      if(centered) {
        pX = (width - pW) / 2;
        pY = (height - pH) / 2;
      }
      font = createFont(textFont, textSize);
      textFont(font);
      if(pW == 0) pW = textWidth(text);
      if(pH == 0) pH = textAscent() + textDescent();
      endTime = int(duration * 1000);
      finalizeTurn();
    }
    else paused = !paused;
  }
  
  void play() {
    if(!playing) return;
    float x = pX; float y = pY; float w = pW; float h = pH;
    color c = bColor;

    if(isBeginTransition()) {
      switch(beginTransitionType) {
        case 0: c = color(red(bColor), green(bColor), blue(bColor), alpha(bColor) * presentTime / beginTransitionDuration / 1000); break;
        case 1: x = width +  (pX - width) * presentTime / beginTransitionDuration / 1000; break;
        case 2: x = -pW + (pX + pW) * presentTime / beginTransitionDuration / 1000; break;
        case 3: y = height +  (pY - height) * presentTime / beginTransitionDuration / 1000; break;
        case 4: y = -pH + (pY + pH) * presentTime / beginTransitionDuration / 1000; break;
      }
    }
    else if(isEndTransition()) {
      switch(endTransitionType) {
        case 0: c = color(red(bColor), green(bColor), blue(bColor), alpha(bColor) * (endTime - presentTime) / endTransitionDuration / 1000); break;
        case 1: x = -pW +  (pX + pW) * (endTime - presentTime) / endTransitionDuration / 1000; break;
        case 2: x = width +  (pX  - width) * (endTime - presentTime) / endTransitionDuration / 1000; break;
        case 3: y = -pH +  (pY + pH) * (endTime - presentTime) / endTransitionDuration / 1000; break;
        case 4: y = height +  (pY  - height) * (endTime - presentTime) / endTransitionDuration / 1000; break;
      }
    }

    textFont(font);
    noStroke();
    fill(c);
    int hor, ver;
    switch(textAlignHor) {
      case 0: hor = LEFT; break;
      case 1: hor = CENTER; break;
      default: hor = RIGHT; break;
    }
    switch(textAlignVer) {
      case 0: ver = BASELINE; break;
      case 1: ver = TOP; break;
      case 2: ver = CENTER; break;
      default: ver = BOTTOM; break;
    }
    textAlign(hor, ver);
    if(nW > 0 && nH > 0) text(text, x, y, w, h);
    else text(text, x, y);

    finalizePlay();
  }
}
