/**
 * Copyright 2015 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

'use strict';

let log = self.console.log.bind(self.console);

class ImageHandler {

  constructor (workerContext) {
    this.queue = [];
    this.workerContext = workerContext;
  }

  enqueue (toEnqueue) {

    // Bail if this URL is already enqueued.
    if (this.queue.indexOf(toEnqueue) >= 0)
      return;

    this.queue.push(toEnqueue);
    this.processQueue();
  }

  processQueue () {

    if (this.queue.length === 0)
      return;

    let url = this.queue.shift();

    // Fetch the image.
    return fetch(url+"?Version=ss344s")
        .then(function(response) {
          

          return response.blob()
        })
        .then(function(blobData)
		{ 
			return createImageBitmap(blobData);
			}
		)
        .then((imageBitmap) => {
          this.workerContext.postMessage({
            url: url,
            imageBitmap: imageBitmap,
			"aa":"cc"
          }, [imageBitmap]);
        }, function (err) {

        })
        .then(() => this.processQueue())
        .catch(() => this.processQueue())
  }
  newFetch(url)
  {
	  return 1;
  }
}

let handler = new ImageHandler(self);

self.onmessage = (evt) => handler.enqueue(evt.data);
