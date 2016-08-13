package laya.ani.bone {
	import laya.display.Graphics;
	import laya.display.Sprite;
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
		/** 插糟显示数据数据的名称 */
		public var attachmentName:String;
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
		
		private var _spineSprite:SkinSprite;
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
		 * 通过名字显示指定对象
		 * @param	name
		 */
		public function showDisplayByName(name:String):void
		{
			showDisplayByIndex(currSlotData.getDisplayByName(name));
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
					var tName:String = currDisplayData.name;
					currTexture = templet.getTexture(tName);
					if (currTexture) {
						switch (currDisplayData.type) {
						case 0: 
							if (currDisplayData.uvs) {//这里的问题是什么时候销毁
								currTexture = new Texture(currTexture.bitmap, currDisplayData.uvs);
							}
							break;
						case 1: 
						case 2:
							if (_spineSprite == null)
							{
								_spineSprite = new SkinSprite();
							}
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
		public function draw(graphics:Graphics, boneMatrixArray:Array, sprite:Sprite, noUseSave:Boolean = false):void {
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
					if (_spineSprite)
					{
						if (_spineSprite.parent == null)
						{
							sprite.addChild(_spineSprite);
						}
						var tVBArray:Array = [];
						var tIBArray:Array = [];
						var tRed:Number = 1;
						var tGreed:Number = 1;
						var tBlue:Number = 1;
						var tAlpha:Number = 1;
						
						if (currDisplayData.bones == null)
						{
							for (var i:int = 0,ii:int = 0; i < currDisplayData.weights.length && ii< currDisplayData.uvs.length;)
							{
								var tX:Number = currDisplayData.weights[i++];
								var tY:Number = currDisplayData.weights[i++];
								tVBArray.push(tX, tY, currDisplayData.uvs[ii++], currDisplayData.uvs[ii++], tRed, tGreed, tBlue, tAlpha);
							}
							var tTriangleNum:int = currDisplayData.triangles.length / 3;
							for (i = 0; i < tTriangleNum; i++)
							{
								tIBArray.push(currDisplayData.triangles[i * 3]);
								tIBArray.push(currDisplayData.triangles[i * 3 + 1]);
								tIBArray.push(currDisplayData.triangles[i * 3 + 2]);
							}
							_spineSprite.init(currTexture, tVBArray, tIBArray);
							var tCurrentMatrix2:Matrix = getDisplayMatrix();
							if (_parentMatrix) {
								if (tCurrentMatrix2) {
									Matrix.mul(tCurrentMatrix2, _parentMatrix, Matrix.TEMP);
									var tResultMatrix2:Matrix;
									if (noUseSave) {
										if (_resultMatrix == null) _resultMatrix = new Matrix();
										tResultMatrix2 = _resultMatrix;
									} else {
										tResultMatrix2 = new Matrix();
									}
									Matrix.TEMP.copyTo(tResultMatrix2);
									_spineSprite.transform = tResultMatrix2;
								}
							}
						}else {
							skinMesh(boneMatrixArray);
						}
					}
					break;
				case 2:
					if (_spineSprite.parent == null)
					{
						sprite.addChild(_spineSprite);
					}
					skinMesh(boneMatrixArray);
					break;
			}
		}
		
		/**
		 * 显示蒙皮动画
		 * @param	boneMatrixArray 当前帧的骨骼矩阵
		 */
		private function skinMesh(boneMatrixArray:Array):void
		{
			if (_spineSprite)
			{
				var tBones:Array = currDisplayData.bones;
				var tUvs:Array = currDisplayData.uvs;
				var tWeights:Array = currDisplayData.weights;
				var tTriangles:Array = currDisplayData.triangles;
				var tVBArray:Array = [];
				var tIBArray:Array = [];
				var tRx:Number = 0;
				var tRy:Number = 0;
				var nn:int = 0;
				var tMatrix:Matrix;
				var tX:Number;
				var tY:Number;
				var tB:Number = 0;
				var tWeight:Number = 0;
				var tVertices:Vector.<Number> = new Vector.<Number>();
				var i:int = 0, j:int = 0, n:int = 0;
				var tRed:Number = 1;
				var tGreed:Number = 1;
				var tBlue:Number = 1;
				var tAlpha:Number = 1;
				for (i = 0, n = tBones.length; i < n;)
				{
					nn = tBones[i++] + i;
					tRx = 0, tRy = 0;
					for (; i < nn; i++)
					{
						tMatrix = boneMatrixArray[tBones[i]]
						tX = tWeights[tB];
						tY = tWeights[tB + 1];
						tWeight = tWeights[tB + 2];
						tRx += (tX * tMatrix.a + tY * tMatrix.c + tMatrix.tx) * tWeight;
						tRy += (tX * tMatrix.b + tY * tMatrix.d + tMatrix.ty) * tWeight;
						tB += 3;
					}
					tVertices.push(tRx, tRy);
				}
				for (i = 0, j = 0; i < tVertices.length && j < tUvs.length; )
				{
					tRx = tVertices[i++];
					tRy = tVertices[i++];
					tVBArray.push(tRx, tRy, tUvs[j++], tUvs[j++], tRed, tGreed, tBlue, tAlpha);
				}
				for (i = 0, n = tTriangles.length; i < n; i++)
				{
					tIBArray.push(tTriangles[i]);
				}
				_spineSprite.init(currTexture, tVBArray, tIBArray);
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
			tBoneSlot.attachmentName = attachmentName;
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