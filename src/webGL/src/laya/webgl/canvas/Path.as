package laya.webgl.canvas {
	import laya.webgl.shapes.BasePoly;
	import laya.webgl.utils.Mesh2D;
	
	public class Path {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		//public var _rect:Rectangle;
		public var _lastOriX:Number = 0;	//moveto等的原始位置。没有经过内部矩阵变换的
		public var _lastOriY:Number = 0;
		public var paths:Array = [];	//所有的路径。{@type renderPath[] }
		private var _curPath:renderPath = null;
		
		
		public function Path() {
		}
		
		public function beginPath(convex:Boolean):void {
			paths.length = 1;
			_curPath = paths[0] = new renderPath();
			_curPath.convex = convex;
			//_curPath.path = [];
		}
		
		public function closePath():void {
			_curPath.loop = true;
		}
		
		public function newPath():void {
			_curPath = new renderPath();
			paths.push(_curPath);
		}
		
		public function addPoint(pointX:Number, pointY:Number):void {
			//tempArray.push(pointX, pointY);
			_curPath.path.push(pointX, pointY);
		}
		
		//直接添加一个完整的path
		public function push(points:Array, convex:Boolean):void {
			if (!_curPath) {
				_curPath = new renderPath();
				paths.push(_curPath);
			} else if (_curPath.path.length > 0) {
				_curPath = new renderPath();
				paths.push(_curPath);
			}
			var rp:renderPath = _curPath;
			rp.path = points.slice();//TODO 这个可能多次slice了
			rp.convex = convex;
		}
		
		public function reset():void {
			this.paths.length = 0;//TODO 复用
		}
	}
}

class renderPath {
	public var path:Array = []; //[x,y,x,y,....]的数组
	public var loop:Boolean = false;
	public var convex:Boolean = false;
}