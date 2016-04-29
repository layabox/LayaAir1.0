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
//var unzip			= require('unzip');
//
var  ipcMain = require('electron').ipcMain;
ipcMain.on("vscode:layaZipPath",function(e,from,to){
    layacopyDirFile(from, to)
})
function layacopyDirFile(from, to) {
    var fs = require('fs'),
        stat = fs.stat;
    var copy = function (src, dst) {
        // 读取目录中的所有文件/目录
        fs.readdir(src, function (err, paths) {
            if (err) {
                throw err;
            }
            paths.forEach(function (pathLaya) {
                var _src = src + path.sep + pathLaya,
                    _dst = dst + path.sep + pathLaya,
                    readable, writable;
                stat(_src, function (err, st) {
                    if (err) {
                        throw err;
                    }
                    // 判断是否为文件
                    if (st.isFile()) {
                        // 创建读取流
                        readable = fs.createReadStream(_src);
                        // 创建写入流
                        writable = fs.createWriteStream(_dst);
                        // 通过管道来传输流
                        readable.pipe(writable);
                    }
                    // 如果是目录则递归调用自身
                    else if (st.isDirectory()) {
                        exists(_src, _dst, copy);
                    }
                });
            });
        });
    };
// 在复制目录前需要判断该目录是否存在，不存在需要先创建目录
    var exists = function (src, dst, callback) {
        mkdirsSyncLaya(dst);
        callback(src, dst);
    };
// 复制目录
    exists(from, to, copy);
}
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
    var  BrowserWindow = require('electron').BrowserWindow;

    var win = new BrowserWindow({ width: 465, height: 311, show: true,frame:false,title:"LayaAir"});
    win.on('closed', function() {
        win = null;
    });
  console.log(__dirname+"==================================")
    win.loadURL(path.join(__dirname,"vs","layaEditor","h5","loading.html"));
    setTimeout(function(){
        win.destroy()
        var a = getNLSConfiguration();
        process.env.VSCODE_NLS_CONFIG = JSON.stringify(a), require("./bootstrap-amd").bootstrap("vs/workbench/electron-main/main")
    },2000)

});
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/fa6d0f03813dfb9df4589c30121e9fcffa8a8ec8/main.js.map
