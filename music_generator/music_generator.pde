// Need G4P library
import g4p_controls.*;
// You can remove the PeasyCam import if you are not using
// the GViewPeasyCam control or the PeasyCam library.
import peasy.*;
import processing.sound.*;
import java.awt.Font;
import ddf.minim.*;

// tempo is actual bpm value, delay is how long the program actually stops for each beat
public int delay, tempo;

// variables keeping track of the state of the generator. volatile because their value can
// change while the program is running and it needs to be monitored by threads
volatile boolean started, stopped;

// other variables to track the state of the program. selected means an emotion has been selected
// mainScreen is true after the user presses "start" on the start screen
public boolean selected, startedOnce, mainScreen;

// stores the emotion and key as ints, which are mapped to strings. modifier describes which
// note subset the instruments should choose
public static int emotion, key1, modifier;
public HashMap<Integer, String> keyMap, emoMap;

// random numbers for choosing pad and instruments; names are stored in variables
private int randInst1, randInst2, randPad;
public String pad, inst1, inst2, chordList;

// emotion list, background images
String[] listItems = new String[8];
PImage bg, rbg;
PFont font;

// minim tools, used for drawing waveform
Minim minim;
AudioInput input;

// table to store responses in
Table responses;

// arrays that store all sound files for each instrument
public SoundFile[] sineNotes;
public SoundFile[] warmthNotes;
public SoundFile[] sawNotes;
public SoundFile[] pianoNotes;
public SoundFile[] violinNotes;
public SoundFile[] fluteNotes;
public SoundFile[] glockNotes;
public SoundFile[] kotoNotes;
public SoundFile[] harpNotes;
public SoundFile[] marimbaNotes;
public SoundFile[] epianoNotes;
public SoundFile[] bassNotes;
public SoundFile[] djembeNotes;
public SoundFile[] ekitNotes;
SoundFile noiseFile;

// initializes all variables declared above & sets up GUI
public void setup(){
  size(700, 550, JAVA2D);
  bg = loadImage("startbackground.png");
  rbg = loadImage("reviewbackground.png");
  background(bg);
  
  createGUI();
  customGUI();
  
  // program starts with music stopped, no emotion selected, on intro screen
  started = false;
  stopped = true;
  selected = false;
  startedOnce = false;
  mainScreen = false;
  font = createFont("Helvetica", 20);
  
  minim = new Minim(this);
  input = minim.getLineIn();
  
  responses = loadTable("responses.csv", "header");
  sineNotes = new SoundFile[12];
  warmthNotes = new SoundFile[12];
  sawNotes = new SoundFile[12];
  pianoNotes = new SoundFile[12];
  violinNotes = new SoundFile[12];
  fluteNotes = new SoundFile[12];
  glockNotes = new SoundFile[12];
  kotoNotes = new SoundFile[12];
  harpNotes = new SoundFile[12];
  marimbaNotes = new SoundFile[12];
  epianoNotes = new SoundFile[12];
  bassNotes = new SoundFile[12];
  djembeNotes = new SoundFile[6];
  ekitNotes = new SoundFile[6];
  createArrays();
}

public void draw(){
  background(bg);
  
  /* begins music generation if an emotion has been selected and 'generate' has been
     pressed. started is only used to indicate that generation should start, not that
     it is running, so it is set to false at the end of the code block. all pads and
     instruments are threads so that they and the GUI can run concurrently */
  if (started && selected){
    background(bg);
    stopped = false;
    chordList = "";
    randPad = (int)random(1, 4);
    randInst1 = (int)random(1, 11);
    
    do {
      randInst2 = (int)random(1, 11);
    } while (randInst2 == randInst1);
    
    chooseTempo();
    chooseKey();
    pad = choosePad(randPad);
    inst1 = chooseInstrument(randInst1);
    inst2 = chooseInstrument(randInst2);
    
    Bass bass = new Bass();
    Thread bassThread = new Thread(bass);
    bassThread.start();

    println("key is: " + key1);
    started = false;
  }
  
  // displays waveform and text describing loop after it has been started once
  if (startedOnce) {
    stroke(220);
    for (int i = 0; i < input.bufferSize() - 1; i++) {
      line(i, 440 + input.left.get(i)*120, i+1, 441 + input.left.get(i+1)*120);
    }  
    displayInfo();
  }
  
}

