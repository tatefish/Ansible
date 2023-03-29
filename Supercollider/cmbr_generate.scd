//garbage zone


//startup
(
s.boot;
)
(
//generate the wavetable samples
var filepath = "C:/Users/swimt/Dropbox (University of Michigan)/Capstone/Capstone/Supercollider/cmbr_5year.wav";
~cmbrW = Array.new;
256.do{
	arg item;
	~cmbrW = ~cmbrW.add(Buffer.read(s,filepath,item*512, 512,bufnum:item));
};
)


//create the wavetable SynthDef
(SynthDef.new(\cmbrwt, {
	arg out=0, bufoffset=0, freq=100,amp = 0.25, atk=0.5, rel=50, x=0;
	var env;
	x = MouseX.kr(0,255);
	env = EnvGen.kr(Env.new([0,amp,0], [atk, rel],[1,-1]), doneAction:0);
	Out.ar(out,
		VOsc3.ar(bufoffset+x,110,220,440,env)
	)
}).add;)

//GUI work

//Demo 1

//Demo 2

//Demo 3



//cleanup
(
Server.killAll;
p.stop;
)

