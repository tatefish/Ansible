SerialPort.listDevices;
s.boot;
//in case of error copy this into terminal:
//echo /usr/bin/jackd -P75 -p16 -dalsa -dhw:0 -r44100 -p1024 -n3 > ~/.jackdrc

//setup the serial port and other things
(
~port = SerialPort(
	"/dev/ttyACM0",
	baudrate: 9600,
	crtscts: true
);
~pitchmida = 55;
~pitchmidb = 55;
~pitchmidc = 55;
~atak = 0.5;
~rele = 0.2;
~tempo = 12
)

//set up CMRB information
(
//generate the wavetable samples
var filepath = "/home/tatefish/Documents/ansible_work/Capstone/Supercollider/cmbr_5year_adj.wav";
~cmbrW = Array.new;
256.do{
	arg item;
	~cmbrW = ~cmbrW.add(Buffer.read(s,filepath,item*512, 512,bufnum:item));
};
)

//synthdef
(SynthDef.new(\cmbrwt, {
	arg out=0, bufoffset=0, freqa=100,freqb=200, freqc=300,amp = 0.25, atk=0.05, rel=0.3, warb = 0.08, cutoff = 125;
	var env, sig;
	//env = EnvGen.kr(Env.new([0,
		//amp,0], [atk, rel],[1,-1]), doneAction:0);
	sig = VOsc3.ar(bufoffset,freqa,freqb,freqc,amp);
	sig = RLPF.ar(sig, cutoff.lag(0.02, 0.25, 0.2);
	Out.ar(out,sig)
	)
}).add;)

//reading from arduino
(
~charArray = [];
~getValues = Routine.new({
	var ascii;
	{
		ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a, {
				~potV = ~charArray.collect(_.digit).convertDigits;
				~charArray = [];
		});
		if(ascii == $b, {
				~butn = ~charArray.collect(_.digit).convertDigits;
				~charArray = [];
		});
		if(ascii == $c, {
				~count = ~charArray.collect(_.digit).convertDigits;
				~charArray = [];
			if(~butn == 0, {~pitchmida = ~count});
			if(~butn == 1, {~pitchmidb = ~count});
			if(~butn == 2, {~pitchmidc = ~count});
			if(~butn == 3, {~ampl = ~count.linlin(0,127,0, 0.25)});
			if(~butn == 4, {~cutoff = ~count.linexp(0,127,60,6000)});
		});
	}.loop;
}).play;
)

//the meat

(
~cmbr = Synth(\cmbrwt);
~control = Routine.new({
	{
		~cmbr.set(
			\freqa, ~pitchmida.midicps,
			\freqb, ~pitchmidb.midicps,
			\freqc, ~pitchmidc.midicps,
			\bufoffset, ~potV.linlin(0, 1023, 2, 254),
		);
		0.01.wait;
	}.loop;

}).play;
)
s.stop;
//cleanup
(~getValues.stop;
~control.stop;
)
~cmbr.free;
