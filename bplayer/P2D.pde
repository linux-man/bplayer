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
//P2D
//*<------------------------------------------------------------
import com.jogamp.newt.opengl.GLWindow;
import com.jogamp.newt.Screen;
import com.jogamp.newt.MonitorDevice;

void initSettings() {
  fullScreen(P2D, 2);
  //size(640, 480, P2D);
  GL = true;
  PJOGL.setIcon("stage.png");
}

int getPrimaryWidth() {
  return Screen.getAllScreens().iterator().next().getPrimaryMonitor().getCurrentMode().getSurfaceSize().getResolution().getWidth();
}

int getPrimaryHeight() {
  return Screen.getAllScreens().iterator().next().getPrimaryMonitor().getCurrentMode().getSurfaceSize().getResolution().getHeight();
}

MonitorDevice secondaryDevice() {
  try {
    if(Screen.getAllScreens().iterator().next().getMonitorDevices().size() > 1)
      for(MonitorDevice m: Screen.getAllScreens().iterator().next().getMonitorDevices()) if(!m.isPrimary()) return m;
    return Screen.getAllScreens().iterator().next().getPrimaryMonitor();
  }
  catch (Exception e) {
      println(e.toString());
      println("Get monitor devices error");
      return null;
  }
}

boolean isFullScreen() {
  return ((GLWindow) surface.getNative()).isFullscreen();
}

void switchFullScreen(boolean full) {
  if(full) {
    MonitorDevice d = secondaryDevice();
    ArrayList<MonitorDevice> list = new ArrayList<MonitorDevice>();
    list.add(d);
    ((GLWindow) surface.getNative()).setFullscreen(list);
    ((GLWindow) surface.getNative()).setFullscreen(true);
  }
  else {
    ((GLWindow) surface.getNative()).setFullscreen(false);
    surface.setSize(640, 480);
    surface.setLocation(screenWidth - 640, screenHeight - 480);
  }
}

void switchFullScreen() {
  if(isFullScreen()) switchFullScreen(false);
  else switchFullScreen(true);
}
//*/
