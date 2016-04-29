/**
 * Created by wangzhihua on 2016/3/21.
 */
var fs = require('fs');
var path = require('path');
var electron = require('electron');
var remote = electron.remote;
var ipc = electron.ipcRenderer;
var windowId = remote.getCurrentWindow().id;
//remote.getCurrentWindow().openDevTools()
var windclipHLaya = 36;
var layaIDEMode = 0;//代码模式
var layaideconfig = {};
var dialogLaya = electron.remote.dialog;
var layaIDEVersion = "0.9.8";
var uiConfigName = ".laya";
var layawindowDebug;
var layaWindowResutl = 4;
function parseURLQueryArgs() {
    var result = {};
    var search = window.location.search;
    if (search) {
        var params = search.split(/[?&]/);
        for (var i = 0; i < params.length; i++) {
            var param = params[i];
            if (param) {
                var keyValue = param.split('=');
                if (keyValue.length === 2) {
                    result[keyValue[0]] = decodeURIComponent(keyValue[1]);
                }
            }
        }
    }

    return result;
}

function createScript(src, onload) {
    var script = document.createElement('script');
    script.src = src;
    script.addEventListener('load', onload);

    var head = document.getElementsByTagName('head')[0];
    head.insertBefore(script, head.lastChild);
}

function uriFromPath(_path) {
    var pathName = path.resolve(_path).replace(/\\/g, '/');

    if (pathName.length > 0 && pathName.charAt(0) !== '/') {
        pathName = '/' + pathName;
    }

    return encodeURI('file://' + pathName);
}

function registerListeners(enableDeveloperTools) {

    // Devtools & reload support
    if (enableDeveloperTools) {
        var extractKey = function (e) {
            return [
                e.ctrlKey ? 'ctrl-' : '',
                e.metaKey ? 'meta-' : '',
                e.altKey ? 'alt-' : '',
                e.shiftKey ? 'shift-' : '',
                e.keyCode
            ].join('');
        };

        var TOGGLE_DEV_TOOLS_KB = (process.platform === 'darwin' ? 'meta-alt-73' : 'ctrl-shift-73'); // mac: Cmd-Alt-I, rest: Ctrl-Shift-I
        var RELOAD_KB = (process.platform === 'darwin' ? 'meta-82' : 'ctrl'); // mac: Cmd-R, rest: Ctrl-R

        window.addEventListener('keydown', function (e) {
            var key = extractKey(e);
            if (key === TOGGLE_DEV_TOOLS_KB) {
                ipc.send('vscode:toggleDevTools', windowId);
            } else if (key === RELOAD_KB) {
                ipc.send('vscode:reloadWindow', windowId);
            }
        });
    }

    //process.on('uncaughtException', function(error) { onError(error, enableDeveloperTools) });
}

function getNlsPluginConfiguration(configuration) {
    var locale = configuration.locale;
    if (locale === 'pseudo') {
        return {availableLanguages: {}, pseudo: true}
    }
    if (!configuration.isBuilt) {
        return {availableLanguages: {}};
    }
    // We have a built version so we have extracted nls file. Try to find
    // the right file to use.
    locale = locale || window.navigator.language;
    while (locale) {
        var candidate = path.join(__dirname, '..', 'workbench.main.nls.') + locale + '.js';
        if (fs.existsSync(candidate)) {
            return {availableLanguages: {'*': locale}};
        } else {
            var index = locale.lastIndexOf('-');
            if (index > 0) {
                locale = locale.substring(0, index);
            } else {
                locale = null;
            }
        }
    }
    return {availableLanguages: {}};
}
var webFrame = require('electron').webFrame;

var mainStarted = false;
var args = parseURLQueryArgs();
var configuration = JSON.parse(args['config']);
//configuration.workspacePath ="c:/123";
var enableDeveloperTools = !configuration.isBuilt || !!configuration.extensionDevelopmentPath;

process.env['VSCODE_SHARED_IPC_HOOK'] = configuration.sharedIPCHandle;

