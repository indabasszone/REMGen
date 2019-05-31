class Bass implements Synth {
  
  SoundFile[] notes;
  int noise = 0;
  
  Bass() {
    this.notes = new SoundFile[2];
    selectNotes();
  }
  
  public String getName() {
    return ("Bass");
  }
  
  /* loops through the notes array, restarting when it reaches the end. also plays
     the noise file if that has been selected. only plays once every 16 beats. stops
     when the user stops the generator */
  void run() {
    println("starting the bass pad");
    for (int i = 0; i < notes.length; i++) {
      if (!stopped) {
        notes[i].play(1, 0.75);
        //notes[((i + 1) % 2)].stop();
        if (noise == 1) {
          noiseFile.play(1, 0.8);
        }

        try { 
          Thread.sleep(delay * 16 + 50);
          if (i == notes.length - 1) {
            i = -1;
          }
          
        } catch (InterruptedException e) {
          println("oops");
        }
      } else {
        break;
      }
    }
    return;
  }
  
  // has its own select notes method that funcitons similarly to the others, except
  // it has fewer options and only picks two notes
  void selectNotes() {
    println("adding bass notes");
    notes[0] = bassNotes[((key1) % 12)];
    int randNote = (int)random(1, 4);
    
    if (emotion == 1 || emotion == 2 || emotion == 3) {
      if (randNote == 1) {
        notes[1] = bassNotes[((key1) % 12)];
      } else if (randNote == 2) {
        notes[1] = bassNotes[((key1 + 2) % 12)];
      } else {
        notes[1] = bassNotes[((key1 + 7) % 12)];
      }
      
    } else if (emotion == 4) {
      if (randNote == 1) {
        notes[1] = bassNotes[((key1 + 3) % 12)];
      } else {
        notes[1] = bassNotes[((key1 + 8) % 12)];
      }
      
    } else {
      if (randNote == 1) {
        notes[1] = bassNotes[((key1 + 6) % 12)];
      } else {
        notes[1] = bassNotes[((key1 + 1) % 12)];
      }
      
    }
    
    if (emotion > 4) {
      noise = (int)random(0, 2);
    }
  }
  
}
