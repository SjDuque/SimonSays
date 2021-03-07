import SimpleOpenNI.*;

SimpleOpenNI openNI = new SimpleOpenNI(this);

public class Kinect {
    // Translated x and y
    float x = 0;
    float y = 0;
    
    // Used to find center of the mass
    PVector com = new PVector();
    PVector com2d = new PVector();
    
    // Confidence threshold for joints
    float confThres = 0.5;
    
    final int width, height;
    
    // Constructor
    public Kinect(){
        this(0, 0);
    }
    
    
    public Kinect(float translateX, float translateY) {
        x = translateX;
        y = translateY;
        openNI.enableRGB();
        openNI.enableDepth();
        openNI.enableUser();
        openNI.setMirror(false);
        this.width = openNI.userWidth();
        this.height = openNI.userHeight();
    }
    
    // Call to update and draw skeleton
    public void update() {
        openNI.update();

        image(openNI.userImage(), x, y);
        image(openNI.rgbImage(), openNI.depthWidth() + x, y);
        
        int[] users = openNI.getUsers();
        
        for (int userID : users)
            if(openNI.isTrackingSkeleton(userID)) {
                //Draw the skeleton
                drawSkeleton(userID);
                //Draw the user's center mass
                massUser(userID);
            }
    }
    
    public int getNumUsers(){
        return openNI.getNumberOfUsers();
    }
    
    public PVector[] getJoint(int jointID) {
        int[] users = openNI.getUsers();
        
        PVector[] userJoints = new PVector[users.length];
        
        for (int i = 0; i < userJoints.length; i++){
            int userID = users[i];
            userJoints[i] = getJoint(userID, jointID);
        }
        
        return userJoints;
    }
    
    public PVector getJoint(int userID, int jointID){
        if(!openNI.isTrackingSkeleton(userID)) {
            return null;
        }
        PVector joint = new PVector();
        
        if(openNI.getJointPositionSkeleton(userID, jointID, joint) < confThres){
            return null;
        }
        
        PVector converted = new PVector();
        openNI.convertRealWorldToProjective(joint, converted);
        
        return converted;
    }
    
    // Draw the skeleton
    public void drawSkeleton(int userID) {
        stroke(0);
        strokeWeight(5);
        
        drawLimb(userID, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
        drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
        drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
        drawLimb(userID, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
        drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
        drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
        drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
        drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
        drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
        drawLimb(userID, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
        drawLimb(userID, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
        drawLimb(userID, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
        drawLimb(userID, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
        drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
        drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
        drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
        
        noStroke();
        fill(255,0,0);
        
        drawJoint(userID, SimpleOpenNI.SKEL_HEAD);
        drawJoint(userID, SimpleOpenNI.SKEL_NECK);
        drawJoint(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER);
        drawJoint(userID, SimpleOpenNI.SKEL_LEFT_ELBOW);
        drawJoint(userID, SimpleOpenNI.SKEL_NECK);
        drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
        drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW);
        drawJoint(userID, SimpleOpenNI.SKEL_TORSO);
        drawJoint(userID, SimpleOpenNI.SKEL_LEFT_HIP);
        drawJoint(userID, SimpleOpenNI.SKEL_LEFT_KNEE);
        drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_HIP);
        drawJoint(userID, SimpleOpenNI.SKEL_LEFT_FOOT);
        drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_KNEE);
        drawJoint(userID, SimpleOpenNI.SKEL_LEFT_HIP);
        drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_FOOT);
        drawJoint(userID, SimpleOpenNI.SKEL_RIGHT_HAND);
        drawJoint(userID, SimpleOpenNI.SKEL_LEFT_HAND);
    }
    
    public void drawLimb(int userID, int jointID1, int jointID2){
        PVector joint1 = new PVector();
        PVector joint2 = new PVector();
        
        float confidence1 = openNI.getJointPositionSkeleton(userID, jointID1, joint1);
        float confidence2 = openNI.getJointPositionSkeleton(userID, jointID2, joint2);
        
        if (confidence1 < confThres || confidence2 < confThres) return;
        
        PVector convertedJoint1 = new PVector();
        PVector convertedJoint2 = new PVector();
        
        openNI.convertRealWorldToProjective(joint1, convertedJoint1);
        openNI.convertRealWorldToProjective(joint2, convertedJoint2);
        
        line(convertedJoint1.x+x, convertedJoint1.y+y, convertedJoint2.x+x, convertedJoint2.y+y);
    }
    
    public void drawJoint(int userID, int jointID) {
        PVector joint = new PVector();
        float confidence = openNI.getJointPositionSkeleton(userID, jointID,
                                                           joint);
        if(confidence < confThres) {
                return;
        }
        PVector convertedJoint = new PVector();
        openNI.convertRealWorldToProjective(joint, convertedJoint);
        ellipse(convertedJoint.x+x, convertedJoint.y+y, 5, 5);
    }
    
    public void massUser(int userID) {
        if (openNI.getCoM(userID, com)) {
            openNI.convertRealWorldToProjective(com, com2d);
            stroke(100, 255, 240);
            strokeWeight(3);
            beginShape(LINES);
            vertex(com2d.x + x, com2d.y - 5 + y);
            vertex(com2d.x + x, com2d.y + 5 + y);
            vertex(com2d.x - 5 +x, com2d.y + y);
            vertex(com2d.x + 5 +x, com2d.y + y);
            endShape();
            fill(0, 255, 100);
            text(Integer.toString(userID), com2d.x + x, com2d.y + y);
        }
    }
}

// Tracking
void onNewUser(SimpleOpenNI openNI, int userID) {
    println("Found User: " + userID);
    openNI.startTrackingSkeleton(userID);
}

void onLostUser(SimpleOpenNI openNI, int userID) {
    println("Lost User: " + userID);
    openNI.stopTrackingSkeleton(userID);
}
