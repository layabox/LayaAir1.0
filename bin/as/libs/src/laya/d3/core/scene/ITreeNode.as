package laya.d3.core.scene 
{
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.graphics.RenderObject;
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
		function addTreeNode(renderObj:RenderObject):void;
		function cullingObjects(boundFrustum:BoundFrustum, testVisible:Boolean, flags:int, cameraPosition:Vector3, projectionView:Matrix4x4):void;
		function renderBoudingBox(linePhasor:PhasorSpriter3D):void;
		function removeObject(object:RenderObject):Boolean;
		function updateObject(object:RenderObject):void;
	}
	
}