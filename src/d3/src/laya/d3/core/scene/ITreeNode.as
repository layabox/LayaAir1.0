package laya.d3.core.scene 
{
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	
	/**
	 * ...
	 * @author lv
	 */
	public interface ITreeNode 
	{
		function init(center:Vector3, treeSize:Vector3):void;
		function addTreeNode(renderObj:BaseRender):void;
		function cullingObjects(boundFrustum:BoundFrustum, testVisible:Boolean, flags:int, cameraPosition:Vector3, projectionView:Matrix4x4):void;
		function cullingShadowObjects(lightBoundFrustum:Vector.<BoundFrustum>, splitShadowQueues:Vector.<RenderQueue>, testVisible:Boolean, flags:int, scene:Scene):void;
		function cullingShadowObjectsOnePSSM(lightBoundFrustum:BoundFrustum,splitShadowQueues:Vector.<RenderQueue>, lightViewProjectMatrix:Matrix4x4,testVisible:Boolean, flags:int, scene:Scene):void;
		function renderBoudingBox(linePhasor:PhasorSpriter3D):void;
		function removeObject(object:BaseRender):Boolean;
		function updateObject(object:BaseRender):void;
	}
	
}