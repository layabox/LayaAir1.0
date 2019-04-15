package Cube {
	import laya.d3.animation.AnimationClip;
	import laya.d3.component.Animator;
	import laya.d3.component.AnimatorControllerLayer;
	import laya.d3.component.AnimatorState;
	import laya.d3.core.Avatar;
	import laya.d3.core.BufferState;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3Extend.Cube.CubeInfo;
	import laya.d3Extend.Cube.CubeMap;
	import laya.d3Extend.Cube.CubeSprite3D;
	import laya.d3Extend.Cube.SubCubeGeometry;
	import laya.d3Extend.worldMaker.CubeInfoArray;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.webgl.WebGLContext;
	import zTest.CubeMapTest;
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
	
		public static var gujiaxArray:Int32Array = new Int32Array([-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-7,-7,-7,-7,-7,-7,-7,-7,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-6,-6,-6,-6,-6,-6,-6,-5,-4,-3,-2,-1,-7,-6,-7,-7,-7,-7,-7,-7,-7,-7,-7,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-6,-6,-6,-6,-6,-6,-6,-5,-7,-6,-7,-7,-7,-7,-7,-7,-7,-7,-7,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-6,-6,-6,-6,-6,-6,-6,-5,-7,-6,-7,-7,-7,-7,-7,-7,-7,-7,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,6,6,6,6,6,6,6,6,6,0,1,2,3,4,5,6,0,1,2,3,4,5,5,5,5,5,5,5,5,5,0,1,2,3,4,5,6,6,6,6,6,6,6,6,6,0,1,2,3,4,5,6,0,1,2,3,4,5,5,5,5,5,5,5,5,5,4,5,6,6,6,6,6,6,6,6,6,0,1,2,3,4,5,6,0,1,2,3,4,5,5,5,5,5,5,5,5,5,4,5,6,6,6,6,6,6,6,6,6,0,1,2,3,4,5,6,-4,-3,-2,-4,-3,-2,-4,-3,-2,-4,-3,-2,-4,-3,-2,-6,-5,-1,-6,-6,-6,-6,-15,-14,-13,-12,-11,-10,-9,-8,-7,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-6,-5,-7,-6,-7,-7,-7,-7,-7,-7,-7,-7,-7,-6,-5,-4,-3,-2,-1,-4,-3,-2,-4,-2,-4,-2,-4,-2,-4,-2,-6,-5,-1,-6,-6,-6,-6,-15,-14,-13,-12,-11,-10,-9,-8,-7,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-6,-5,-7,-6,-7,-7,-7,-7,-7,-7,-7,-7,-7,-6,-5,-4,-3,-2,-1,-4,-3,-2,-4,-2,-4,-3,-2,-4,-3,-2,-4,-3,-2,-6,-5,-1,-6,-6,-6,-6,-6,-6,-6,-6,-5,-7,-6,-7,-7,-7,-7,-7,-7,-7,-7,-7,-6,-5,-4,-3,-2,-1,-4,-3,-2,-4,-3,-2,-6,-5,-4,-3,-2,-1,-6,-6,-6,-6,-6,-6,-6,-6,-5,-7,-6,-7,-7,-7,-7,-7,-7,-7,-7,-7,-6,-5,-4,-3,-2,-1,-4,-3,-2,-4,-3,-2,-6,-5,-4,-3,-2,-1,-6,-6,-6,-6,-6,-6,-6,-6,-5,-4,-3,-2,-1,-7,-6,-7,-7,-7,-7,-7,-7,-7,-7,-7,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-7,-7,-7,-7,-3,-7,-3,-7,-7,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-2,-1,-7,-6,-5,-4,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,-7,-6,-5,-4,-3,-2,-1,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,0,4,5,5,5,5,5,6,7,8,9,10,11,12,13,14,6,7,8,9,10,11,12,13,14,5,5,4,5,6,6,6,6,6,6,6,6,6,0,1,2,3,4,5,6,1,2,3,1,3,1,3,1,3,1,3,0,4,5,5,5,5,5,6,7,8,9,10,11,12,13,14,6,7,8,9,10,11,12,13,14,5,5,4,5,6,6,6,6,6,6,6,6,6,0,1,2,3,4,5,6,1,2,3,1,3,1,2,3,1,2,3,1,2,3,0,4,5,5,5,5,5,5,5,5,5,4,5,6,6,6,6,6,6,6,6,6,0,1,2,3,4,5,6,1,2,3,1,2,3,0,1,2,3,4,5,5,5,5,5,5,5,5,5,4,5,6,6,6,6,6,6,6,6,6,0,1,2,3,4,5,6,1,2,3,1,2,3,0,1,2,3,4,5,5,5,5,5,5,5,5,5,0,1,2,3,4,5,6,6,6,6,6,6,6,6,6,0,1,2,3,4,5,6,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,6,6,6,6,6,2,6,2,6,6,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,3,4,5,6,0,1,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6,0,1,2,3,4,5,6]);
		public static var gujiayArray:Int32Array = new Int32Array([15,15,15,15,15,15,15,16,16,16,16,16,16,16,17,17,17,17,17,17,17,18,18,18,18,18,18,18,19,19,19,19,19,19,19,20,20,20,20,20,20,20,21,21,21,21,21,21,21,22,22,22,22,22,22,22,23,23,23,23,23,23,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9,9,9,9,10,10,10,10,10,10,11,11,11,11,11,11,12,12,12,12,12,12,13,13,13,13,13,13,15,15,15,15,15,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,14,14,14,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,15,15,15,15,15,15,15,16,16,16,16,16,16,16,17,17,17,17,17,17,17,18,18,18,18,18,18,18,19,19,19,19,19,19,19,20,20,20,20,20,20,20,21,21,21,21,21,21,21,22,22,22,22,22,22,22,23,23,23,23,23,23,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9,9,9,9,10,10,10,10,10,10,11,11,11,11,11,11,12,12,12,12,12,12,13,13,13,13,13,13,15,15,15,15,15,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,14,14,14,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,7,8,9,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,0,0,0,1,1,2,2,3,3,4,4,5,5,5,6,7,8,9,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,0,0,0,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,7,8,9,10,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,0,0,0,1,1,1,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,0,0,0,1,1,1,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,14,14,14,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9,9,9,9,10,10,10,10,10,10,11,11,11,11,11,11,12,12,12,12,12,12,13,13,13,13,13,13,15,15,15,15,15,15,15,16,17,18,19,20,20,21,21,22,23,24,24,24,24,24,24,24,15,15,15,15,15,15,15,16,16,16,16,16,16,16,17,17,17,17,17,17,17,18,18,18,18,18,18,18,19,19,19,19,19,19,19,20,20,20,20,20,20,21,21,21,21,21,21,22,22,22,22,22,22,22,23,23,23,23,23,23,23,24,24,24,24,24,24,24,0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,7,8,9,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,0,0,0,1,1,2,2,3,3,4,4,5,5,5,6,7,8,9,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,0,0,0,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,7,8,9,10,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,0,0,0,1,1,1,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,0,0,0,1,1,1,5,5,5,5,5,5,6,7,8,9,10,11,12,13,14,14,14,14,14,15,15,16,17,18,19,20,21,22,23,24,24,24,24,24,24,24,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9,9,9,9,10,10,10,10,10,10,11,11,11,11,11,11,12,12,12,12,12,12,13,13,13,13,13,13,15,15,15,15,15,15,15,16,17,18,19,20,20,21,21,22,23,24,24,24,24,24,24,24,15,15,15,15,15,15,15,16,16,16,16,16,16,16,17,17,17,17,17,17,17,18,18,18,18,18,18,18,19,19,19,19,19,19,19,20,20,20,20,20,20,21,21,21,21,21,21,22,22,22,22,22,22,22,23,23,23,23,23,23,23,24,24,24,24,24,24,24]);
		public static var gujiazArray:Int32Array = new Int32Array([-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6]);
		public static var gujiacolArray:Int32Array = new Int32Array([1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,56734,13615,13615,13615,13615,13615,13615,13615,13615,13615,16710335,16710335,16710335,16710335,16710335,16710335,16710335,56734,56734,6734,6734,6734,6734,6734,6734,6734,56734,56734,6734,6734,6734,6734,6734,6734,6734,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,13615,13615,13615,13615,13615,13615,16710335,16710335,16710335,16710335,16710335,16710335,16710335,56734,56734,6734,6734,6734,6734,6734,6734,6734,56734,56734,6734,6734,6734,6734,6734,6734,6734,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,13615,13615,13615,13615,13615,13615,13615,13615,13615,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,56734,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,56734,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,56734,13615,13615,13615,13615,13615,13615,13615,13615,13615,16710335,16710335,16710335,16710335,16710335,16710335,16710335,6734,6734,6734,6734,6734,6734,6734,56734,56734,6734,6734,6734,6734,6734,6734,6734,56734,56734,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,13615,13615,13615,13615,13615,13615,16710335,16710335,16710335,16710335,16710335,16710335,16710335,6734,6734,6734,6734,6734,6734,6734,56734,56734,6734,6734,6734,6734,6734,6734,6734,56734,56734,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,13615,13615,13615,13615,13615,13615,13615,13615,13615,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,56734,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,56734,56734,56734,56734,56734,56734,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,16710335,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358,1358]);
		public static var Large:int = 1;
		public static var CUBECHARACTER_SMALL = 1;
		public static var CUBECHARACTER_MEDIUM = 2;
		public static var CUBECHARACTER_LARGE = 3;
		
		
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
		private var _vbDatas:Float32Array;
		private var _vbindex:int = 0;
		/*private 描述顶点的属性*/
		private static var _vertexDeclaration:VertexDeclaration = VertexMesh.getVertexDeclaration("POSITION,NORMAL,COLOR,BLENDWEIGHT,BLENDINDICES");
		/*private 描述到底有多少顶点*/
		private var _vertexCount:int;
		/*private 描述到底有多少顶点buffer*/
		private var _vertexBufferCount:int;
		/*private 当前操作的cubeInfo*/
		private var _cubeInfo:CubeInfo;
		/*private 左肩范围格子*/
		private var leftArammax:Vector3 = new Vector3( -999, -999,-999);
		private var leftArammin:Vector3 = new Vector3(999, 999,999);
		/*private 右肩范围格子*/
		private var rightArammax:Vector3 = new Vector3( -999, -999,-999);
		private var rightArammin:Vector3 = new Vector3(999, 999,999);
		/*private 左腿范围格子*/
		private var leftlegmax:Vector3 = new Vector3( -999, -999,-999);
		private var leftlegmin:Vector3 = new Vector3(999, 999,999);
		/*private 右腿范围格子*/
		private var rightlegmax:Vector3 = new Vector3( -999, -999,-999);
		private var rightlegmin:Vector3 = new Vector3(999, 999,999);
		
		
		private var bkub:BlinnPhongMaterial;
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
		public static var num:int = 0;
		public static function creatbones(cubesprite3D:CubeSprite3D):void
		{
			
			//身体
			creatOneBounes(cubesprite3D, -6 * Large, 6 * Large-1, 5 * Large, 14 * Large-1, -5 * Large, 5 * Large-1, 1358);
			//右肩
			creatOneBounes(cubesprite3D, -13 * Large, -6 * Large-1, 10 * Large, 12 * Large-1, -1 * Large,  Large-1, 5885);
			//右手
			creatOneBounes(cubesprite3D, -15 * Large, -13 * Large-1, 10 * Large, 12 * Large-1, -1 * Large, Large-1, 16710335);
			//左肩
			creatOneBounes(cubesprite3D, 6 * Large, 13 * Large-1, 10 * Large, 12 * Large-1, -1 * Large,Large-1, 5885);
			//左手
			creatOneBounes(cubesprite3D, 13 * Large, 15* Large-1, 10* Large, 12 * Large-1, -1 * Large, 1 * Large-1, 16710335);
			//右腿
			creatOneBounes(cubesprite3D, -4 * Large, -1 * Large-1, 2 * Large, 5 * Large-1, -1 * Large, 2 * Large-1, 1265425);
			//左腿
			creatOneBounes(cubesprite3D, 1 * Large, 4 * Large-1, 2 * Large, 5 * Large-1, -1 * Large, 2 * Large-1,1265425);
			//脖子
			creatOneBounes(cubesprite3D, -5 * Large, 5 * Large-1, 14 * Large, 15 * Large-1, -4 * Large, 4 * Large-1, 51358);
			//头
			creatOneBounes(cubesprite3D, -7 * Large, 7 * Large-1, 15 * Large, 25 * Large-1, -6 * Large, 6 * Large-1, 51358);
			//右脚
			creatOneBounes(cubesprite3D,  -4 * Large, -1 * Large-1, 0, 2*Large-1,-1 * Large, 4 * Large-1, 51358);
			//左脚
			creatOneBounes(cubesprite3D, 1 * Large, 4 * Large-1, 0, 2 * Large-1, -1 * Large, 4 * Large-1, 51358);
			console.log(num);
		}
		public static function creatOneBounes(cubesprite3D:CubeSprite3D, xmin:int, xmax:int, ymin:int, ymax:int, zmin, zmax,color:int):void
		{
			for (var i:int = xmin; i <=xmax ; i++) {
				for (var j:int = ymin; j <= ymax ; j++) {
					for (var k:int = zmin; k <=zmax ; k++) {
						cubesprite3D.AddCube(i, j, k, color);
						num++;
					}
				}
			}
		}
		
		/**
		 * 这个类用来加载所有的骨骼文件
		 */
		public static function animationclip():void
		{
		
			var clip:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_walk-walk.lani") as AnimationClip;
			aniClipArray.push(clip);
			animatorName.push("walk");
			clip.islooping = true;
			var clip1:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_bow-bow.lani") as AnimationClip;
			aniClipArray.push(clip1);
			animatorName.push("bow");
			clip1.islooping = true;
			var clip2:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_jump-jump.lani") as AnimationClip;
			aniClipArray.push(clip2);
			animatorName.push("jump");
			clip2.islooping = true;
			var clip3:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_throw-throw.lani") as AnimationClip;
			aniClipArray.push(clip3);
			animatorName.push("throw");
			clip3.islooping = true;
			var clip4:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_turn-turn.lani") as AnimationClip;
			aniClipArray.push(clip4);
			animatorName.push("turn");
			clip4.islooping = true;
			var clip5:AnimationClip = Loader.getRes("Test/guge/Assets/card/model/snowboy_wave-wave.lani") as AnimationClip;
			aniClipArray.push(clip5);
			animatorName.push("wave");
			clip5.islooping = true;
		}
	
		/**
		 * @private
		 */
		public function CubeCharacter(scene:Scene3D,cubesprite3D:CubeSprite3D)
		{
			_Character= new Sprite3D();
			var animator:Animator = _Character.addComponent(Animator) as Animator;
			animator.avatar = avatar;
			var animatorLayer:AnimatorControllerLayer = new AnimatorControllerLayer("animat");
			animator.addControllerLayer(animatorLayer);
			animatorStateCreat(animator);
			
			 bkub = new BlinnPhongMaterial();
			 bkub.specularColor = new Vector4(0.2, 0.2, 0.2, 1);
			 bkub.enableVertexColor = true;
		}
		public function hide():void
		{
			_Character.removeSelf();
			cubeCharacter && cubeCharacter.removeSelf();
		}
		
		public function init(cubearray:Vector.<CubeInfo>,scene:Scene3D,cubesprite3D:CubeSprite3D):void
		{
			var youjian:Vector.<CubeInfo> = new Vector.<CubeInfo>();
			var zuojian:Vector.<CubeInfo> = new Vector.<CubeInfo>();
			var youtui:Vector.<CubeInfo> = new Vector.<CubeInfo>();
			var zuotui:Vector.<CubeInfo> = new Vector.<CubeInfo>();
			
			var leng:int = cubearray.length;
			for (var i:int = 0; i<leng; i++) 
			{
				//右肩
				if (cubearray[i].x-1600 ==-(6*Large+1)&&cubearray[i].y-1600<=(14*Large-1) &&cubearray[i].y-1600>=5*Large)
				{
					youjian.push(cubearray[i]);
				}
				//左肩
				else if (cubearray[i].x-1600 == 6*Large && cubearray[i].y-1600<=(14*Large-1) &&cubearray[i].y-1600>=5*Large)
				{
					zuojian.push(cubearray[i]);
				}
				//右腿
				else if (cubearray[i].y - 1600 == (5*Large-1) && cubearray[i].x-1600 <= 0)
				{
					youtui.push(cubearray[i]);
				}
				//左腿
				else if (cubearray[i].y - 1600 == (5*Large-1) && cubearray[i].x-1600 >= 0)
				{
					zuotui.push(cubearray[i]);
				}	
			}
			calarm(youjian,0);
			calarm(zuojian,1);
			calleg(youtui,0);
			calleg(zuotui,1);
			_cubeSprite3D = cubesprite3D;
			parseCubeInfos(cubearray, skinmesh._boneNames, skinmesh._inverseBindPoses);
			scene.addChild(_Character);
			_Character.addChild(cubeCharacter);
			cubeCharacter.skinnedMeshRenderer.material  = bkub;
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
		
		//计算肩膀范围
		public function calarm(cubearray:Vector.<CubeInfo>, index:int):void
		{
	
			var miny:int = 999;
			var maxy:int = -999;
			var minz:int = 999;
			var maxz:int = -999;
			for (var i:int = 0; i < cubearray.length; i++) {
				if (cubearray[i].y - 1600 > maxy)
				{
					maxy = cubearray[i].y - 1600;
				}
				if (cubearray[i].y - 1600 < miny)
				{
					miny = cubearray[i].y - 1600;
				}
				if (cubearray[i].z - 1600 > maxz)
				{
					maxz = cubearray[i].z - 1600;
				}
				if (cubearray[i].z - 1600 < minz)
				{
					minz = cubearray[i].z - 1600;
				}
			}
			switch(index)
			{
				case 0:
					
					rightArammax.y = maxy+1;
					rightArammax.z = maxz+1;
					rightArammin.y = miny;
					rightArammin.z = minz;
					break;
				case 1:
					leftArammax.y = maxy+1;
					leftArammax.z = maxz+1;
					leftArammin.y = miny;
					leftArammin.z = minz;
					break;
			}
			
		}
		//计算腿部范围
		public function calleg(cubearray:Vector.<CubeInfo>,index:int):void
		{
			var minx:int = 999;
			var maxx:int = -999;
			var minz:int = 999;
			var maxz:int = -999;
			for (var i:int = 0; i < cubearray.length; i++) {
				if (cubearray[i].x - 1600 > maxx)
				{
					maxx = cubearray[i].x - 1600;
				}
				if (cubearray[i].x - 1600 < minx)
				{
					minx = cubearray[i].x - 1600;
				}
				if (cubearray[i].z - 1600 > maxz)
				{
					maxz = cubearray[i].z - 1600;
				}
				if (cubearray[i].z - 1600 < minz)
				{
					minz = cubearray[i].z - 1600;
				}
			}
			switch(index)
			{
				case 0:
					rightlegmax.x = maxx+1;
					rightlegmax.z = maxz+1;
					rightlegmin.x = minx;
					rightlegmin.z = minz;
					break;
				case 1:
					leftlegmax.x = maxx+1;
					leftlegmax.z = maxz+1;
					leftlegmin.x = minx;
					leftlegmin.z = minz;
					break;
			}
			
		}
		
		public function onecubesFace(cubeinfo:CubeInfo):int
		{
			var num:int = 0;
			 num += (cubeinfo.backVBIndex ==-1?0:1);
			 num += (cubeinfo.frontVBIndex ==-1?0:1);
			 num += (cubeinfo.leftVBIndex ==-1?0:1);
			 num += (cubeinfo.rightVBIndex ==-1?0:1);
			 num += (cubeinfo.topVBIndex ==-1?0:1);
			 num += (cubeinfo.downVBIndex ==-1?0:1);
			 return num;
		}
		
		/**
		 * @private cubeinfo数组解析
		 * @param 方块信息数组
		 */
		public function parseCubeInfos(CubeinfoArray:Vector.<CubeInfo>,boneNames:Vector.<String>,InverseBindPoses:Vector.<Matrix4x4>):SkinnedMeshSprite3D
		{
			//if (_mesh)
				//_mesh.destroy();
			_mesh = new Mesh();
			var maxvertexNum:int = 0;
			_vbindex = 0;
			var lent:int = CubeinfoArray.length;
			for (var l:int = 0; l < lent; l++) {
				maxvertexNum+=onecubesFace(CubeinfoArray[l]);
			}
		
			_vbDatas = new Float32Array(maxvertexNum*4*18);
	
			//组织VB数据
			for (var i:int = 0; i < lent; i++) {
			
				parseCubeinfo(CubeinfoArray[i])
			}
			
	
			//_vbDatas = new Float32Array(点*10)
			var vertexBuffer:VertexBuffer3D = new VertexBuffer3D(_vbDatas.length * 4, WebGLContext.STATIC_DRAW, true);
			vertexBuffer.vertexDeclaration = _vertexDeclaration;
			vertexBuffer.setData(_vbDatas);
			_mesh._vertexBuffers.push(vertexBuffer);
			_mesh._vertexCount += vertexBuffer.vertexCount;
			//组织IB数据
		
			var maxfaceNums:int = maxvertexNum;
			console.log(maxfaceNums*4);
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
		
		
			//为啥要除以2
			var indexBuffer:IndexBuffer3D = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, ibDatas.length, WebGLContext.STATIC_DRAW, true);
			indexBuffer.setData(ibDatas);
			_mesh._indexBuffer = indexBuffer;
			
			var bufferState:BufferState = _mesh._bufferState;
			bufferState.bind();
			bufferState.applyVertexBuffers(_mesh._vertexBuffers);
			bufferState.applyIndexBuffer(indexBuffer);
			bufferState.unBind();
			
			
			
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
			
			//var bufferstate:BufferState = submesh._bufferState;
			//bufferstate.bind();
			//bufferstate.applyVertexBuffer(_mesh._vertexBuffers[0]);
			//bufferstate.applyIndexBuffer(_mesh._indexBuffer);
			//bufferstate.unBind();
			
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
			//cubeCharacter.meshFilter.sharedMesh = _mesh;
			if (!cubeCharacter)
			{
				cubeCharacter = new SkinnedMeshSprite3D();
			}
			cubeCharacter.meshFilter.sharedMesh = _mesh;
			//cubeCharacter = new SkinnedMeshSprite3D(_mesh);
			return cubeCharacter;
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
					pushOneFaceData(_cubeInfo.frontVBIndex, subecubeGeometry/*, blendIndices*/);
				}
				if (_cubeInfo.backVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.backVBIndex, subecubeGeometry/*, blendIndices*/);
				}
				if (_cubeInfo.leftVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.leftVBIndex, subecubeGeometry/*, blendIndices*/);
				}
				if (_cubeInfo.rightVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.rightVBIndex, subecubeGeometry/*, blendIndices*/);
				}
				if (_cubeInfo.topVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.topVBIndex, subecubeGeometry/*, blendIndices*/);
				}
				if (_cubeInfo.downVBIndex !=-1)
				{
					pushOneFaceData(_cubeInfo.downVBIndex, subecubeGeometry/*, blendIndices*/);
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
		public function pushOneFaceData(vbindex:int,subecubeGeometry:SubCubeGeometry/*,blendIndices:int*/):void
		{

	
			var vertexArray:Float32Array =subecubeGeometry._vertices[vbindex >> 24];
			var offset:int = vbindex & 0x00ffffff;
			for (var i:int = 0; i < 4; i++) {
				var ss:int = i*10
				for (var j:int = 0; j < 10; j++) {
					if (j <= 2)
					{
						_vbDatas[_vbindex] = vertexArray[offset + ss + j]/Large;
					}
					else
					{
						_vbDatas[_vbindex] = vertexArray[offset + ss + j];
					}
					_vbindex++;
				}
				var blendIndices:int = autoBondIndex(vertexArray[offset + ss + 0], vertexArray[offset + ss + 1],vertexArray[offset+ss+2]);
				//blendIndices = 8;
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
		
		
		public var fenhe:Boolean = false;
		
		public function autoBondIndex(x:int,y:int,z:int):int
		{
			fenhe = false;
			//head
			if (y > 14*Large+0.5)
			{
		
				return 0;
			}
			else
			{
				if (y > 5*Large-0.5)
				{
					//右手
					if (x <-13*Large-0.5)//-13.5
					{
						return 10;
					}
					else if (x <-6*Large-0.5)//-6.5
					{
				
						//右肩
						return 8;
					}
					else if (x < 6*Large+0.5)//6.5
					{
						if (x==-6*Large&&y <= rightArammax.y && z <= rightArammax.z && y >= rightArammin.y && z >= rightArammin.z)
						{
							
							return 8;
						}
						if (x == 6*Large && y <= leftArammax.y && z <= leftArammax.z && y >= leftArammin.y && z >= leftArammin.z)
						{
							
							return 2;
						}
						if (y == 5*Large && x <= rightlegmax.x && z <= rightlegmax.z && x >= rightlegmin.x && z >= rightlegmin.z)
						{
							
							return 4;
						}
						if (y == 5*Large && x <= leftlegmax.x && z <= leftlegmax.z && x >= leftlegmin.x && z >= leftlegmin.z)
						{
							
							return 6;
						}
						//身体
						return 1;
					}
					else if (x < 13*Large+0.5)
					{
						//左肩
						return 2;
					}
					else
					{
						//左手
						return 9;
					}
					
				}
				else if(y>2*Large+0.5)
				{
					//左腿
					if (x >= 0)
					{
						return 6;
					}
					else
					{
						//右腿
						return 4;
					}
				}
				else
				{
					if (x >= 0)
					{
						//左脚
						return 7;
					}
					else
					{
						//右脚
						return 5;
					}
				}
				
			}
		}
		
		
		
		
		
		
	}

}