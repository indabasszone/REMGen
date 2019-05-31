class EKit implements Instrument {
  
  int[] rememberRandom1;
  int kickPlayProb, snarePlayProb, hatPlayProb;
  
  /*functions similarly to others, except now the three components of the kit have
  individual play probabilities.*/
  EKit() {
    this.rememberRandom1 = new int[((int)random(1,3)*8)];
    if (emotion == 3) {
      this.kickPlayProb = (int)random(4, 6);
      this.snarePlayProb = (int)random(4, 6);
      this.hatPlayProb = (int)random(3, 5);
      
    } else if (emotion == 1 || emotion == 4 || emotion == 5 || emotion == 7) {
      this.kickPlayProb = (int)random(3, 5);
      this.snarePlayProb = (int)random(4, 6);
      this.hatPlayProb = (int)random(3, 4);
      
    } else {
      this.kickPlayProb = (int)random(2, 4);
      this.snarePlayProb = (int)random(2, 4);
      this.hatPlayProb = (int)random(2, 3);
    }
  }
  
  public String getName() {
    return ("Electronic Kit");
  }
  
  /*loops through rememberRandom1 once and stores the random numbers that decide
  whether or not it plays, then loops through it again continuously using the stored
  random numbers to play. doesnt use rememberMelody because it will play the same
  soundfiles each time. chooses to play the kick, snare, and hat individually based on
  their respective playprobs. also has other constraints on them: kick can only play on even
  beats, snare cant play on first beat of 4, hat plays every 4th beat.*/
  public void run() {
    println("starting the ekit");
    for (int i = 0; i < rememberRandom1.length; i++) {
      if (!stopped) {
        int random1 = int(random(1, 10));
        rememberRandom1[i] = random1;
     
        if (random1 % kickPlayProb == 0 && i % 2 == 0){
          ekitNotes[0].play(1, 0.9);
        }
        if (random1 % snarePlayProb == 0 && i % 4 != 0){
          ekitNotes[1].play(1, 0.7);
        }
        if (random1 % hatPlayProb == 0 || i % 4 == 0){
          ekitNotes[2].play();
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
    
    for (int i = 0; i < rememberRandom1.length; i++) {
      if (!stopped) {
        int value = rememberRandom1[i];
        
        if (value % kickPlayProb == 0 && i % 2 == 0){
          ekitNotes[0].play(1, 0.9);
        }
        if (value % snarePlayProb == 0 && i % 4 != 0){
          ekitNotes[1].play(1, 0.7);
        }
        if (value % hatPlayProb == 0 || i % 4 == 0){
          ekitNotes[2].play();
        }
        
        if (i == rememberRandom1.length - 1) {
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
}
