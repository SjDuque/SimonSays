import ddf.minim.*; 
Minim minim = new Minim(this);

public class Sound {
    AudioPlayer correct;
    AudioPlayer incorrect;
    
    public Sound() {
        correct = minim.loadFile("correct.mp3");
        incorrect = minim.loadFile("incorrect.mp3");
        
        correct.setGain(-10);
        incorrect.setGain(-10);
    }
    
    public Action countDown(){
        return say("3... 2. 1...", "Zira", -5);
    }
    
    public Action say (String phrase) {
        return say(phrase, "Zira", 0);
    }
    
    public Action say (String phrase, int rate) {
        return say(phrase, "Zira", rate);
    }
    
    public Action say (String phrase, String voice) {
        return say(phrase, voice, 0);
    }
    
    public Action say (String phrase, String voice, int rate) {
        return new Action(Speech.say(phrase, voice, rate));
    }
    
    public Action correct(){
        correct.rewind();
        correct.play();
        return new Action(correct);
    }
    
    public Action incorrect(){
        incorrect.rewind();
        incorrect.play();
        return new Action(incorrect);
    }
}
