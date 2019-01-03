import { eventMixin } from './js/scroll/event'
import { initMixin } from './js/scroll/init'
import { coreMixin } from './js/scroll/core'
import { snapMixin } from './js/scroll/snap'
import { wheelMixin } from './js/scroll/wheel'
import { scrollbarMixin } from './js/scroll/scrollbar'
import { pullDownMixin } from './js/scroll/pulldown'
import { pullUpMixin } from './js/scroll/pullup'
import { mouseWheelMixin } from './js/scroll/mouse-wheel'
import { zoomMixin } from './js/scroll/zoom'
import { infiniteMixin } from './js/scroll/inifinity'

import { warn } from './js/util/debug'

function BScroll(el, options) {
  this.wrapper = typeof el === 'string' ? document.querySelector(el) : el
  if (!this.wrapper) {
    warn('Can not resolve the wrapper DOM.')
  }
  this.scroller = this.wrapper.children[0]
  if (!this.scroller) {
    warn('The wrapper need at least one child element to be scroller.')
  }
  // cache style for better performance
  this.scrollerStyle = this.scroller.style

  this._init(el, options)
}

initMixin(BScroll)
coreMixin(BScroll)
eventMixin(BScroll)
snapMixin(BScroll)
wheelMixin(BScroll)
scrollbarMixin(BScroll)
pullDownMixin(BScroll)
pullUpMixin(BScroll)
mouseWheelMixin(BScroll)
zoomMixin(BScroll)
infiniteMixin(BScroll)

BScroll.Version = '1.13.2'

export default BScroll
