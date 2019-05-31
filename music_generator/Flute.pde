//see EPiano for a more detailed description of how this works

class Flute implements Instrument {
  
  SoundFile[] rememberMelody1;
  ArrayList<SoundFile> notes;
  int[] rememberRandom1;
  int playProb;
  
  Flute() {
    this.rememberMelody1 = new SoundFile[(((int)random(1, 3)) * 16)];
    this.rememberRandom1 = new int[rememberMelody1.length];
    
    if (emotion == 3) {
      this.playProb = (int)random(3, 5);
    } else if (emotion == 1 || emotion == 4 || emotion == 5 || emotion == 7) {
      this.playProb = (int)random(2, 4);
    } else {
      this.playProb = (int)random(2, 3);
    }
    
    this.notes = new ArrayList<SoundFile>();
    
    selectNotes(fluteNotes, notes);
  }
  
  public String getName() {
    return ("Flute");
  }
  
  //j counter variable is used to prevent notes from playing in quick succession
  void run() {
    println("starting the flute");
    int j = 0;
    for (int i = 0; i < rememberMelody1.length; i++) {
      if (!stopped) {
        int random1 = int(random(1, 10));
        rememberRandom1[i] = random1;
        
        if (j > 0) {
          j--;
        }
     
        if (random1 % playProb == 0 && j == 0 && i % 2 == 0){
          j = 4;
          SoundFile sound = notes.get(int(random(0, notes.size())));
          sound.play(1, 0.7);
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
    
    j = 0;
    for (int i = 0; i < rememberMelody1.length; i++) {
      if (!stopped) {
        if (j > 0) {
          j--;
        }
        
        if (rememberRandom1[i] % playProb == 0 && j == 0 && i % 2 == 0){
          j = 4;
          rememberMelody1[i].play(1, 0.7);
        }
        
        if (i == rememberMelody1.length - 1) {
          i = -1;
          j = 0;
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
  }
  
}
