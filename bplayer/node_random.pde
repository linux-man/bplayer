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
class Random extends Node {

  Random(Random no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, no.targetable, nodes.size(), no.x + 1, no.y, no.highlight, new int[0]);
  }

  Random() {
    this("", "", 0, false, false, false, false, nodes.size(), -translation, trackHeight, 0, new int[0]);
  }

  Random(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, boolean targetable, int index, int x, int y, int highlight, int[] next) {
    super("Random", label, notes, duration, beginPaused, endPaused, independent, targetable, index, x, y, highlight, next);
  }
  
    void finalizeEnd(boolean fullStop) {
    playing = false;
    paused = false;
    onEndPause = false;
    noLoop = false;
    onLoop = false;
    stage[track] = null;
    if(!fullStop) {
      if(next.length > 0) {
        Node no = nodes.get(next[int(random(next.length))]);
        if(no.playing) no.end(true);
        no.turn();
      }
    }
  }
}