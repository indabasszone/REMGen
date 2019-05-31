//interface used to group all synths together, each must have getName() method

interface Synth extends Runnable {
  String getName();
}