registerListeners(enableDeveloperTools);
//初始化拖动条
initMenuBar()
function initMenuBar() {
    var _winddragBar = document.createElement("div");
    _winddragBar.style.position = "absolute";
    _winddragBar.style.left = "600px";
    _winddragBar.style.right = "180px";
    _winddragBar.style.webkitAppRegion = "drag";
    _winddragBar.style.height = "20px";
    document.body.appendChild(_winddragBar);
}
window.addEventListener('beforeunload', addOnBeforeUnload, false);
function addOnBeforeUnload() {
    layaideconfig.lastOpenPro = configuration.workspacePath;
    //layaideconfig.layaRecentPaths[configuration.workspacePath] = 1;
    fs.writeFileSync(remote.app.getDataPath() + path.sep + "layaconfig.json", JSON.stringify(layaideconfig));
}
initLaya();
//window.onkeydown = function (e) {
//    if (e.keyCode == 116) {
//        remote.getCurrentWindow().reload();
//    }
//}
//检查编辑器进入模式
function initLaya() {
    if (!configuration.workspacePath) {
        layaideconfig = {};
        layaideconfig.mode = "0";
        layaideconfig.recentOpenPath = {}
        //layaCodeView.src = "vscode.js";
        conList.style.display = "block";
        document.getElementById("ouibounce-modal").style.zIndex = 99999999999999999999;
        title_dialg.innerText = "欢迎";
        layaPanelClose.style.display = "none"
        showDiv("subpackage");
    } else {
        var filepath = remote.app.getDataPath() + path.sep + "layaconfig.json";
        try {
            window.layaProperties = JSON.parse(fs.readFileSync(configuration.workspacePath + path.sep + "layaProperties.json"));
        } catch (e) {
            window.layaProperties = {};
        }
        fs.exists(filepath, function (exists) {
            if (exists) {
                // serve file
                layaideconfig = fs.readFileSync(remote.app.getDataPath() + path.sep + "layaconfig.json", "utf-8");
                layaideconfig = JSON.parse(layaideconfig);
                if (layaideconfig.mode == "1") {
                    //编辑器模式
                    conList.style.display = "none";
                    changeLayaViewMode();
                } else {
                    //code 模式；
                    conList.style.display = "block";
                    layaCodeView.src = "vscode.js";
                    var timeId = setInterval(function () {
                        divconLayaCode = document.getElementsByClassName("monaco-shell-content")[0];
                        if (divconLayaCode) {
                            divconLayaCode.style.visibility = 'visible';
                            initchangeBug();
                            clearInterval(timeId);
                            changeLayaIDECodeMode()
                        }
                    }, 1);
                }

            } else {
                layaideconfig = {};
                layaideconfig.recentOpenPath = {};
                layaideconfig.mode == "0";
                layaCodeView.src = "vscode.js";
                conList.style.display = "block";
                subpackage.style.display = "block"
            }
        });
    }
    initMenuPro();
}
var divconLayaCode;//代码模式的容器
var layaCanvasView;//ui容器
//切换到代码模式
function initchangeBug() {
    var con = document.getElementsByClassName("actions-container")[0]
    var li = document.createElement("li");
    li.onclick = function () {
        changeLayaViewMode();
    }
    li.className = "action-item";
    li.role = "presentation";
    var ach = document.createElement("a");
    ach.className = "action-label debug0";
    ach.title = "切换到UI编辑器模式(Alt+A)";
    li.appendChild(ach);
    con.appendChild(li);
    // conList.style.display = "none";
    faceVs = document.getElementsByClassName("statusbar-item right");
    faceVs[0].style.display = "none"
}
function changeLayaIDECodeMode() {
    layaideconfig.mode = "0";
    if (!layaCodeView.src) {
        layaCodeView.src = "vscode.js";
        setTimeout(initchangeBug, 1000)
    }
    if (!divconLayaCode) {
        divconLayaCode = document.getElementsByClassName("monaco-shell-content")[0];
        if (divconLayaCode)divconLayaCode.style.visibility = 'visible';
    } else if (divconLayaCode) {
        divconLayaCode.style.visibility = 'visible'
    }
    if (!layaCanvasView) {
        var canvas = document.getElementsByTagName("canvas");
        for (var i = 0; i < canvas.length; i++) {
            if (canvas[i].className == "") {
                layaCanvasView = canvas[i];
                layaCanvasView.style.display = "none";
                if (laya)laya.events.KeyBoardManager.enabled = false;
                break
            }
        }
    } else {
        layaCanvasView.style.display = "none";
        if (laya)laya.events.KeyBoardManager.enabled = false;
    }
    conList.style.display = "block";

}
//新建工程
function layaNewCreatePro(e) {
    document.getElementById("title_dialg").innerText = "新建项目";
    document.getElementById("ouibounce-modal").style.zIndex = 99999999999999999999
    flashResTool.style.display = "block";
    subpackage.style.display = "none"
    showDiv("newProW");
}
//切换到编辑模式
function layaAlert(e) {
    document.getElementById("conp").innerText = e;
    document.getElementById("layaAlertWarning").style.display = 'block';
}
function layaAlertOpen(e) {
    document.getElementById("mesgLaya").innerText = e;
    document.getElementById("layaAlertWarningOpen").style.display = 'block';
}
function closeAlerHandler(id) {
    document.getElementById(id).style.display = 'none';
    changeLayaIDECodeMode();
}
function changeLayaViewMode() {
    if (!configuration.workspacePath || !fs.existsSync(configuration.workspacePath + path.sep + "laya" + path.sep + uiConfigName)) {
        layaAlert("该项目不是有效的LayaAir可视化项目,是否要创建？");
        return
    }
    layaideconfig.mode = "1";
    if (!layaUIView.src) {
        layaUIView.src = "layabuilder.max.js"
    }
    if (!divconLayaCode) {
        divconLayaCode = document.getElementsByClassName("monaco-shell-content")[0];
        if (divconLayaCode)divconLayaCode.style.visibility = 'hidden';
    } else {
        divconLayaCode.style.visibility = 'hidden';
    }
    if (!layaCanvasView) {
        var canvas = document.getElementsByTagName("canvas");
        for (var i = 0; i < canvas.length; i++) {
            if (canvas[i].className == "") {
                layaCanvasView = canvas[i];
                layaCanvasView.style.display = "block";
                break
            }
        }
    } else {
        layaCanvasView.style.display = "block";
    }
    conList.style.display = "none";
    //if (laya)laya.editor.manager.ProjectManager.openProjectByPath(path.join(configuration.workspacePath, "laya", "Mylaya"));
    {
        setTimeout(function () {
            if (laya)laya.editor.manager.ProjectManager.loadProject(path.join(configuration.workspacePath, "laya", uiConfigName));
            if (laya)laya.events.KeyBoardManager.enabled = true;
        }, 1000)
    }
    //if (laya)laya.editor.manager.ProjectManager.openProjectByPath(path.join(configuration.workspacePath, "laya", "mylaya"));
}
var lastOpenProview;
//菜单点击事件
function oclick(type) {
    if (type == "close") {
        remote.getCurrentWindow().close();
    } else if (type == "restore") {
        if (!remote.getCurrentWindow().isMaximized()) {
            remote.getCurrentWindow().maximize();
        } else {
            remote.getCurrentWindow().restore();
        }
    } else if (type == "minimize") {
        remote.getCurrentWindow().minimize()
    } else if (type == "f12") {
        remote.getCurrentWindow().openDevTools();
    } else if (type == "newfile") {
        sendMsgLaya("vscode:openFilePicker")
    } else if (type == "openFolder") {
        sendMsgLaya("vscode:openFolderPicker");
    } else if (type == "newwindow") {
        sendMsgLaya("vscode:openNewWindow");
    } else if (type == "F11") {
        remote.getCurrentWindow().setFullScreen(!remote.getCurrentWindow().isFullScreen())
    } else if (type == "flash") {
        document.getElementById("CompressJS").style = "block"

    } else if (type == "changeViewUi") {
        changeLayaViewMode();
    } else if (type == "layaboxPublic") {
        window.open("http://www.layabox.com/")
    } else if (type == "layabox") {
        window.open("http://ask.layabox.com/question")
    } else if (type == "apianddemo") {


    } else if (type == "downLoad") {
        window.open("http://ldc.layabox.com/")
    }
    else if ("debugLaya" == type) {
        if (!configuration.workspacePath) {
            layaAlert("该项目不是有效的LayaAir项目！");
            return
        } else {
            var fileList = fs.readdirSync(configuration.workspacePath);
            var urlIndex
            for (var i = 0; i < fileList.length; i++) {
                if (fileList[i].indexOf(".laya") != -1) {
                    var stat = fs.lstatSync(configuration.workspacePath + path.sep + fileList[i]);
                    if (!stat.isDirectory()) {
                        var data = fs.readFileSync(configuration.workspacePath + path.sep + fileList[i], "utf-8");
                        var player=JSON.parse(data);
                        urlIndex = player.indexhtml;

                        break;
                    }
                }
            }
            var url = urlIndex;
            var urlIndex = configuration.workspacePath + path.sep + urlIndex
            if (fs.existsSync(urlIndex)) {
                if (!layawindowDebug) {
                    var BrowserWindow = remote.BrowserWindow;

                    layawindowDebug = new BrowserWindow({width: player.playerW, height: player.playerH, show: true, title: "LayaAir"});
                    layawindowDebug.on('closed', function () {
                        layawindowDebug = null;
                    });
                }
                layawindowDebug.loadURL(urlIndex);
                layawindowDebug.show();
            } else {
                layaAlertOpen("当前路径文件" + url + "不存在,  设置配置文件" + fileList[i] + "中indexHtml属性")
                return
            }


        }

    }
}
function mouseOutHandler(e) {
    var par = e.currentTarget.children[1];
    par.style.display = "none";
}
function overHandler(e) {
    var par = e.currentTarget.children[1];
    par.style.display = "block";
}
function b_block(e) {
    e.preventDefault();
    var par = e.currentTarget.children[1];
    if (par.style.display == "none") {
        par.style.display = "block";
    } else {
        par.style.display = "none";
    }
}
//新建项目
function createProHandler(id) {
    document.getElementById("title_dialg").innerText = "新建项目";
    document.getElementById("ouibounce-modal").style.zIndex = 99999999999999999999
    flashResTool.style.display = "block";
    subpackage.style.display = "none";
    showDiv("newProW");
}
function showDiv(id) {
    document.getElementById("ouibounce-modal").style.display = "block";
    proNameOutput.value = remote.app.getPath("documents") + path.sep + "myLaya";
    proNameInput.value = "myLaya"
}
function changeFolderPro(e) {
    dialogLaya.showOpenDialog({properties: ["openDirectory", 'createDirectory']}, function (path) {
        path = path[0];
        proNameOutput.value = path;
    });
}
function okCreateLayaUI() {
    //var filestr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<project version=" + "\"" + layaIDEVersion + "\"" + ">\n" + "	<!--assets异步资源目录，在这些目录里面的资源，不会被编译到swf里面，但会复制到发布目录-->\n" + "	<asynRes>img,temp,sound</asynRes>\n" + "	<!--assets不处理目录，在这些目录里面的资源，不会做任何处理（包括复制）-->\n" + "	<unDealRes>embed</unDealRes>\n" + "	<!--资源类型-->\n" + "	<resTypes>png,jpg</resTypes>\n" + "	<!--发布资源导出目录-->\n" + "	<resExportPath>bin/h5/res/atlas</resExportPath>\n" + "	<!--UICode导出目录-->\n" + "	<codeExportPath>src/game/ui</codeExportPath>\n" + "	<!--UICode默认导入类-->\n" + "	<codeImports>import laya.ui.*;</codeImports>\n" + "	<codeImportsJS>var View=laya.ui.View;\nvar Dialog=laya.ui.Dialog;</codeImportsJS>\n" + "	<!--UI模式（0:内嵌模式，1:加载模式）-->\n" + "	<uiType>0</uiType>\n" + "	<!--UI导出目录（加载模式可用）-->\n" + "	<uiExportPath>bin/ui.swf</uiExportPath>\n" + "	<!--容器列表（转换为容器功能使用）-->\n" + "	<boxTypes>Box,List,Tab,RadioGroup,ViewStack,Panel,HBox,VBox,Tree</boxTypes>\n" + "	<!--页面类型（用于自定义页面继承）-->\n" + "	<pageTypes>View,Dialog</pageTypes>\n" + "	<!--多模块开发时共用的资源目录-->\n" + "	<shareResPath></shareResPath>\n" + "	<!--语言类型-->\n" + "	<codeType>0</codeType>\n" + "</project>";
    //mkdirsSyncLaya(proNameOutput.value);
    //layacopyDirFile(path.dirname(__dirname) + path.sep + "laya" + path.sep + "default", configuration.workspacePath + path.sep + "laya");
    var layaZipPath = path.dirname(__dirname) + path.sep + "laya" + path.sep + "code" + path.sep + "as";
    //filestr = filestr.replace("<codeType>0</codeType>", "<codeType>" + proTypeLaya.selectedIndex + "</codeType>");
    //fs.writeFileSync(configuration.workspacePath + path.sep + "laya" + path.sep + uiConfigName, filestr);
    layacopyDirFile(layaZipPath, configuration.workspacePath + path.sep + "laya");
    var layaProperties = {};
    layaProperties.proName = "MyLaya";
    layaProperties.version = layaIDEVersion;
    layaProperties.proType = "0";
    layaProperties.playerW =800;
    layaProperties.playerH =600;
    layaProperties.indexhtml = "index.html";
    fs.writeFileSync(configuration.workspacePath + path.sep + "MyLaya.laya", JSON.stringify(layaProperties));
    closeAlerHandler("layaAlertWarning");
    changeLayaViewMode();
    //ipc.send("vscode:openFolderPickerLaya", [proNameOutput.value]);
}
function createProWorkspace(type) {

    //var filestr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<project version=" + "\"" + layaIDEVersion + "\"" + ">\n" + "	<!--assets异步资源目录，在这些目录里面的资源，不会被编译到swf里面，但会复制到发布目录-->\n" + "	<asynRes>img,temp,sound</asynRes>\n" + "	<!--assets不处理目录，在这些目录里面的资源，不会做任何处理（包括复制）-->\n" + "	<unDealRes>embed</unDealRes>\n" + "	<!--资源类型-->\n" + "	<resTypes>png,jpg</resTypes>\n" + "	<!--发布资源导出目录-->\n" + "	<resExportPath>bin/h5/res/atlas</resExportPath>\n" + "	<!--UICode导出目录-->\n" + "	<codeExportPath>src/game/ui</codeExportPath>\n" + "	<!--UICode默认导入类-->\n" + "	<codeImports>import laya.ui.*;</codeImports>\n" + "	<codeImportsJS>var View=laya.ui.View;\nvar Dialog=laya.ui.Dialog;</codeImportsJS>\n" + "	<!--UI模式（0:内嵌模式，1:加载模式）-->\n" + "	<uiType>0</uiType>\n" + "	<!--UI导出目录（加载模式可用）-->\n" + "	<uiExportPath>bin/ui.swf</uiExportPath>\n" + "	<!--容器列表（转换为容器功能使用）-->\n" + "	<boxTypes>Box,List,Tab,RadioGroup,ViewStack,Panel,HBox,VBox,Tree</boxTypes>\n" + "	<!--页面类型（用于自定义页面继承）-->\n" + "	<pageTypes>View,Dialog</pageTypes>\n" + "	<!--多模块开发时共用的资源目录-->\n" + "	<shareResPath></shareResPath>\n" + "	<!--语言类型-->\n" + "	<codeType>0</codeType>\n" + "</project>";
    if (proNameOutput.value) {
        document.getElementById("ouibounce-modal").style.display = "none";
        if (proTypeLaya.selectedIndex == 0) {
            var layaZipPath = path.dirname(__dirname) + path.sep + "laya" + path.sep + "code" + path.sep + "as";
            var proName = proNameInput.value || "Main";
        } else if (proTypeLaya.selectedIndex == 1) {
            var layaZipPath = path.dirname(__dirname) + path.sep + "laya" + path.sep + "code" + path.sep + "ts";
        } else {
            var layaZipPath = path.dirname(__dirname) + path.sep + "laya" + path.sep + "code" + path.sep + "js";
        }
        mkdirsSyncLaya(proNameOutput.value);
        //layacopyDirFile(path.dirname(__dirname) + path.sep + "laya" + path.sep + "default", proNameOutput.value + path.sep + "laya");
        //filestr = filestr.replace("<codeType>0</codeType>", "<codeType>" + proTypeLaya.selectedIndex + "</codeType>");
        layacopyDirFile(layaZipPath, proNameOutput.value);
        //fs.writeFileSync(proNameOutput.value + path.sep + "laya" + path.sep + uiConfigName, filestr);
        var layaProperties = {};
        layaProperties.proName = proNameInput.value;
        layaProperties.version = layaIDEVersion;
        layaProperties.proType = proTypeLaya.selectedIndex + "";
        layaProperties.indexhtml = "index.html";
        layaProperties.playerW =800;
        layaProperties.playerH =600;
        if (layaideconfig.recentOpenPath) {
            layaideconfig.recentOpenPath[proNameOutput.value + path.sep + proNameInput.value + ".laya"] = 1;
        } else {
            layaideconfig.recentOpenPath = {}
            layaideconfig.recentOpenPath[proNameOutput.value + path.sep + proNameInput.value + ".laya"] = 1;
        }
        fs.writeFileSync(proNameOutput.value + path.sep + proNameInput.value + ".laya", JSON.stringify(layaProperties));
        if (proTypeLaya.selectedIndex == 0) {
            setTimeout(function(){
                var fdd =fs.readFileSync(layaZipPath+path.sep+"LayaUISample.as3proj","utf-8");
                fs.writeFileSync(proNameOutput.value+path.sep+layaProperties.proName+".as3proj",fdd);
                var fb = fs.readFileSync(layaZipPath+path.sep+".project","utf-8");
                fs.writeFileSync(proNameOutput.value+path.sep+".project",fb.replace("GameMain",layaProperties.proName))
                fs.unlinkSync(proNameOutput.value+path.sep+"LayaUISample.as3proj");
                setTimeout(function(){
                    ipc.send("vscode:openFolderPickerLaya", [proNameOutput.value]);
                },10)

            },10)
        }else{
            setTimeout(function(){
                ipc.send("vscode:openFolderPickerLaya", [proNameOutput.value]);
            },10)
        }
        fs.writeFileSync(proNameOutput.value + path.sep + proNameInput.value + ".laya", JSON.stringify(layaProperties));
    }
}
function mkdirsSyncLaya(dirname, mode) {
    console.log(dirname);
    if (fs.existsSync(dirname)) {
        return true;
    } else {
        if (mkdirsSyncLaya(path.dirname(dirname), mode)) {
            fs.mkdirSync(dirname, mode);
            return true;
        }
    }
}
function layacopyDirFile(from, to) {
    var fs = require('fs');
    var path = require("path")
    var readDir = fs.readdirSync;
    var stat = fs.statSync;
    var copDir = function(src,dst){
        var paths = fs.readdirSync(src);
        paths.forEach(function(pathLaya){
            var _src = src + path.sep + pathLaya;
            var _dst = dst + path.sep + pathLaya;
            var isDir = stat(_src);
            if (isDir.isFile()) {
                fs.writeFileSync(_dst, fs.readFileSync(_src));
            } else {
                exists(_src, _dst, copDir);
            }
        })
    }
    function mkdirsSyncLaya(dirname, mode) {
        console.log(dirname);
        if (fs.existsSync(dirname)) {
            return true;
        } else {
            if (mkdirsSyncLaya(path.dirname(dirname), mode)) {
                fs.mkdirSync(dirname, mode);
                return true;
            }
        }
    }
// 在复制目录前需要判断该目录是否存在，不存在需要先创建目录
    var exists = function (src, dst, callback) {
        mkdirsSyncLaya(dst);
        callback(src, dst);
    };
// 复制目录
    exists(from, to, copDir);
}
//菜单命令
function sendMenuHandlerLaya(type) {
    sendLayaIpcMenu(type);
}
function sendMsgLaya(msg) {
    ipc.send(msg, windowId);
}
function openProHandler() {
    dialogLaya.showOpenDialog({
        properties: ["openFile", 'createDirectory'],
        filters: [{name: 'All Files', extensions: ['laya']}]
    }, function (pathLaya) {
        if (!pathLaya)return;
        pathLaya = pathLaya[0];
        var data = fs.readFileSync(pathLaya, "utf-8");
        try {
            //正常打开项目code  模式的打开
            var config = JSON.parse(data);
            if (config.proName || config.version) {
                layaideconfig.mode = "0";
                layaideconfig.recentOpenPath[pathLaya] = 1
                addOnBeforeUnload();
                ipc.send("vscode:openFolderPickerLaya", [path.dirname(pathLaya)]);
            }
        } catch (e) {
            //uiConfigName ui模式的打开
            if (path.basename(pathLaya) == uiConfigName) {
                layaideconfig.mode = "1";
                var pa = path.dirname(pathLaya);
                layaideconfig.recentOpenPath[pa] = 1
                pa = path.dirname(pa);
                addOnBeforeUnload();
                ipc.send("vscode:openFolderPickerLaya", [pa]);
            } else if (data.indexOf("<project version") != -1) {
                var dir = path.dirname(pathLaya) + path.sep + "laya";
                mkdirsSyncLaya(dir);
                var rst = (new DOMParser()).parseFromString(data, 'text/xml');
                rst.children[0].attributes[0].nodeValue = layaIDEVersion;
                rst = new XMLSerializer().serializeToString(rst)
                fs.writeFileSync(dir + path.sep + uiConfigName, rst);
                fs.unlinkSync(pathLaya);
                var layaProperties = {};
                layaideconfig.mode = "1";
                layaProperties.proName = path.basename(pathLaya);
                layaProperties.version = layaIDEVersion;
                layaProperties.proType = proTypeLaya.selectedIndex + "";
                layaProperties.indexhtml = "index.html";
                layaProperties.playerW =800;
                layaProperties.playerH =600;
                var pathdir = path.dirname(pathLaya);
                fs.writeFileSync(pathdir + path.sep + layaProperties.proName, JSON.stringify(layaProperties));
                ipc.send("vscode:openFolderPickerLaya", [path.dirname(pathLaya)]);
            }
        }
    });
}
function closeWindHandler(id) {
    if (!layaCodeView.src) {
        layaCodeView.src = "vscode.js";
    }
    document.getElementById(id).style.display = 'none';
}
function cancelBtnAlert() {
    document.getElementById(id).style.display = 'none';
}
function onBtnAlert() {

}
//--------------------------初始化最近打开的项目------------------------
function initMenuPro() {
    setTimeout(function () {
        var item;
        for (var key in layaideconfig.recentOpenPath) {
            if (key) {
                if (!fs.existsSync(key)) {
                    delete layaideconfig.recentOpenPath[key]
                } else {
                    var src = key;
                    item = createMenuItem(src, "menuList");
                    item.addEventListener("click", itemclickHandler);
                }
            }
        }

        function itemclickHandler(e) {
            if (fs.existsSync(e.currentTarget.url)) {
                ipc.send("vscode:openFolderPickerLaya", [path.dirname(e.currentTarget.url)]);
            }
            else {
                layaAlertOpen("项目已删除！请检查项目配置文件")
            }

        }

    }, 1000)

}
///------------------创建子菜单-------------------------；
function createMenuItem(name, id) {
    var con = document.getElementById(id);
    var li = document.createElement("Li");
    var a = document.createElement("a");
    a.href = "#";
    a.style = "padding: 8px 10px 10px 10px;height: 12px;";
    a.style.height = "12px";
    a.style.padding = "8px 10px"
    li.url = name;
    li.id = Math.random();
    if (name.length > 30) {
        var par = path.normalize(name + "\\..")
        name = par.substr(0, 30) + path.sep + ".." + path.sep + path.basename(name);
        con.style.width = 320 + "px";
    }
    a.innerText = name;
    li.appendChild(a);
    con.appendChild(li);
    return li;
}
///////////////////////////////////////////
var layaPageSaveAndCallBackResult = 3;
var tempFunction = {}
function layaPageSaveAndCallBack(saveHandler, nosaveHandler) {
    //var a=confirm("郭杨和小代是好朋友吗？");
    tempFunction.save = saveHandler;
    tempFunction.nosave = nosaveHandler;

    if (layaPageSaveAndCallBackResult == 3) {
        var obj = {};
        obj.title = "LayaAir";
        obj.message = "UI页面还未保存，是否保存这些修改？";
        obj.type = "warning";
        obj.detail = "如果不保存，更改将丢失";
        obj.buttons = ["保存(&S)", "不保存(&S)", "取消"];
        obj.cancelId = 2;
        obj.noLink = true;
        //var result = '{"title":"Laya","message":"是否要保存对 Test.as 的更改?","type":"warning","detail":"如果不保存，更改将丢失。","buttons":["保存(&S)","不保存(&S)","取消"],"noLink":true,"cancelId":2}'
        var show = dialogLaya.showMessageBox(remote.getCurrentWindow(), obj);
        if (show == 2) {
            window.event.returnValue = false;
        } else if (show == 0) {
            tempFunction.save();
        } else {
            tempFunction.nosave();
        }
    } else if (layaPageSaveAndCallBackResult == 0) {
        tempFunction.save();
    } else if (layaPageSaveAndCallBackResult == 1) {
        tempFunction.nosave();
    } else if (layaPageSaveAndCallBackResult == 2) {

    }

}
function layaPageNoSAveHandler() {
    tempFunction.nosave();
}
function layaPageSAveHandler() {
    tempFunction.save();

}
//
//
//var layaEditors = document.getElementById("workbench.parts.editor");
//function sendMsgLaya(msg) {
//    ipc.send(msg, windowId);
//}
////传递文件路径
//function openFile(filePath) {
//    ipc.send('vscode:windowOpen', [filePath]);
//}
//var windV = false;
//var faceVs
//function vscodeOpenFolder(p) {
//    //configuration.workspacePath =path;
//    ipc.send("vscode:openFolderPickerLaya", [p]);
//}
////window.onload = function () {
////    if (window.layaProPathUI) {
////        var layaProPathUI = window.layaProPathUI = path.dirname(window.layaProPathUI)
////        if (layaProPathUI != configuration.workspacePath) {
////            if (window.layaProPathUI) {
////                ipc.send("vscode:openFolderPickerLaya", [layaProPathUI]);
////            }
////        }
////    }
////
////}
////if(window.layaProPathUI!=configuration.workspacePath)
////{
////    alert(window.layaProPathUI)
////    window.layaProPathUI&&ipc.send("vscode:openFolderPickerLaya",[window.layaProPathUI]);
////}
//function createLayaTsconfig(pathfile, type) {
//
//    pathfile = path.dirname(pathfile);
//    if (type == 0) {
//        var layaZipPath = path.dirname(__dirname) + path.sep + "demos" + path.sep + "as";
//    } else if (type == 1) {
//        var layaZipPath = path.dirname(__dirname) + path.sep + "demos" + path.sep + "ts";
//    } else {
//        var layaZipPath = path.dirname(__dirname) + path.sep + "demos" + path.sep + "js";
//    }
//    laya.ide.devices.FileTools.copyDir(layaZipPath, pathfile);
//    if (window.layaProPathUI) {
//        var layaProPathUI = window.layaProPathUI = path.dirname(window.layaProPathUI)
//        if (layaProPathUI != configuration.workspacePath) {
//            if (window.layaProPathUI) {
//                ipc.send("vscode:openFolderPickerLaya", [layaProPathUI]);
//            }
//        }
//    }
//}

