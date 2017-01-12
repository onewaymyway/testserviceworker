/*
 Copyright 2014 Google Inc. All Rights Reserved.
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

// While overkill for this specific sample in which there is only one cache,
// this is one best practice that can be followed in general to keep track of
// multiple caches used by a given service worker, and keep them all versioned.
// It maps a shorthand identifier for a cache to a specific, versioned cache name.

// Note that since global state is discarded in between service worker restarts, these
// variables will be reinitialized each time the service worker handles an event, and you
// should not attempt to change their values inside an event handler. (Treat them as constants.)

// If at any point you want to force pages that use this service worker to start using a fresh
// cache, then increment the CACHE_VERSION value. It will kick off the service worker update
// flow and the old cache(s) will be purged as part of the activate event handler when the
// updated service worker is activated.
var CACHE_VERSION = 1;

var myPath = "service-worker.js";
var urlBasePath = location.href.replace(myPath, "");
var CACHE_SIGN = "layaairtest";
function getRelativePath(tPath) {
  return tPath.replace(urlBasePath, "");
}
function getPreCacheVer(file) {
  return localStorage[file];
}
function updateCacheVer(file, ver) {
  localStorage[file] = ver;
}
function getPureRelativePath(tPath) {
  tPath = getRelativePath(tPath)
  if (tPath.indexOf("?") >= 0) {
    tPath = tPath.split("?")[0];
  }
  return tPath;
}
function getAdptPath(tPath) {
  if (tPath.indexOf("?") >= 0) {
    tPath = tPath.split("?")[0];
  }
  return tPath;
}

function getAdptRequest(preRequest) {
  tPurePath = getPureRelativePath(preRequest.url);
  adptPath = getAdptPath(preRequest.url)
  adptPath += "?ver=" + self.verdata[tPurePath];
  adptRequest = new Request(adptPath);
  return adptRequest;
}
function getUrlVer(tPath) {
  if (tPath.indexOf("?ver=") > 0) {
    var tStr = tPath.split("?ver=")[1];
    return tStr;

  }
  return "";
}
self.addEventListener('install',
  function (event) {
    console.log("install");
    //event.waitUntil(

    //);
  });

function reloadConfigAndClearPre() {
  return fetch("./fileconfig.json").then(
    function (response) {
      return response.json();
    }
  ).then(
    function (data) {
      console.log("load fileConfig success:", data);
      self.verdata = data;
      return data;
    }).then(
    function () {
      return caches.open(CACHE_SIGN).then(
        function (cache) {
          cache.keys().then(function (cacheNames) {
            return Promise.all(
              cacheNames.map(function (tRequest) {
                var cacheName = tRequest.url;
                console.log("work with:", cacheName);
                if (cacheName.indexOf("?") > 0) {
                  tPureName = getPureRelativePath(cacheName);
                  tVer = getUrlVer(cacheName);
                  if (self.verdata[tPureName] && self.verdata[tPureName] == tVer) {
                    console.log('cache is ok:', cacheName);
                  } else {
                    console.log('cache is old:', cacheName);
                    return cache.delete(tRequest);
                  }
                }
              })
            );
          })
        }
      )

    }
    ).catch(
    function (e) {
      console.log("Oops, error");
    })
}
self.addEventListener('activate', function (event) {
  console.log('activate:');
  event.waitUntil(
    reloadConfigAndClearPre()
  );
});

self.addEventListener('fetch', function (event) {
  //console.log('Handling fetch event for', event.request.url);

  var tPurePath = getPureRelativePath(event.request.url);
  if (self.verdata && self.verdata[tPurePath]) {

    tPromise = caches.open(CACHE_SIGN).then(function (cache) {


      return cache.match(getAdptRequest(event.request)).then(function (response) {
        if (response) {
          //&& self.verdata[tPurePath] == getPreCacheVer(tPurePath)

          console.log(' Found response in cache and ver same:', response.url);

          return response;
        }

        // console.log(' No response for %s found in cache. About to fetch from network...', event.request.url);

        return fetch(getAdptRequest(event.request)).then(function (response) {
          // console.log('  Response for %s from network is: %O', response,response.url);
          adptRequest = getAdptRequest(event.request);

          if (response.status < 400) {

            tPurePath = getPureRelativePath(response.url);
            if (self.verdata && self.verdata[tPurePath]) {
              console.log('  Caching the response to', event.request.url, response.url);
              var cacheResponse = response.clone();
              cache.put(adptRequest.clone(), cacheResponse);
            } else {
              console.log("not cache for not in verdata resPath:", tResPath, response.url);
            }

          } else {
            console.log('  Not caching the response to', adptRequest.url, response.url);
          }
          return response;
        });
      }).catch(function (error) {
        console.error('  Error in fetch handler:', error);

        throw error;
      });
    })


  } else {

    tPromise = fetch(event.request.clone()).then(function (response) {
      return response;
    }).catch(function (error) {
      console.error('  Error in fetch handler:', error);
      throw error;
    });
  }
  event.respondWith(
    tPromise
  );
});


self.addEventListener('message', function (event) {
  console.log('Handling message event:', event);
  if (event.data) {
    switch (event.data.cmd) {
      case "reloadConfig":
        reloadConfigAndClearPre();
        break;
    }
  }
});