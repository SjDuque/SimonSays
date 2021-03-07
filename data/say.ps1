param(
    [string] $v = "Zira", 
    [int] $r = 0, 
    [string] $f,
    [Parameter(ValueFromRemainingArguments = $true, Position=1)] $toSay = 'Bananas are cool'
);

Add-Type -AssemblyName System.Speech; 
$SAY = New-Object System.Speech.Synthesis.SpeechSynthesizer; 
$SAY.SelectVoice("Microsoft $v Desktop");
$SAY.Rate = $r;

if($f) {
    $SAY.SetOutputToWaveFile($f)
}

$SAY.Speak($toSay);