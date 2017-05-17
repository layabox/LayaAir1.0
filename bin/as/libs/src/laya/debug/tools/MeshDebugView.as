package laya.debug.tools 
{
	import laya.ani.bone.canvasmesh.MeshData;
	import laya.display.Sprite;
	/**
	 * 
	 * @author ww
	 */
	public class MeshDebugView extends Sprite
	{
		public var textureCt:Sprite;
		public var resultCt:Sprite;
		public function MeshDebugView() 
		{
			textureCt = new Sprite();
			resultCt = new Sprite();
			addChild(textureCt);
			addChild(resultCt);
		}
		public function showMesh(mesh:MeshData):void
		{
			textureCt.graphics.clear();
			textureCt.graphics.drawTexture(mesh.texture);
			var oWidth:Number = mesh.texture.bitmap.width;
			var oHeight:Number=mesh.texture.bitmap.height;
			debugger;
			MeshDebugTools.drawVerticles(mesh.uvs, oWidth, oHeight, textureCt, -oWidth * mesh.texture.uv[0], -oHeight * mesh.texture.uv[1]);
			MeshDebugTools.drawVerticles(mesh.texture.uv, oWidth, oHeight, textureCt, -oWidth * mesh.texture.uv[0], -oHeight * mesh.texture.uv[1],2,"#00ff00",10);
			resultCt.graphics.clear();
			MeshDebugTools.drawVerticles(mesh.vertices, 1, 1, resultCt);
			resultCt.pos(300, 0);
			var newVers:Array;
			newVers = MeshDebugTools.solveMesh(mesh);
			debugger;
			MeshDebugTools.drawVerticles(newVers, 1, 1, resultCt,0,0,2,"#00ff00",20);
		}
	}

}