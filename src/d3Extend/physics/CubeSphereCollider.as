package physics {
import Cube.CubeMap;
import adobe.utils.CustomActions;
import laya.d3.core.MeshSprite3D;
import laya.d3.core.Sprite3D;
import laya.d3.core.pixelLine.PixelLineSprite3D;
import laya.d3.math.BoundSphere;
import laya.d3.math.CollisionUtils;
import laya.d3.math.Color;
import laya.d3.math.Vector3;
import laya.d3.resource.models.Mesh;
import laya.d3Extend.Cube.CubeInfo;
import laya.d3Extend.worldMaker.CubeInfoArray;

/**
 * ...
 * @author ...
 */
public class CubeSphereCollider extends CubePhysicsCompnent {
   
    ///** @private 包围球中点*/
    public var center:Vector3 = new Vector3(0,0,0);
    /** @private 包围球半径*/
    public var radius:Number = 1;
    public var _boundSphere:BoundSphere = new BoundSphere(new Vector3(0, 0, 0), 0);
	private var _primitPosition:Vector3;
	private var _disparity:Vector3 = new Vector3();
	private var _primitscale:Vector3 = new Vector3();
  	public var pixelline: PixelLineSprite3D = new PixelLineSprite3D(320);
	public var primitradius:Number = 0;
    public function CubeSphereCollider() {


    }

    override public function onAwake():void {
      //  super.onAwake();
		this.type = CubePhysicsCompnent.TYPE_SPHERE;
        _sprite3D = owner as Sprite3D;
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
        BoundSphere.createfromPoints(AllPositions, _boundSphere);
		var OBBcenter:Vector3 = _boundSphere.center;
		_primitPosition = _sprite3D.transform.position;
		_primitscale = _sprite3D.transform.scale;
		_disparity.setValue(OBBcenter.x - _primitPosition.x, OBBcenter.y - _primitPosition.y, OBBcenter.z - _primitPosition.z);
		primitradius = _boundSphere.radius;

		_boundBox.max.setValue(OBBcenter.x + radius, OBBcenter.y + radius, OBBcenter.z + radius);
		_boundBox.min.setValue(OBBcenter.x - radius, OBBcenter.y - radius, OBBcenter.z - radius);
		_boundSpheres.center.setValue(OBBcenter.x, OBBcenter.y, OBBcenter.z);
		_boundSpheres.radius = _boundSphere.radius;		
		_octree.add(this);
    }

    override public function onUpdate():void
    {
        updataBoundSphere();
    }

    public function updataBoundSphere():void {
			var bei:Number = Math.max(_primitscale.x, _primitscale.y, _primitscale.z);
			_boundSphere.radius = primitradius*bei*radius;
			
			var spt:Vector3 = _sprite3D.transform.position;
		
			_boundSphere.center.setValue((spt.x + _disparity.x*bei) + center.x, (spt.y + _disparity.y*bei + center.y), (spt.z + _disparity.z*bei + center.z));

			var vec:Vector3 = _boundSphere.center;
			var ra:Number = _boundSphere.radius;
			
			_boundBox.max.setValue(vec.x + ra, vec.y + ra, vec.z + ra);
			_boundBox.min.setValue(vec.x - ra, vec.y - ra, vec.z - ra);
			_boundSpheres.center.setValue(vec.x, vec.y, vec.z);
			_boundSpheres.radius = ra;
			
    }

    /**
     * 判断是否碰撞
     */
    override public function isCollision(other:CubePhysicsCompnent):int {
        switch (other.type) {
            case 0:
                return sphereAndBox(other as CubeBoxCollider);
                break;
            case 1:
                return sphereAndShpere(other as CubeSphereCollider);
                break;
            case 2:
                return sphereAndCube(other as CubeEditCubeCollider);
                break;
            default:
                return 999;
        }
    }

    ////计算最长距离
    //private var _vector3:Vector3 = new Vector3();

    /**
     * 计算球和球
     */
    public function sphereAndShpere(other:CubeSphereCollider):int {
   
        return CollisionUtils.sphereContainsSphere(other._boundSphere, this._boundSphere);
    }

    /**
     * 计算球和Box
     */
    public function sphereAndBox(other:CubeBoxCollider):int {
        return other.boxAndSphere(this);
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
     * 计算球和建筑Cube
     */
    public function sphereAndCube(other:CubeEditCubeCollider):int {
       
        var cubemap:CubeMap = other.cubeMap;
        //根据中心点和半径来确定一个球网
        var minx:int = Math.floor(_boundSphere.center.x - _boundSphere.radius);
        var maxx:int = Math.floor(_boundSphere.center.x + _boundSphere.radius);
        var miny:int = Math.floor(_boundSphere.center.y - _boundSphere.radius);
        var maxy:int = Math.floor(_boundSphere.center.y + _boundSphere.radius);
        var minz:int = Math.floor(_boundSphere.center.z - _boundSphere.radius);
        var maxz:int = Math.floor(_boundSphere.center.z + _boundSphere.radius);
        var ix:int;
        var iy:int;
        var iz:int;
      
        for (var i:int = minx; i <= maxx; i++) {
            for (var j:int = miny; j <= maxy; j++) {
                for (var k:int = minz; k <= maxz; k++) {
                    if (OneCubeIsCollider(other, i, j, k) != 0) return 1;
                }
            }

        }

        return 0;


    }


    private var cubePoint:Vector3 = new Vector3();

    public function OneCubeIsCollider(cubeCollider:CubeEditCubeCollider, x:int, y:int, z:int):int {
       
        if (cubeCollider.find(x+1600,y+1600,z+1600)) {
            cubePoint.setValue(x, y, z);
            //Vector3.transformV3ToV3(cubePoint, _localmatrix4x4, cubePoint);
            if (CollisionUtils.sphereContainsPoint(_boundSphere, cubePoint) != 0) return 1;
            cubePoint.setValue(x + 1, y, z);
            //Vector3.transformV3ToV3(cubePoint, _localmatrix4x4, cubePoint);
            if (CollisionUtils.sphereContainsPoint(_boundSphere, cubePoint) != 0) return 1;
            cubePoint.setValue(x, y + 1, z);
            //Vector3.transformV3ToV3(cubePoint, _localmatrix4x4, cubePoint);
            if (CollisionUtils.sphereContainsPoint(_boundSphere, cubePoint) != 0) return 1;
            cubePoint.setValue(x, y, z + 1);
            //Vector3.transformV3ToV3(cubePoint, _localmatrix4x4, cubePoint);
            if (CollisionUtils.sphereContainsPoint(_boundSphere, cubePoint) != 0) return 1;
            cubePoint.setValue(x + 1, y + 1, z);
            //Vector3.transformV3ToV3(cubePoint, _localmatrix4x4, cubePoint);
            if (CollisionUtils.sphereContainsPoint(_boundSphere, cubePoint) != 0) return 1;
            cubePoint.setValue(x + 1, y, z + 1);
            //Vector3.transformV3ToV3(cubePoint, _localmatrix4x4, cubePoint);
            if (CollisionUtils.sphereContainsPoint(_boundSphere, cubePoint) != 0) return 1;
            cubePoint.setValue(x, y + 1, z + 1);
            //Vector3.transformV3ToV3(cubePoint, _localmatrix4x4, cubePoint);
            if (CollisionUtils.sphereContainsPoint(_boundSphere, cubePoint) != 0) return 1;
            cubePoint.setValue(x + 1, y + 1, z + 1);
            //Vector3.transformV3ToV3(cubePoint, _localmatrix4x4, cubePoint);
            if (CollisionUtils.sphereContainsPoint(_boundSphere, cubePoint) != 0) return 1;

           

        }
		 return 0;

    }
	
	private var vec1:Vector3 = new Vector3();
	private var vec2:Vector3 = new Vector3();
	
	public function drawBound(color:Color = Color.GREEN):void {
			//if (debugLine.lineCount + 12 > debugLine.maxLineCount)
				//debugLine.maxLineCount += 12;
			
			pixelline.clear();
			var lineNums:int  = 100;
			var duan:Number = 6.28 / lineNums;
			var sita:Number = 0;
			var center:Vector3 = _boundSphere.center;
			var ra:Number = _boundSphere.radius;
			debugger;
			for (var i:int = 0; i <= lineNums; i++) {
				vec1.setValue(Math.cos(sita)*ra + center.x, Math.sin(sita)*ra + center.y, center.z);
				sita = i * duan;
				vec2.setValue(Math.cos(sita) * ra + center.x, Math.sin(sita) * ra + center.y, center.z);
				pixelline.addLine(vec1, vec2, color, color);
			}
			for (var i:int = 0; i <= lineNums; i++) {
				vec1.setValue( center.x, Math.sin(sita)*ra + center.y, Math.cos(sita)*ra+center.z);
				sita = i * duan;
				vec2.setValue(center.x, Math.sin(sita) * ra + center.y,Math.cos(sita)*ra+center.z);
				pixelline.addLine(vec1, vec2, color, color);
			}
			for (var i:int = 0; i <= lineNums; i++) {
				vec1.setValue(Math.cos(sita)*ra + center.x,center.y,Math.sin(sita)*ra+ center.z);
				sita = i * duan;
				vec2.setValue(Math.cos(sita) * ra + center.x,center.y,Math.sin(sita)*ra+center.z);
				pixelline.addLine(vec1, vec2, color, color);				
			}
			
			
		}


   

}

}