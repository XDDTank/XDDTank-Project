// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.controls.PageSelector

package ddt.view.controls
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class PageSelector extends Component 
    {

        private var _bg:ScaleLeftRightImage;
        private var _firstBtn:BaseButton;
        private var _previousBtn:BaseButton;
        private var _nextBtn:BaseButton;
        private var _lastBtn:BaseButton;
        private var _pageBg:ScaleLeftRightImage;
        private var _pageText:FilterFrameText;
        private var _page:int = 1;
        private var _maxPage:int;

        public function PageSelector()
        {
            this.initEvent();
        }

        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddt.view.controls.pageSelector.Bg");
            this._firstBtn = ComponentFactory.Instance.creat("ddt.view.controls.pageSelector.firstBtn");
            this._previousBtn = ComponentFactory.Instance.creat("ddt.view.controls.pageSelector.previousBtn");
            this._nextBtn = ComponentFactory.Instance.creat("ddt.view.controls.pageSelector.nextBtn");
            this._lastBtn = ComponentFactory.Instance.creat("ddt.view.controls.pageSelector.lastBtn");
            this._pageText = ComponentFactory.Instance.creatComponentByStylename("ddt.view.controls.pageSelector.pageTxt");
            this._pageBg = ComponentFactory.Instance.creatComponentByStylename("ddt.view.controls.pageSelector.PageBg");
            super.init();
        }

        private function initEvent():void
        {
            this._firstBtn.addEventListener(MouseEvent.CLICK, this.__click);
            this._previousBtn.addEventListener(MouseEvent.CLICK, this.__click);
            this._nextBtn.addEventListener(MouseEvent.CLICK, this.__click);
            this._lastBtn.addEventListener(MouseEvent.CLICK, this.__click);
        }

        private function removeEvent():void
        {
            this._firstBtn.removeEventListener(MouseEvent.CLICK, this.__click);
            this._previousBtn.removeEventListener(MouseEvent.CLICK, this.__click);
            this._nextBtn.removeEventListener(MouseEvent.CLICK, this.__click);
            this._lastBtn.removeEventListener(MouseEvent.CLICK, this.__click);
        }

        protected function __click(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            switch (_arg_1.target)
            {
                case this._firstBtn:
                    this.page = 1;
                    return;
                case this._previousBtn:
                    this.page--;
                    return;
                case this._nextBtn:
                    this.page++;
                    return;
                case this._lastBtn:
                    this.page = this._maxPage;
                    return;
            };
        }

        override protected function addChildren():void
        {
            addChild(this._bg);
            addChild(this._firstBtn);
            addChild(this._previousBtn);
            addChild(this._pageBg);
            addChild(this._pageText);
            addChild(this._nextBtn);
            addChild(this._lastBtn);
        }

        public function get page():int
        {
            return (this._page);
        }

        public function set page(_arg_1:int):void
        {
            if (this._page < 1)
            {
                this._page = 1;
            };
            if (this._page > this._maxPage)
            {
                this._page = this._maxPage;
            };
            this._page = _arg_1;
            this._firstBtn.enable = (this._previousBtn.enable = (this._page > 1));
            this._nextBtn.enable = (this._lastBtn.enable = (this._page < this._maxPage));
            this._pageText.text = [this._page, this._maxPage].join("/");
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function get maxPage():int
        {
            return (this._maxPage);
        }

        public function set maxPage(_arg_1:int):void
        {
            this._maxPage = _arg_1;
            this.page = this._page;
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._firstBtn);
            this._firstBtn = null;
            ObjectUtils.disposeObject(this._previousBtn);
            this._previousBtn = null;
            ObjectUtils.disposeObject(this._nextBtn);
            this._nextBtn = null;
            ObjectUtils.disposeObject(this._lastBtn);
            this._lastBtn = null;
            ObjectUtils.disposeObject(this._pageBg);
            this._pageBg = null;
            ObjectUtils.disposeObject(this._pageText);
            this._pageText = null;
        }


    }
}//package ddt.view.controls

