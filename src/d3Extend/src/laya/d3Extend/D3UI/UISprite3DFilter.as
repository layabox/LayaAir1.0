package laya.d3Extend.D3UI {
	import laya.ani.math.BezierLerp;
	import laya.d3.core.BufferState;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.Vertex.VertexPositionNormal;
	import laya.d3.graphics.Vertex.VertexPositionNormalColor;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	import laya.d3Extend.VertexColor;
	import laya.layagl.LayaGL;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 */
	public class UISprite3DFilter extends GeometryElement {
		/**@private */
		private static var _type:int = _typeCounter++;
		
		public var boundSphere:BoundSphere = new BoundSphere(new Vector3(6, 6, 6), 10.392);
		public var indexNum:int = 0;
		public var vertexNum:int = 0;
		private var _bbx:Array = [0, 0, 0, 0, 0, 0];
		private var _owner:UISprite3D = null;
		
		public function UISprite3DFilter(owner:UISprite3D) {
			_owner = owner;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getType():int {
			return _type;
		}
			
		
		/**
		 * @private
		 * @return  是否需要渲染。
		 */
		override public function _prepareRender(state:RenderContext3D):Boolean {
			return true;
		}		
		
		private function updateBBX(x:Number,y:Number,z:Number):void {
			if (_bbx[0] > x)_bbx[0] = x;
			if (_bbx[1] > y)_bbx[1] = y;
			if (_bbx[2] > z)_bbx[2] = z;
			if (_bbx[3] < x)_bbx[3] = x;
			if (_bbx[4] < y)_bbx[4] = y;
			if (_bbx[5] < z)_bbx[5] = z;
		}
		
		private function getBBXCenter(vout:Vector3):void {
			vout.x = (_bbx[0] + _bbx[3]) / 2;
			vout.y = (_bbx[1] + _bbx[4]) / 2;
			vout.z = (_bbx[2] + _bbx[5]) / 2;
		}
		
		//包围盒的对角线
		private function getBBXSize():Number {
			var dx:Number = _bbx[3] - _bbx[0];
			var dy:Number = _bbx[4] - _bbx[1];
			var dz:Number = _bbx[5] - _bbx[2];
			return Math.sqrt(dx * dx + dy * dy + dz * dz);
		}
		

		//
		override public function _render(state:RenderContext3D):void {
			_owner.renderUI();
			/*
			var gl:WebGLContext = LayaGL.instance;
			gl.drawElements(WebGLContext.TRIANGLES, indexNum, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.drawCall += 1;
			Stat.trianglesFaces += indexNum/3;
			*/
		}
		
		public function _destroy():void {
			//_bufferState.destroy();
			//TODO 郭磊这里应该怎么处理啊
		}		
	}
}

