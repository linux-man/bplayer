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
class Rect extends Node {
  String target;
  boolean centered, perX, perY, perW, perH, clickable;
  float nX, nY, nW, nH;
  int beginTransitionType, endTransitionType;
  color bColor;

  float pX, pY, pW, pH;

  Rect(Rect no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, no.targetable, nodes.size(), no.x + 1, no.y, no.highlight, new int[0],
    no.loop, no.beginTransition, no.endTransition, no.centered,
    no.nX, no.nY, no.nW, no.nH, no.perX, no.perY, no.perW, no.perH, no.beginTransitionDuration, no.endTransitionDuration,
    no.beginTransitionType, no.endTransitionType, no.bColor,
    no.clickable, no.target);
  }

  Rect() {
    this("", "", defaultDuration, false, false, false, false, nodes.size(), -translation, trackHeight, 0, new int[0], false, false, false, false, 0, 0, 100, 100, false, false, true, true, 1, 1, 0, 0, color(128), false, "");
  }

  Rect(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, boolean targetable, int index, int x, int y, int highlight, int[] next,
  boolean loop, boolean beginTransition, boolean endTransition, boolean centered,
  float nX, float nY, float nW, float nH, boolean perX, boolean perY, boolean perW, boolean perH, float beginTransitionDuration, float endTransitionDuration,
  int beginTransitionType, int endTransitionType,
  color bColor,
  boolean clickable, String target) {
    super("Rect", label, notes, duration, beginPaused, endPaused, independent, targetable, index, x, y, highlight, next);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition; this.centered = centered;
    this.nX = nX; this.nY = nY; this.nW = nW; this.nH = nH; this.perX = perX; this.perY = perY; this.perW = perW; this.perH = perH;
    this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration;
    this.beginTransitionType = beginTransitionType; this.endTransitionType = endTransitionType;
    this.bColor = bColor;
    this.clickable = clickable; this.target = target;
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
        case 1:
          w = pW * presentTime / beginTransitionDuration / 1000;
          h = pH * presentTime / beginTransitionDuration / 1000;
          x = pX + (pW - w) / 2;
          y = pY + (pH - h) / 2;
          break;
        case 2: x = width +  (pX - width) * presentTime / beginTransitionDuration / 1000; break;
        case 3: x = -pW + (pX + pW) * presentTime / beginTransitionDuration / 1000; break;
        case 4: y = height +  (pY - height) * presentTime / beginTransitionDuration / 1000; break;
        case 5: y = -pH + (pY + pH) * presentTime / beginTransitionDuration / 1000; break;
      }
    }
    else if(isEndTransition()) {
      switch(endTransitionType) {
        case 0: c = color(red(bColor), green(bColor), blue(bColor), alpha(bColor) * (endTime - presentTime) / endTransitionDuration / 1000); break;
        case 1:
          w = pW * (endTime - presentTime) / endTransitionDuration / 1000;
          h = pH * (endTime - presentTime) / endTransitionDuration / 1000;
          x = pX + (pW - w) / 2;
          y = pY + (pH - h) / 2;
          break;
        case 2: x = -pW +  (pX + pW) * (endTime - presentTime) / endTransitionDuration / 1000; break;
        case 3: x = width +  (pX  - width) * (endTime - presentTime) / endTransitionDuration / 1000; break;
        case 4: y = -pH +  (pY + pH) * (endTime - presentTime) / endTransitionDuration / 1000; break;
        case 5: y = height +  (pY  - height) * (endTime - presentTime) / endTransitionDuration / 1000; break;
      }
    }

    noStroke();
    fill(c);
    rect(x, y, w, h);

    finalizePlay();
  }

  boolean isOver() {
    return clickable & mouseX > pX & mouseX < pX + pW & mouseY > pY & mouseY < pY + pH;
  }

  void jump() {
    end(true);
    for(Node no: nodes) if(no.targetable & no.label.equals(target)) {
      if(no.playing) no.end(true);
      no.turn();
    }
  }

  boolean isClickable() {
    return clickable;
  }

  int getTarget() {
    for(Node no: nodes) if(no.targetable & no.label.equals(target)) return no.index;
    return -1;
  }
}