// sets up all gui elements for the intro screen.
public void customGUI(){
  listItems[0] = " Select Emotion";
  listItems[1] = " Happiness";
  listItems[2] = " Excitement";
  listItems[3] = " Peacefulness";
  listItems[4] = " Sadness";
  listItems[5] = " Nervousness";
  listItems[6] = " Anger";
  listItems[7] = " Fear";
  
  Font font = FontManager.getFont("Helvetica", Font.PLAIN, 18);
  emoList.setFont(font);
  emoList.setItems(listItems, 0);
  newMelBtn.setEnabled(false);
  newMelBtn.setVisible(false);
  playBtn.setEnabled(false);
  playBtn.setVisible(false);
  waitBtn.setEnabled(false);
  waitBtn.setVisible(false);
  reviewBtn.setEnabled(false);
  reviewBtn.setVisible(false);
  reviewWindow.setVisible(false);
  exitBtn.setEnabled(false);
  exitBtn.setVisible(false);
  emoList.setEnabled(false);
  emoList.setVisible(false);
}

//randomly chooses tempo from a range based on the emotion
private void chooseTempo() {
  if (emotion == 1) {
    tempo = (int)random(115, 131);
  } else if (emotion == 2) {
    tempo = (int)random(140, 156);
  } else if (emotion == 3) {
    tempo = (int)random(80, 96);
  } else if (emotion == 4) {
    tempo = (int)random(85, 101);
  } else if (emotion == 5) {
    tempo = (int)random(95, 111);
  } else if (emotion == 6) {
    tempo = (int)random(140, 156);
  } else if (emotion == 7) {
    tempo = (int)random(100, 116);
  }
  
  delay = (30000 / tempo);
}

// randomly chooses key
private void chooseKey() {
  key1 = (int)random(0, 12);
}

// chooses the pad based on the random number passed in, starts a thread for it, returns its name
private String choosePad(int num) {
  if (num == 1) {
    BasicSine sine = new BasicSine();
    Thread sineThread = new Thread(sine);
    sineThread.start();
    return sine.getName();
    
  } else if (num == 2) {
    Warmth warmth = new Warmth();
    Thread warmthThread = new Thread(warmth);
    warmthThread.start(); 
    return warmth.getName();
  
  } else {
    Saw saw = new Saw();
    Thread sawThread = new Thread(saw);
    sawThread.start(); 
    return saw.getName();
  }
  
}

// chooses the instrument based on the random number passed in, starts a thread for it, returns its name
private String chooseInstrument(int num) {
  if (num == 1) {
    Piano piano = new Piano();
    Thread pianoThread = new Thread(piano);
    pianoThread.start();
    return piano.getName();
    
  } else if (num == 2) {
    Violin violin = new Violin();
    Thread violinThread = new Thread(violin);
    violinThread.start(); 
    return violin.getName();
    
  } else if (num == 3) {
    Djembe djembe = new Djembe();
    Thread djembeThread = new Thread(djembe);
    djembeThread.start();
    return djembe.getName();
    
  } else if (num == 4) {
    Flute flute = new Flute();
    Thread fluteThread = new Thread(flute);
    fluteThread.start();
    return flute.getName();
    
  } else if (num == 5) {
    Glock glock = new Glock();
    Thread glockThread = new Thread(glock);
    glockThread.start();
    return glock.getName();
    
  } else if (num == 6) {
    Koto koto = new Koto();
    Thread kotoThread = new Thread(koto);
    kotoThread.start();
    return koto.getName();
    
  } else if (num == 7) {
    Harp harp = new Harp();
    Thread harpThread = new Thread(harp);
    harpThread.start();
    return harp.getName();
  }
  
  else if (num == 8 ) {
    Marimba marimba = new Marimba();
    Thread marimbaThread = new Thread(marimba);
    marimbaThread.start();
    return marimba.getName();
  }
  
  else if (num == 9) {
    EPiano epiano = new EPiano();
    Thread epianoThread = new Thread(epiano);
    epianoThread.start();
    return epiano.getName();
  }
  
  else {
    EKit ekit = new EKit();
    Thread ekitThread = new Thread(ekit);
    ekitThread.start();
    return ekit.getName();
  }
}

// displays all lines and text describing the loop
private void displayInfo() {
  textFont(font);
  fill(220);
  stroke(255);
  line(440, 276, 640, 276);
  line(240, 346, 640, 346);
  line(240, 206, 640, 206);
  line(440, 206, 440, 346);
  
  textSize(20);
  text("Instruments: ", 244, 229);
  text(pad, 244, 256);
  text(inst1, 244, 283);
  text(inst2, 244, 310);
  text("Bass", 244, 337);
  textSize(23);
  text("Key: " + keyMap.get(key1), 448, 247);
  text("Tempo: " + (30000 / delay) + " BPM", 448, 319);
  textSize(14);
  //text("Modifier: " + modifier, 580, 490);
  //text("Chords: " + chordList, 580, 510);
}

