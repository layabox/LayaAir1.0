package laya.ani.bone {
	import laya.ani.KeyframesAniTemplet;
	import laya.ani.bone.BoneSlot;
	import laya.ani.bone.SkinData;
	import laya.ani.bone.SkinSlotDisplayData;
	import laya.ani.bone.SlotData;
	import laya.ani.bone.Transform;
	import laya.display.Graphics;
	import laya.events.Event;
	import laya.resource.Texture;
	import laya.utils.Byte;
	
	/**
	 * 动画模板类
	 */
	public class Templet extends KeyframesAniTemplet {
		private var _mainTexture:Texture;
		private var _textureJson:*;
		private var _graphicsCache:Array = [];
		
		/** 存放原始骨骼信息 */
		public var srcBoneMatrixArr:Array = [];
		/** 存放插槽数据的字典 */
		public var boneSlotDic:Object = {};
		/** 存放插糟数据的数组 */
		public var boneSlotArray:Array = [];
		/** 皮肤数据 */
		public var skinDataArray:Array = [];
		/** 存放纹理数据 */
		public var subTextureDic:Object = {};
		
		private var _rate:int = 60;
		
		/**
		 * 解析骨骼动画数据
		 * @param	skeletonData	骨骼动画信息及纹理分块信息
		 * @param	texture			骨骼动画用到的纹理
		 * @param	playbackRate	缓冲的帧率数据（会根据帧率去分帧）
		 */
		public function parseData(texture:Texture, skeletonData:ArrayBuffer, playbackRate:int = 60):void {
			_mainTexture = texture;
			_rate = playbackRate;
			parse(skeletonData, playbackRate);
		}
		
		/**
		 * 创建动画
		 * @return
		 */
		public function buildArmature():Skeleton {
			return new Skeleton(this);
		}
		
		/**
		 * 解析动画
		 * @param	data
		 * @param	playbackRate
		 */
		override public function parse(data:ArrayBuffer, playbackRate:int):void {
			super.parse(data, playbackRate);
			//解析公共数据
			_parsePublicExtData();
			this.event(Event.COMPLETE, this);
		}
		
		/**
		 * 解析自定义数据
		 */
		private function _parsePublicExtData():void {
			var i:int = 0, j:int = 0, k:int = 0, n:int = 0;
			for (i = 0, n = getAnimationCount(); i < n; i++) {
				_graphicsCache.push([]);
			}
			var tByte:Byte = new Byte(getPublicExtData());
			var tX:Number = 0, tY:Number = 0, tWidth:Number = 0, tHeight:Number = 0;
			var tFrameX:Number = 0, tFrameY:Number = 0, tFrameWidth:Number = 0, tFrameHeight:Number = 0;
			var tTextureLen:int = tByte.getUint8();
			var tTextureName:String = tByte.readUTFString();
			var tTextureNameArr:Array = tTextureName.split("\n");
			for (i = 0; i < tTextureLen; i++) {
				tTextureName = tTextureNameArr[i];
				tX = tByte.getFloat32();
				tY = tByte.getFloat32();
				tWidth = tByte.getFloat32();
				tHeight = tByte.getFloat32();
				tFrameX = tByte.getFloat32();
				tFrameY = tByte.getFloat32();
				tFrameWidth = tByte.getFloat32();
				tFrameHeight = tByte.getFloat32();
				
				subTextureDic[tTextureName] = Texture.create(_mainTexture, tX, tY, tWidth, tHeight, -tFrameX, -tFrameY, tFrameWidth, tFrameHeight);
			}
			
			var tMatrixDataLen:int = tByte.getUint16();
			var tLen:int = tByte.getUint16();
			var parentIndex:int;
			var bones:Vector.<*> = getNodes(0);
			var boneLength:int = bones.length;
			
			var tMatrixArray:Array = srcBoneMatrixArr;
			for (i = 0; i < boneLength; i++) {
				var tResultTransform:Transform = new Transform();
				tResultTransform.scX = tByte.getFloat32();
				tResultTransform.skX = tByte.getFloat32();
				tResultTransform.skY = tByte.getFloat32();
				tResultTransform.scY = tByte.getFloat32();
				tResultTransform.x = tByte.getFloat32();
				tResultTransform.y = tByte.getFloat32();
				tMatrixArray.push(tResultTransform);
			}
			
			//创建插槽并绑定到骨骼上
			var tBoneSlotLen:int = tByte.getInt16();
			for (i = 0; i < tBoneSlotLen; i++) {
				var tDBBoneSlot:BoneSlot = new BoneSlot();
				var tName:String = tByte.readUTFString();
				var tParent:String = tByte.readUTFString();
				var tDisplayIndex:int = tByte.getInt16();
				boneSlotDic[tParent] = tDBBoneSlot;
				boneSlotArray.push(tDBBoneSlot);
			}
			
			var tNameString:String = tByte.readUTFString();
			var tNameArray:Array = tNameString.split("\n");
			var tNameStartIndex:int = 0;
			
			var tSkinDataLen:int = tByte.getUint8();
			for (i = 0; i < tSkinDataLen; i++) {
				var tSkinData:SkinData = new SkinData();
				tSkinData.name = tNameArray[tNameStartIndex++];
				var tSlotDataLen:int = tByte.getUint8();
				
				for (j = 0; j < tSlotDataLen; j++) {
					var tSlotData:SlotData = new SlotData();
					tSlotData.name = tNameArray[tNameStartIndex++];
					var tDisplayDataLen:int = tByte.getUint8();
					for (k = 0; k < tDisplayDataLen; k++) {
						var tDisplayData:SkinSlotDisplayData = new SkinSlotDisplayData();
						tDisplayData.name = tNameArray[tNameStartIndex++];
						tDisplayData.transform = new Transform();
						tDisplayData.transform.scX = tByte.getFloat32();
						tDisplayData.transform.skX = tByte.getFloat32();
						tDisplayData.transform.skY = tByte.getFloat32();
						tDisplayData.transform.scY = tByte.getFloat32();
						tDisplayData.transform.x = tByte.getFloat32();
						tDisplayData.transform.y = tByte.getFloat32();
						tSlotData.displayArr.push(tDisplayData);
					}
					tSkinData.slotArr.push(tSlotData);
				}
				skinDataArray.push(tSkinData);
			}
		}
		
		/**
		 * 得到缓冲数据
		 * @param	aniIndex
		 * @param	frameIndex
		 * @return
		 */
		public function getGrahicsDataWithCache(aniIndex:int, frameIndex:Number):Graphics {
			return _graphicsCache[aniIndex][frameIndex];
		}
		
		/**
		 * 保存缓冲grahpics
		 * @param	aniIndex
		 * @param	frameIndex
		 * @param	graphics
		 */
		public function setGrahicsDataWithCache(aniIndex:int, frameIndex:int, graphics:Graphics):void {
			trace("aniIndex:" + aniIndex.toString() + " frameIndex:" + frameIndex.toString());
			_graphicsCache[aniIndex][frameIndex] = graphics;
		}
		
		/**
		 * 预留
		 */
		public function destory():void {
		
		}
		
		/***********************************下面为一些儿访问接口*****************************************/
		/**
		 * 通过索引得动画名称
		 * @param	index
		 * @return
		 */
		public function getAniNameByIndex(index:int):String {
			var tAni:* = getAnimation(index);
			if (tAni) return tAni.name;
			return null;
		}
		
		public function get rate():Number {
			return _rate;
		}
		
		/*****************************************下面是一些儿兼容性接口*****************************************************/
		/**
		 * 解析骨骼动画数据
		 * @param	skeletonData	骨骼动画信息及纹理分块信息
		 * @param	texture			骨骼动画用到的纹理
		 * @param	playbackRate	缓冲的帧率数据（会根据帧率去分帧）
		 */
		public function Templet(skeletonData:ArrayBuffer = null, texture:Texture = null, playbackRate:int = 60):void {
			if (skeletonData && texture) {
				parseData(texture, skeletonData, playbackRate);
			}
		}
		
		public function get textureWidth():Number {
			if (_mainTexture) {
				return _mainTexture.sourceWidth;
			}
			return 0;
		}
		
		public function get textureHeight():Number {
			if (_mainTexture) {
				return _mainTexture.sourceHeight;
			}
			return 0;
		}
	}
}