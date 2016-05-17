package laya.ani.bone {
	import laya.display.Graphics;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	
	/**
	 * @private
	 */
	public class BoneSlot {
		
		public var textureArray:Array = [];
		public var displayDataArray:Array = [];
		public var currTexture:Texture;
		public var currDisplayData:SkinSlotDisplayData;
		private var _parentMatrix:Matrix;
		
		/**
		 * 加入皮肤
		 * @param	texture
		 * @param	displayData
		 */
		public function addSprite(texture:Texture, displayData:SkinSlotDisplayData):void {
			textureArray.push(texture);
			displayDataArray.push(displayData);
			displayData.name
			showSpriteByIndex(0);
		}
		
		/**
		 * 显示哪个皮肤
		 * @param	index
		 */
		public function showSpriteByIndex(index:int):void {
			if (index > -1 && index < textureArray.length) {
				currTexture = textureArray[index];
			} else {
				currTexture = null;
			}
			if (index > -1 && index < displayDataArray.length) {
				currDisplayData = displayDataArray[index];
			} else {
				currDisplayData = null;
			}
		}
		
		/**
		 * 替换皮肤
		 * @param	_texture
		 */
		public function replaceSkin(_texture:Texture):void {
			currTexture = _texture;
		}
		
		/**
		 * 保存父矩阵的索引
		 * @param	parentMatrix
		 */
		public function setParentMatrix(parentMatrix:Matrix):void {
			_parentMatrix = parentMatrix;
		}
		
		/**
		 * 把纹理画到Graphics上
		 * @param	graphics
		 */
		public function draw(graphics:Graphics):void {
			if (currTexture == null || currDisplayData == null) return;
			var tTexture:Texture = currTexture;
			if (graphics) {
				var tCurrentMatrix:Matrix = getDisplayMatrix();
				if (tCurrentMatrix) {
					Matrix.mul(tCurrentMatrix, _parentMatrix, Matrix.TEMP);
					var tResultMatrix:Matrix = new Matrix();
					Matrix.TEMP.copy(tResultMatrix);
					graphics.drawTexture(tTexture, -tTexture.sourceWidth / 2, -tTexture.sourceHeight / 2, tTexture.sourceWidth, tTexture.sourceHeight, tResultMatrix);
				}
			}
		}
		
		/**
		 * 画骨骼的起始点，方便调试
		 * @param	graphics
		 */
		public function drawBonePoint(graphics:Graphics):void {
			if (graphics && _parentMatrix) {
				graphics.drawCircle(_parentMatrix.tx, _parentMatrix.ty, 5, "#ff0000");
			}
		}
		
		/**
		 * 得到显示对象的矩阵
		 * @return
		 */
		private function getDisplayMatrix():Matrix {
			if (currDisplayData) {
				return currDisplayData.transform.getMatrix();
			}
			return null;
		}
	}
}