/* function to select notes for an instrument to play. picks one of three modifers,
   then based on that and the emotion, it picks a cluster of notes from the instNotes
   parameter to add into the notes parameter. instNotes contains all sound files for the
   instrument, notes is the set of notes it picks from when randomly generating */
public void selectNotes(SoundFile[] instNotes, ArrayList<SoundFile> notes) {
  println("selecting notes");
  if (emotion == 1 || emotion == 2 || emotion == 3) {
    modifier = (int)random(1, 4);
    
    // notes are in A-G# order, so it picks the position in the scale then adds the key
    // (represented as an int, also in A-G# order) to pick the right notes for the key
    for (int i = 0; i < instNotes.length; i++) {
      if (modifier == 1) {
        if (i == 0 || i == 4 || i == 7) {
          notes.add(instNotes[((i + key1) % 12)]);
        }
      } else if (modifier == 2) {
        if (i == 0 || i == 5 || i == 9) {
          notes.add(instNotes[((i + key1) % 12)]);
        }
      } else {
        if (i == 0 || i == 4 || i == 7 || i == 9) {
          notes.add(instNotes[((i + key1) % 12)]);
        }
      }
    }
   
  } else if (emotion == 4) {
    for (int i = 0; i < instNotes.length; i++) {
      modifier = (int)random(1, 4);
      if (modifier == 1) {
        if (i == 0 || i == 3 || i == 7 || i == 10) {
          notes.add(instNotes[((i + key1) % 12)]);
        }
      } else if (modifier == 2) {
        if (i == 0 || i == 3 || i == 5 || i == 8) {
          notes.add(instNotes[((i + key1) % 12)]);
        }
      } else {
        if (i == 2 || i == 3 || i == 7 || i == 10) {
          notes.add(instNotes[((i + key1) % 12)]);
        }
      }
    }
    
  } else {
    for (int i = 0; i < instNotes.length; i++) {
      modifier = (int)random(1, 4);
      if (modifier == 1) {
        if (i == 0 || i == 1 || i == 6 || i == 7) {
          notes.add(instNotes[((i + key1) % 12)]);
        }
      } else if (modifier == 2) {
        if (i == 3 || i == 4 || i == 9 || i == 10) {
          notes.add(instNotes[((i + key1) % 12)]);
        }
      } else {
        if (i == 0 || i == 1 || i == 4 || i == 7 || i == 10) {
          notes.add(instNotes[((i + key1) % 12)]);
        }
      }
    }
    
  }
}

/* function to select chords for a pad to play. picks one of 5 random chords, then based on'
   that and the emotion, it picks a chord (represented vertically in a 2d array) to add to the
   notes parameter. notes are taken from the instNotes parameter */
public void selectChords(SoundFile[] instNotes, SoundFile[][] notes) {
  if (emotion == 1 || emotion == 2 || emotion == 3) {
    for (int i = 0; i < notes.length; i++) {
      int randChord = (int)random(1, 6);
      chordList += randChord + " ";
      
      // similar to picking notes above: offsets the notes by the key
      if (randChord == 1) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((4 + key1) % 12)], instNotes[((7 + key1) % 12)]};
      } else if (randChord == 2) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((5 + key1) % 12)], instNotes[((9 + key1) % 12)]};
      } else if (randChord == 3) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((4 + key1) % 12)]};
      } else if (randChord == 4) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((7 + key1) % 12)]};
      } else {
        notes[i] = new SoundFile[]{instNotes[((5 + key1) % 12)], instNotes[((9 + key1) % 12)]};
      }
    }
    
  } else if (emotion == 4) {
    for (int i = 0; i < notes.length; i++) {
      int randChord = (int)random(1, 6);
      chordList += randChord + " ";
      
      if (randChord == 1) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((3 + key1) % 12)], instNotes[((7 + key1) % 12)]};
      } else if (randChord == 2) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((5 + key1) % 12)], instNotes[((8 + key1) % 12)]};
      } else if (randChord == 3) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((3 + key1) % 12)]};
      } else if (randChord == 4) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((7 + key1) % 12)]};
      } else {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((3 + key1) % 12)], instNotes[((10 + key1) % 12)]};
      }
    }
    
  } else {
    for (int i = 0; i < notes.length; i++) {
      int randChord = (int)random(1, 6);
      chordList += randChord + " ";
      
      if (randChord == 1) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((6 + key1) % 12)]};
      } else if (randChord == 2) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((7 + key1) % 12)]};
      } else if (randChord == 3) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((3 + key1) % 12)]};
      } else if (randChord == 4) {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((6 + key1) % 12)], instNotes[((9 + key1) % 12)]};
      } else {
        notes[i] = new SoundFile[]{instNotes[((key1) % 12)], instNotes[((3 + key1) % 12)], instNotes[((6 + key1) % 12)]};
      }
    }
  }
}

