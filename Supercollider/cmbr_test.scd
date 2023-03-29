
(
var filepath = "C:/Users/swimt/Dropbox (University of Michigan)/Capstone/Capstone/Supercollider/cmbr_5year.wav";

c = Buffer.read(s, filepath);
)
c.duration/256;
(
{
	var sig,freq;
	freq = 1;
	sig = GrainBuf.ar(
		2, //stereo
		Impulse.ar(MouseX.kr(60,1200)),
		c.duration/256,
		c,
		1,
		MouseY.kr(0,1),
		2,
		0
	);
}.play;
)

{Osc.ar(sig, MouseX.kr(0.001,10000,1), mul:0.2!2)}.play;

s.boot;