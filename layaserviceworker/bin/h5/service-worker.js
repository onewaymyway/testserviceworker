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
function getCacheUrl(tPath)
{
  
}
self.addEventListener('install',
  function (event) {
    console.log("install");
    //event.waitUntil(

    //);
  });

self.addEventListener('activate', function (event) {
  console.log('activate:');
  event.waitUntil(
    fetch("./fileconfig.json").then(
      function (response) {
        return response.json();
      }
    ).then(
      function (data) {
        console.log(data);
        self.verdata = data;
      }).catch(
      function (e) {
        console.log("Oops, error");
      })
  );
});

self.addEventListener('fetch', function (event) {
  console.log('Handling fetch event for', event.request.url);

  tPurePath = getPureRelativePath(event.request.url);
  if (self.verdata&&self.verdata[tPurePath]) {
    
    tPromise = caches.open(CACHE_SIGN).then(function (cache) {
      adptPath = getAdptPath(event.request.url)
      adptPath+="?ver="+self.verdata[tPurePath];
      adptRequest = new Request(adptPath);
      adptRequest.method = event.request.method;
      console.log("cache match:",adptRequest.url);

      return cache.match(adptRequest).then(function (response) {
        if (response ) {
          //&& self.verdata[tPurePath] == getPreCacheVer(tPurePath)

          console.log(' Found response in cache and ver same:', response.url);

          return response;
        }

        console.log(' No response for %s found in cache. About to fetch ' +
          'from network...', adptRequest.url,event.request.url);

        return fetch(adptRequest.clone()).then(function (response) {
          console.log('  Response for %s from network is: %O',
            adptRequest.url, response,response.url);

          if (response.status < 400) {
            console.log('  Caching the response to', event.request.url,adptRequest.url,response.url);
            var tResPath = tPurePath;
            console.log("resPath:", tPurePath);
            if (self.verdata && self.verdata[tPurePath]) {
              console.log("cache resPath:", tPurePath);
              var cacheResponse= response.clone();
             //cacheResponse.ver=self.verdata[tPurePath];
              //cacheResponse.headers.set("fileVer",self.verdata[tPurePath]);
              cache.put(adptRequest.clone(), cacheResponse);
              console.log("cache:",adptRequest.url,cacheResponse.url)
              //updateCacheVer(tPurePath, self.verdata[tPurePath])
            } else {
              console.log("not cache for not in verdata resPath:", tResPath,response.url);
            }

          } else {
            console.log('  Not caching the response to', adptRequest.url,response.url);
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