// adds all the notes to all the note arrays
private void createArrays() {
  sineNotes[0] = new SoundFile(this, "sineA3.wav");
  sineNotes[1] = new SoundFile(this, "sineA#3.wav");
  sineNotes[2] = new SoundFile(this, "sineB3.wav");
  sineNotes[3] = new SoundFile(this, "sineC3.wav");
  sineNotes[4] = new SoundFile(this, "sineC#3.wav");
  sineNotes[5] = new SoundFile(this, "sineD3.wav");
  sineNotes[6] = new SoundFile(this, "sineD#3.wav");
  sineNotes[7] = new SoundFile(this, "sineE3.wav");
  sineNotes[8] = new SoundFile(this, "sineF3.wav");
  sineNotes[9] = new SoundFile(this, "sineF#3.wav");
  sineNotes[10] = new SoundFile(this, "sineG3.wav");
  sineNotes[11] = new SoundFile(this, "sineG#3.wav");
  
  warmthNotes[0] = new SoundFile(this, "warmthA3.wav");
  warmthNotes[1] = new SoundFile(this, "warmthA#3.wav");
  warmthNotes[2] = new SoundFile(this, "warmthB3.wav");
  warmthNotes[3] = new SoundFile(this, "warmthC3.wav");
  warmthNotes[4] = new SoundFile(this, "warmthC#3.wav");
  warmthNotes[5] = new SoundFile(this, "warmthD3.wav");
  warmthNotes[6] = new SoundFile(this, "warmthD#3.wav");
  warmthNotes[7] = new SoundFile(this, "warmthE3.wav");
  warmthNotes[8] = new SoundFile(this, "warmthF3.wav");
  warmthNotes[9] = new SoundFile(this, "warmthF#3.wav");
  warmthNotes[10] = new SoundFile(this, "warmthG3.wav");
  warmthNotes[11] = new SoundFile(this, "warmthG#3.wav");
  
  sawNotes[0] = new SoundFile(this, "sawA3.wav");
  sawNotes[1] = new SoundFile(this, "sawA#3.wav");
  sawNotes[2] = new SoundFile(this, "sawB3.wav");
  sawNotes[3] = new SoundFile(this, "sawC3.wav");
  sawNotes[4] = new SoundFile(this, "sawC#3.wav");
  sawNotes[5] = new SoundFile(this, "sawD3.wav");
  sawNotes[6] = new SoundFile(this, "sawD#3.wav");
  sawNotes[7] = new SoundFile(this, "sawE3.wav");
  sawNotes[8] = new SoundFile(this, "sawF3.wav");
  sawNotes[9] = new SoundFile(this, "sawF#3.wav");
  sawNotes[10] = new SoundFile(this, "sawG3.wav");
  sawNotes[11] = new SoundFile(this, "sawG#3.wav");
  
  pianoNotes[0] = new SoundFile(this, "pianoA3.wav");
  pianoNotes[1] = new SoundFile(this, "pianoA#3.wav");
  pianoNotes[2] = new SoundFile(this, "pianoB3.wav");
  pianoNotes[3] = new SoundFile(this, "pianoC3.wav");
  pianoNotes[4] = new SoundFile(this, "pianoC#3.wav");
  pianoNotes[5] = new SoundFile(this, "pianoD3.wav");
  pianoNotes[6] = new SoundFile(this, "pianoD#3.wav");
  pianoNotes[7] = new SoundFile(this, "pianoE3.wav");
  pianoNotes[8] = new SoundFile(this, "pianoF3.wav");
  pianoNotes[9] = new SoundFile(this, "pianoF#3.wav");
  pianoNotes[10] = new SoundFile(this, "pianoG3.wav");
  pianoNotes[11] = new SoundFile(this, "pianoG#3.wav");
  
  violinNotes[0] = new SoundFile(this, "violinA3.wav");
  violinNotes[1] = new SoundFile(this, "violinA#3.wav");
  violinNotes[2] = new SoundFile(this, "violinB3.wav");
  violinNotes[3] = new SoundFile(this, "violinC3.wav");
  violinNotes[4] = new SoundFile(this, "violinC#3.wav");
  violinNotes[5] = new SoundFile(this, "violinD3.wav");
  violinNotes[6] = new SoundFile(this, "violinD#3.wav");
  violinNotes[7] = new SoundFile(this, "violinE3.wav");
  violinNotes[8] = new SoundFile(this, "violinF3.wav");
  violinNotes[9] = new SoundFile(this, "violinF#3.wav");
  violinNotes[10] = new SoundFile(this, "violinG3.wav");
  violinNotes[11] = new SoundFile(this, "violinG#3.wav");
  
  fluteNotes[0] = new SoundFile(this, "fluteA3.wav");
  fluteNotes[1] = new SoundFile(this, "fluteA#3.wav");
  fluteNotes[2] = new SoundFile(this, "fluteB3.wav");
  fluteNotes[3] = new SoundFile(this, "fluteC4.wav");
  fluteNotes[4] = new SoundFile(this, "fluteC#4.wav");
  fluteNotes[5] = new SoundFile(this, "fluteD4.wav");
  fluteNotes[6] = new SoundFile(this, "fluteD#4.wav");
  fluteNotes[7] = new SoundFile(this, "fluteE4.wav");
  fluteNotes[8] = new SoundFile(this, "fluteF4.wav");
  fluteNotes[9] = new SoundFile(this, "fluteF#4.wav");
  fluteNotes[10] = new SoundFile(this, "fluteG3.wav");
  fluteNotes[11] = new SoundFile(this, "fluteG#3.wav");
  
  glockNotes[0] = new SoundFile(this, "glockA3.wav");
  glockNotes[1] = new SoundFile(this, "glockA#3.wav");
  glockNotes[2] = new SoundFile(this, "glockB3.wav");
  glockNotes[3] = new SoundFile(this, "glockC4.wav");
  glockNotes[4] = new SoundFile(this, "glockC#4.wav");
  glockNotes[5] = new SoundFile(this, "glockD4.wav");
  glockNotes[6] = new SoundFile(this, "glockD#4.wav");
  glockNotes[7] = new SoundFile(this, "glockE4.wav");
  glockNotes[8] = new SoundFile(this, "glockF4.wav");
  glockNotes[9] = new SoundFile(this, "glockF#4.wav");
  glockNotes[10] = new SoundFile(this, "glockG4.wav");
  glockNotes[11] = new SoundFile(this, "glockG#3.wav");
  
  kotoNotes[0] = new SoundFile(this, "kotoA3.wav");
  kotoNotes[1] = new SoundFile(this, "kotoA#3.wav");
  kotoNotes[2] = new SoundFile(this, "kotoB3.wav");
  kotoNotes[3] = new SoundFile(this, "kotoC4.wav");
  kotoNotes[4] = new SoundFile(this, "kotoC#4.wav");
  kotoNotes[5] = new SoundFile(this, "kotoD4.wav");
  kotoNotes[6] = new SoundFile(this, "kotoD#4.wav");
  kotoNotes[7] = new SoundFile(this, "kotoE3.wav");
  kotoNotes[8] = new SoundFile(this, "kotoF3.wav");
  kotoNotes[9] = new SoundFile(this, "kotoF#3.wav");
  kotoNotes[10] = new SoundFile(this, "kotoG3.wav");
  kotoNotes[11] = new SoundFile(this, "kotoG#3.wav");
  
  harpNotes[0] = new SoundFile(this, "harpA3.wav");
  harpNotes[1] = new SoundFile(this, "harpA#3.wav");
  harpNotes[2] = new SoundFile(this, "harpB3.wav");
  harpNotes[3] = new SoundFile(this, "harpC4.wav");
  harpNotes[4] = new SoundFile(this, "harpC#4.wav");
  harpNotes[5] = new SoundFile(this, "harpD4.wav");
  harpNotes[6] = new SoundFile(this, "harpD#4.wav");
  harpNotes[7] = new SoundFile(this, "harpE3.wav");
  harpNotes[8] = new SoundFile(this, "harpF3.wav");
  harpNotes[9] = new SoundFile(this, "harpF#3.wav");
  harpNotes[10] = new SoundFile(this, "harpG3.wav");
  harpNotes[11] = new SoundFile(this, "harpG#3.wav");
  
  marimbaNotes[0] = new SoundFile(this, "marimbaA3.wav");
  marimbaNotes[1] = new SoundFile(this, "marimbaA#3.wav");
  marimbaNotes[2] = new SoundFile(this, "marimbaB3.wav");
  marimbaNotes[3] = new SoundFile(this, "marimbaC3.wav");
  marimbaNotes[4] = new SoundFile(this, "marimbaC#3.wav");
  marimbaNotes[5] = new SoundFile(this, "marimbaD3.wav");
  marimbaNotes[6] = new SoundFile(this, "marimbaD#3.wav");
  marimbaNotes[7] = new SoundFile(this, "marimbaE3.wav");
  marimbaNotes[8] = new SoundFile(this, "marimbaF3.wav");
  marimbaNotes[9] = new SoundFile(this, "marimbaF#3.wav");
  marimbaNotes[10] = new SoundFile(this, "marimbaG3.wav");
  marimbaNotes[11] = new SoundFile(this, "marimbaG#3.wav");
  
  epianoNotes[0] = new SoundFile(this, "epianoA2.wav");
  epianoNotes[1] = new SoundFile(this, "epianoA#2.wav");
  epianoNotes[2] = new SoundFile(this, "epianoB2.wav");
  epianoNotes[3] = new SoundFile(this, "epianoC3.wav");
  epianoNotes[4] = new SoundFile(this, "epianoC#3.wav");
  epianoNotes[5] = new SoundFile(this, "epianoD3.wav");
  epianoNotes[6] = new SoundFile(this, "epianoD#3.wav");
  epianoNotes[7] = new SoundFile(this, "epianoE3.wav");
  epianoNotes[8] = new SoundFile(this, "epianoF3.wav");
  epianoNotes[9] = new SoundFile(this, "epianoF#3.wav");
  epianoNotes[10] = new SoundFile(this, "epianoG3.wav");
  epianoNotes[11] = new SoundFile(this, "epianoG#2.wav");
  
  bassNotes[0] = new SoundFile(this, "bassA1.wav");
  bassNotes[1] = new SoundFile(this, "bassA#1.wav");
  bassNotes[2] = new SoundFile(this, "bassB1.wav");
  bassNotes[3] = new SoundFile(this, "bassC1.wav");
  bassNotes[4] = new SoundFile(this, "bassC#1.wav");
  bassNotes[5] = new SoundFile(this, "bassD1.wav");
  bassNotes[6] = new SoundFile(this, "bassD#1.wav");
  bassNotes[7] = new SoundFile(this, "bassE1.wav");
  bassNotes[8] = new SoundFile(this, "bassF1.wav");
  bassNotes[9] = new SoundFile(this, "bassF#1.wav");
  bassNotes[10] = new SoundFile(this, "bassG1.wav");
  bassNotes[11] = new SoundFile(this, "bassG#1.wav");
  
  djembeNotes[0] = new SoundFile(this, "djembe1.wav");
  djembeNotes[1] = new SoundFile(this, "djembe2.wav");
  djembeNotes[2] = new SoundFile(this, "djembe3.wav");
  djembeNotes[3] = new SoundFile(this, "djembe4.wav");
  djembeNotes[4] = new SoundFile(this, "djembe5.wav");
  djembeNotes[5] = new SoundFile(this, "djembe6.wav");
  
  ekitNotes[0] = new SoundFile(this, "kitkick.wav");
  ekitNotes[1] = new SoundFile(this, "kitsnare.wav");
  ekitNotes[2] = new SoundFile(this, "kithat.wav");
  
  noiseFile = new SoundFile(this, "static.wav");
  
  //initializes the maps for emotion and key
  keyMap = new HashMap<Integer, String>();
  keyMap.put(0, "A");
  keyMap.put(1, "A#");
  keyMap.put(2, "B");
  keyMap.put(3, "C");
  keyMap.put(4, "C#");
  keyMap.put(5, "D");
  keyMap.put(6, "D#");
  keyMap.put(7, "E");
  keyMap.put(8, "F");
  keyMap.put(9, "F#");
  keyMap.put(10, "G");
  keyMap.put(11, "G#");
  
  emoMap = new HashMap<Integer, String>();
  emoMap.put(1, "Happiness");
  emoMap.put(2, "Excitement");
  emoMap.put(3, "Peacefulness");
  emoMap.put(4, "Sadness");
  emoMap.put(5, "Nervousness");
  emoMap.put(6, "Anger");
  emoMap.put(7, "Fear");
}
