

/*

lorentz attractor

x' = s * (y - x)
y' = x * (r - z) - y
z' = x * y - b * z

*/


// select and enter
// change the code while running


(
Ndef(\x, {
	LorenzL.ar(
		freq: SampleRate.ir,
		s: 10,
		r: MouseX.kr(16, 20),
		b: 1.3,
		h: 0.03,
		xi: 0.1,
		yi: 0,
		zi: 0
	) * 0.1 ! 2
}).play
)


// cursor coordinates control two parameters
(
Ndef(\x, {
	LorenzL.ar(
		freq: SampleRate.ir,
		s: 10,
		r: 28,
		b: MouseX.kr(0.2, 2.667),
		h: MouseY.kr(0.001, 0.1),
		xi: 0.1,
		yi: 0,
		zi: 0
	) * 0.1 ! 2
}).play
)


// here we listen to two systems, one each stereo channel
(
Ndef(\x, {
	LorenzL.ar(
		freq: SampleRate.ir,
		s: 10,
		r: 28,
		b: [MouseX.kr(0.2, 2.8), MouseY.kr(0.2, 2.8)],
		h: 0.04,
		xi: 0.1,
		yi: 0,
		zi: 0
	) * 0.2
}).play
)


// here, we modulate a sine signal with the dynamical system
(
Ndef(\x, {
	var sig;
	sig = LorenzL.ar(
		freq: 1230,
		b: [MouseX.kr(0.2, 2.8), MouseY.kr(0.2, 2.8)],
		h: 0.04,
	);
	SinOsc.ar(sig.linlin(0, 1, 200, 11000)) * 0.1
}).play
)




// we simplify a little.

// preparation for a jam
// your system may ask for permissions
(
NetAddr.broadcastFlag = true;
~net = NetAddr("255.255.255.255", 57120);
~share = { |value, group = 0| ~net.sendMsg("/share", value, group) };
~myGroup = [1, 2].choose;
"my group: %".format(~myGroup).postln;
OSCdef(\x, { |msg|
	var doIt, value, group;
	value = msg[1]; group = msg[2];
	doIt = group == 0 or: { group == ~myGroup };
	if(doIt) { Ndef(\x).set(\c, value) };
}, "/share").add.fix;
)


(
Ndef(\x, { |c = 1|
	LorenzL.ar(
		freq: SampleRate.ir,
		b: c.linlin(0, 1, 0.2, 2.667) + [0, 0.01],
		h: 0.04,
	) * 0.1
}).play
)



Ndef(\x).set(\c, 1.0.rand); // set your own, random value
Ndef(\x).fadeTime = 1; // crossfade between code

~share.(1.0.rand); // sent to all
~share.(1.0.rand, 1); // sent to all
~share.(1.0.rand, 2); // sent to all


// here we listen to the system
(
Ndef(\x, { |c = 1|
	LorenzL.ar(
		freq: SampleRate.ir,
		b: c.linlin(0, 1, 0.2, 2.667) + [0, 0.01],
		h: 0.04,
	) * 0.1
}).play
)


// here, we modulate a sine signal with the dynamical system
(
Ndef(\x, { |c = 1|
	var sig;
	sig = LorenzL.ar(
		freq: 1330,
		b: c.linlin(0, 1, 0.2, 2.667) + [0, 0.01],
		h: 0.04,
	);
	SinOsc.ar(sig.linlin(0, 1, 200, 6000)) * 0.1
}).play
)

~share.(0.1); // sent to all
~share.(0.12); // sent to all






