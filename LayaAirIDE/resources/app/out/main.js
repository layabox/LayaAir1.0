/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
function stripComments(a) {
    var e = /("(?:[^\\\"]*(?:\\.)?)*")|('(?:[^\\\']*(?:\\.)?)*')|(\/\*(?:\r?\n|.)*?\*\/)|(\/{2,}.*?(?:(?:\r?\n)|$))/g, r = a.replace(e, function (a, e, r, n, t) {
        if (n)return "";
        if (t) {
            var o = t.length;
            return o > 2 && "\n" === t[o - 1] ? "\r" === t[o - 2] ? "\r\n" : "\n" : ""
        }
        return a
    });
    return r
}
function getNLSConfiguration() {
    for (var a = void 0, e = "--locale", r = 0; r < process.argv.length; r++) {
        var n = process.argv[r];
        if (n.slice(0, e.length) == e) {
            var t = n.split("=");
            a = t[1];
            break
        }
    }
    if (!a) {
        var o = app.getPath("userData");
        if (localeConfig = path.join(o, "User", "locale.json"), fs.existsSync(localeConfig))try {
            var s = stripComments(fs.readFileSync(localeConfig, "utf8"));
            value = JSON.parse(s).locale, value && "string" == typeof value && (a = value)
        } catch (l) {
        }
    }
    if (a = a || app.getLocale(), a = a ? a.toLowerCase() : a, "pseudo" === a)return {
        locale: a,
        availableLanguages: {},
        pseudo: !0
    };
    var i = a;
    if (process.env.VSCODE_DEV)return {locale: a, availableLanguages: {}};
    for (; a;) {
        var p = path.join(__dirname, "vs", "workbench", "electron-main", "main.nls.") + a + ".js";
        if (fs.existsSync(p))return {locale: i, availableLanguages: {"*": a}};
        var c = a.lastIndexOf("-");
        a = c > 0 ? a.substring(0, c) : null
    }
    return {locale: i, availableLanguages: {}}
}
global.vscodeStart = Date.now();
var app = require("electron").app, fs = require("fs"), path = require("path");
try {
    process.env.VSCODE_CWD && process.chdir(process.env.VSCODE_CWD)
} catch (err) {
}
if (process.env.VSCODE_DEV) {
    var appData = app.getPath("appData");
    app.setPath("userData", path.join(appData, "Code-Development"))
}
global.macOpenFiles = [], app.on("open-file", function (a, e) {
    global.macOpenFiles.push(e)
}), app.once("ready", function () {
    var BrowserWindow = require('electron').BrowserWindow;

    var win = new BrowserWindow({width: 465, height: 311, show: true, frame: false, title: "LayaAir"});
    win.on('closed', function () {
        win = null;
    });

    win.loadURL('file://'+path.join(__dirname, "vs", "layaEditor", "h5", "loading.html"));
    setTimeout(function () {
        win.destroy()
        var a = getNLSConfiguration();
        //fs.writeFileSync("c:/aa.txt",localeConfig+"Asdasd")
        //console.log(process.argv[1]+"==================================")
        process.env.VSCODE_NLS_CONFIG = JSON.stringify(a), require("./bootstrap-amd").bootstrap("vs/workbench/electron-main/main")
    }, 2000)

});
var layaDebugerWin;
var ipcMain = require('electron').ipcMain;
var globalShortcut = require('electron').globalShortcut
ipcMain.on('layaDebugerWinMessage', function (e, player,index) {
    if (!layaDebugerWin) {
        var BrowserWindow = require('electron').BrowserWindow;
        layaDebugerWin = new BrowserWindow({width: player.playerW, height: player.playerH, show: true, frame: true, title: "LayaAir"});
        layaDebugerWin.on('closed', function () {
            layaDebugerWin = null;
            //globalShortcut.unregisterAll();
        });
        layaDebugerWin.webContents.on('did-finish-load',function(){
            layaDebugerWin.webContents.executeJavaScript('var electron = require("electron");var remote = electron.remote;document.onkeydown = function (oEvent) { if(oEvent.keyCode == 116){location.reload()}else if(oEvent.keyCode == 123){remote.getCurrentWindow().webContents.toggleDevTools()}}')
        })

        //globalShortcut.register('F5', function() {
        //    layaDebugerWin.reload();
        //});
        initMenu();
    }
        layaDebugerWin.loadURL('file://'+index);
        layaDebugerWin.show();
});
function initMenu() {
    const Menu = require('electron').Menu;
    const MenuItem = require('electron').MenuItem;
    var template = [
        {
            label: '视图',
            submenu: [
                {
                    label: '重新加载(F5)',
                    click: function (item, focusedWindow) {
                        layaDebugerWin.reload();
                    }
                },
                {
                    label: '打开开发者工具(F12)',
                    accelerator: (function () {
                        return 'F12';
                    })(),
                    click: function (item, focusedWindow) {
                        if(layaDebugerWin)layaDebugerWin.webContents.toggleDevTools();
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
    var menu = Menu.buildFromTemplate(template);
    Menu.setApplicationMenu(menu);
}
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/fa6d0f03813dfb9df4589c30121e9fcffa8a8ec8/main.js.map
ipcMain.on('layaMessageCreatePro', function(e,type,layaZipPath,proNameInput,proNameOutput){
        layacopyDirFile(layaZipPath, proNameOutput);
        var layafile = fs.readFileSync(layaZipPath + path.sep + "myLaya.laya", "utf-8")
        fs.unlinkSync(proNameOutput + path.sep + "myLaya.laya");
        fs.writeFileSync(proNameOutput + path.sep + proNameInput + ".laya", layafile);
        if(type==0)
        {
            var fb = fs.readFileSync(layaZipPath + path.sep + ".project", "utf-8");
            fs.writeFileSync(proNameOutput + path.sep + ".project", fb.replace("GameMain", proNameInput))
            fs.renameSync(proNameOutput + path.sep + "LayaUISample.as3proj", proNameOutput + path.sep + proNameInput + ".as3proj")
        }

});
////----------------------------------------------------------------
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
//-----------------------------------------------------------------------------------------