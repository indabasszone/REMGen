//see EPiano for a more detailed description of how this works

class Piano implements Instrument {
  
  SoundFile[] rememberMelody1;
  ArrayList<SoundFile> notes;
  int[] rememberRandom1;
  int playProb;
  
  Piano() {
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
    
    selectNotes(pianoNotes, notes);
  }
  
  public String getName() {
    return ("Piano");
  }
  
  void run() {
    println("starting the piano");
    for (int i = 0; i < rememberMelody1.length; i++) {
      if (!stopped) {
        int random1 = int(random(1, 10));
        rememberRandom1[i] = random1;
     
        if (random1 % playProb == 0){
          SoundFile sound = notes.get(int(random(0, notes.size())));
          sound.play(1, (i % 4) + (1 - (1.1 * (i % 4))));
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
          rememberMelody1[i].play(1, (i % 4) + (1 - (1.1 * (i % 4))));
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
