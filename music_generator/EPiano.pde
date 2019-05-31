class EPiano implements Instrument {
  
  SoundFile[] rememberMelody1;
  ArrayList<SoundFile> notes;
  int[] rememberRandom1;
  int playProb;
  
  //rememberMelody1 stores references to the sound file it chose to play
  //rememberRandom1 stores the random values it chose so it plays on the same beats each time
  //playprob determines how often the instrument plays, depending on emotion
  //notes is the set of notes it chooses from when playing, populated by selectNotes()
  EPiano() {
    this.rememberMelody1 = new SoundFile[(((int)random(1, 3)) * 16)];
    this.rememberRandom1 = new int[rememberMelody1.length];
    
    if (emotion == 3) {
      this.playProb = (int)random(4, 6);
    } else if (emotion == 1 || emotion == 4 || emotion == 5 || emotion == 7) {
      this.playProb = (int)random(3, 5);
    } else {
      this.playProb = (int)random(2, 4);
    }
    
    this.notes = new ArrayList<SoundFile>();
    
    selectNotes(epianoNotes, notes);
  }
  
  public String getName() {
    return ("Electric Piano");
  }
  
  /* on first iteration of loop (the first 16 beats), it picks a randon number from
     1 to 10; if this is divisible by the playprob, it chooses a random note from
     the notes arraylist to play, which it stores in rememberMelody1. the random
     number is stored in rememberRandom1 so that it will play on the same beats on
     subsequent iterations of the loop. after looping once, it reloops through
     rememberMelody1 and rememberRandom1 so that it will play the same notes on
     the same beats. delays for delay milliseconds between each beat. stops as soon
     as the user tells the generator to stop */
  void run() {
    println("starting the epiano");
    for (int i = 0; i < rememberMelody1.length; i++) {
      if (!stopped) {
        int random1 = int(random(1, 10));
        rememberRandom1[i] = random1;
     
        if (random1 % playProb == 0){
          SoundFile sound = notes.get(int(random(0, notes.size())));
          sound.play(1, (i % 4) + (1 - (1 * (i % 4))));
          rememberMelody1[i] = sound;
        }
        
        try { 
          Thread.sleep(delay);
        } catch (InterruptedException e) {
          println("oops");
        }
      } else {
        break;
      }
    }
    
    for (int i = 0; i < rememberMelody1.length; i++) {
      if (!stopped) {
        if (rememberRandom1[i] % playProb == 0){
          rememberMelody1[i].play(1, (i % 4) + (1 - (1 * (i % 4))));
        }
        
        if (i == rememberMelody1.length - 1) {
          i = -1;
        }
        
        try { 
          Thread.sleep(delay);
        } catch (InterruptedException e) {
          println("oops");
        }
      } else {
        break;
      }
    }
    return;
  } //<>// //<>// //<>//
  
}
