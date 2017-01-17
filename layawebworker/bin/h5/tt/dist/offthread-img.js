/*!
 * Copyright 2016 Google Inc. All rights reserved.
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
!function t(e, i, n) {
  function r(s, h) {
    if (!i[s]) {
      if (!e[s]) {
        var u = 'function' == typeof require && require;
        if (!h && u) return u(s, !0);
        if (a) return a(s, !0);
        var o = new Error('Cannot find module \'' + s + '\'');
        throw o.code = 'MODULE_NOT_FOUND',
        o
      }
      var l = i[s] = {
        exports: {
        }
      };
      e[s][0].call(l.exports, function (t) {
        var i = e[s][1][t];
        return r(i ? i : t)
      }, l, l.exports, t, e, i, n)
    }
    return i[s].exports
  }
  for (var a = 'function' == typeof require && require, s = 0; s < n.length; s++) r(n[s]);
  return r
}({
  1: [
    function (t, e, i) {
      'use strict';
      function n(t) {
        return t && t.__esModule ? t : {
          'default': t
        }
      }
      var r = t('./offthread-img/offthread-img'),
      a = n(r);
      window.requestIdleCallback = window.requestIdleCallback || function (t) {
        var e = Date.now();
        return setTimeout(function () {
          t({
            didTimeout: !1,
            timeRemaining: function () {
              return Math.max(0, 50 - (Date.now() - e))
            }
          })
        }, 1)
      },
      window.cancelIdleCallback = window.cancelIdleCallback || function (t) {
        clearTimeout(t)
      },
      'undefined' == typeof window.OffthreadImage ? window.OffthreadImage = a['default'] : console.warn('OffthreadImage already exists')
    },
    {
      './offthread-img/offthread-img': 2
    }
  ],
  2: [
    function (t, e, i) {
      'use strict';
      function n(t, e) {
        if (!(t instanceof e)) throw new TypeError('Cannot call a class as a function')
      }
      var r = function () {
        function t(t, e) {
          for (var i = 0; i < e.length; i++) {
            var n = e[i];
            n.enumerable = n.enumerable || !1,
            n.configurable = !0,
            'value' in n && (n.writable = !0),
            Object.defineProperty(t, n.key, n)
          }
        }
        return function (e, i, n) {
          return i && t(e.prototype, i),
          n && t(e, n),
          e
        }
      }();
      Object.defineProperty(i, '__esModule', {
        value: !0
      });
      var a = function () {
        function t() {
          var e = arguments.length <= 0 || void 0 === arguments[0] ? null : arguments[0];
          if (n(this, t), null === e) throw new Error('OffthreadImage() requires a target element');
          this.id_ = Math.round(Math.random() * Number.MAX_SAFE_INTEGER).toString(16),
          this.canvas_ = null,
          this.ctx_ = null,
          this.element_ = e,
          this.onLoad_ = null,
          this.onDecode_ = null,
          this.status = t.STATUS.INERT,
          this.src_ = null,
          this.width_ = e.getAttribute('width'),
          this.height_ = e.getAttribute('height'),
          this.drawWidth_ = this.width_,
          this.drawHeight_ = this.height_,
          this.background_ = !1,
          e.getAttribute('src') ? this.src = e.getAttribute('src')  : e.getAttribute('bg-src') && (this.src = e.getAttribute('bg-src'), this.background_ = !0),
          e.getAttribute('alt') || e.getAttribute('aria-label') ? e.getAttribute('aria-label') || e.setAttribute('aria-label', e.getAttribute('alt'))  : console.warn('The element does have an alt or aria-label attribute.'),
          e.getAttribute('role') || e.setAttribute('role', 'img')
        }
        return r(t, null, [
          {
            key: 'createFromSelector',
            value: function () {
              for (var e = arguments.length <= 0 || void 0 === arguments[0] ? '.offthread-img' : arguments[0], i = [
              ], n = document.querySelectorAll(e), r = void 0, a = 0; a < n.length; a++) r = n[a],
              i.push(new t(r));
              return i
            }
          },
          {
            key: 'version',
            get: function () {
              return '0.1.0'
            }
          },
          {
            key: 'STATUS',
            get: function () {
              return {
                INERT: 'inert',
                LOAD_STARTED: 'loadstarted',
                LOADED: 'load',
                DECODED: 'decoded',
                PAINTED: 'painted'
              }
            }
          },
          {
            key: 'MIN_INSERT_IDLE_WINDOW',
            get: function () {
              return 10
            }
          },
          {
            key: 'available',
            get: function () {
              return 'createImageBitmap' in window
            }
          }
        ]),
        r(t, [
          {
            key: 'setCanvasDimensions_',
            value: function (t) {
              if (this.background_) {
                this.width_ = this.element_.offsetWidth,
                this.height_ = this.element_.offsetHeight,
                this.drawWidth_ = t.width,
                this.drawHeight_ = t.height;
                var e = window.getComputedStyle(this.element_).backgroundSize,
                i = 1;
                switch (e) {
                  case 'contain':
                    i = Math.min(this.width_ / this.drawWidth_, this.height_ / this.drawHeight_);
                    break;
                  case 'cover':
                    i = Math.max(this.width_ / this.drawWidth_, this.height_ / this.drawHeight_)
                }
                this.drawWidth_ *= i,
                this.drawHeight_ *= i
              } else null !== this.width_ && null === this.height_ ? this.height_ = this.width_ * (t.height / t.width)  : null === this.width_ && null !== this.height_ ? this.width_ = this.height_ * (t.width / t.height)  : null === this.width_ && null === this.height_ && (this.width_ = t.width, this.height_ = t.height),
              this.width_ = parseInt(this.width_),
              this.height_ = parseInt(this.height_),
              this.drawWidth_ = this.width_,
              this.drawHeight_ = this.height_;
              this.canvas_.width = this.width_,
              this.canvas_.height = this.height_
            }
          },
          {
            key: 'fire_',
            value: function (t) {
              var e = arguments.length <= 1 || void 0 === arguments[1] ? null : arguments[1],
              i = arguments.length <= 2 || void 0 === arguments[2] ? !0 : arguments[2],
              n = arguments.length <= 3 || void 0 === arguments[3] ? !0 : arguments[3],
              r = new CustomEvent(t, {
                detail: e,
                bubbles: i,
                cancelable: n
              });
              this.element_.dispatchEvent(r)
            }
          },
          {
            key: 'src',
            get: function () {
              return this.src_
            },
            set: function (e) {
              this.src_ = e,
              this.status_ = t.STATUS.LOAD_STARTED,
              h.enqueue(this)
            }
          },
          {
            key: 'status',
            set: function (e) {
              switch (e) {
                case t.STATUS.INERT:
                case t.STATUS.LOAD_STARTED:
                case t.STATUS.LOADED:
                case t.STATUS.DECODED:
                case t.STATUS.PAINTED:
                  this.fire_(e);
                  break;
                default:
                  throw new Error('Unknown status: ' + e)
              }
              this.status_ = e
            },
            get: function () {
              return this.status_
            }
          },
          {
            key: 'imageBitmap',
            set: function (e) {
              var i = this,
              n = function r(n) {
                return n.timeRemaining() < t.MIN_INSERT_IDLE_WINDOW ? requestIdleCallback(r)  : (null === i.canvas_ && (i.canvas_ = document.createElement('canvas'), i.canvas_.setAttribute('aria-hidden', 'true')), null === i.ctx_ && (i.ctx_ = i.canvas_.getContext('2d')), i.setCanvasDimensions_(e), i.ctx_.drawImage(e, 0, 0, i.drawWidth_, i.drawHeight_), i.element_.appendChild(i.canvas_), void (i.status = t.STATUS.PAINTED))
              };
              requestIdleCallback(n)
            },
            get: function () {
              return null
            }
          }
          ]),
          t
        }(); i['default'] = a; var s = function () {
          function t() {
            var e = this;
            n(this, t);
            var i = this.getDirectoryName_(this.convertURLToAbsolute_(document.currentScript.src));
            this.worker = new Worker(i + '/offthread-img-worker.js'),
            this.worker.onmessage = function (t) {
              return e.handleIncomingMessage_(t.data)
            },
            this.jobs = {
            }
          }
          return r(t, [
            {
              key: 'enqueue',
              value: function (t) {
                if (!(t instanceof a)) throw new Error('Enqueue expects an OffthreadImage');
                var e = this.convertURLToAbsolute_(t.src);
                'undefined' == typeof this.jobs[e] && (this.jobs[e] = [
                ]),
                this.jobs[e].push(t),
                this.worker.postMessage(e),
                t.status = a.STATUS.LOAD_STARTED
              }
            },
            {
              key: 'getDirectoryName_',
              value: function (t) {
                return t.replace(/[^\/]*$/, '')
              }
            },
            {
              key: 'convertURLToAbsolute_',
              value: function (t) {
                if ('string' != typeof t) throw new Error('convertURLToAbsolute_ expects a string');
                if (t.startsWith('http')) return t;
                var e = this.getDirectoryName_(window.location.href),
                i = new URL(e + t);
                return i.toString()
              }
            },
            {
              key: 'handleIncomingMessage_',
              value: function (t) {
                if (t.error) return console.warn(t.error);
                var e = t.url,
                i = this.jobs[e],
                n = void 0;
                if (t.load) for (var r = 0; r < i.length; r++) n = i[r],
                n.status = a.STATUS.LOADED;
                 else {
                  for (var s = t.imageBitmap, r = 0; r < i.length; r++) n = i[r],
                  n.status = a.STATUS.DECODED,
                  n.imageBitmap = s;
                  this.jobs[e].length = 0
                }
              }
            }
          ]),
          t
        }(), h = new s
      },
      {
      }
      ]
    },
    {
    },
    [
      1
    ]);
