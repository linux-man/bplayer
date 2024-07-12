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
class Video extends Node {
  String path, target;
  boolean centered, aspectRatio, perX, perY, perW, perH, clickable;
  float nX, nY, nW, nH, volume, beginAt, endAt;
  int beginTransitionType, endTransitionType;
  boolean equalizer;
  int preset;
  
  float pX, pY, pW, pH, pVolume, pPreamp, preamp;
  boolean loading, turnStarted;
  float[] pAmps, amps;
  VLCJVideo video;

  Video(Video no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, no.targetable, nodes.size(), no.x + 1, no.y, no.highlight, new int[0],
    no.path, no.loop, no.beginTransition, no.endTransition, no.centered, no.aspectRatio,
    no.nX, no.nY, no.nW, no.nH, no.perX, no.perY, no.perW, no.perH, no.beginTransitionDuration, no.endTransitionDuration, no.volume, no.beginAt, no.endAt,
    no.beginTransitionType, no.endTransitionType,
    no.equalizer, no.preset, no.video.preamp(), no.video.amps(),
    no.clickable, no.target);
  }

  Video(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, boolean targetable, int index, int x, int y, int highlight, int[] next,
  String path,
  boolean loop, boolean beginTransition, boolean endTransition, boolean centered, boolean aspectRatio,
  float nX, float nY, float nW, float nH, boolean perX, boolean perY, boolean perW, boolean perH, float beginTransitionDuration, float endTransitionDuration, float volume, float beginAt, float endAt,
  int beginTransitionType, int endTransitionType,
  boolean equalizer, int preset, float preamp, float[] amps,
  boolean clickable, String target) {
    super("Video", label, notes, duration, beginPaused, endPaused, independent, targetable, index, x, y, highlight, next);
    this.path = normalizePath(path);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition; this.centered = centered; this.aspectRatio = aspectRatio;
    this.nX = nX; this.nY = nY; this.nW = nW; this.nH = nH; this.perX = perX; this.perY = perY; this.perW = perW; this.perH = perH;
    this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration;
    this.volume = volume; this.beginAt = beginAt; this.endAt = endAt;
    this.beginTransitionType = beginTransitionType; this.endTransitionType = endTransitionType;
    this.equalizer = equalizer; this.preset = preset; this.preamp = preamp; this.amps = amps;
    this.clickable = clickable; this.target = target;
  }

  void turn() {
    if(!playing) {
      initializeTurn();
      video = new VLCJVideo(main);

      video.bind(VLCJVideo.MediaPlayerEventType.LENGTH_CHANGED, new VRunnable(this) { public void run() {
        if(parent.loading) {
          parent.video.setVolume(0);
          parent.duration = video.duration() / 1000.0;
          if(parent.duration <= 0) throw new IllegalArgumentException("This is not a Video!");
          if(parent.beginAt < 0 || parent.beginAt >= parent.duration) parent.beginAt = 0;
          if(parent.endAt <= 0 || parent.endAt > parent.duration || parent.endAt <= parent.beginAt) parent.endAt = parent.duration;
          parent.video.stop();
          parent.loading = false;
        }
      }});

      loading = true;
      video.openAndPlay(projectPath.getParent().resolve(Paths.get(this.path)).normalize().toString());
      while(loading || video.width == 0) delay(10);
      if(equalizer) {
        if(preset >= 0) video.setEqualizer(preset);
        else {
          video.setEqualizer();
          video.setPreamp(preamp);
          video.setAmps(amps);
        }
      }
      turnStarted = true;
      if(perX) pX = width * nX / 100.0; else pX = nX;
      if(perY) pY = height * nY / 100.0; else pY = nY;
      if(perW) pW = width * nW / 100.0; else pW = nW;
      if(perH) pH = height * nH / 100.0; else pH = nH;
      if(centered) {
        pX = (width - pW) / 2;
        pY = (height - pH) / 2;
      }
      endTime = int((endAt - beginAt) * 1000);
      video.play();

      if(beginTransition) video.setVolume(0);
      else video.setVolume(int(volume * 100));
      video.setTime(int(beginAt * 1000));
      if(aspectRatio) {
        float ratio = float(video.width) / video.height;
        pW = min(pW, pH * ratio);
        pH = min(pH, pW / ratio);
      }
      if(centered) {
        pX = (width - pW) / 2;
        pY = (height - pH) / 2;
      }
      finalizeTurn();
    }
    else paused = !paused;

    if(paused) video.pause();
    else video.play();
  }

  void play() {
    if(!playing) return;
    float x = pX; float y = pY; float w = pW; float h = pH;
    tint(255, 255);

    if(isBeginTransition()) {
      switch(beginTransitionType) {
        case 0: tint(255, 255 * presentTime / beginTransitionDuration / 1000); break;
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
      video.setVolume(int(volume * presentTime / beginTransitionDuration / 10));
    }
    else if(isEndTransition()) {
      switch(endTransitionType) {
        case 0: tint(255, 255 * (endTime - presentTime) / endTransitionDuration / 1000); break;
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
      video.setVolume(int(volume * (endTime - presentTime) / endTransitionDuration / 10));
    }
    else video.setVolume(int(volume * 100));

    if(paused && video.isPlaying()) video.pause();
    
    if(!turnStarted || presentTime > 200) {
      try {
        image(video, x, y, w, h);
      }
      catch(Exception e) {
        println(e.toString());
        println(projectPath.getParent().resolve(Paths.get(this.path)).normalize().toString());
        presentTime = endTime;
      }
      turnStarted = false;
    }
    finalizePlay();
    if(loop && presentTime == 0 && !paused) {
      if(!video.isPlaying()) video.play();
      video.setTime(int(beginAt * 1000));
    }
  }

  void finalizeEnd(boolean fullStop) {
    video.stop();
    video = null;
    //video.dispose(); //Crashes App
    super.finalizeEnd(fullStop);
  }

  void cancel() {
    volume = pVolume;
    video.setPreamp(pPreamp);
    video.setAmps(pAmps);
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
