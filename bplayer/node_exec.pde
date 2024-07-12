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
class Exec extends Node {
  String command;
  Process process;

  Exec(Exec no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, no.targetable, nodes.size(), no.x + 1, no.y, no.highlight, new int[0],
    no.command);
  }

  Exec() {
    this("", "", defaultDuration, false, false, false, false, nodes.size(), -translation, trackHeight, 0, new int[0], "");
  }

  Exec(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, boolean targetable, int index, int x, int y, int highlight, int[] next,
  String command) {
    super("Exec", label, notes, duration, beginPaused, endPaused, independent, targetable, index, x, y, highlight, next);
    this.command = command;
  }

  void finalizeTurn() {
    super.finalizeTurn();
    String[] params = command.split("\\s+(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1);
    for(int n = 0; n < params.length; n++) params[n] = params[n].replaceAll("^\"|\"$", "");

    try {
      execute(params);
    }
    catch(IOException e) {
      println(e.toString());
      endTime = 0;
    }
  }

  void finalizeEnd(boolean fullStop) {
    super.finalizeEnd(fullStop);
    if(process != null) {
      try {
        process.destroy();
      }
      catch(Exception e) {
        println(e.toString());
      }
    }
  }

  void execute(String[] params) throws IOException {
    ProcessBuilder builder = new ProcessBuilder(params);
    process = builder.start();
  }
}