//var divconLaya
//var timeId = setInterval(function () {
//    divconLaya = document.getElementsByClassName("monaco-shell-content")[0];
//    if (divconLaya) {
//        divconLaya.style.visibility = 'visible';
//        var con = document.getElementsByClassName("actions-container")[0]
//        var li = document.createElement("li");
//        li.onclick = function () {
//            changeViewUILaya();
//        }
//        li.className = "action-item";
//        li.role = "presentation";
//        var ach = document.createElement("a");
//        ach.className = "action-label debug0";
//        ach.title = "切换到UI编辑器模式(Alt+A)";
//        li.appendChild(ach);
//        con.appendChild(li);
//        // conList.style.display = "none";
//        faceVs = document.getElementsByClassName("statusbar-item right");
//        faceVs[0].style.display = "none"
//        clearInterval(timeId);
//    }
//}, 1);
//
//function oclick(type) {
//    if (type == "close") {
//        remote.getCurrentWindow().close();
//    } else if (type == "restore") {
//        if (!remote.getCurrentWindow().isMaximized()) {
//            remote.getCurrentWindow().maximize();
//        } else {
//            remote.getCurrentWindow().restore();
//        }
//    } else if (type == "minimize") {
//        remote.getCurrentWindow().minimize()
//    } else if (type == "f12") {
//        remote.getCurrentWindow().openDevTools();
//    } else if (type == "newfile") {
//        sendMsgLaya("vscode:openFilePicker")
//    } else if (type == "openFolder") {
//        sendMsgLaya("vscode:openFolderPicker");
//    } else if (type == "newwindow") {
//        sendMsgLaya("vscode:openNewWindow");
//    } else if (type == "F11") {
//        remote.getCurrentWindow().setFullScreen(!remote.getCurrentWindow().isFullScreen())
//    } else if (type == "flash") {
//        document.getElementById("CompressJS").style = "block"
//
//    } else if (type == "changeViewUi") {
//        changeViewUILaya();
//    } else if (type == "layaboxPublic") {
//        window.open("http://www.layabox.com/")
//    } else if (type == "layabox") {
//        window.open("http://ask.layabox.com/question")
//    } else if (type == "apianddemo") {
//
//
//    } else if (type == "downLoad") {
//        window.open("http://ldc.layabox.com/")
//    }
//    else if ("debugLaya" == type) {
//        var BrowserWindow = remote.BrowserWindow;
//
//        var win = new BrowserWindow({width: 800, height: 600, show: true, title: "LayaAir"});
//        win.on('closed', function () {
//            win = null;
//        });
//        if (configuration.workspacePath) {
//            win.loadURL(configuration.workspacePath + path.sep + "index.html");
//            win.show();
//        }
//    }
//}
//function changeViewUILaya() {
//    if (!layaUIView.src) {
//        layaUIView.src = "layabuilder.max.js"
//    }
//    if (!divconLaya) {
//        divconLaya = document.getElementsByClassName("monaco-shell-content")[0];
//    }
//    if (!layaCanvas) {
//        var canvas = document.getElementsByTagName("canvas");
//        for (var i = 0; i < canvas.length; i++) {
//            if (canvas[i].className == "") {
//                layaCanvas = canvas[i];
//                break
//            }
//        }
//    }
//    if (layaCanvas) {
//        layaCanvas.style.display = "block";
//    }
//    conList.style.display = "none";
//    divconLaya.style.visibility = 'hidden';
//    if (laya)laya.editor.manager.ProjectManager.openProjectByPath(path.join(configuration.workspacePath, "laya", "mylaya"));
//}
//var layaCanvas
//function changeViewCode() {
//    if (!divconLaya) {
//        divconLaya = document.getElementsByClassName("monaco-shell-content")[0];
//    }
//    if (!layaCanvas) {
//        var canvas = document.getElementsByTagName("canvas");
//        for (var i = 0; i < canvas.length; i++) {
//            if (canvas[i].className == "") {
//                layaCanvas = canvas[i];
//                break
//            }
//        }
//    }
//    layaCanvas.style.display = "none";
//    conList.style.display = "block";
//    divconLaya.style.visibility = 'visible'
//}
//function sendMenuHandlerLaya(type) {
//    sendLayaIpcMenu(type);
//}
//function mouseOutHandler(e) {
//    var par = e.currentTarget.children[1];
//    par.style.display = "none";
//}
//function overHandler(e) {
//    var par = e.currentTarget.children[1];
//    par.style.display = "block";
//}
//function b_block(e) {
//    e.preventDefault();
//    var par = e.currentTarget.children[1];
//    if (par.style.display == "none") {
//        par.style.display = "block";
//    } else {
//        par.style.display = "none";
//    }
//}
//var globalShortcut = remote.globalShortcut;

