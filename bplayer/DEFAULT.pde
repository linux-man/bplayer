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
//DEFAULT
/*<------------------------------------------------------------
import javax.swing.*;
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;

void initSettings() {
  fullScreen(2);
}

GraphicsDevice[] screens() {
  GraphicsEnvironment env = GraphicsEnvironment.getLocalGraphicsEnvironment();
  return env.getScreenDevices();
}

int getPrimaryWidth() {
  return screens()[0].getDisplayMode().getWidth();
}

int getPrimaryHeight() {
  return screens()[0].getDisplayMode().getHeight();
}

boolean isFullScreen() {
  //return ((SmoothCanvas) surface.getNative()).getFrame().getExtendedState() == JFrame.MAXIMIZED_BOTH; 
  return ((SmoothCanvas) surface.getNative()).getFrame().getWidth() != 640; 
}

void switchFullScreen(boolean full) {
  if(full) {
    ((SmoothCanvas) surface.getNative()).getFrame().removeNotify();
    ((SmoothCanvas) surface.getNative()).getFrame().setUndecorated(true);
    ((SmoothCanvas) surface.getNative()).getFrame().setExtendedState(JFrame.MAXIMIZED_BOTH);
    //((SmoothCanvas) surface.getNative()).getFrame().setLocation(0, 0);  
    //((SmoothCanvas) surface.getNative()).getFrame().setSize(displayWidth, displayHeight);  
    windowMove(0, 0);
    windowResize(displayWidth, displayHeight);
    ((SmoothCanvas) surface.getNative()).getFrame().addNotify();
    //surface.setLocation(0, 0);
    //surface.setSize(displayWidth, displayHeight);
  }
  else {
    ((SmoothCanvas) surface.getNative()).getFrame().removeNotify();
    ((SmoothCanvas) surface.getNative()).getFrame().setUndecorated(false);
    ((SmoothCanvas) surface.getNative()).getFrame().setExtendedState(JFrame.NORMAL);
    ((SmoothCanvas) surface.getNative()).getFrame().setSize(640, 480); 
    ((SmoothCanvas) surface.getNative()).getFrame().setLocation(getPrimaryWidth() - 640, getPrimaryHeight() - 480);
    windowMove(getPrimaryWidth() - 640, getPrimaryHeight() - 480);
    windowResize(640, 480);
    ((SmoothCanvas) surface.getNative()).getFrame().addNotify();
    //surface.setLocation(getPrimaryWidth() - 640, getPrimaryHeight() - 480);
    //surface.setSize(640, 480);
  }
}

void switchFullScreen() {
  if(isFullScreen()) switchFullScreen(false);
  else switchFullScreen(true);
}
//*/
