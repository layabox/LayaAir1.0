package laya.ani.bone {
	
	import laya.display.Sprite;
	import laya.maths.Matrix;
	
	/**
	 * @private
	 */
	public class Bone {
		
		public var name:String;
		public var _parent:Bone;
		public var _children:Vector.<Bone> = new Vector.<Bone>();
		public var length:Number = 10;
		public var transform:Transform;
		public var resultTransform:Transform = new Transform();
		public var resultMatrix:Matrix = new Matrix();
		private var sprite:Sprite;
		public var inheritScale:Boolean = true;
		public var inheritRotation:Boolean = true;
		
		public var rotation:Number;
		public var resultRotation:Number;
		
		public function Bone() {
		}
		
		public function update(pMatrix:Matrix = null):void {
			rotation = transform.skX;
			var tResultMatrix:Matrix;
			if (pMatrix) {
				tResultMatrix = resultTransform.getMatrix();
				Matrix.mul(tResultMatrix, pMatrix, resultMatrix);
				resultRotation = rotation;
			} else {
				resultRotation = rotation + _parent.resultRotation;
				if (_parent) {
					if (inheritRotation && inheritScale) {
						tResultMatrix = resultTransform.getMatrix();
						Matrix.mul(tResultMatrix, _parent.resultMatrix, resultMatrix);
					} else {
						var la:Number = transform.getMatrix().a;
						var lb:Number = transform.getMatrix().b;
						var lc:Number = transform.getMatrix().c;
						var ld:Number = transform.getMatrix().d;
						
						var temp:Number = 0;
						var parent:Bone = _parent;
						var tAngle:Number;
						var cos:Number;
						var sin:Number;
						var tParentMatrix:Matrix = _parent.resultMatrix;
						var worldX:Number = tParentMatrix.a * transform.x + tParentMatrix.b * transform.y + tParentMatrix.tx;
						var worldY:Number = tParentMatrix.c * transform.x + tParentMatrix.d * transform.y + tParentMatrix.ty;
						var tTestMatrix:Matrix = new Matrix();
						if (inheritRotation) {
							tAngle = Math.atan2(parent.resultMatrix.c, parent.resultMatrix.a);
							cos = Math.cos(tAngle), sin = Math.sin(tAngle);
							tTestMatrix.setTo(cos, sin, -sin, cos, 0, 0);
							var tTestYMatrix:Matrix = new Matrix(1, 0, 0, -1);
							Matrix.mul(tTestYMatrix, tTestMatrix, Matrix.TEMP);
							Matrix.TEMP.copyTo(tTestMatrix);
							tResultMatrix = resultTransform.getMatrix();
							Matrix.mul(tResultMatrix, tTestMatrix, resultMatrix);
							resultMatrix.tx = worldX;
							resultMatrix.ty = worldY;
						} else if (inheritScale) {
							tResultMatrix = resultTransform.getMatrix();
							Matrix.TEMP.identity();
							Matrix.TEMP.d = -1;
							Matrix.mul(tResultMatrix, Matrix.TEMP, resultMatrix);
							resultMatrix.tx = worldX;
							resultMatrix.ty = worldY;
						} else {
							tResultMatrix = resultTransform.getMatrix();
							Matrix.TEMP.identity();
							Matrix.TEMP.d = -1;
							Matrix.mul(tResultMatrix, Matrix.TEMP, resultMatrix);
							resultMatrix.tx = worldX;
							resultMatrix.ty = worldY;
						}
					}
					
				} else {
					tResultMatrix = resultTransform.getMatrix();
					tResultMatrix.copyTo(resultMatrix);
				}
			}
			var i:int = 0, n:int = 0;
			var tBone:Bone;
			for (i = 0, n = _children.length; i < n; i++) {
				tBone = _children[i];
				tBone.update();
			}
		}
		
		public function updateChild():void {
			var i:int = 0, n:int = 0;
			var tBone:Bone;
			for (i = 0, n = _children.length; i < n; i++) {
				tBone = _children[i];
				tBone.update();
			}
		}
		
		public function updateDraw(x:Number, y:Number):void {
			if (sprite) {
				sprite.x = x + resultMatrix.tx;
				sprite.y = y + resultMatrix.ty;
			} else {
				sprite = new Sprite();
				sprite.graphics.drawCircle(0, 0, 5, "#ff0000");
				sprite.graphics.fillText(name, 0, 0, "20px Arial", "#00ff00", "center");
				Laya.stage.addChild(sprite);
				sprite.x = x + resultMatrix.tx;
				sprite.y = y + resultMatrix.ty;
			}
			var i:int = 0, n:int = 0;
			var tBone:Bone;
			for (i = 0, n = _children.length; i < n; i++) {
				tBone = _children[i];
				tBone.updateDraw(x, y);
			}
		}
		
		public function addChild(bone:Bone):void {
			_children.push(bone);
			bone._parent = this;
		}
		
		public function findBone(boneName:String):Bone {
			if (this.name == boneName) {
				return this;
			} else {
				var i:int, n:int;
				var tBone:Bone;
				var tResult:Bone;
				for (i = 0, n = _children.length; i < n; i++) {
					tBone = _children[i];
					tResult = tBone.findBone(boneName);
					if (tResult) {
						return tResult;
					}
				}
			}
			return null;
		}
		
		public function localToWorld(local:Vector.<Number>):void {
			var localX:Number = local[0];
			var localY:Number = local[1];
			local[0] = localX * resultMatrix.a + localY * resultMatrix.c + resultMatrix.tx;
			local[1] = localX * resultMatrix.b + localY * resultMatrix.d + resultMatrix.ty;
		}
	
	}

}