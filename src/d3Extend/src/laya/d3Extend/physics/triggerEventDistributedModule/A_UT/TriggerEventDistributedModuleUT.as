package triggerEventDistributedModule.A_UT {
import laya.components.Script;
import laya.d3.component.Script3D;
import laya.d3.core.Sprite3D;
import laya.display.Node;
import laya.display.Sprite;
import laya.ui.Button;

import triggerEventDistributedModule.E_function.cell.DistributedTriggerEvent;
import triggerEventDistributedModule.E_function.cell.GlobalOnlyValueCell;

import triggerEventDistributedModule.E_function.cell.TriggerStateDetection;
import triggerEventDistributedModule.F_data.TriggerEvent;


public class TriggerEventDistributedModuleUT extends Script {

    public var staticSprite3D:Vector.<Sprite3D> = new Vector.<Sprite3D>();

    public var dySprite3D:Vector.<Sprite3D> = new Vector.<Sprite3D>();
    /** @prop {name:scene3D,tips:"3D场景节点",type:Node}*/
    public var scene3D:Node;

    public function TriggerEventDistributedModuleUT() {

    }

    override public function onStart():void {
        addStaticChild("static1");
        addStaticChild("static2");
        addStaticChild("static3");
        addStaticChild("static4");
        addStaticChild("static5");
        addStaticChild("static6");
        addStaticChild("static7");
        addStaticChild("static8");
        addDynamicChild("dynamic1");
        addDynamicChild("dynamic2");
        addDynamicChild("dynamic3");
        addDynamicChild("dynamic4");
        addDynamicChild("dynamic5");
        addDynamicChild("dynamic6");
        addDynamicChild("dynamic7");
        addDynamicChild("dynamic8");

        var triggerStateDetection:TriggerStateDetection = new TriggerStateDetection(function (thisBody, otherBody) {
            if(!thisBody["onlyID"])
            {
                thisBody["onlyID"] = GlobalOnlyValueCell.getOnlyID();
            }
            if(!otherBody["onlyID"])
            {
                otherBody["onlyID"] = GlobalOnlyValueCell.getOnlyID();
            }
            var t:Number = thisBody["onlyID"];
            var o:Number = otherBody["onlyID"];
            return t + o >= 10;
        });
//
//
        triggerStateDetection.allTriggerDetection(staticSprite3D, dySprite3D);
//
        DistributedTriggerEvent.distributedAllEvent(triggerStateDetection.lastTriggerQueue, triggerStateDetection.triggerQueue);

    }

    public function addStaticChild(name:String) {
        var _gameObject:Sprite = scene3D.getChildByName(name) as Sprite;
        staticSprite3D.push(_gameObject);
        _gameObject.on(TriggerEvent.TRIGGER_ENTER, this, onEnter);
        _gameObject.on(TriggerEvent.TRIGGER_STAY, this, onStay);
        _gameObject.on(TriggerEvent.TRIGGER_EXIT, this, onExit);
    }

    public function addDynamicChild(name:String) {
        var _gameObject:Sprite = scene3D.getChildByName(name) as Sprite;

        dySprite3D.push(_gameObject);
        _gameObject.on(TriggerEvent.TRIGGER_ENTER, this, onEnter);
        _gameObject.on(TriggerEvent.TRIGGER_STAY, this, onStay);
        _gameObject.on(TriggerEvent.TRIGGER_EXIT, this, onExit);
    }

    public function onEnter(o:Sprite3D) {
        console.log(o["onlyID"]);
    }

    public function onStay(o:Sprite3D) {

    }

    public function onExit(o:Sprite3D) {


    }

}
}