document.onkeydown = function () {

    var oEvent = window.event;
    if (oEvent.altKey && oEvent.keyCode == "65") {
        if (layaideconfig.mode == "1") {
            changeLayaIDECodeMode();
        } else {
            changeLayaViewMode();
        }
    }
}
//var proCodeType = 0;
//function createProHandler(id) {
//    document.getElementById("title_dialg").innerText = "新建项目";
//    document.getElementById("ouibounce-modal").style.zIndex = 99999999999999999999
//
//    showDiv("newProW");
//}
//function openProHandler() {
//
//    dialogLaya.showOpenDialog({
//        properties: ["openFile", 'createDirectory'],
//        filters: [{name: 'All Files', extensions: ['laya']}]
//    }, function (path) {
//        path = path[0];
//        changeViewUILaya();
//        setTimeout(function () {
//            laya.editor.manager.ProjectManager.openProjectByPath(path);
//        }, 1000)
//    });
//}
//function showDiv(id) {
//    document.getElementById("ouibounce-modal").style.display = "block";
//    proNameOutput.value = remote.app.getPath("documents");
//    proNameInput.value = "Mylaya"
//}
//function closeWindHandler(id) {
//    document.getElementById(id).style.display = 'none';
//}
//var dialogLaya = electron.remote.dialog;
//function startProWork(e) {
//    dialogLaya.showOpenDialog({properties: ["openDirectory", 'createDirectory']}, function (path) {
//        path = path[0];
//        proNameOutput.value = path;
//    });
//}
//var layaProperties = {};
//function newProWorkspace(type) {
//    var filestr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<project version=\"0.97\">\n" + "	<!--assets异步资源目录，在这些目录里面的资源，不会被编译到swf里面，但会复制到发布目录-->\n" + "	<asynRes>img,temp,sound</asynRes>\n" + "	<!--assets不处理目录，在这些目录里面的资源，不会做任何处理（包括复制）-->\n" + "	<unDealRes>embed</unDealRes>\n" + "	<!--资源类型-->\n" + "	<resTypes>png,jpg</resTypes>\n" + "	<!--发布资源导出目录-->\n" + "	<resExportPath>bin/h5</resExportPath>\n" + "	<!--UICode导出目录-->\n" + "	<codeExportPath>src/game/ui</codeExportPath>\n" + "	<!--UICode默认导入类-->\n" + "	<codeImports>import laya.ui.*;</codeImports>\n" + "	<codeImportsJS>var View=laya.ui.View;\nvar Dialog=laya.ui.Dialog;</codeImportsJS>\n" + "	<!--UI模式（0:内嵌模式，1:加载模式）-->\n" + "	<uiType>0</uiType>\n" + "	<!--UI导出目录（加载模式可用）-->\n" + "	<uiExportPath>bin/ui.swf</uiExportPath>\n" + "	<!--容器列表（转换为容器功能使用）-->\n" + "	<boxTypes>Box,List,Tab,RadioGroup,ViewStack,Panel,HBox,VBox,Tree</boxTypes>\n" + "	<!--页面类型（用于自定义页面继承）-->\n" + "	<pageTypes>View,Dialog</pageTypes>\n" + "	<!--多模块开发时共用的资源目录-->\n" + "	<shareResPath></shareResPath>\n" + "	<!--语言类型-->\n" + "	<codeType>0</codeType>\n" + "</project>";
//    if (proNameOutput.value) {
//        document.getElementById("ouibounce-modal").style.display = "none";
//        if (proTypeLaya.selectedIndex == 0) {
//            var layaZipPath = path.dirname(__dirname) + path.sep + "laya" + path.sep + "demos" + path.sep + "as";
//        } else if (proTypeLaya.selectedIndex == 1) {
//            var layaZipPath = path.dirname(__dirname) + path.sep + "laya" + path.sep + "demos" + path.sep + "ts";
//        } else {
//            var layaZipPath = path.dirname(__dirname) + path.sep + "laya" + path.sep + "demos" + path.sep + "js";
//        }
//        mkdirsSync(proNameOutput.value);
//        setTimeout(function () {
//            layacopyDirFile(path.dirname(__dirname) + path.sep + "laya" + path.sep + "default", proNameOutput.value + path.sep + "laya");
//            filestr = filestr.replace("<codeType>0</codeType>", "<codeType>" + proTypeLaya.selectedIndex + "</codeType>");
//            layacopyDirFile(layaZipPath, proNameOutput.value);
//            fs.writeFileSync(proNameOutput.value + path.sep + "laya" + path.sep + proNameInput.value + ".laya", filestr);
//            layaProperties.proName = proNameInput.value;
//            fs.writeFileSync(proNameOutput.value, JSON.stringify(layaProperties + ".json"));
//            ipc.send("vscode:openFolderPickerLaya", [proNameOutput.value]);
//        }, 100)
//    }
//}
//function mkdirsSync(dirname, mode) {
//    console.log(dirname);
//    if (fs.existsSync(dirname)) {
//        return true;
//    } else {
//        if (mkdirsSync(path.dirname(dirname), mode)) {
//            fs.mkdirSync(dirname, mode);
//            return true;
//        }
//    }
//}
const Menu = remote.Menu;
const MenuItem = remote.MenuItem;
var template = [
    {
        label: '编辑',
        submenu: [
            {
                label: '撤销',
                accelerator: 'CmdOrCtrl+Z',
                role: 'undo'
            },
            {
                label: '重做',
                accelerator: 'Shift+CmdOrCtrl+Z',
                role: 'redo'
            },
            {
                type: 'separator'
            },
            {
                label: '剪切',
                accelerator: 'CmdOrCtrl+X',
                role: 'cut'
            },
            {
                label: '复制',
                accelerator: 'CmdOrCtrl+C',
                role: 'copy'
            },
            {
                label: '粘贴',
                accelerator: 'CmdOrCtrl+V',
                role: 'paste'
            },
            {
                label: '全选',
                accelerator: 'CmdOrCtrl+A',
                role: 'selectall'
            },
        ]
    },
    {
        label: '视图',
        submenu: [
            {
                label: '重新加载',
                accelerator: 'CmdOrCtrl+R',
                click: function (item, focusedWindow) {

                }
            },
            {
                label: '切换全屏',
                accelerator: (function () {
                    if (process.platform == 'darwin')
                        return 'Ctrl+Command+F';
                    else
                        return 'F11';
                })(),
                click: function (item, focusedWindow) {
                    if (focusedWindow)
                        focusedWindow.setFullScreen(!focusedWindow.isFullScreen());
                }
            },
            {
                label: '打开开发者工具',
                accelerator: (function () {
                    if (process.platform == 'darwin')
                        return 'Alt+Command+I';
                    else
                        return 'Ctrl+Shift+I';
                })(),
                click: function (item, focusedWindow) {
                    if (focusedWindow)
                        focusedWindow.webContents.toggleDevTools();
                }
            },
        ]
    },
    {
        label: '窗口',
        role: 'window',
        submenu: [
            {
                label: '最小化',
                accelerator: 'CmdOrCtrl+M',
                role: 'minimize'
            },
            {
                label: '关闭',
                accelerator: 'CmdOrCtrl+W',
                role: 'close'
            },
        ]
    },
    {
        label: '帮助',
        role: 'help',
        submenu: [
            {
                label: '问答社区',
                click: function () {
                    require('electron').shell.openExternal("http://ask.layabox.com/question")
                }
            },
        ]
    },
];

