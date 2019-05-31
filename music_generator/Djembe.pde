//see EPiano for a more detailed description of how this works

class Djembe implements Instrument {
  
  SoundFile[] rememberMelody1;
  ArrayList<SoundFile> notes;
  int[] rememberRandom1;
  int playProb;
  
  Djembe() {
    this.rememberMelody1 = new SoundFile[16];
    this.rememberRandom1 = new int[16];
    
    if (emotion == 3) {
      this.playProb = (int)random(5, 7);
    } else if (emotion == 1 || emotion == 4 || emotion == 5 || emotion == 7) {
      this.playProb = (int)random(4, 6);
    } else {
      this.playProb = (int)random(2, 4);
    }
    
    this.notes = new ArrayList<SoundFile>();
    
    selectNotes();
  }
  
  public String getName() {
    return ("Djembe");
  }
  
  void run() {
    println("starting the djembe");
    for (int i = 0; i < rememberMelody1.length; i++) {
      if (!stopped) {
        int random1 = int(random(1, 10));
        rememberRandom1[i] = random1;
     
        if (random1 % playProb == 0 || i % 8 == 0){
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
    
    for (int i = 0; i < rememberMelody1.length; i++) {
      if (!stopped) {
        if (rememberRandom1[i] % playProb == 0 || i % 8 == 0){
          rememberMelody1[i].play(1, 0.7);
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
  }
  
  //has its own selectNotes method becauses theres only 6 notes that dont depend on key
  void selectNotes() {
    println("adding djembe notes");
    for (int i = 0; i < djembeNotes.length; i++) {
      notes.add(djembeNotes[i]);
    }
  }
  
}
