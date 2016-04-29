/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var url_1 = require('url');
var proxy_1 = require('./proxy');
var https = require('https');
var http = require('http');
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
var proxyUrl = null;
var strictSSL = true;
function assign(destination) {
    var sources = [];
    for (var _i = 1; _i < arguments.length; _i++) {
        sources[_i - 1] = arguments[_i];
    }
    sources.forEach(function (source) { return Object.keys(source).forEach(function (key) { return destination[key] = source[key]; }); });
    return destination;
}
function configure(_proxyUrl, _strictSSL) {
    proxyUrl = _proxyUrl;
    strictSSL = _strictSSL;
}
exports.configure = configure;
function xhr(options) {
    var agent = proxy_1.getProxyAgent(options.url, { proxyUrl: proxyUrl, strictSSL: strictSSL });
    options = assign({}, options);
    options = assign(options, { agent: agent, strictSSL: strictSSL });
    if (typeof options.followRedirects !== 'number') {
        options.followRedirects = 5;
    }
    return request(options).then(function (result) { return new Promise(function (c, e) {
        var res = result.res;
        var data = [];
        res.on('data', function (c) { return data.push(c); });
        res.on('end', function () {
            if (options.followRedirects > 0 && (res.statusCode >= 300 && res.statusCode <= 303 || res.statusCode === 307)) {
                var location = res.headers['location'];
                if (location) {
                    var newOptions = {
                        type: options.type, url: location, user: options.user, password: options.password, responseType: options.responseType, headers: options.headers,
                        timeout: options.timeout, followRedirects: options.followRedirects - 1, data: options.data
                    };
                    xhr(newOptions).then(c, e);
                    return;
                }
            }
            var response = {
                responseText: data.join(''),
                status: res.statusCode
            };
            if ((res.statusCode >= 200 && res.statusCode < 300) || res.statusCode === 1223) {
                c(response);
            }
            else {
                e(response);
            }
        });
    }); }, function (err) {
        var message;
        if (agent) {
            message = 'Unable to to connect to ' + options.url + ' through a proxy . Error: ' + err.message;
        }
        else {
            message = 'Unable to to connect to ' + options.url + '. Error: ' + err.message;
        }
        return Promise.reject({
            responseText: message,
            status: 404
        });
    });
}
exports.xhr = xhr;
function request(options) {
    var req;
    return new Promise(function (c, e) {
        var endpoint = url_1.parse(options.url);
        var opts = {
            hostname: endpoint.hostname,
            port: endpoint.port ? parseInt(endpoint.port) : (endpoint.protocol === 'https:' ? 443 : 80),
            path: endpoint.path,
            method: options.type || 'GET',
            headers: options.headers,
            agent: options.agent,
            rejectUnauthorized: (typeof options.strictSSL === 'boolean') ? options.strictSSL : true
        };
        if (options.user && options.password) {
            opts.auth = options.user + ':' + options.password;
        }
        var protocol = endpoint.protocol === 'https:' ? https : http;
        req = protocol.request(opts, function (res) {
            if (res.statusCode >= 300 && res.statusCode < 400 && options.followRedirects && options.followRedirects > 0 && res.headers['location']) {
                c(request(assign({}, options, {
                    url: res.headers['location'],
                    followRedirects: options.followRedirects - 1
                })));
            }
            else {
                c({ req: req, res: res });
            }
        });
        req.on('error', e);
        if (options.timeout) {
            req.setTimeout(options.timeout);
        }
        if (options.data) {
            req.write(options.data);
        }
        req.end();
    });
}
function getErrorStatusDescription(status) {
    if (status < 400) {
        return void 0;
    }
    switch (status) {
        case 400: return localize(0, null);
        case 401: return localize(1, null);
        case 403: return localize(2, null);
        case 404: return localize(3, null);
        case 405: return localize(4, null);
        case 406: return localize(5, null);
        case 407: return localize(6, null);
        case 408: return localize(7, null);
        case 409: return localize(8, null);
        case 410: return localize(9, null);
        case 411: return localize(10, null);
        case 412: return localize(11, null);
        case 413: return localize(12, null);
        case 414: return localize(13, null);
        case 415: return localize(14, null);
        case 500: return localize(15, null);
        case 501: return localize(16, null);
        case 503: return localize(17, null);
        default: return localize(18, null, status);
    }
}
exports.getErrorStatusDescription = getErrorStatusDescription;
//# sourceMappingURL=httpRequest.js.map