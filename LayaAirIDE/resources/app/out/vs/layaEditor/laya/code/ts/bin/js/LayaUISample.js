var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var test = ui.test.TestPageUI;
var Label = laya.ui.Label;
var Handler = laya.utils.Handler;
var Loader = laya.net.Loader;
var TestUI = (function (_super) {
    __extends(TestUI, _super);
    function TestUI() {
        _super.call(this);
        //btn是编辑器界面设定的，代码里面能直接使用，并且有代码提示
        this.btn.on(laya.events.Event.CLICK, this, this.onBtnClick);
        this.btn2.on(laya.events.Event.CLICK, this, this.onBtn2Click);
    }
    TestUI.prototype.onBtnClick = function () {
        //手动控制组件属性
        this.radio.selectedIndex = 1;
        this.clip.index = 8;
        this.tab.selectedIndex = 2;
        this.combobox.selectedIndex = 0;
        this.check.selected = true;
    };
    TestUI.prototype.onBtn2Click = function () {
        //通过赋值可以简单快速修改组件属性
        //赋值有两种方式：
        //简单赋值，比如：progress:0.2，就是更改progress组件的value为2
        //复杂复制，可以通知某个属性，比如：label:{color:"#ff0000",text:"Hello LayaAir"}
        this.box.dataSource = { slider: 50, scroll: 80, progress: 0.2, input: "This is a input", label: { color: "#ff0000", text: "Hello LayaAir" } };
        //list赋值，先获得一个数据源数组
        var arr = [];
        for (var i = 0; i < 100; i++) {
            arr.push({ label: "item " + i, clip: i % 9 });
        }
        //给list赋值更改list的显示
        this.list.array = arr;
        //还可以自定义list渲染方式，可以打开下面注释看一下效果
        //list.renderHandler = new Handler(this, onListRender);
    };
    TestUI.prototype.onListRender = function (item, index) {
        //自定义list的渲染方式
        var label = item.getChildByName("label");
        if (index % 2) {
            label.color = "#ff0000";
        }
        else {
            label.color = "#000000";
        }
    };
    return TestUI;
}(ui.test.TestPageUI));
// 程序入口
Laya.init(600, 400);
Laya.loader.load([{ url: "res/atlas/comp.json", type: Loader.ATLAS }], Handler.create(this, this.onLoaded));
function onLoaded() {
    //实例UI界面
    var testUI = new TestUI();
    Laya.stage.addChild(testUI);
}
//# sourceMappingURL=LayaUISample.js.map