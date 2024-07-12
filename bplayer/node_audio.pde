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
class Audio extends Node {
  String path;
  float volume, beginAt, endAt;
  boolean equalizer;
  int preset;
  
  boolean loading;
  float pVolume, pPreamp, preamp;
  float[] amps, pAmps;
  VLCJVideo audio;

  Audio(Audio no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, no.targetable, nodes.size(), no.x + 1, no.y, no.highlight, new int[0],
    no.path, no.loop, no.beginTransition, no.endTransition,
    no.beginTransitionDuration, no.endTransitionDuration, no.volume, no.beginAt, no.endAt,
    no.equalizer, no.preset, no.audio.preamp(), no.audio.amps());
  }

  Audio(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, boolean targetable, int index, int x, int y, int highlight, int[] next,
  String path,
  boolean loop, boolean beginTransition, boolean endTransition,
  float beginTransitionDuration, float endTransitionDuration, float volume, float beginAt, float endAt,
  boolean equalizer, int preset, float preamp, float[] amps) {
    super("Audio", label, notes, duration, beginPaused, endPaused, independent, targetable, index, x, y, highlight, next);
    this.path = normalizePath(path);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition;
    this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration; this.volume = volume; this.beginAt = beginAt; this.endAt = endAt;
    this.equalizer = equalizer; this.preset = preset; this.preamp = preamp; this.amps = amps;
  }

  void turn() {
    if(!playing) {
      initializeTurn();
      audio = new VLCJVideo(main);
  
      audio.bind(VLCJVideo.MediaPlayerEventType.LENGTH_CHANGED, new ARunnable(this) { public void run() {
        if(parent.loading) {
          parent.audio.setVolume(0);
          parent.duration = audio.duration() / 1000.0;
          if(parent.duration <= 0) throw new IllegalArgumentException("This is not an Audio!");
          if(parent.beginAt < 0 || parent.beginAt >= parent.duration) parent.beginAt = 0;
          if(parent.endAt <= 0 || parent.endAt > parent.duration || parent.endAt <= parent.beginAt) parent.endAt = parent.duration;
          //parent.audio.stop();
          parent.loading = false;
        }
      }});

      loading = true;
      audio.openAndPlay(projectPath.getParent().resolve(Paths.get(this.path)).normalize().toString());
      //while(loading) delay(10);
      if(equalizer) {
        if(preset >= 0) audio.setEqualizer(preset);
        else {
          audio.setEqualizer();
          audio.setPreamp(preamp);
          audio.setAmps(amps);
        }
      }
      endTime = int((endAt - beginAt) * 1000);
      //audio.play();

      if(beginTransition) audio.setVolume(0);
      else audio.setVolume(int(volume * 100));
      audio.setTime(int(beginAt * 1000));
      finalizeTurn();
    }
    else paused = !paused;

    if(paused) audio.pause();
    else audio.play();
  }

  void play() {
    if(!playing) return;

    if(isBeginTransition()) audio.setVolume(int(volume * presentTime / beginTransitionDuration / 10));
    else if(isEndTransition()) audio.setVolume(int(volume * (endTime - presentTime) / endTransitionDuration / 10));
    else audio.setVolume(int(volume * 100));

    if(paused && audio.isPlaying()) audio.pause();
    
    finalizePlay();
    try {
      if(loop && presentTime == 0 && !paused) {
        if(!audio.isPlaying()) audio.play();
        audio.setTime(int(beginAt * 1000));
      }
    }
    catch(Exception e) {
      println(e.toString());
      println(projectPath.getParent().resolve(Paths.get(this.path)).normalize().toString());
      presentTime = endTime;
    }
  }

  void finalizeEnd(boolean fullStop) {
    audio.stop();
    //audio.dispose(); //Crashes App
    audio = null;
    super.finalizeEnd(fullStop);
  }

  void cancel() {
    volume = pVolume;
    audio.setPreamp(pPreamp);
    audio.setAmps(pAmps);
  }
}
