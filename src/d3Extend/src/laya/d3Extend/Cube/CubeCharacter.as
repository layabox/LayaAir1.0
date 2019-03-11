package laya.d3Extend.Cube {
	
	import laya.d3.animation.AnimationClip;
	import laya.d3.component.Animator;
	import laya.d3.component.AnimatorControllerLayer;
	import laya.d3.component.AnimatorState;
	import laya.d3.core.Avatar;
	import laya.d3.core.BufferState;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.webgl.WebGLContext;
	/**
	 * @private
	 * <code>CubeCharacter</code> 类用于将cube信息变成Meshsprite3D模型。
	 */
	public class CubeCharacter {
		
		public static var skinMeshsprti:SkinnedMeshSprite3D;
		public static var skinmesh:Mesh;
		public static var aniClipArray:Vector.<AnimationClip> = new Vector.<AnimationClip>();
		public static var avatar:Avatar;
		public static var animatorName:Vector.<String> = new Vector.<String>();
	
		

		
		/*public 用来当动画文件的父节点*/
		public var _Character:Sprite3D;
		/*public 最后合成的MeshSprite3D*/
		public var cubeCharacter:SkinnedMeshSprite3D;
		/*private 用来使用的Mesh*/
		private var _mesh:Mesh = new Mesh();		
		/*private 获得场景中的CubeMap*/
		private var _cubemap:CubeMap;
		/*private 获得场景中的CubeSprite*/
		private var _cubeSprite3D:CubeSprite3D;
		/*private 用来获得顶点数据的数组*/
		private var _vbDatas:Float32Array = new Float32Array(655360);
		private var _vbindex:int = 0;
		/*private 描述顶点的属性*/
		private static var _vertexDeclaration:VertexDeclaration = VertexMesh.getVertexDeclaration("POSITION,NORMAL,COLOR,BLENDWEIGHT,BLENDINDICES");
		/*private 描述到底有多少顶点*/
		private var _vertexCount:int;
		/*private 描述到底有多少顶点buffer*/
		private var _vertexBufferCount:int;
		/*private 当前操作的cubeInfo*/
		private var _cubeInfo:CubeInfo;
		/*private 传入的是*/
		
		
		/**
		 * 这个类用来初始化骨骼
		 */
		public static function __init__()
		{
			Sprite3D.load("Test/guge/stage.lh", Handler.create(null, function(sprite:Sprite3D):void {
				skinMeshsprti = sprite.getChildByName("snowboy_Skin").getChildByName("snow") as SkinnedMeshSprite3D;
				skinmesh = skinMeshsprti.meshFilter.sharedMesh as Mesh;
				animationclip();
				avatar = Loader.getRes("Test/guge/Assets/card/model/snowboy_Skin-snowboy_Skin-snowboy_SkinAvatar.lav") as Avatar;
				sprite.transform.rotationEuler
			}));
		}
		/**
		 * 这个类用来加载所有的骨骼文件
		 */
		public static function animationclip():void
		{
		
			var clip:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_walk-walk.lani") as AnimationClip;
			aniClipArray.push(clip);
			animatorName.push("walk");
			var clip1:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_bow-bow.lani") as AnimationClip;
			aniClipArray.push(clip1);
			animatorName.push("bow");
			var clip2:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_jump-jump.lani") as AnimationClip;
			aniClipArray.push(clip2);
			animatorName.push("jump");
			var clip3:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_throw-throw.lani") as AnimationClip;
			aniClipArray.push(clip3);
			animatorName.push("throw");
			clip2.islooping = true;
			var clip4:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_turn-turn.lani") as AnimationClip;
			aniClipArray.push(clip4);
			animatorName.push("turn");
			var clip5:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_wave-wave.lani") as AnimationClip;
			aniClipArray.push(clip5);
			animatorName.push("wave");
			
		}
		
		
		/**
		 * @private
		 */
		public function CubeCharacter(cubearray:Vector.<CubeInfo>,scene:Scene3D,cubesprite3D:CubeSprite3D)
		{
			
			_cubeSprite3D = cubesprite3D;
			parseCubeInfos(cubearray, skinmesh._boneNames, skinmesh._inverseBindPoses);
			
			_Character= new Sprite3D();
			var animator:Animator = _Character.addComponent(Animator) as Animator;
			animator.avatar = avatar;
			var animatorLayer:AnimatorControllerLayer = new AnimatorControllerLayer("animat");
			animator.addControllerLayer(animatorLayer);
			animatorStateCreat(animator);
			_Character.addChild(cubeCharacter);
			scene.addChild(_Character);

		}
		
		/**
		 * 此类用来创建绑定AnimationState
		 */
		public function animatorStateCreat(animator:Animator):void
		{
			for (var i:int = 0; i < animatorName.length; i++) {
				var animatorState:AnimatorState = new AnimatorState();
				animatorState.name = animatorName[i];
				animatorState.clip = aniClipArray[i];
				animator.addState(animatorState, 0);
			}
		}
		
		
		
		/**
		 * @private cubeinfo数组解析
		 * @param 方块信息数组
		 */
		public function parseCubeInfos(CubeinfoArray:Vector.<CubeInfo>,boneNames:Vector.<String>,InverseBindPoses:Vector.<Matrix4x4>):void
		{
		
			var vectorLength:int = CubeinfoArray.length;
			
			//组织VB数据
			for (var i:int = 0; i < vectorLength; i++) {
				if(CubeinfoArray[i].cubeProperty != 999)
				parseCubeinfo(CubeinfoArray[i])
			}
			
			console.log(_vbDatas);
	
			var vertexBuffer:VertexBuffer3D = new VertexBuffer3D(_vbDatas.length * 4, WebGLContext.STATIC_DRAW, true);
			vertexBuffer.vertexDeclaration = _vertexDeclaration;
			vertexBuffer.setData(_vbDatas);
			_mesh._vertexBuffers.push(vertexBuffer);
			_mesh._vertexCount += vertexBuffer.vertexCount;
			//组织IB数据
			var maxfaceNums:int = _vertexCount / 4;
			var ibDatas:Uint16Array = new Uint16Array(maxfaceNums * 6);
			for (var j:int = 0; j <maxfaceNums ; j++) {
				var indexOffset:int = j * 6;
				var pointOffset:int = j * 4;
				ibDatas[indexOffset] = pointOffset;
				ibDatas[indexOffset + 1] = 2 + pointOffset;
				ibDatas[indexOffset + 2] = 1 + pointOffset;
				ibDatas[indexOffset + 3] = pointOffset;
				ibDatas[indexOffset + 4] = 3 + pointOffset;
				ibDatas[indexOffset + 5] = 2 + pointOffset;
			}
			console.log(ibDatas);
		
			//为啥要除以2
			var indexBuffer:IndexBuffer3D = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, ibDatas.length, WebGLContext.STATIC_DRAW, true);
			indexBuffer.setData(ibDatas);
			_mesh._indexBuffer = indexBuffer;
			
			
			//接下来就该绑定骨骼数据了
			_mesh._boneNames = boneNames;
			_mesh._inverseBindPoses = InverseBindPoses;
			
			//SubMesh的绑定
			var submeshs:Vector.<SubMesh> = new Vector.<SubMesh>();
			var submesh:SubMesh = new SubMesh(_mesh);
			submesh._indexBuffer = _mesh._indexBuffer;
			submesh._indexStart = 0;
			submesh._indexCount = ibDatas.length;
			submesh._indices = new Uint16Array(_mesh._indexBuffer.getData().buffer, 0, ibDatas.length);
			submesh._vertexBuffer = _mesh._vertexBuffers[0];
			
			var bufferstate:BufferState = submesh._bufferState;
			bufferstate.bind();

			bufferstate.applyVertexBuffer(_mesh._vertexBuffers[0]);
			bufferstate.applyIndexBuffer(_mesh._indexBuffer);
			bufferstate.unBind();
			
			var subIndexBufferStart:Vector.<int> = submesh._subIndexBufferStart;
			var subIndexBufferCount:Vector.<int> = submesh._subIndexBufferCount;
			var boneIndicesList:Vector.<Uint16Array> = submesh._boneIndicesList;
			var drawCount:int = 1;
			boneIndicesList.length = drawCount;
			subIndexBufferStart.length = drawCount;
			subIndexBufferCount.length = drawCount;
			
			subIndexBufferStart[0] = 0;
			subIndexBufferCount[0] = ibDatas.length;
			
			var pathMarks:Vector.<Array> = _mesh._skinDataPathMarks;
			var bindPoseIndices:Vector.<int> = new Vector.<int>();
			var subMeshIndex:int = 0;
			
			
			boneIndicesList[0] = new Uint16Array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10]);
			var boneIndices:Uint16Array = boneIndicesList[0];
			for (var k:int = 0,m:int = boneIndices.length; k < m; k++) {
				var index:int = boneIndices[k];
				var combineIndex:int = bindPoseIndices.indexOf(index);
				if (combineIndex===-1){
					boneIndices[j]=bindPoseIndices.length;
					bindPoseIndices.push(index);
					pathMarks.push([subMeshIndex,0,k]);
					}else {
					boneIndices[j]=combineIndex;
				}
			}
	

			submeshs.push(submesh);
			_mesh._bindPoseIndices = new Uint16Array(boneIndices);
			_mesh._setSubMeshes(submeshs);
			cubeCharacter = new SkinnedMeshSprite3D(_mesh);
		}
		
		/**
		 * @private 解析一个方块信息的方法
		 * @param 方块
		 */
		public function parseCubeinfo(cubeInfo:CubeInfo):void
		{
				var blendIndices:int = calBlendIndices(cubeInfo.cubeProperty);
				_cubeInfo = cubeInfo
				var subecubeGeometry:SubCubeGeometry =_cubeInfo.subCube;
				if (_cubeInfo.frontVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.frontVBIndex, subecubeGeometry, blendIndices);
				}
				if (_cubeInfo.backVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.backVBIndex, subecubeGeometry, blendIndices);
				}
				if (_cubeInfo.leftVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.leftVBIndex, subecubeGeometry, blendIndices);
				}
				if (_cubeInfo.rightVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.rightVBIndex, subecubeGeometry, blendIndices);
				}
				if (_cubeInfo.topVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.topVBIndex, subecubeGeometry, blendIndices);
				}
				if (_cubeInfo.downVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.downVBIndex, subecubeGeometry, blendIndices);
				}
		}
		
		/**
		 * @private 根据方块特殊的属性来计算这个方块的骨骼位置
		 * @param 方块属性
		 */
		public function calBlendIndices(index:int):int
		{
			//需要改
			return index;
		}
		
		/**
		 * @private 将一个面的数据传入buffer
		 * @param 方块VB位置  顶点数据获得的地方   骨骼索引
		 */
		public function pushOneFaceData(vbindex:int,subecubeGeometry:SubCubeGeometry,blendIndices:int):void
		{

			var vertexArray:Float32Array =subecubeGeometry._vertices[vbindex >> 24];
			var offset:int = vbindex & 0x00ffffff;
			for (var i:int = 0; i < 4; i++) {
				var ss:int = i*10
				for (var j:int = 0; j < 10; j++) {
					_vbDatas[_vbindex] =vertexArray[offset + ss + j];
					_vbindex++;
				}
				_vbDatas[_vbindex] = 1;
				_vbDatas[_vbindex+1] = 0;
				_vbDatas[_vbindex+2] = 0;
				_vbDatas[_vbindex+3] = 0;
				_vbDatas[_vbindex+4] =blendIndices;
				_vbDatas[_vbindex+5] = 0;
				_vbDatas[_vbindex+6] = 0;
				_vbDatas[_vbindex + 7] = 0;
				_vbindex += 8;
			}
			
			_vertexCount += 4;
		}
		
		
		
		
		
		
	}

}