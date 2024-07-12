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
import VLCJVideo.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.prefs.Preferences;
import java.util.Arrays;
import processing.awt.PSurfaceAWT.SmoothCanvas;

//boolean aarch64;
boolean GL = false;
boolean dragging, draggingWindow, draggingSlider, playing, paused;
int screenWidth, screenHeight, colorScheme, trackHeight, translation, tracks, version;
color backgroundColor, normalColor, overColor, selectedColor, borderColor;
float defaultDuration;
boolean hideCursor = false;
ArrayList<Node> nodes;
Node[] stage;
Path projectPath, prevProjectPath;
Preferences prefs;
PApplet main = this;

void settings() {
  initSettings();
}

void setup() {
  //aarch64 = System.getProperty("os.arch") == "aarch64";
  prefs = Preferences.userRoot().node(this.getClass().getName());
  frameRate(60);
  version = 4;
  defaultDuration = 5;
  tracks = 4;
  trackHeight = 48;
  translation = 0;
  screenWidth = getPrimaryWidth();
  screenHeight = getPrimaryHeight();
  projectPath = Paths.get(System.getProperty("user.home")).resolve("presentation.stage");
  prevProjectPath = projectPath;
  nodes = new ArrayList<Node>();
  stage = new Node[tracks];
  //if(GL) switchFullScreen(true);

  if (args != null) {
    surface.setAlwaysOnTop(true);
    thread("loadArgs");    
  }
}

void loadArgs() {
  loadProject(new File(args[0]));
  hideCursor();
  //end(true);
  turn();  
}

void draw() {
  background(0);
  for(Node no: stage) if(no != null && !no.independent) {
    playing = true;
    if(!no.paused) paused = false;
  }
  if(!playing) paused = false;
  if(playing) for(Node no: stage) if(no != null) no.play();
}

void mouseClicked() {
  if(playing) for(Node no: stage) if(no != null) {
    if(no.isOver()) no.jump();
  }
}

void turn() {
  if(!playing) {for(Node no: nodes) if(no.selected && !no.independent) no.turn();}
  //else {for(Node no: stage) if(no != null && !no.independent && !(paused  ^ no.paused)) no.turn();}
}

void end(boolean fullStop) {
  for(Node no: stage) if(no != null) no.end(fullStop);
  for(Node no: nodes) if(no != null) no.end(fullStop);//To stop nodes that play on load
}

void next() {
  for(Node no: stage) if(no != null && !no.independent) no.next();
}

void keyPressed() {
  key = keyCode == ESC ? 0 : key;
}

void hideCursor() {
  if(hideCursor) noCursor();
  else cursor(ARROW);
}
