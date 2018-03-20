package laya.ani.bone {
	
	import laya.ani.GraphicsAni;
	import laya.ani.bone.canvasmesh.SimpleSkinMeshCanvas;
	import laya.ani.bone.canvasmesh.SkinMeshCanvas;
	import laya.display.Graphics;
	import laya.maths.Matrix;
	import laya.renders.Render;
	import laya.resource.Texture;
	import laya.utils.RunDriver;
	
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
		/** 索引替换表 */
		private var _replaceDic:Object = { };
		/** 当前diyTexture的动画纹理 */
		private var _curDiyUV:Array;
		private var _curDiyVS:Array;
		
		/** 实时模式下，复用使用 */
		private var _skinSprite:*;
		/** @private 变形动画数据 */
		public var deformData:Array;
		
		/**
		 * 设置要显示的插槽数据
		 * @param	slotData
		 * @param	disIndex
		 * @param	freshIndex 是否重置纹理
		 */
		public function showSlotData(slotData:SlotData,freshIndex:Boolean=true):void {
			currSlotData = slotData;
			if(freshIndex)
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
			if (currSlotData) {	
				showDisplayByIndex(currSlotData.getDisplayByName(name));
			}
		}
		
		/**
		 * 替换贴图名
		 * @param	tarName 要替换的贴图名
		 * @param	newName 替换后的贴图名
		 */
		public function replaceDisplayByName(tarName:String, newName:String):void
		{
			if (!currSlotData) return;
			var preIndex:int;
			preIndex = currSlotData.getDisplayByName(tarName);
			var newIndex:int;
			newIndex = currSlotData.getDisplayByName(newName);
			replaceDisplayByIndex(preIndex, newIndex);
		}
		
		/**
		 * 替换贴图索引
		 * @param	tarIndex 要替换的索引
		 * @param	newIndex 替换后的索引
		 */
		public function replaceDisplayByIndex(tarIndex:int, newIndex:int):void
		{
			if (!currSlotData) return;
			_replaceDic[tarIndex] = newIndex;
			if (displayIndex == tarIndex)
			{
				showDisplayByIndex(tarIndex);
			}
		}
		
		/**
		 * 指定显示对象
		 * @param	index
		 */
		public function showDisplayByIndex(index:int):void {
			if (_replaceDic[index]!=null) index = _replaceDic[index];
			if (currSlotData && index > -1 && index < currSlotData.displayArr.length) {
				displayIndex = index;
				currDisplayData = currSlotData.displayArr[index];
				if (currDisplayData) {
					var tName:String = currDisplayData.name;
					currTexture = templet.getTexture(tName);
					//if (currTexture && Render.isWebGL && currDisplayData.type == 0 && currDisplayData.uvs)
					//{
						//currTexture = currDisplayData.createTexture(currTexture);
					//}
					if (currTexture && !Render.isConchApp && currDisplayData.type == 0 && currDisplayData.uvs)
					{
						currTexture = currDisplayData.createTexture(currTexture);
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
			if (_curDiyUV) _curDiyUV.length = 0;
			if (currDisplayData&&_diyTexture == currDisplayData.texture)
			{
				_diyTexture = null;
			}
		}
		
		/**
		 * 保存父矩阵的索引
		 * @param	parentMatrix
		 */
		public function setParentMatrix(parentMatrix:Matrix):void {
			_parentMatrix = parentMatrix;
		}
		
		private var _mVerticleArr:Array;
		private static var _tempMatrix:Matrix = new Matrix();
		public static function createSkinMesh():*
		{
			if (Render.isWebGL || Render.isConchApp)
			{
				return RunDriver.skinAniSprite();
			}else
			{
				if (!Render.isWebGL)
				{
					if (Skeleton.useSimpleMeshInCanvas)
					{
						return new SimpleSkinMeshCanvas();
					}else
					{
						return new SkinMeshCanvas();
					}
					
				}	
			}
			return null;
		}
		/**
		 * 把纹理画到Graphics上
		 * @param	graphics
		 * @param	noUseSave
		 */
		public function draw(graphics:GraphicsAni, boneMatrixArray:Array, noUseSave:Boolean = false, alpha:Number = 1):void {
			if ((_diyTexture == null && currTexture == null) || currDisplayData == null) {
				if (!(currDisplayData && currDisplayData.type == 3))
				{
					return;
				}
			}
			var tTexture:Texture = currTexture;
			if (_diyTexture) tTexture = _diyTexture;
			var tSkinSprite:*;
			switch (currDisplayData.type) {
				case 0: 
					if (graphics) {
						var tCurrentMatrix:Matrix = getDisplayMatrix();
						if (_parentMatrix) {
							var tRotateKey:Boolean = false;
							if (tCurrentMatrix) {
								Matrix.mul(tCurrentMatrix, _parentMatrix, Matrix.TEMP);
								var tResultMatrix:Matrix;
								if (noUseSave) {
									if (_resultMatrix == null) _resultMatrix = new Matrix();
									tResultMatrix = _resultMatrix;
								} else {
									tResultMatrix = new Matrix();
								}
								if ((!Render.isWebGL && currDisplayData.uvs) || (Render.isWebGL && _diyTexture && currDisplayData.uvs))
								{
									var tTestMatrix:Matrix = _tempMatrix;
									tTestMatrix.identity();
									//判断是否反转
									if (currDisplayData.uvs[1] > currDisplayData.uvs[5])
									{
										tTestMatrix.d = -1;
									}
									//判断是否旋转
									if (currDisplayData.uvs[0] > currDisplayData.uvs[4]
										&& currDisplayData.uvs[1] > currDisplayData.uvs[5])
									{
										tRotateKey = true;
										tTestMatrix.rotate(-Math.PI/2);
									}
									Matrix.mul(tTestMatrix,Matrix.TEMP,tResultMatrix);
								}else {
									Matrix.TEMP.copyTo(tResultMatrix);
								}
								if (tRotateKey)
								{
									graphics.drawTexture(tTexture, -currDisplayData.height / 2, -currDisplayData.width / 2, currDisplayData.height, currDisplayData.width, tResultMatrix);
								}else {
									graphics.drawTexture(tTexture, -currDisplayData.width / 2, -currDisplayData.height / 2, currDisplayData.width, currDisplayData.height, tResultMatrix);
								}
							}
						}
					}
					break;
				case 1:
					if (noUseSave) {	
						if (_skinSprite == null) {	
							_skinSprite = createSkinMesh();
						}
						tSkinSprite = _skinSprite;
					}else {
						tSkinSprite = createSkinMesh();
					}
					if (tSkinSprite == null)
					{
						return;
					}
					var tIBArray:Array ;
					var tRed:Number = 1;
					var tGreed:Number = 1;
					var tBlue:Number = 1;
					var tAlpha:Number = 1;
					if (currDisplayData.bones == null)
					{
						var tVertices:Array = currDisplayData.weights;
						if (deformData)
						{
							tVertices = deformData;
						}
						var tUVs:Array;				
						if (_diyTexture)
						{
							if (!_curDiyUV)
							{
								_curDiyUV = [];
							}
							if (_curDiyUV.length == 0)
							{
								_curDiyUV = UVTools.getRelativeUV(this.currTexture.uv, currDisplayData.uvs,_curDiyUV);
								_curDiyUV = UVTools.getAbsoluteUV(this._diyTexture.uv, _curDiyUV, _curDiyUV);
							}
							tUVs = _curDiyUV;
						}else
						{
							tUVs = currDisplayData.uvs;
						}
						
						_mVerticleArr = tVertices;
						var tTriangleNum:int = currDisplayData.triangles.length / 3;
	
						tIBArray = currDisplayData.triangles;

						tSkinSprite.init2(tTexture, null , tIBArray,_mVerticleArr,tUVs);
						
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
								tSkinSprite.transform = tResultMatrix2;
							}
						}
					}else {
						skinMesh(boneMatrixArray,tSkinSprite,alpha);
					}
					
					graphics.drawSkin(tSkinSprite);
					break;
				case 2:
					if (noUseSave) {	
						if (_skinSprite == null) {	
							_skinSprite = createSkinMesh();
						}
						tSkinSprite = _skinSprite;
					}else {
						tSkinSprite = createSkinMesh();
					}
					if (tSkinSprite == null)
					{
						return;
					}
					skinMesh(boneMatrixArray, tSkinSprite, alpha);
					graphics.drawSkin(tSkinSprite);
					break;
				case 3:
					break;
			}
		}
		
		/**
		 * 显示蒙皮动画
		 * @param	boneMatrixArray 当前帧的骨骼矩阵
		 */
		private function skinMesh(boneMatrixArray:Array,skinSprite:*,alpha:Number):void
		{
			var tTexture:Texture = currTexture;
			var tBones:Array = currDisplayData.bones;
			var tUvs:Array;				
			if (_diyTexture)
			{
				tTexture = _diyTexture;
				if (!_curDiyUV)
				{
					_curDiyUV = [];
				}
				if (_curDiyUV.length == 0)
				{
					_curDiyUV = UVTools.getRelativeUV(this.currTexture.uv, currDisplayData.uvs,_curDiyUV);
					_curDiyUV = UVTools.getAbsoluteUV(this._diyTexture.uv, _curDiyUV, _curDiyUV);
				}
				tUvs = _curDiyUV;
			}else
			{
				tUvs = currDisplayData.uvs;
			}
			
			var tWeights:Array = currDisplayData.weights;
			var tTriangles:Array = currDisplayData.triangles;
			var tIBArray:Array ;
			var tRx:Number = 0;
			var tRy:Number = 0;
			var nn:int = 0;
			var tMatrix:Matrix;
			var tX:Number;
			var tY:Number;
			var tB:Number = 0;
			var tWeight:Number = 0;
			var tVertices:Array = [];
			var i:int = 0, j:int = 0, n:int = 0;
			var tRed:Number = 1;
			var tGreed:Number = 1;
			var tBlue:Number = 1;
			var tAlpha:Number = alpha;
			if (deformData && deformData.length > 0) {
				var f:Number = 0;
				for (i = 0, n = tBones.length; i < n;)
				{
					nn = tBones[i++] + i;
					tRx = 0, tRy = 0;
					for (; i < nn; i++)
					{
						tMatrix = boneMatrixArray[tBones[i]]
						tX = tWeights[tB] + deformData[f++];
						tY = tWeights[tB + 1] + deformData[f++];
						tWeight = tWeights[tB + 2];
						tRx += (tX * tMatrix.a + tY * tMatrix.c + tMatrix.tx) * tWeight;
						tRy += (tX * tMatrix.b + tY * tMatrix.d + tMatrix.ty) * tWeight;
						tB += 3;
					}
					tVertices.push(tRx, tRy);
				}
			}else {
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
			}
			_mVerticleArr = tVertices;
			tIBArray = tTriangles;
			skinSprite.init2(tTexture, null, tIBArray, _mVerticleArr,tUvs);
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