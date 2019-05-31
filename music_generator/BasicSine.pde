class BasicSine implements Synth {
  
  SoundFile[][] chords;
  
  //initializes array to store two chords, which are added by calling selectNotes()
  //chords are stored vertically in 2d array
  BasicSine() {
    this.chords = new SoundFile[2][];
    selectChords(sineNotes, chords);
  }
  
  public String getName() {
    return ("Basic Sine Pad");
  }
  
  // until the program is stopped, it loops through the array of chords, playing each note
  // in the chord individually. resets the iteration variable when it reaches the last chord
  // so it can keep looping. delays delay*16 because it only plays once per 16 beats
  void run() {
    println("starting the sine pad");
    for (int i = 0; i < chords.length; i++) {
      if (!stopped) {
        for (int j = 0; j < chords[i].length; j++) { 
          println(i);
          println("j is " + j + ", playing note");
          chords[i][j].play(1, 0.7);
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
