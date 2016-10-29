package laya.debug.view.nodeInfo.recinfos 
{
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.maths.GrahamScan;
	import laya.maths.Rectangle;
	import laya.debug.tools.WalkTools;
	/**
	 * ...
	 * @author ww
	 */
	public class NodeRecInfo extends Sprite
	{
		
	    public var txt:Text;
		public function NodeRecInfo() 
		{
			txt = new Text();
			txt.color = "#ff0000";
			txt.bgColor = "#00ff00";
			txt.fontSize = 12;
			addChild(txt);
		}
		public function setInfo(str:String):void
		{
			txt.text = str;
		}
		protected var _tar:Sprite;
		public var recColor:String = "#00ff00";
		public function setTarget(tar:Sprite):void
		{
			_tar = tar;
		}
		private static var _disBoundRec:Rectangle=new Rectangle();
		public function showInfo(node:Sprite):void
		{
			
			_tar = node;
			if (!node) return;
			if(!node._$P) return;
		
			this.graphics.clear();
			
			var pointList:Array;
			pointList=node._getBoundPointsM(true);
			if(!pointList||pointList.length<1) return;
			pointList=GrahamScan.pListToPointList(pointList,true);	
			WalkTools.walkArr(pointList,node.localToGlobal,node);	
			pointList=GrahamScan.pointListToPlist(pointList);
			_disBoundRec=Rectangle._getWrapRec(pointList,_disBoundRec);
			this.graphics.drawRect(0, 0, _disBoundRec.width, _disBoundRec.height, null, recColor,2);
			this.pos(_disBoundRec.x, _disBoundRec.y);
		}
		public function fresh():void
		{
			showInfo(_tar);
		}
		public function clearMe():void
		{
			_tar = null;
		}
	}

}