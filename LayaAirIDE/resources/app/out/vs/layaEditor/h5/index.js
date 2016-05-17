/**
 * Created by wangzhihua on 2016/4/21.
 */
var fs = require('fs');
var path = require('path');
var electron = require('electron');
var remote = electron.remote;
var ipc = electron.ipcRenderer;
var childProcess = require("child_process");
var windowId = remote.getCurrentWindow().id;
//remote.getCurrentWindow().openDevTools()
var windclipHLaya = 0;
var layaTopClip = "36px";
var layaIDEMode = 0;//代码模式
var layaideconfig = {};
var dialogLaya = electron.remote.dialog;
var layaIDEVersion = "0.9.9";
var uiConfigName = ".laya";
var layawindowDebug;
var layaWindowResutl = 4;
var layaEditeVscode;
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
remote.getCurrentWindow().setTitle("LayaAir")
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
var layaDviCon = [flashResTool, compressJS, loadingCompress, subpackage];
//初始化拖动条
initMenuBar()
function initMenuBar() {
    var _winddragBar = document.createElement("div");
    _winddragBar.style.position = "absolute";
    _winddragBar.style.left = "360px";
    _winddragBar.style.right = "180px";
    _winddragBar.style.webkitAppRegion = "drag";
    _winddragBar.style.height = "30px";
    _winddragBar.id = "_layaDrop";
    _winddragBar.style.top = "0px";
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
        //layaideconfig.recentOpenPath = {};
        layaideconfig.recentOpenPro = []
        //layaCodeView.src = "vscode.js";
        conList.style.visibility = 'visible';
        conList.style.display = "block";
        document.getElementById("ouibounce-modal").style.zIndex = 99;
        title_dialg.innerText = "欢迎";
        layaPanelClose.style.display = "none"
        showDivPop(subpackage);
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
                    conList.style.visibility = 'hidden';
                    editeMenu.style.display = "block";
                    editeMenu.style.zIndex = 1000;
                    changeLayaViewMode();
                } else {
                    //code 模式；
                    conList.style.visibility = 'visible';
                    conList.style.display = "block"
                    layaCodeView.src = "vscode.js";
                    var timeId = setInterval(function () {
                        divconLayaCode = document.getElementsByClassName("monaco-shell-content")[0];
                        if (divconLayaCode) {
                            divconLayaCode.style.visibility = 'visible';
                            divconLayaCode.style.position = "absolute";
                            divconLayaCode.style.top = layaTopClip;
                            initchangeBug();
                            clearInterval(timeId);
                            changeLayaIDECodeMode()
                        }
                    }, 1);
                }

            } else {
                layaideconfig = {};
                layaideconfig.recentOpenPath = {};
                layaideconfig.recentOpenPro = [];
                layaideconfig.mode == "0";
                layaCodeView.src = "vscode.js";
                conList.style.visibility = 'visible';
                conList.style.display = "block"
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
    ach.title = "切换到UI编辑器模式(Alt+Q)";
    li.appendChild(ach);
    con.appendChild(li);
    // conList.style.display = "none";
    faceVs = document.getElementsByClassName("statusbar-item right");
    faceVs[0].style.display = "none";
    //divconLayaCode.style.position ="absolute";
    //divconLayaCode.style.top = layaTopClip;
}
var layaCanvasEd;
function changeLayaIDECodeMode() {
    //window.blur()
    if (!configuration.workspacePath) {
        return
    }
    layaideconfig.mode = "0";
    editeMenu.style.display = "none";
    if (!layaCodeView.src) {
        layaCodeView.src = "vscode.js";
        setTimeout(initchangeBug, 1000)
    }
    if (!divconLayaCode) {
        divconLayaCode = document.getElementsByClassName("monaco-shell-content")[0];
        if (divconLayaCode) {
            divconLayaCode.style.visibility = 'visible';
            divconLayaCode.style.position = "absolute";
            divconLayaCode.style.top = layaTopClip;
        }
    } else if (divconLayaCode) {
        divconLayaCode.style.visibility = 'visible';
        divconLayaCode.style.position = "absolute";
        divconLayaCode.style.top = layaTopClip;
    }
    if (!layaCanvasView) {
        var canvas = document.getElementsByTagName("canvas");
        for (var i = 0; i < canvas.length; i++) {
            if (canvas[i].className == "") {
                layaCanvasView = canvas[i];
                //layaCanvasView.style.display = "none";
                document.body.removeChild(layaCanvasView);
                // Laya.stage.visible = false;
                if (laya)laya.events.KeyBoardManager.enabled = false;
                break
            }
        }
    } else {
        document.body.removeChild(layaCanvasView);
        if (laya)laya.events.KeyBoardManager.enabled = false;
    }
    if (window["laya"])laya.events.KeyBoardManager.enabled = false;
    conList.style.visibility = 'visible';
    conList.style.display = "block"

}
//新建工程
function layaNewCreatePro(e) {
    document.getElementById("title_dialg").innerText = "新建项目";
    document.getElementById("ouibounce-modal").style.zIndex = 9999
    flashResTool.style.display = "block";
    subpackage.style.display = "none"
    showDiv();
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
    if (!configuration.workspacePath) {
        return
    }
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
        if (divconLayaCode) {
            divconLayaCode.style.visibility = 'hidden';
            divconLayaCode.style.position = "absolute";
            divconLayaCode.style.top = layaTopClip;
        }
    } else {
        divconLayaCode.style.visibility = 'hidden';
        divconLayaCode.style.position = "absolute";
        divconLayaCode.style.top = layaTopClip;
    }
    if (!layaCanvasView) {
        var canvas = document.getElementsByTagName("canvas");
        for (var i = 0; i < canvas.length; i++) {
            if (canvas[i].className == "") {
                layaCanvasView = canvas[i];
                //    Laya.stage.visible = false;
                document.body.appendChild(layaCanvasView);
                //layaCanvasView.style.display = "block";
                break
            }
        }
    } else {
        //   Laya.stage.visible = false;
        document.body.appendChild(layaCanvasView);
        //layaCanvasView.style.display = "block";
    }
    conList.style.visibility = 'hidden';
    editeMenu.style.display = "block";
    editeMenu.style.zIndex = 1000;
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
var tsErrorPanel;
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
    } else if (type == "layademo") {
        window.open("http://layaair.ldc.layabox.com/demo/#Sprite_DisplayImage")
    } else if (type == "downLoad") {
        window.open("http://ldc.layabox.com/")
    }
    else if ("debugLaya" == type) {
        sendMenuHandlerLaya("workbench.action.files.saveAll");

        if (!configuration.workspacePath) {
            layaAlertOpen("该项目不是有效的LayaAir项目！");
            return
        } else {
            var fileList = fs.readdirSync(configuration.workspacePath);
            var urlIndex
            for (var i = 0; i < fileList.length; i++) {
                if (fileList[i].indexOf(".laya") != -1) {
                    var stat = fs.lstatSync(configuration.workspacePath + path.sep + fileList[i]);
                    if (!stat.isDirectory()) {
                        var data = fs.readFileSync(configuration.workspacePath + path.sep + fileList[i], "utf-8");
                        data = data.replace(/\\/g, "/")
                        var player = JSON.parse(data);
                        urlIndex = player.indexhtml;
                        break;
                    }
                }
            }
            var url = urlIndex;
            if (!url) {
                layaAlertOpen("该项目不是有效的LayaAir项目！");
                return
            }
            debugButton.style.pointerEvents = "none";
            debugButton.style.backgroundColor = "#585656"
            var urlIndex = configuration.workspacePath + path.sep + urlIndex;
            urlIndex = path.normalize(urlIndex)
                //var ar ="tsc -p D:/Documents/myLayassffr -outDir D:/Documents/myLayassffree/bin";
                if (fs.existsSync(configuration.workspacePath + path.sep + "tsconfig.json")) {
                    tsStartHandler(player, urlIndex);
                } else if (fs.existsSync(configuration.workspacePath + path.sep + "jsconfig.json")) {
                    jsStartHandler(player, urlIndex)
                } else {
                    asStartHandler(player, urlIndex)
                }
        }

    }
}
var layaWaitComplete = 0;
function tsStartHandler(player, urlIndex) {
    playerConfig = player;
    layaEditeVscode.clearOutput("Tasks");
    layaEditeVscode.append("Tasks", "准备编译...\n");
    clearInterval(layaWaitComplete);
    //layaEditeVscode.showOutput("Tasks", true);
    var count = 0;
    var arcount = [".", "...", ".....", "......", "........"];
    var infoLaya = ["|", "/", "-", "\\", "|"]
    if (tsErrorPanel.innerText == "0") {
        layaAndvscodeInfo.className = "task-statusbar-item-progress";
        layaWaitComplete = setInterval(function () {
            count++;
            count = count % 5;
            layaInfo.innerHTML = "开始编译:" + arcount[count];
            layaAndvscodeInfo.innerHTML = infoLaya[count]
        }, 50);
        var config = fs.readFileSync(configuration.workspacePath + path.sep + ".laya" + path.sep + "tasks.json", "utf-8");
        var config = JSON.parse(config);
        config = config.args[3].replace(/\\/g, path.sep);
        var ar = "tsc -p " + configuration.workspacePath + " -outDir " + configuration.workspacePath + path.sep + config;
        childProcess.exec(ar, {encoding: "binary", maxBuffer: 1024 * 1024 * 20}, function (err, stdOut, stdErr) {
            clearInterval(layaWaitComplete);
            layaInfo.innerHTML = "编译完成";
            debugButton.style.pointerEvents = "";
            debugButton.style.backgroundColor = ""
            layaAndvscodeInfo.className = "task-statusbar-item-progress hidden";
            if (stdOut||stdErr) {
                layaEditeVscode.clearOutput("Tasks");
                layaEditeVscode.showOutput("Tasks", true);
                layaEditeVscode.append("Tasks", stdOut);
                layaEditeVscode.append("Tasks", stdErrs);
                layaEditeVscode.append("Tasks", " 编译完成。");
            }
            else {
                //sendLayaIpcMenu("workbench.action.showErrorsWarnings");
                if (fs.existsSync(urlIndex)){
                    ipc.send("layaDebugerWinMessage", player, urlIndex);
                }else{
                    alert("可运行的html文件:"+urlIndex+"不存在!\n请指定配置文件中的html文件！")
                }
                layaEditeVscode.clearOutput("Tasks");
                layaEditeVscode.append("Tasks", " 编译完成。");
            }
        });
    } else {
        sendLayaIpcMenu("workbench.action.showErrorsWarnings");
        debugButton.style.pointerEvents = "";
        debugButton.style.backgroundColor = ""
    }
}
var playerConfig;
function layaDebugGoon(player, urlIndex) {
    layaPageSave.style.display = "none"
    ipc.send("layaDebugerWinMessage", playerConfig, playerConfig.indexHtml);
}
function asStartHandler(player, urlIndex) {
    asCompileModule(player)
    return
    //ipc.send("layaDebugerWinMessage", player, urlIndex);
}
function jsStartHandler(player, urlIndex) {
    debugButton.style.pointerEvents = "";
    debugButton.style.backgroundColor = ""
    ipc.send("layaDebugerWinMessage", player, urlIndex);
}
function mouseOutHandler(e) {
    var par = e.currentTarget.children[1];
    par.style.display = "none";
}
function overHandler(e) {
    var par = e.currentTarget.children[1];
    par && (par.style.display = "block");
}
function b_block(e) {
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
    document.getElementById("ouibounce-modal").style.zIndex = 9999;
    showDivPop(flashResTool);
    showDiv(flashResTool);
}
function showDiv(id) {
    document.getElementById("ouibounce-modal").style.display = "block";
    proNameOutput.value = remote.app.getPath("documents") + path.sep + "myLaya";
    proNameInput.value = "myLaya"
}
function showDialg(id) {
    document.getElementById("ouibounce-modal").style.display = "block";
    id.style.display = "block";
}
function changeFolderPro(e) {
    dialogLaya.showOpenDialog({properties: ["openDirectory", 'createDirectory']}, function (path) {
        path = path[0];
        proNameOutput.value = path;
    });
}
function okCreateLayaUI() {
    var layaZipPath = path.dirname(__dirname) + path.sep + "laya" + path.sep + "code" + path.sep + "as" + path.sep + "laya";
    layacopyDirFile(layaZipPath, configuration.workspacePath + path.sep + "laya");
    closeAlerHandler("layaAlertWarning");
    changeLayaViewMode();
    //ipc.send("vscode:openFolderPickerLaya", [proNameOutput.value]);
}
function createProWorkspace(type) {
    if (!proNameOutput.value || !proNameInput.value) {
        return
    }
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
        if (layaideconfig.recentOpenPro) {
            layaideconfig.recentOpenPro.unshift(proNameOutput.value + path.sep + proNameInput.value + ".laya");
        } else {
            layaideconfig.recentOpenPro = [];
            layaideconfig.recentOpenPro.unshift(proNameOutput.value + path.sep + proNameInput.value + ".laya");
        }
        //macHandler(proTypeLaya.selectedIndex,layaZipPath,proNameInput.value,proNameOutput.value);
        if(process.platform === 'darwin')
        {
            macHandler(proTypeLaya.selectedIndex,layaZipPath,proNameInput.value,proNameOutput.value)
        }else{
            ipc.send("layaMessageCreatePro", proTypeLaya.selectedIndex,layaZipPath,proNameInput.value,proNameOutput.value);
        }
        ipc.send("vscode:openFolderPickerLaya", [proNameOutput.value]);
    }
}
function macHandler(type,layaZipPath)
{
    layacopyDirFile(layaZipPath, proNameOutput.value);
    var layafile = fs.readFileSync(layaZipPath + path.sep + "myLaya.laya", "utf-8")
    fs.unlinkSync(proNameOutput.value + path.sep + "myLaya.laya");
    fs.writeFileSync(proNameOutput.value + path.sep + proNameInput.value + ".laya", layafile);
    if(type==0)
    {
        var fb = fs.readFileSync(layaZipPath + path.sep + ".project", "utf-8");
        fs.writeFileSync(proNameOutput.value + path.sep + ".project", fb.replace("GameMain", proNameInput.value))
        fs.renameSync(proNameOutput.value + path.sep + "LayaUISample.as3proj", proNameOutput.value + path.sep + proNameInput.value + ".as3proj")
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
    var copDir = function (src, dst) {
        var paths = fs.readdirSync(src);
        paths.forEach(function (pathLaya) {
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
    if (!configuration.workspacePath) {
        return
    }
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
            data = data.replace(/\\/g, "/");
            var config = JSON.parse(data);
            if (config.proName || config.version) {
                layaideconfig.mode = "0";
                //layaideconfig.recentOpenPath[pathLaya] = new Date().getTime();
                layaideconfig.recentOpenPro.unshift(pathLaya);
                addOnBeforeUnload();
                ipc.send("vscode:openFolderPickerLaya", [path.dirname(pathLaya)]);
            }
        } catch (e) {
            //uiConfigName ui模式的打开
            if (path.basename(pathLaya) == uiConfigName) {
                layaideconfig.mode = "1";
                var pa = path.dirname(pathLaya);
                //layaideconfig.recentOpenPath[pa] = new Date().getTime();
                layaideconfig.recentOpenPro.unshift(pa);
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
                layaProperties.playerW = 800;
                layaProperties.playerH = 600;
                var pathdir = path.dirname(pathLaya);
                fs.writeFileSync(pathdir + path.sep + layaProperties.proName, JSON.stringify(layaProperties));
                ipc.send("vscode:openFolderPickerLaya", [path.dirname(pathLaya)]);
            }
        }
    });
}
function closeWindHandler(id) {
    //if (!layaCodeView.src) {
    //    layaCodeView.src = "vscode.js";
    //}
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
        var i = 0;
        if (layaideconfig.recentOpenPro && layaideconfig.recentOpenPro.length > 0) {
            for (var k = 0; k < layaideconfig.recentOpenPro.length; k++) {
                var src = layaideconfig.recentOpenPro[k];
                if (!src)continue;
                i++;
                if(i>10)break;
                layaideconfig.recentOpenPro.push(key);
                item = createMenuItem(src, "menuList");
                item.addEventListener("click", itemclickHandler);
                item = createMenuItem(src, "menuListEd");
                item.addEventListener("click", itemclickHandler);
            }
        } else {
            layaideconfig.recentOpenPro = [];
            for (var key in layaideconfig.recentOpenPath) {
                if (key) {
                    if (!fs.existsSync(key) || i > 10) {
                        delete layaideconfig.recentOpenPath[key]
                    } else {
                        var src = key;
                        layaideconfig.recentOpenPro.push(key);
                        item = createMenuItem(src, "menuList");
                        i++;
                        item.addEventListener("click", itemclickHandler);
                        item = createMenuItem(src, "menuListEd");
                        item.addEventListener("click", itemclickHandler);
                    }
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
function addMenuListItem(id, itemName, clickHandler) {
    var con = document.getElementById(id);
    var li = document.createElement("Li");
    var a = document.createElement("a");
    a.href = "#";
    a.style = "padding: 8px 10px 10px 10px;height: 12px;";
    a.style.height = "12px";
    a.style.padding = "8px 10px";
    a.innerText = itemName;
    li.appendChild(a);
    con.appendChild(li);
    li.addEventListener("click", clickHandler)
    return li;
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
document.onkeydown = function () {
    var oEvent = window.event;
    if (configuration.workspacePath) {
        if (oEvent.altKey && oEvent.keyCode == "81") {
            window.blur();
            if (layaideconfig.mode == "1") {
                changeLayaIDECodeMode();
            } else {
                changeLayaViewMode();
            }
        } else if (oEvent.keyCode == 116) {
            if (layaideconfig.mode == "0") {
                oclick("debugLaya");
            }
        }
    }

}
function editeMenuhandler(type) {
    var Keyboard = laya.events.Keyboard;
    var ShortcutManager = laya.editor.manager.ShortcutManager;
    switch (type) {
        case "newProEditeMenu":
            createProHandler();
            layaideconfig.mode = "1";
            break;
        case "openProEditeMenu":
            openProHandler();
            break;
        case "newUntitledFile":
            ShortcutManager.exeKey(Keyboard.N, true);
            break
        case "newDir":
            ShortcutManager.exeKey(Keyboard.D, true);
            break;
        case "setPage":
            ShortcutManager.exeKey(Keyboard.P, true);
            break;
        case "setPro":
            ShortcutManager.exeKey(Keyboard.F9);
            break;
        case "undoEd":
            ShortcutManager.exeKey(Keyboard.Z, true);
            break;
        case"redoEd":
            ShortcutManager.exeKey(Keyboard.Y, true);
            break;
        case "copyEd":
            ShortcutManager.exeKey(Keyboard.C, true);
            break;
        case "pasteEd":
            ShortcutManager.exeKey(Keyboard.V, true);
            break;
        case "paseteEdP":
            ShortcutManager.exeKey(Keyboard.V, true, true);
            break;
        case "cutEd":
            ShortcutManager.exeKey(Keyboard.X, true);
            break;
        case "selectAllEd":
            ShortcutManager.exeKey(Keyboard.A, true);
            break;
        case "coverConEd":
            ShortcutManager.exeKey(Keyboard.B, true);
            break;
        case "deleteEd":
            ShortcutManager.exeKey(Keyboard.DELETE);
            break;
        case "fastMoveEd":

            break;
        case "remodeConEd":
            ShortcutManager.exeKey(Keyboard.U, true);
            break;
        case "reCopyEd":
            ShortcutManager.exeKey(Keyboard.R, true);
            break
        case "fixResEd":
            laya.ide.event.IDEEvent.emitKeyEvent(Keyboard.K, true, false);
            break;
        case "findReplaceEd":
            ShortcutManager.exeKey(Keyboard.F, true);
            break;
        case "saveEd":
            ShortcutManager.exeKey(Keyboard.S, true);
            break;
        case "saveAllEd":
            ShortcutManager.exeKey(Keyboard.S, true, true);
            break;
        case "bigViewEd":
            ShortcutManager.exeKey(Keyboard.EQUAL, true);
            break;
        case "smallViewEd":
            ShortcutManager.exeKey(Keyboard.MINUS, true);
            break;
        case "showViewEd":
            ShortcutManager.exeKey(Keyboard.F8);
            break;
        case "resetViewEd":
            ShortcutManager.exeKey(Keyboard.BACKSLASH, true);
            break;
        case "shoeViewDeEd":
            ShortcutManager.exeKey(Keyboard.R, true, true);
            laya.ide.event.IDEEvent.emitKeyEvent(Keyboard.R, true, true);
            break;
        case "upEd":
            break;
        case "downEd":
            ShortcutManager.exeKey(Keyboard.DOWN, true);
            IDEEvent.emitKeyEvent(Keyboard.DOWN, true);
            break;
        case "projPanelEd":
            laya.ide.managers.LayoutRecManager.showPanelByClassName("PagePanel");
            break;
        case "resPanelEd":
            laya.ide.managers.LayoutRecManager.showPanelByClassName("ResPanel");
            break;
        case "CompPanel":
            laya.ide.managers.LayoutRecManager.showPanelByClassName("CompPanel");
            break;
        case "objPanelEd":
            laya.ide.managers.LayoutRecManager.showPanelByClassName("PropPanel");
            break;
        case "displayTreePanel":
            laya.ide.managers.LayoutRecManager.showPanelByClassName("DisplayTreePanel");
            break;
        case "timePanel":
            laya.ide.managers.LayoutRecManager.showPanelByClassName("TimeLinePanel");
            break;
        case "资源转换工具":
            CMDShell.exeFile(FileManager.getAppPath(Paths.AirTool), null, null);
            break;
        case "resetPanel":
            ShortcutManager.exeKey(Keyboard.F3);
            break;
        case "changeProEditeMenu":
            laya.editor.view.other.ConvertProject.instance.start();
            break;
        case "pushEd":
            ShortcutManager.exeKey(Keyboard.F12);
            break;
        case "cleanPush":
            ShortcutManager.exeKey(Keyboard.F12, true);
            break;
        case "pushFinalEd":
            ShortcutManager.exeKey(Keyboard.F11);
            break;
        case "refreshPanelEd":
            ShortcutManager.exeKey(Keyboard.F5);
            break;
        case "refreshPagePanelEd":
            ShortcutManager.exeKey(Keyboard.F6);
            break
        case "refreshResPanelEd":
            ShortcutManager.exeKey(Keyboard.F7);
            break;
        case"findNoPageEd":
            ShortcutManager.exeKey(Keyboard.F4);
            break;
        case "altaPackEd":
            laya.editor.view.other.PackAltas.instance.start();
            break;
        case "resCoverEd":
            var dir = path.dirname(__dirname);
            var file = path.join(dir, "libs", "LayaAirTool", "LayaAirTool.exe");
            childProcess.execFile(file);
            break;
        case "jsCompress":
            comprssJSModule()
            break
    }
}
function openUserPath() {
    remote.shell.openItem(remote.app.getDataPath())
}
//window.onkeydown = function (e) {
//    if (e.keyCode == 116) {
//        remote.getCurrentWindow().reload();
//    }
//
//}

function showDivPop(id) {
    document.getElementById("ouibounce-modal").style.display = "block"
    for (var i = 0; i < layaDviCon.length; i++) {
        layaDviCon[i].style.display = "none";
    }
    id.style.display = "block";
}


//outputService.append(_this.outputChannel, line + '\n')