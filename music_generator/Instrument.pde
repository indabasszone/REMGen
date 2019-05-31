//interface used to group all instruments together, each must have getName() method

interface Instrument extends Runnable {
  String getName();
}
