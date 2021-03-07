int transparent = 128;
color[] green = {color(20, 128, 20, transparent), color(0, 255, 0, transparent)};
color[] red = {color(128, 20, 20, transparent), color(255, 0, 0, transparent)};
color[] yellow = {color(128, 128, 20, transparent), color(255, 255, 0, transparent)};
color[] cyan = {color(20, 128, 128, transparent), color(0, 255, 255, transparent)};

color[][] colors = {green, red, yellow, cyan};



public class SimonImage {
    int imgSize;
    
    PImage eyeImg;
    PFont font;
    int prevLitUp = 0;
    float x, y;
    int hsbCount = 0;
    int frameRate;
    
    float timeCount = 0;
    int lastMillis;
    
    public SimonImage(float x, float y, int imgSize, int frameRate){
        this.x = x;
        this.y = y;
        
        this.imgSize = imgSize;
        this.eyeImg = loadImage("green_eye_flip.jpg");
        this.eyeImg.resize(imgSize, imgSize);
        this.font = createFont("RussoOne.ttf", 32);
        this.frameRate = frameRate;
        this.lastMillis = millis();
    }
    
    public void update() {
        noStroke();
        
        int curMillis = millis();
        timeCount += (curMillis - lastMillis) * 0.001f;
        lastMillis = curMillis;
        
        image(eyeImg, x, y);
        
        ///////////////////////////////////////////////////////////////
        //
        // Decide which color to light up
        //
        ///////////////////////////////////////////////////////////////
        
        ///////////////////////////////////////////////////////////////
        //
        // Draw all the colors as quarter circles
        //
        ///////////////////////////////////////////////////////////////
        int litUp;
        if (timeCount > 1f/frameRate){
            timeCount -= 1f/frameRate;  
            
            do {
                litUp = int(random(4));
            } while (litUp == prevLitUp);
            
            prevLitUp = litUp;
        } 
        else { litUp = prevLitUp; }
        
        for (int i = 0; i < 4; i++){
            if (litUp == i)
                fill(colors[i][1]);
            else 
                fill(colors[i][0]);
                
            arc(imgSize/2 + x, imgSize/2 + y, imgSize * 53 / 100, imgSize * 53 / 100, PI/2 * i, PI/2 * (i+1));
        }
            
        ///////////////////////////////////////////////////////////////
        //
        // Draw center block
        //
        ///////////////////////////////////////////////////////////////
        
        fill(0);
        circle(imgSize/2 +x, imgSize/2 + y, imgSize/5);
        
        ///////////////////////////////////////////////////////////////
        //
        // Change to HSB to make a rainbow color change for the name
        //
        ///////////////////////////////////////////////////////////////
        colorMode(HSB);
        
        float time = radians(millis() / 33);
        fill(255 * (0.5*cos(time) + 0.5), 255, 255);
        
        ///////////////////////////////////////////////////////////////
        //
        // Draw text
        //
        ///////////////////////////////////////////////////////////////
        
        textFont(font);
        textAlign(CENTER, CENTER);    
        textSize(imgSize/23);
        text(name, imgSize / 2 + x, imgSize * 49 / 100 + y);
        
        colorMode(RGB);
    }
}
