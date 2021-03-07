public static class Speech {
  
    // Male voices
    static final String DAVID = "David";
    
    // Female voices
    static final String HAZEL = "Hazel";
    static final String ZIRA = "Zira";
    
    // Array of voices to select one at random
    public static String[] voices = {
      DAVID, HAZEL, ZIRA
    };
     
    // Runs a command that uses Windows built in text to speech
    public static Process say(String script, String voice, int speed) {
    	try {
    		return Runtime.getRuntime().exec(
                    "PowerShell -Command "
            .concat("Add-Type -AssemblyName System.Speech; ") 
            .concat("$SAY = New-Object System.Speech.Synthesis.SpeechSynthesizer; ")
            .concat(String.format("$SAY.SelectVoice('Microsoft %s Desktop'); ", voice))
            .concat(String.format("$SAY.Rate =%2d; ", speed))
            .concat(String.format("$SAY.Speak('%s\');", script))
            );
    	}
    	catch (Exception e) {
        	System.err.println("Say method");
    	}
        return null;
	}

	// Overload say method with defaults
	public static Process say(String script) {
    	return say(script, ZIRA, 0);
	}
}
