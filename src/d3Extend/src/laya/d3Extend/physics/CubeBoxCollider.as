package physics {
import Cube.CubeMap;

import laya.d3.core.MeshSprite3D;
import laya.d3.core.RenderableSprite3D;
import laya.d3.core.SkinnedMeshSprite3D;
import laya.d3.core.Sprite3D;
import laya.d3.core.Transform3D;
import laya.d3.core.pixelLine.PixelLineSprite3D;
import laya.d3.math.BoundBox;
import laya.d3.math.BoundSphere;
import laya.d3.math.Color;
import laya.d3.math.Matrix4x4;
import laya.d3.math.OrientedBoundBox;
import laya.d3.math.Quaternion;
import laya.d3.math.Vector3;
import laya.d3.resource.models.Mesh;
import laya.d3Extend.Cube.CubeInfo;

import laya.d3Extend.worldMaker.CubeInfoArray;
import laya.display.Node;
import laya.webgl.utils.RenderSprite3D;
import physics.triggerEventDistributedModule.D_manager.TriggerManager;
import physics.triggerEventDistributedModule.E_function.cell.GlobalOnlyValueCell;

/**
 * ...
 * @author ...
 */
public class CubeBoxCollider extends CubePhysicsCompnent {

    public var oriBoundCenter:Vector3 = new Vector3();
    //这些描述包围盒的数据都是物体模型坐标
	public var position:Vector3 = new Vector3(0,0, 0);
	public var scale:Vector3 = new Vector3(2, 2, 2);
	public var privateScale:Vector3 = new Vector3(0, 0, 0);
	public var lineActive:Boolean = false;
	
	private var temp:Vector3 = new Vector3(0, 0, 0);
	//用来记录物体本身的位置盒缩放
	private var _vec1:Vector3 = new Vector3();
	private var _vec2:Vector3 = new Vector3();
	public var scaleMatrix:Matrix4x4 = new Matrix4x4();
    /** @private 世界坐标的左后下角*/
    private var W_minx:int = 9999;
    private var W_miny:int = 9999;
    private var W_minz:int = 9999;
    private var W_maxx:int = -9999;
    private var W_maxy:int = -9999;
    private var W_maxz:int = -9999;
	public var pixelline: PixelLineSprite3D = new PixelLineSprite3D(20);

    /** @private 包围盒点*/
    public var OBBWorldPointList:Vector.<Vector3> = new Vector.<Vector3>();

    //OBB包围盒
    public var _orientedBoundBox:OrientedBoundBox = new OrientedBoundBox(new Vector3(), new Matrix4x4());
	//transform
	
	//相当于local position
	private var _primitPosition:Vector3 = new Vector3();
	private var _disparity:Vector3 = new Vector3();
	private var tempVector:Vector3 = new Vector3();
	//用来画线的临时变量

    private var _primitPosition:Vector3 = new Vector3();
    private var _disparity:Vector3 = new Vector3();

    //用来画线的临时变量

    public var tempVectorPoints:Vector.<Vector3> = new Vector.<Vector3>();


    override public function onAwake():void {
       // super.onAwake();
        this.type = CubePhysicsCompnent.TYPE_BOX;


        _sprite3D = owner as Sprite3D;
		
		if (!pixelline)
		{
			pixelline = new PixelLineSprite3D(20);
		}
		_sprite3D.scene.addChild(pixelline);
		var Mesharray:Vector.<Mesh> = new Vector.<Mesh>();
	
		var spriteArray:Vector.<RenderableSprite3D> = new Vector.<RenderableSprite3D>();
		CubePhysicsCompnent.findAllMesh(_sprite3D, Mesharray,spriteArray);
		
		var AllPositions:Vector.<Vector3> = new Vector.<Vector3>();
		for (var i:int = 0, n:int = Mesharray.length; i < n; i++) {
			
			var positions:Vector.<Vector3> = Mesharray[i]._getPositions();
			var worldmatrix:Matrix4x4 = spriteArray[i].transform.worldMatrix;
			for (var j:int = 0; j < positions.length; j++) {
		
				Vector3.transformCoordinate(positions[j], worldmatrix, positions[j]);
				AllPositions.push(positions[j]);
			}
		}
        var boundbox:BoundBox = new BoundBox(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
		
		BoundBox.createfromPoints(AllPositions, boundbox);
		//Vector3.transformCoordinate(boundbox.max, _sprite3D.transform.worldMatrix, boundbox.max);
		//Vector3.transformCoordinate(boundbox.min, _sprite3D.transform.worldMatrix, boundbox.min);
        OrientedBoundBox.createByBoundBox(boundbox, _orientedBoundBox);
		var vect:Vector3 = _orientedBoundBox.extents;
		var SpriteScale:Vector3 = _sprite3D.transform.scale;
		privateScale.setValue(vect.x / SpriteScale.x, vect.y / SpriteScale.y, vect.z / SpriteScale.z);
		//privateScale.setValue(vect.x, vect.y, vect.z);
		var OBBcenter:Vector3 = new Vector3();
		_orientedBoundBox.getCenter(OBBcenter);
		Vector3.subtract(OBBcenter,_sprite3D.transform.position,_primitPosition);
		
		
		
		
		
		//创建包围盒和包围球
		_boundBox = boundbox;
		//BoundSphere.createfromPoints(AllPositions,_boundSpheres)
		
		//_octree.add(this);
		
		//drawLine
		for (var k:int = 0; k < 8; k++) {
			tempVectorPoints.push(new Vector3());
		}
		
		 //创建包围盒和包围球
        _boundBox = boundbox;
        BoundSphere.createfromPoints(AllPositions, _boundSpheres)

        _octree.add(this);

        //drawLine
        for (var k:int = 0; k < 8; k++) {
            tempVectorPoints.push(new Vector3());
        }

		
    }

       
    


    override public function onUpdate():void {
        updataObbTranform();
    }

    /*
     * 方法用于更新物体的包围盒,运动的物体要时时刻刻调用
     *
     */
    public function updataObbTranform():void {
	
		 
		 //_sprite3D.transform.worldMatrix.cloneTo( _orientedBoundBox.transformation);
		 //Vector3.transformCoordinate(_primitPosition, _sprite3D.transform.worldMatrix, tempVector);
		 //
		 //_orientedBoundBox.translate(_primitPosition);
		 ////_orientedBoundBox.Size();
		 
		var obbMat:Matrix4x4 = _orientedBoundBox.transformation;
		var transform:Transform3D = _sprite3D.transform;
		var rotation:Quaternion = transform.rotation;
		var scale1:Vector3 = transform.scale;
		
		Vector3.add(_primitPosition,position,_disparity);
		if (_disparity.x=== 0.0 && _disparity.y=== 0.0 && _disparity.z === 0.0) {
			Matrix4x4.createAffineTransformation(transform.position, rotation, Vector3.ONE, obbMat);
		} else {
			
			Vector3.multiply(_disparity,scale1, tempVector);
			Vector3.transformQuat(tempVector, rotation, tempVector);
			Vector3.add(transform.position, tempVector, tempVector);
			Matrix4x4.createAffineTransformation(tempVector, rotation, Vector3.ONE, obbMat);
		}
		_orientedBoundBox.transformation = obbMat;
		
		var extentsE:Vector3 = _orientedBoundBox.extents;
		var sizeE:Float32Array = scale.elements;
		var scaleE:Float32Array = scale1.elements;
		extentsE.x = scale.x * 0.5 * scale1.x*privateScale.x;
		extentsE.y = scale.y * 0.5 * scale1.y*privateScale.y;
		extentsE.z = scale.z * 0.5 * scale1.z*privateScale.z;
		
		 _orientedBoundBox.extents = extentsE;
		 
		 
		 
		 var extend:Vector3 = _orientedBoundBox.extents;
		 //更新八叉树的包围盒和包围球
		 _boundBox.max.setValue(oriBoundCenter.x + extend.x, oriBoundCenter.y + extend.y, oriBoundCenter.z + extend.z);
		 _boundBox.min.setValue(oriBoundCenter.x - extend.x, oriBoundCenter.y - extend.y, oriBoundCenter.z - extend.z);
		 _boundSpheres.center = oriBoundCenter;
		 
		//_octreeNode.update(this);
		 
    }


    /**
     * 碰撞检测
     */
    override public function isCollision(other:CubePhysicsCompnent):int {
        switch (other.type) {
            case 0:
                return boxAndBox(other as CubeBoxCollider);
                break;
            case 1:
                return boxAndSphere(other as CubeSphereCollider);
                break;
            case 2:
                return boxAndCube(other as CubeEditCubeCollider);
                break;
            default:
                return 999;
        }

    }

	
	public function _showline():void
	{
		pixelline.active = true;
		drawBound();
	}
	public function _noShowLine():void
	{
		pixelline.active = false;
	}
	
	
	/**
		 * @private
		 */
		public function drawBound(color:Color = Color.GREEN):void {
			//if (debugLine.lineCount + 12 > debugLine.maxLineCount)
			
			//debugLine.maxLineCount += 12;
			
			pixelline.clear();
			_orientedBoundBox.getCorners(tempVectorPoints);
		
			pixelline.addLine(tempVectorPoints[0],tempVectorPoints[1], color, color);
			pixelline.addLine(tempVectorPoints[1],tempVectorPoints[2], color, color);
			pixelline.addLine(tempVectorPoints[2],tempVectorPoints[3], color, color);
			pixelline.addLine(tempVectorPoints[3],tempVectorPoints[0], color, color);
			pixelline.addLine(tempVectorPoints[0],tempVectorPoints[4], color, color);
			pixelline.addLine(tempVectorPoints[1],tempVectorPoints[5], color, color);
			pixelline.addLine(tempVectorPoints[2],tempVectorPoints[6], color, color);
			pixelline.addLine(tempVectorPoints[3],tempVectorPoints[7], color, color);
			pixelline.addLine(tempVectorPoints[4],tempVectorPoints[5], color, color);
			pixelline.addLine(tempVectorPoints[5],tempVectorPoints[6], color, color);
			pixelline.addLine(tempVectorPoints[6],tempVectorPoints[7], color, color);
			pixelline.addLine(tempVectorPoints[7],tempVectorPoints[4], color, color);
		}

  
    /**
     * 计算盒和球
     */
    public function boxAndSphere(other:CubeSphereCollider):int {

        return _orientedBoundBox.containsSphere(other._boundSphere, true);


    }

    /**
     * 计算盒和盒
     */
    public function boxAndBox(other:CubeBoxCollider):int {
        return _orientedBoundBox.containsOrientedBoundBox(other._orientedBoundBox);
    }

    /**
     * 计算盒和建筑Cube
     */
    public function boxAndCube(other:CubeEditCubeCollider):int {
		initmaxmin();
        updataMinMax();
		init2maxmin();
        for (var i:int = W_minx; i <= W_maxx; i++) {
            for (var j:int = W_miny; j <= W_maxy; j++) {

                for (var k:int = W_minz; k <= W_maxz; k++) {
                    if (OneCubeIsCollider(other, i, j, k) != 0) {
                        return 1;
                    }
                }
            }
        }

        return 0;

    }


    private var OBBpoints:Vector.<Vector3> = new Vector.<Vector3>();

    /*
     * 计算最大最小的世界空间值
     */
    public function updataMinMax():void {
        _orientedBoundBox.getCorners(tempVectorPoints);
        for (var i:int = 0; i < tempVectorPoints.length; i++) {
            if (tempVectorPoints[i].x > W_maxx) W_maxx = tempVectorPoints[i].x;
            if (tempVectorPoints[i].x < W_minx) W_minx = tempVectorPoints[i].x;
            if (tempVectorPoints[i].y > W_maxy) W_maxy = tempVectorPoints[i].y;
            if (tempVectorPoints[i].y < W_miny) W_miny = tempVectorPoints[i].y;
            if (tempVectorPoints[i].z > W_maxz) W_maxz = tempVectorPoints[i].z;
            if (tempVectorPoints[i].z < W_minz) W_minz = tempVectorPoints[i].z;

        }
    }

	public function initmaxmin():void
	{
		W_minx = 9999;
		W_miny = 9999;
		W_minz = 9999;
		W_maxx = -9999;
		W_maxy = -9999;
		W_maxz = -9999;
	}

	public function init2maxmin():void
	{
		W_minx = Math.floor(W_minx);
		W_miny = Math.floor(W_miny);
		W_minz = Math.floor(W_minz);
		W_maxx = Math.ceil(W_maxx);
		W_maxy = Math.ceil(W_maxy);
		W_maxz = Math.ceil(W_maxz);
	}
	
    public var cubePoint:Vector3 = new Vector3();

    /*
     * 判断一个cube是否碰撞了BoxCollider
     */
    public function OneCubeIsCollider(cubecollider:CubeEditCubeCollider, x:int, y:int, z:int):int {
        var ii:int = cubecollider.find(x + 1600, y + 1600, z + 1600);
		if ( ii!=-1) {
			cubecollider.collisionCube.setValue(x, y, z);
			cubecollider.cubeProperty = ii;
            cubePoint.setValue(x, y, z);
            if (_orientedBoundBox.containsPoint(cubePoint) != 0) return 1;
            cubePoint.setValue(x + 1, y, z);
            if (_orientedBoundBox.containsPoint(cubePoint) != 0) return 1;
            cubePoint.setValue(x, y + 1, z);
            if (_orientedBoundBox.containsPoint(cubePoint) != 0) return 1;
            cubePoint.setValue(x, y, z + 1);
            if (_orientedBoundBox.containsPoint(cubePoint) != 0) return 1;
            cubePoint.setValue(x + 1, y + 1, z);
            if (_orientedBoundBox.containsPoint(cubePoint) != 0) return 1;
            cubePoint.setValue(x + 1, y, z + 1);
            if (_orientedBoundBox.containsPoint(cubePoint) != 0) return 1;
            cubePoint.setValue(x, y + 1, z + 1);
            if (_orientedBoundBox.containsPoint(cubePoint) != 0) return 1;
            cubePoint.setValue(x + 1, y + 1, z + 1);
            if (_orientedBoundBox.containsPoint(cubePoint) != 0) return 1;


        }
        return 0;
    }

	override public function onDestroy():void
	{
		clearLine();
		super.onDestroy();
		
	}
	
	override public function onDisable():void
	{
		super.onDisable();
		pixelline.active = false;
	}
	
	
	override public function onEnable():void {
		super.onEnable();
		pixelline.active = true;
	}
	
	public function clearLine():void
	{
		pixelline.clear();
		pixelline.destroy();
	}
		
	public function resizeBound():void
	{
		var Mesharray:Vector.<Mesh> = new Vector.<Mesh>();
	
		var spriteArray:Vector.<RenderableSprite3D> = new Vector.<RenderableSprite3D>();
		CubePhysicsCompnent.findAllMesh(_sprite3D, Mesharray,spriteArray);
		
		var AllPositions:Vector.<Vector3> = new Vector.<Vector3>();
		for (var i:int = 0, n:int = Mesharray.length; i < n; i++) {
			
			var positions:Vector.<Vector3> = Mesharray[i]._getPositions();
			var worldmatrix:Matrix4x4 = spriteArray[i].transform.worldMatrix;
			for (var j:int = 0; j < positions.length; j++) {
		
				Vector3.transformCoordinate(positions[j], worldmatrix, positions[j]);
				AllPositions.push(positions[j]);
			}
		}
        var boundbox:BoundBox = new BoundBox(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
		BoundBox.createfromPoints(AllPositions, boundbox);
        OrientedBoundBox.createByBoundBox(boundbox, _orientedBoundBox);
		var vect:Vector3 = _orientedBoundBox.extents;
		privateScale.setValue(vect.x, vect.y, vect.z);
		var OBBcenter:Vector3 = new Vector3();
		_orientedBoundBox.getCenter(OBBcenter);
		Vector3.subtract(OBBcenter,_sprite3D.transform.position,_primitPosition);
		
	}

	
	
}

}