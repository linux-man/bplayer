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

boolean isDim(String s) {
  return !(Float.isNaN(float(s)));
}

String dimToString(float n) {
  return str(int(n));
}

float stringToDim(String s) {
  return float(s);
}

boolean isTime(String s) {
  if(Float.isNaN(float(s))) return false;
  if(float(s) < 0) return false;
  return true;
}

String timeToString(float n) {
  return str(int(n * 100) / 100.0);
}

float stringToTime(String s) {
  return float(s);
}

String normalizePath(String path) {
  File file = new File(path);
  if(!file.isAbsolute()) {
    file = new File(projectPath.getParent().resolve(Paths.get(path)).normalize().toString());
    if(file.isFile() || file.isDirectory()) path = projectPath.getParent().resolve(Paths.get(path)).normalize().toString();
    else path = prevProjectPath.getParent().resolve(Paths.get(path)).normalize().toString();
  }
  path = projectPath.getParent().relativize(Paths.get(path)).normalize().toString();
  return path;
}

void tracksChange(int n) {
  int oldTracks = tracks;
  tracks = min(max(n, 4), 8);
  int dif = tracks - oldTracks;;
  stage = new Node[tracks];
  for(Node no: nodes) {
    no.y += dif * trackHeight;
    no.track = max(0, min(tracks - 1, tracks - round(float(no.y) / trackHeight)));
  }
}

public class VRunnable implements Runnable {
  public Video parent;
  public VRunnable(Video parent) {
    this.parent = parent;
  }

  @Override
  public void run() {    
  }
}

public class ARunnable implements Runnable {
  public Audio parent;
  public ARunnable(Audio parent) {
    this.parent = parent;
  }

  @Override
  public void run() {    
  }
}
