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
class Node {
  String type, label, notes;
  int index, x, y, w, h, highlight; int[] next;
  boolean beginPaused, endPaused, loop, beginTransition, endTransition, independent, targetable;
  float duration, beginTransitionDuration, endTransitionDuration;
  
  int track, endTime, presentTime, prevMillis;
  boolean selected, connecting, dragged, mouseOver, playing, paused, onEndPause, noLoop, onLoop;

  Node(String type, String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, boolean targetable, int index, int x, int y, int highlight, int[] next) {
    this.type = type; this.label = label; this.notes = notes; this.duration = duration; this.beginPaused = beginPaused; this.endPaused = endPaused; this.independent = independent;
    this.targetable = targetable; this.index = index; this.x = x; this.y = y; this.highlight = highlight; this.next = next;
    w = 84;
    h = 40;
    track = tracks - int(round(float(y) / trackHeight));
    
    loop = false; beginTransition = false; endTransition = false;
    beginTransitionDuration = 1; endTransitionDuration = 1;
  }

  void turn() {
    if(!playing) {
      initializeTurn();
      endTime = int(duration * 1000);
      finalizeTurn();
    }
    else paused = !paused;
  }

  void initializeTurn() {
    paused = false;
    if(stage[track] != null) stage[track].end(true); 
    stage[track] = this;
  }
  
  void finalizeTurn() {
    presentTime = 0;
    paused = beginPaused;
    onEndPause = false;
    noLoop = false;
    onLoop = false;
    prevMillis = millis();
    playing = true;
  }
  
  void play() {
    if(!playing) return;
    finalizePlay();
  }

  void finalizePlay() {
    int presentMillis = millis();
    if(!paused) {
      presentTime += presentMillis - prevMillis;
      if(presentTime >= endTime) {
        if(loop && !noLoop && !onEndPause) {
          onLoop = true;
          presentTime = 0;
        }
        else end(false);
      }
    }
    prevMillis = presentMillis;
  }

  void end(boolean fullStop) {
    if(!fullStop && endPaused && !onEndPause && (!loop || noLoop)) gotoEndPause();
    else finalizeEnd(fullStop);
  }
  
  void gotoEndPause() {
    onEndPause = true;
    presentTime = endTime;
    turn();
  }

  void finalizeEnd(boolean fullStop) {
    playing = false;
    paused = false;
    onEndPause = false;
    noLoop = false;
    onLoop = false;
    stage[track] = null;
    if(!fullStop) {
      for(int n: next) {
        Node no = nodes.get(n);
        if(no.playing) no.end(true);
        no.turn();
      }
    }
  }

  void next() {
    noLoop = true;
    if(paused) turn();
    if(endTransition) {
      if(presentTime + endTransitionDuration * 1000 < endTime) endTime = presentTime + int(endTransitionDuration * 1000);
    }
    else endTime = presentTime;
  }

  void cancel() {
    //Placeholder for Audio and Video Classes
  }

  boolean isBeginTransition() {
    return beginTransition && beginTransitionDuration > 0 && !onLoop && presentTime < beginTransitionDuration * 1000;
  }

  boolean isEndTransition() {
    return endTransition && endTransitionDuration > 0 && (!loop || noLoop) && presentTime > endTime - endTransitionDuration * 1000;
  }

  boolean isOver() {
    return false;
  }

  void jump() {
    //Placeholder for clickable nodes
  }

  boolean isClickable() {
    return false;
  }

  int getTarget() {
    return -1;
  }
}
