package laya.d3Editor.shape {
	import laya.d3.core.Camera;
	import laya.d3.core.Transform3D;
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.math.Color;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3Editor.material.DepthCullLineMaterial;
	/**
	 * ...
	 * @author 
	 */
	public class SphereShapeLine3D extends PixelLineSprite3D{
		
		private var color:Color = Color.GREEN;
		
		private var curCamera:Camera;
		private var circleBillBoard:PixelLineSprite3D;
		
		/** @private */
		private var _radius:Number;
		
		private var _mat:Matrix4x4 = new Matrix4x4();
		private var _position:Vector3 = new Vector3();
		private var _rotation:Quaternion = new Quaternion();
		private var _scale:Vector3 = new Vector3();
		
		/**
		 * 返回半径
		 * @return 半径
		 */
		public function get radius():Number {
			return _radius;
		}
		
		/**
		 * 设置半径（改变此属性会重新生成顶点和索引）
		 * @param  value 半径
		 */
		public function set radius(value:Number):void {
			if (_radius !== value) {
				_radius = value;
				reCreateShape();
			}
		}
		
		private function reCreateShape():void{
			var i:int;
			
			//----------------------------x--------------------------------
			var perAngle:Number = (Math.PI * 2.0) / 63;
			var curAngle:Number = 0;
			var lasePosition:Vector3 = new Vector3(0, 0, radius);
			var curPosition:Vector3 = new Vector3();
			for (i = 0; i < 64; i++) {
				curAngle = i * perAngle;
				curPosition.x = 0;
				curPosition.y = Math.sin(curAngle) * radius;
				curPosition.z = Math.cos(curAngle) * radius;
				setLine(i, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
			
			//----------------------------y--------------------------------
			curAngle = 0;
			lasePosition = new Vector3(radius, 0, 0);
			for (i = 0; i < 64; i++) {
				curAngle = i * perAngle;
				curPosition.x = Math.cos(curAngle) * radius;
				curPosition.y = 0;
				curPosition.z = Math.sin(curAngle) * radius;
				setLine(i + 64, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
			
			//----------------------------z--------------------------------
			curAngle = 0;
			lasePosition = new Vector3(radius, 0, 0);
			for (i = 0; i < 64; i++) {
				curAngle = i * perAngle;
				curPosition.x = Math.cos(curAngle) * radius;
				curPosition.y = Math.sin(curAngle) * radius;
				curPosition.z = 0;
				setLine(i + 128, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
			
//			if (curCamera){
//				curAngle = 0;
//				lasePosition = new Vector3(radius, 0, 0);
//				for (var i:int = 0; i < 64; i++) {
//					curAngle = i * perAngle;
//					curPosition.x = Math.cos(curAngle) * radius;
//					curPosition.y = Math.sin(curAngle) * radius;
//					curPosition.z = 0;
//					circleBillBoard.setLine(i, lasePosition, curPosition, color, color);
//					curPosition.cloneTo(lasePosition);
//				}
//			}
		}
		
		public function SphereShapeLine3D(radius:Number = 0.5, camera:Camera = null) {
			
			super(192);
			_radius = radius;
//			curCamera = camera;
//			circleBillBoard = addChild(new PixelLineSprite3D(64)) as PixelLineSprite3D;
			reCreateShape();
//			DepthCullLineMaterial.initShader();
//			var mat:DepthCullLineMaterial = new DepthCullLineMaterial();
//			mat.color = new Vector4(1, 1, 1, 0.2);
//			pxLineRenderer.sharedMaterial = mat;
			
//			Laya.timer.loop(1, this, function():void{
//				if (curCamera && active){
//					var cameraTransform:Transform3D = curCamera.transform;
//					var cameraRight:Vector3 = cameraTransform.right;
//					var cameraUp:Vector3 = cameraTransform.up;
//					var cameraForward:Vector3 = cameraTransform.forward;
//					var mate:Float32Array = _mat.elements;
//					mate[0]  = cameraRight.x;
//					mate[1]  = cameraRight.y;
//					mate[2]  = cameraRight.z;
//					mate[4]  = cameraUp.x;
//					mate[5]  = cameraUp.y;
//					mate[6]  = cameraUp.z;
//					mate[8]  = cameraForward.x;
//					mate[9]  = cameraForward.y;
//					mate[10] = cameraForward.z;
////					Matrix4x4.billboard(new Vector3(), cameraTransform.position, cameraTransform.right, cameraTransform.up, cameraTransform.forward, _mat);
//					_mat.decomposeTransRotScale(_position, _rotation, _scale);
//					circleBillBoard.transform.rotation = _rotation;
//				}
//			});
		}
		
	}

}