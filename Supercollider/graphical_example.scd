(
var size = 512;
var canvas, wave, lastPos, lastVal;

w = Window("Wavetable", Rect(100, 100, 1024, 500)).front;
wave = Signal.sineFill(size, [1]);
b = Buffer.alloc(s, size * 2); // double the size for the wavetable

Slider(w, Rect(0, 5, 1024, 20)).action_({|sl| x.set(\freq, sl.value*1000)});
  UserView(w, Rect(0, 30, 1024, 470))
    .background_(Color.black)
    .animate_(true)
    .mouseMoveAction_({ |me, x, y, mod, btn|
       var pos = (size * (x / me.bounds.width)).floor;
       var val = (2 * (y / me.bounds.height)) - 1;
       val = min(max(val, -1), 1);
       wave.clipPut(pos, val);
       if(lastPos != nil, {
           for(lastPos + 1, pos - 1, { |i|
               wave.clipPut(i, lastVal + (((i - lastPos) / (pos - lastPos)) * (val - lastVal)));
           });
           for(pos + 1, lastPos - 1, { |i|
               wave.clipPut(i, lastVal + (((i - lastPos) / (pos - lastPos)) * (val - lastVal)));
           });
       });
       lastPos = pos;
       lastVal = val;
       b.loadCollection(wave.asWavetable);
       })
       .mouseUpAction_({
           lastPos = nil;
          lastVal = nil;
       })
       .drawFunc_({ |me|
             Pen.color = Color.white;
           Pen.moveTo(0@(me.bounds.height * (wave[0] + 1) / 2));
           for(1, size - 1, { |i, a|
               Pen.lineTo((me.bounds.width * i /size)@(me.bounds.height * (wave[i] + 1)/2))
           });
           Pen.stroke;
       });
b.loadCollection(wave.asWavetable);
x = {arg freq=440; Osc.ar(b, freq) *0.4 ! 2 }.play;
)