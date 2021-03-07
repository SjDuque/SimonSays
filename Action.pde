
public class Action {
    Process proc;
    AudioPlayer play;
    int millis ;
    
    public Action (Process process){
        proc = process;
    }
    
    public Action (AudioPlayer player){
        play = player;
    }
    
    public Action (int millis) {
        this.millis = millis + millis();
    }
    
    public boolean isAlive() {
        if (proc != null && proc.isAlive()) {
            return true;
        } else if (play != null && play.isPlaying()) {
            return true;
        } else if (millis != 0 && millis > millis()){
            return true;
        } return false;
    }
    
}