if (process.platform == 'darwin') {
    var name = require('electron').remote.app.getName();
    template.unshift({
        label: name,
        submenu: [
            {
                label: 'About ' + name,
                role: 'about'
            },
            {
                type: 'separator'
            },
            {
                label: 'Services',
                role: 'services',
                submenu: []
            },
            {
                type: 'separator'
            },
            {
                label: 'Hide ' + name,
                accelerator: 'Command+H',
                role: 'hide'
            },
            {
                label: 'Hide Others',
                accelerator: 'Command+Alt+H',
                role: 'hideothers'
            },
            {
                label: 'Show All',
                role: 'unhide'
            },
            {
                type: 'separator'
            },
            {
                label: 'Quit',
                accelerator: 'Command+Q',
                click: function () {
                    app.quit();
                }
            },
        ]
    });
    // Window menu.
    template[3].submenu.push(
        {
            type: 'separator'
        },
        {
            label: 'Bring All to Front',
            role: 'front'
        }
    );
}

var menu = Menu.buildFromTemplate(template);
Menu.setApplicationMenu(menu);
//function layacopyDirFile(from, to) {
//    var fs = require('fs'),
//        stat = fs.stat;
//
//    var copy = function (src, dst) {
//        // 读取目录中的所有文件/目录
//        fs.readdir(src, function (err, paths) {
//            if (err) {
//                throw err;
//            }
//            paths.forEach(function (pathLaya) {
//                var _src = src + path.sep + pathLaya,
//                    _dst = dst + path.sep + pathLaya,
//                    readable, writable;
//                stat(_src, function (err, st) {
//                    if (err) {
//                        throw err;
//                    }
//                    // 判断是否为文件
//                    if (st.isFile()) {
//                        // 创建读取流
//                        readable = fs.createReadStream(_src);
//                        // 创建写入流
//                        writable = fs.createWriteStream(_dst);
//                        // 通过管道来传输流
//                        readable.pipe(writable);
//                    }
//                    // 如果是目录则递归调用自身
//                    else if (st.isDirectory()) {
//                        exists(_src, _dst, copy);
//                    }
//                });
//            });
//        });
//    };
//// 在复制目录前需要判断该目录是否存在，不存在需要先创建目录
//    var exists = function (src, dst, callback) {
//        fs.exists(dst, function (exists) {
//            // 已存在
//            if (exists) {
//                callback(src, dst);
//            }
//            // 不存在
//            else {
//                fs.mkdir(dst, function () {
//                    callback(src, dst);
//                });
//            }
//        });
//    };
//// 复制目录
//    exists(from, to, copy);
//}
//window.onkeydown = function (e) {
//    if (e.keyCode == 116) {
//        remote.getCurrentWindow().reload()
//    }
//}
//
//
//
