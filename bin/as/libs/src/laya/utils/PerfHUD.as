package laya.utils {
	import laya.display.Sprite;
	import laya.display.SpriteConst;
	import laya.resource.Context;
	public class PerfHUD extends Sprite {
		private static var _lastTm:Number = 0;	//perf Data
		private static var _now:Number = 0;
		private var datas:Array = [];
		public static var DATANUM:int = 300;
		
		public var xdata:Array = new Array(DATANUM);
		public var ydata:Array = new Array(DATANUM);
		
		public var hud_width:int =800;
		public var hud_height:int = 200;
		
		public var gMinV:Number = 0;
		public var gMaxV:Number = 100;
		
		private var textSpace:Number = 40;	//留给刻度文字的
		public static var inst:PerfHUD;
		
		private var _now:Function;
		private var sttm:Number = 0;
		
		public static var drawTexTm:Number = 0;
		
		//TODO:coverage
		public function PerfHUD() {
			inst = this;
			_renderType |= SpriteConst.CUSTOM;
			_setRenderType(_renderType);
			_setCustomRender();
			
			addDataDef(0, 0xffffff, 'frame', 1.0);
			addDataDef(1, 0x00ff00, 'update', 1.0);
			addDataDef(2, 0xff0000, 'flush', 1.0);
			_now = __JS__("performance?performance.now.bind(performance):Date.now");
		}
		
		//TODO:coverage
		public function now():Number {
			return _now();
		}
		
		//TODO:coverage
		public function start():void {
			sttm = _now();
		}
		
		//TODO:coverage
		public function end(i:int):void {
			var dt:Number = _now() - sttm;
			updateValue(i, dt);
		}
		
		//TODO:coverage
		public function config(w:int, h:int):void {
			hud_width = w;
			hud_height = h;
		}
		
		//TODO:coverage
		public function addDataDef(id:int, color:int, name:String, scale:Number):void {
			datas[id] = new PerfData(id, color, name, scale);
		}
		
		//TODO:coverage
		public function updateValue(id:int, v:Number):void {
			datas[id].addData(v);
		}
		
		//TODO:coverage
		public function v2y(v:Number):Number {
			var bb:Number = _y + hud_height * (1 - (v - gMinV) / gMaxV);
			return _y+hud_height*(1-(v-gMinV)/gMaxV);			
		}
		
		//TODO:coverage
		public function drawHLine(ctx:Context, v:Number, color:String, text:String):void{
			var sx:Number = _x;
			var ex:Number = _x+hud_width;
			var sy:Number = v2y(v);
			ctx.fillText(text,sx,sy-6,null,'green');
			sx += textSpace;
			ctx.fillStyle = color;
			ctx.fillRect(sx, sy, _x + hud_width, 1);
		}
				
		//TODO:coverage
		override public function customRender(ctx:Context, x:Number, y:Number):void {
			var now:Number = __JS__("performance.now();");
			if (_lastTm <= 0) _lastTm = now;
			updateValue(0, now - _lastTm);
			_lastTm = now;
			
			ctx.save();
			ctx.fillRect(_x, _y, hud_width, hud_height+4, '#000000cc');
			ctx.globalAlpha = 0.9;
			/*
			for ( var i = 0; i < gMaxV; i+=30) {
				drawHLine(ctx, i, 'green', '' + i);// '' + Math.round(1000 / (i + 1)));
			}
			*/
			drawHLine(ctx, 0, 'green', '    0');
			drawHLine(ctx, 10, 'green', '  10');
			drawHLine(ctx, 16.667, 'red', ' ');
			drawHLine(ctx, 20, 'green', '50|20');
			drawHLine(ctx, 16.667 * 2, 'yellow', '');
			drawHLine(ctx, 16.667 * 3, 'yellow', '');
			drawHLine(ctx, 16.667 * 4, 'yellow', '');
			drawHLine(ctx, 50, 'green', '20|50');
			drawHLine(ctx, 100, 'green', '10|100');
			
			//数据
			for ( var di:int = 0, sz:int = datas.length; di < sz; di++) {
				var cd:PerfData = datas[di];
				if (!cd) continue;
				var dtlen:int = cd.datas.length;
				var dx:Number = (hud_width-textSpace)/dtlen;
				var cx:Number = cd.datapos;
				var _cx:Number = _x+textSpace;
				ctx.fillStyle = cd.color;
				//开始部分
				/*
				ctx.beginPath();
				ctx.strokeStyle = cd.color;
				ctx.moveTo(_cx, v2y(cd.datas[cx]* cd.scale) );
				cx++;
				_cx += dx;
				for ( var dtsz:int = dtlen; cx < dtsz; cx++) {
					ctx.lineTo(_cx, v2y(cd.datas[cx]* cd.scale) );
					_cx += dx;
				}
				//剩下的
				for (cx = 0; cx < cd.datapos; cx++) {
					ctx.lineTo(_cx, v2y(cd.datas[cx] * cd.scale));
					_cx += dx;
				}
				ctx.stroke();
				*/
				for ( var dtsz:int = dtlen; cx < dtsz; cx++) {
					var sty:Number = v2y(cd.datas[cx] * cd.scale);
					ctx.fillRect(_cx, sty, dx, hud_height+_y-sty);
					_cx += dx;
				}
				//剩下的
				for (cx = 0; cx < cd.datapos; cx++) {
					sty = v2y(cd.datas[cx] * cd.scale);
					ctx.fillRect(_cx, sty, dx, hud_height+_y-sty);
					_cx += dx;
				}
				
			}
			ctx.restore();
		}
	}
}