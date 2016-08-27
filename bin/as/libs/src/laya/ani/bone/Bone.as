package laya.ani.bone 
{
	import laya.display.Sprite;
	import laya.maths.Matrix;
	/**
	 * ...
	 * @author 
	 */
	public class Bone 
	{
		
		public var name:String;
		public var _parent:Bone;
		public var _children:Vector.<Bone> = new Vector.<Bone>();
		public var length:Number = 10;
		public var transform:Transform;
		public var resultTransform:Transform = new Transform();
		public var resultMatrix:Matrix = new Matrix();
		private var sprite:Sprite;
		
		public function Bone() 
		{
		}
		
		public function update(pMatrix:Matrix = null):void
		{
			var tResultMatrix:Matrix;
			if (pMatrix)
			{
				tResultMatrix = resultTransform.getMatrix();
				Matrix.mul(tResultMatrix,pMatrix,resultMatrix);
			}else {
				if (_parent)
				{
					tResultMatrix = resultTransform.getMatrix();
					Matrix.mul(tResultMatrix,_parent.resultMatrix,resultMatrix);
				}else {
					tResultMatrix = resultTransform.getMatrix();
					tResultMatrix.copyTo(resultMatrix);
				}
			}
			var i:int = 0, n:int = 0;
			var tBone:Bone;
			for (i = 0, n = _children.length; i < n; i++)
			{
				tBone = _children[i];
				tBone.update();
			}
		}
		
		public function updateDraw(x:Number,y:Number):void {	
			if (sprite) {
				sprite.x = x + resultMatrix.tx;
				sprite.y = y + resultMatrix.ty;
			}else {
				sprite = new Sprite();
				sprite.graphics.drawCircle(0, 0, 5, "#ff0000");
				Laya.stage.addChild(sprite);
				sprite.x = x + resultMatrix.tx;
				sprite.y = y + resultMatrix.ty;
			}
			var i:int = 0, n:int = 0;
			var tBone:Bone;
			for (i = 0, n = _children.length; i < n; i++) {	
				tBone = _children[i];
				tBone.updateDraw(x,y);
			}
		}
		
		public function addChild(bone:Bone):void
		{
			_children.push(bone);
			bone._parent = this;
		}
		
		public function findBone(boneName:String):Bone
		{
			if (this.name == boneName)
			{
				return this;
			}else {
				var i:int, n:int;
				var tBone:Bone;
				var tResult:Bone;
				for (i = 0, n = _children.length; i < n; i++)
				{
					tBone = _children[i];
					tResult = tBone.findBone(boneName);
					if (tResult)
					{
						return tResult;
					}
				}
			}
			return null;
		}
		
	}

}