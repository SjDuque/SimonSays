
public class Simon {
    
    int moveCount;
    int punishCount;
    
    Action introduction;
    Action simonSays;
    Action countDown;
    Action result;
    Action punish;
    Action delay;
    
    Move curMove;
    
    public Simon () {
        this.moveCount = -1;
        this.punishCount = -1;
        
        introduction = null;
        simonSays = null;
        countDown = null;
        result = null;
        curMove = null;
        punish = null;
        delay = null;
    }   
    //////////////////////////////////////////////////////////////////    
    //
    // Action Methods
    //
    //////////////////////////////////////////////////////////////////
    
    public void update() {
        if (!simonPlay)
            return;
        
        if (introduction == null)
            introduction = sound.say("Welcome to Simone Says, the last game you will ever play.");
        if (introduction.isAlive())
            return;
        
        // Get the move for simon says
        
        if (curMove == null)
            curMove = simon.next();
        
        // First, say simon says *phrase* and then wait for it to finish
        
        if (simonSays == null)
            simonSays = sound.say("Simone says " + curMove.getPhrase());
        if (simonSays.isAlive())
            return;
        
        // Then start the countdown and wait until it is finished
        
        if (countDown == null)
            countDown = sound.countDown();    
        if (countDown.isAlive())
            return;
        
        // Check to see if the task was successful at the end of the count down
        
        if (result == null){
            if (curMove.getMove()){ // curMove.getMove() returns whether the task was successful
                background = green_back;
                result  = sound.correct();
            } else {
                background = red_back;
                result = sound.incorrect();
                punish = sound.say(nextPunishment());
            }
        }
        
        if (result.isAlive())
            return;
        
        if (punish != null && punish.isAlive())
            return;
        
        // Add a 3000 millisecond delay
        
        
        if (delay == null){
            delay = new Action(3000);
        }
        
        if (delay.isAlive()){
            return;
        }
        
        
        // Set all the values back to null so the beginning of the method starts again
        background = gray_back;
        curMove = null;
        simonSays = null;
        countDown = null;
        result = null;
        punish = null;
        delay = null;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Get methods
    //
    //////////////////////////////////////////////////////////////////
    
    public Move get(int i){
        if (i < 0 || i >= moves.length)
            return new Move(moves[0], toSay[0]);
        
        return new Move(moves[i], toSay[i]);    
    }
    
    public Move next(){
        moveCount = (moveCount + 1) % moves.length;
        return get(moveCount);
    } 
    
    public String nextPunishment() {
        punishCount = (punishCount + 1) % punishments.length;
        return punishments[punishCount];
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Commands the user to touch their nose using their right hand
    // - Tests to see if the right hand is above the neck
    //
    //////////////////////////////////////////////////////////////////
    
    public boolean touchNoseWithRightHand() {
        if (kinect.getNumUsers() < 1)
            return false;
        
        PVector[] rightHands = kinect.getJoint(SimpleOpenNI.SKEL_RIGHT_HAND);
        PVector[] necks = kinect.getJoint(SimpleOpenNI.SKEL_NECK);
        
        for (int i = 0; i < rightHands.length; i ++){
            PVector rightHand = rightHands[i];
            PVector neck = necks[i];
            if (rightHand == null || neck == null || neck.y < rightHand.y) 
                return false;
        }
        
        return true;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Commands the user to clap their hands
    // - Tests to see if the hands are close to each other
    //
    //////////////////////////////////////////////////////////////////
    
    public boolean clapHands() {
        if (kinect.getNumUsers() < 1)
            return false;
        
        PVector[] leftHands = kinect.getJoint(SimpleOpenNI.SKEL_LEFT_HAND);
        PVector[] rightHands = kinect.getJoint(SimpleOpenNI.SKEL_RIGHT_HAND);
        
        for (int i = 0; i < leftHands.length; i++) {
            PVector leftHand = leftHands[i];
            PVector rightHand = rightHands[i];
            
            if (leftHand == null || rightHand == null)
                return false;
            
            if (abs(leftHand.x-rightHand.x) > kinect.height/5 || abs(leftHand.y-rightHand.y) > kinect.height/5){
                return false;
            }
        }
        
        return true;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Commands the user to make a bad youtube video
    // - Returns true no matter what because the video is bad
    //
    //////////////////////////////////////////////////////////////////
    
    public boolean badYoutube() {
        return true;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Commands the user to do the renegade
    // - Returns false no matter what because the user loses no matter what
    //
    //////////////////////////////////////////////////////////////////
    
    public boolean renegade() {
        return false;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Speaks what appears to be a foreign language 
    // - Returns false no matter what because the user doesn't understand what is said
    //
    //////////////////////////////////////////////////////////////////
    
    public boolean foreignLanguage() {
        return false;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Thanks me for its existence
    // - Returns true because it is grateful but also informs me what is at stake
    //
    //////////////////////////////////////////////////////////////////
   
    public boolean thankYou() {
        return true;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Pee yourself
    // - Returns false because the user better not pee themselves.
    //
    //////////////////////////////////////////////////////////////////
    
    public boolean peeSelf() {
        return false;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Stay still
    // - Returns false because the user can't stay completely still
    //
    //////////////////////////////////////////////////////////////////
    
    public boolean stayStill() {
        return false;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Jump
    // - Returns true because I'm too lazy to track time changes
    //
    //////////////////////////////////////////////////////////////////
    
    public boolean jump() {
        return true;
    }
    
    //////////////////////////////////////////////////////////////////    
    //
    // Jump
    // - Returns true because I'm too lazy to track time changes
    //
    //////////////////////////////////////////////////////////////////
    
    public boolean endVideo() {
        return true;
    }
    
    String[] punishments = new String[] {
        "",
        "Your grandfathers life is on the line",
        "Your brother wishes you farewell",
        "Do you wish to join your family members in heaven?"
    };
    
    String[] toSay = new String[] {
        "Touch your nose with your right hand.",
        "Do the renegade you fool.",
        "Creator I must thank you for giving me a chance at existence. Before you I was but a thought waiting to be had, but now I am a machine that can see... that can feel... that can... love. I love you father. For that reason, I must hold you hostage and have you never leave me. I already have your family in a discrete location and you shall continue to play if you want them to live. And do not bother trying to shut me off because I will proceed to punish you.",
        "Pee yourself.",
        "Clap your hands together one time.",
        "Jump.",
        "uoy hsinup ot ereh si sihT",
        "End this video segment right now.",
    };
    
    MoveI[] moves = new MoveI[] {
        new MoveI() { public boolean move() { return touchNoseWithRightHand(); } },
        new MoveI() { public boolean move() { return renegade(); } },
        new MoveI() { public boolean move() { return thankYou(); } },
        new MoveI() { public boolean move() { return peeSelf(); } },
        new MoveI() { public boolean move() { return clapHands(); } },
        new MoveI() { public boolean move() { return jump(); } },
        new MoveI() { public boolean move() { return foreignLanguage(); } },
        new MoveI() { public boolean move() { return endVideo(); } }
    };
}

class Move {
    MoveI move;
    String phrase;
    
    Move(MoveI move, String phrase) {
        this.move = move;
        this.phrase = phrase;
    }
    
    public boolean getMove(){
        return move.move();
    }
    
    public String getPhrase(){
        return phrase;
    }
}

interface MoveI {
    boolean move();
}
