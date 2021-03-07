Kinect kinect;
SimonImage simImg;
Simon simon; 
Sound sound;
String name = "SIMONE";
color green_back = color(32, 128, 32);
color red_back = color(128, 32, 32);
color gray_back = color(16, 16, 16);
color background = gray_back;
boolean simonPlay = false;


void setup() {
    size(1280, 960);
    frameRate(60);
    simImg = new SimonImage(width/3, 0, height/2, 5);
    kinect = new Kinect(0, height/2);
    simon = new Simon();
    sound = new Sound();
}

void draw() {
    background(background);
    
    kinect.update();
    simImg.update();
    simon.update();
}

void keyReleased() {
    if (key == 's' || key == 'S')
        simonPlay = !simonPlay;
        
}
