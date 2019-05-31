//see BasicSine for a more detailed description of how this works

class Saw implements Synth {
  
  SoundFile[][] chords;
  
  Saw() {
    this.chords = new SoundFile[2][];
    selectChords(sawNotes, chords);
  }
  
  public String getName() {
    return ("Saw Pad");
  }
  
  void run() {
    println("starting the warmth pad");
    for (int i = 0; i < chords.length; i++) {
      if (!stopped) {
        for (int j = 0; j < chords[i].length; j++) { 
          println(i);
          println("j is " + j + ", playing note");
          chords[i][j].play(1, 0.8);
        }
         
        if (i == chords.length - 1) {
          i = -1;
        }

        try { 
          Thread.sleep(delay * 16 + 50);
        } catch (InterruptedException e) {
          println("oops");
        }
      } else {
        break;
      }
    }
    return;
  }
  
}
