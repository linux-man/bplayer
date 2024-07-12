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
//import java.io.FileOutputStream;
import java.io.FileInputStream;
//import java.util.zip.*;

void loadProject(File file) {
  if (file != null && file.exists()) {
    JSONObject json = loadJSONObject(file);
    int saveVersion = json.getInt("version", 1);
    projectPath = Paths.get(file.getPath());
    prevProjectPath = Paths.get(json.getString("projectPath", projectPath.toString()));
    tracksChange(json.getInt("tracks", 4));
    hideCursor = json.getBoolean("hidecursor", false);
    if(hideCursor) noCursor();
    else cursor(ARROW);
    JSONArray jsonNodes = json.getJSONArray("nodes");
    for(int n = 0; n < jsonNodes.size(); n++) {
      try {
        JSONObject node = jsonNodes.getJSONObject(n);
        switch(node.getString("type")) {
          case "Link":
            nodes.add(new Link(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
            node.getBoolean("independent"), node.getBoolean("targetable", false), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getInt("highlight", 0), node.getJSONArray("next").toIntArray()));
            break;
          case "Random":
            nodes.add(new Random(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
            node.getBoolean("independent"), node.getBoolean("targetable", false), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getInt("highlight", 0), node.getJSONArray("next").toIntArray()));
            break;
          case "Rect":
            nodes.add(new Rect(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
            node.getBoolean("independent"), node.getBoolean("targetable", false), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getInt("highlight", 0), node.getJSONArray("next").toIntArray(),
            node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"), node.getBoolean("centered"),
            node.getFloat("nX"), node.getFloat("nY"), node.getFloat("nW"), node.getFloat("nH"),
            node.getBoolean("perX"), node.getBoolean("perY"), node.getBoolean("perW"), node.getBoolean("perH"),
            node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"),
            node.getInt("beginTransitionType"), node.getInt("endTransitionType"),
            node.getInt("bColor"), node.getBoolean("clickable", false), node.getString("target", "")));
            break;
          case "Text":
            nodes.add(new Text(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
            node.getBoolean("independent"), node.getBoolean("targetable", false), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getInt("highlight", 0), node.getJSONArray("next").toIntArray(),
            node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"), node.getBoolean("centered"),
            node.getFloat("nX"), node.getFloat("nY"), node.getFloat("nW"), node.getFloat("nH"),
            node.getBoolean("perX"), node.getBoolean("perY"), node.getBoolean("perW"), node.getBoolean("perH"),
            node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"),
            node.getInt("beginTransitionType"), node.getInt("endTransitionType"), node.getInt("textAlignHor"), node.getInt("textAlignVer"), node.getInt("textSize"),
            node.getString("text"), node.getString("textFont"),
            node.getInt("bColor")));
            break;
          case "Image":
            nodes.add(new Image(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
            node.getBoolean("independent"), node.getBoolean("targetable", false), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getInt("highlight", 0), node.getJSONArray("next").toIntArray(),
            node.getString("path"),
            node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"), node.getBoolean("centered"), node.getBoolean("aspectRatio"),
            node.getFloat("nX"), node.getFloat("nY"), node.getFloat("nW"), node.getFloat("nH"),
            node.getBoolean("perX"), node.getBoolean("perY"), node.getBoolean("perW"), node.getBoolean("perH"),
            node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"),
            node.getInt("beginTransitionType"), node.getInt("endTransitionType"), node.getBoolean("clickable", false), node.getString("target", "")));
            break;
          case "Audio":
            nodes.add(new Audio(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
            node.getBoolean("independent"), node.getBoolean("targetable", false), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getInt("highlight", 0), node.getJSONArray("next").toIntArray(),
            node.getString("path"),
            node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"),
            node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"), node.getFloat("volume"), node.getFloat("beginAt"), node.getFloat("endAt"),
            node.getBoolean("equalizer", false), node.getInt("preset", -1), node.getFloat("preamp", 0),
            saveVersion > 1 ? node.getJSONArray("amps").toFloatArray() : new float[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}));
            break;
          case "Video":
            nodes.add(new Video(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
            node.getBoolean("independent"), node.getBoolean("targetable", false), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getInt("highlight", 0), node.getJSONArray("next").toIntArray(),
            node.getString("path"),
            node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"), node.getBoolean("centered"), node.getBoolean("aspectRatio"),
            node.getFloat("nX"), node.getFloat("nY"), node.getFloat("nW"), node.getFloat("nH"),
            node.getBoolean("perX"), node.getBoolean("perY"), node.getBoolean("perW"), node.getBoolean("perH"),
            node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"),
            node.getFloat("volume"), node.getFloat("beginAt"), node.getFloat("endAt"),
            node.getInt("beginTransitionType"), node.getInt("endTransitionType"),
            node.getBoolean("equalizer", false), node.getInt("preset", -1), node.getFloat("preamp", 0),
            saveVersion > 1 ? node.getJSONArray("amps").toFloatArray() : new float[]{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            node.getBoolean("clickable", false), node.getString("target", "")));
            break;
          case "Gallery":
            nodes.add(new Gallery(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
            node.getBoolean("independent"), node.getBoolean("targetable", false), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getInt("highlight", 0), node.getJSONArray("next").toIntArray(),
            node.getString("path"),
            node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"), node.getBoolean("centered"), node.getBoolean("aspectRatio"),
            node.getFloat("nX"), node.getFloat("nY"), node.getFloat("nW"), node.getFloat("nH"),
            node.getBoolean("perX"), node.getBoolean("perY"), node.getBoolean("perW"), node.getBoolean("perH"),
            node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"),
            node.getInt("beginTransitionType"), node.getInt("endTransitionType"),
            node.getBoolean("clickable", false), node.getString("target", "")));
            break;
          case "Exec":
            nodes.add(new Exec(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
            node.getBoolean("independent"), node.getBoolean("targetable", false), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getInt("highlight", 0), node.getJSONArray("next").toIntArray(),
            node.getString("command")));
            break;
        }
      }
      catch(Exception e) {
        println(e.toString());
      }
    }
    if(nodes != null && nodes.size() > 0) {
      Node sel = nodes.get(0);
      for(Node no: nodes) {
        if(no.x < sel.x) sel = no;
      }
      sel.selected = true;
    }
  }
}
