package laya.ani.bone {
	import laya.display.Graphics;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	
	/**
	 * @private
	 */
	public class BoneSlot {
		
		/** 插槽名称 */
		public var name:String;
		/** 插槽绑定的骨骼名称 */
		public var parent:String;
		/** 原始数据的索引 */
		public var srcDisplayIndex:int = -1;
		/** 判断对象是否是原对象 */
		public var type:String = "src";
		/** 模板的指针 */
		public var templet:Templet;
		/** 当前插槽对应的数据 */
		public var currSlotData:SlotData;
		/** 当前插槽显示的纹理 */
		public var currTexture:Texture;
		/** 显示对象对应的数据 */
		public var currDisplayData:SkinSlotDisplayData;
		
		/** 显示皮肤的索引 */
		public var displayIndex:int = -1;
		
		/** 用户自定义的皮肤 */
		private var _diyTexture:Texture;
		private var _parentMatrix:Matrix;
		private var _resultMatrix:Matrix;//只有不使用缓冲时才使用
		
		/**
		 * 设置要显示的插槽数据
		 * @param	slotData
		 * @param	disIndex
		 */
		public function showSlotData(slotData:SlotData):void {
			currSlotData = slotData;
			displayIndex = srcDisplayIndex;
			currDisplayData = null;
			currTexture = null;
		}
		
		/**
		 * 指定显示对象
		 * @param	index
		 */
		public function showDisplayByIndex(index:int):void {
			if (currSlotData && index > -1 && index < currSlotData.displayArr.length) {
				
				displayIndex = index;
				currDisplayData = currSlotData.displayArr[index];
				if (currDisplayData) {
					currTexture = templet.getTexture(currDisplayData.name);
					if (currTexture) {
						switch (currDisplayData.type) {
						case 0: 
							if (currDisplayData.uvs) {//这里的问题是什么时候销毁
								currTexture = new Texture(currTexture.bitmap, currDisplayData.uvs);
							}
							break;
						case 1: 
							break;
						case 2: 
							break;
						}
					}
				}
			} else {
				displayIndex = -1;
				currDisplayData = null;
				currTexture = null;
			}
		}
		
		/**
		 * 替换皮肤
		 * @param	_texture
		 */
		public function replaceSkin(_texture:Texture):void {
			_diyTexture = _texture;
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
		 * @param	noUseSave
		 */
		public function draw(graphics:Graphics, boneMatrixArray:Array, noUseSave:Boolean = false):void {
			if ((_diyTexture == null && currTexture == null) || currDisplayData == null) return;
			var tTexture:Texture = currTexture;
			if (_diyTexture) tTexture = _diyTexture;
			switch (currDisplayData.type) {
			case 0: 
				if (graphics) {
					var tCurrentMatrix:Matrix = getDisplayMatrix();
					if (_parentMatrix) {
						if (tCurrentMatrix) {
							Matrix.mul(tCurrentMatrix, _parentMatrix, Matrix.TEMP);
							var tResultMatrix:Matrix;
							if (noUseSave) {
								if (_resultMatrix == null) _resultMatrix = new Matrix();
								tResultMatrix = _resultMatrix;
							} else {
								tResultMatrix = new Matrix();
							}
							Matrix.TEMP.copyTo(tResultMatrix);
							graphics.drawTexture(tTexture, -currDisplayData.width / 2, -currDisplayData.height / 2, currDisplayData.width, currDisplayData.height, tResultMatrix);
						}
					}
				}
				break;
			case 1: 
				break;
			case 2: 
				break;
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
		
		/**
		 * 得到插糟的矩阵
		 * @return
		 */
		public function getMatrix():Matrix {
			return _resultMatrix;
		}
		
		/**
		 * 用原始数据拷贝出一个
		 * @return
		 */
		public function copy():BoneSlot {
			var tBoneSlot:BoneSlot = new BoneSlot();
			tBoneSlot.type = "copy";
			tBoneSlot.name = name;
			tBoneSlot.srcDisplayIndex = srcDisplayIndex;
			tBoneSlot.parent = parent;
			tBoneSlot.displayIndex = displayIndex;
			tBoneSlot.templet = templet;
			tBoneSlot.currSlotData = currSlotData;
			tBoneSlot.currTexture = currTexture;
			tBoneSlot.currDisplayData = currDisplayData;
			return tBoneSlot;
		}
	}
}