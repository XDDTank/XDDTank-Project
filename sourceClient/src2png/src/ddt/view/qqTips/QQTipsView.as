// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.qqTips.QQTipsView

package ddt.view.qqTips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.text.TextField;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import ddt.manager.QQtipsManager;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.KeyboardEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.DisplayUtils;
    import flash.ui.Keyboard;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import ddt.manager.PathManager;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import flash.events.IOErrorEvent;
    import calendar.CalendarManager;
    import ddt.manager.DesktopManager;
    import flash.external.ExternalInterface;
    import flash.net.navigateToURL;
    import com.pickgliss.ui.LayerManager;

    public class QQTipsView extends Sprite implements Disposeable 
    {

        private var _qqInfo:QQTipsInfo;
        private var _bg:Bitmap;
        private var _closeBtn:BaseButton;
        private var _titleTxt:FilterFrameText;
        private var _outUrlTxt:TextField;
        protected var _moveRect:Sprite;

        public function QQTipsView()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.core.QQtipsBG");
            this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("coreIconQQ.closebt");
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("coreIconQQ.titleTxt");
            this._outUrlTxt = ComponentFactory.Instance.creatCustomObject("coreIconQQ.QQOutUrlTxt");
            this._outUrlTxt.defaultTextFormat = ComponentFactory.Instance.model.getSet("coreIconQQ.qq.outTF");
            this._moveRect = new Sprite();
            addChild(this._bg);
            addChild(this._closeBtn);
            addChild(this._titleTxt);
            addChild(this._outUrlTxt);
            addChild(this._moveRect);
        }

        private function initEvents():void
        {
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.__colseClick);
            this._outUrlTxt.addEventListener(TextEvent.LINK, this.__onTextClicked);
            this._moveRect.addEventListener(MouseEvent.MOUSE_DOWN, this.__onFrameMoveStart);
            QQtipsManager.instance.addEventListener(QQtipsManager.COLSE_QQ_TIPSVIEW, this.__CloseView);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
        }

        private function remvoeEvents():void
        {
            if (this._closeBtn)
            {
                this._closeBtn.removeEventListener(MouseEvent.CLICK, this.__colseClick);
            };
            if (this._outUrlTxt)
            {
                this._outUrlTxt.removeEventListener(TextEvent.LINK, this.__onTextClicked);
            };
            if (this._moveRect)
            {
                this._moveRect.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onFrameMoveStart);
            };
            QQtipsManager.instance.removeEventListener(QQtipsManager.COLSE_QQ_TIPSVIEW, this.__CloseView);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
        }

        private function __colseClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ObjectUtils.disposeObject(this);
        }

        private function __CloseView(_arg_1:Event):void
        {
            ObjectUtils.disposeObject(this);
        }

        private function __onKeyDown(_arg_1:KeyboardEvent):void
        {
            var _local_2:DisplayObject = (StageReferance.stage.focus as DisplayObject);
            if (DisplayUtils.isTargetOrContain(_local_2, this))
            {
                if (_arg_1.keyCode == Keyboard.ESCAPE)
                {
                    SoundManager.instance.play("008");
                    ObjectUtils.disposeObject(this);
                };
            };
        }

        protected function __onFrameMoveStart(_arg_1:MouseEvent):void
        {
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.__onMoveWindow);
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP, this.__onFrameMoveStop);
            startDrag();
        }

        protected function __onFrameMoveStop(_arg_1:MouseEvent):void
        {
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onFrameMoveStop);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__onMoveWindow);
            stopDrag();
        }

        protected function __onMoveWindow(_arg_1:MouseEvent):void
        {
            if (DisplayUtils.isInTheStage(new Point(_arg_1.localX, _arg_1.localY), this))
            {
                _arg_1.updateAfterEvent();
            }
            else
            {
                this.__onFrameMoveStop(null);
            };
        }

        public function set qqInfo(_arg_1:QQTipsInfo):void
        {
            this._qqInfo = _arg_1;
            this._titleTxt.text = this._qqInfo.title;
            var _local_2:String = ((((('<a href="event:' + "clicktype:") + this._qqInfo.outInType) + '">') + this._qqInfo.content) + "</a>");
            this._outUrlTxt.htmlText = _local_2;
        }

        private function __onTextClicked(_arg_1:TextEvent):void
        {
            var _local_2:URLRequest = new URLRequest(PathManager.solveRequestPath("LogClickTip.ashx"));
            var _local_3:URLVariables = new URLVariables();
            _local_3["title"] = this.qqInfo.title;
            _local_2.data = _local_3;
            var _local_4:URLLoader = new URLLoader(_local_2);
            _local_4.load(_local_2);
            _local_4.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            if (this.qqInfo.outInType == 0)
            {
                this.__playINmoudle();
            }
            else
            {
                SoundManager.instance.play("008");
                this.gotoPage(this.qqInfo.url);
            };
            ObjectUtils.disposeObject(this);
        }

        private function onIOError(_arg_1:IOErrorEvent):void
        {
        }

        private function __playINmoudle():void
        {
            if (this.qqInfo.outInType == 0)
            {
                if (this.qqInfo.moduleType == QQTipsInfo.MODULE_CALENDAR)
                {
                    CalendarManager.getInstance().qqOpen(this.qqInfo.inItemID);
                }
                else
                {
                    if (this.qqInfo.moduleType == QQTipsInfo.MODULE_SHOP)
                    {
                        QQtipsManager.instance.gotoShop(this.qqInfo.inItemID);
                    };
                };
            };
        }

        private function gotoPage(_arg_1:String):void
        {
            var _local_2:String;
            if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
            {
                _local_2 = (('function redict () {window.open("' + _arg_1) + '", "_blank")}');
                ExternalInterface.call(_local_2);
            }
            else
            {
                navigateToURL(new URLRequest(encodeURI(_arg_1)), "_blank");
            };
        }

        public function get qqInfo():QQTipsInfo
        {
            return (this._qqInfo);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, false);
            StageReferance.stage.focus = this;
        }

        public function set moveRect(_arg_1:String):void
        {
            var _local_2:Array = _arg_1.split(",");
            this._moveRect.graphics.clear();
            this._moveRect.graphics.beginFill(0, 0);
            this._moveRect.graphics.drawRect(_local_2[0], _local_2[1], _local_2[2], _local_2[3]);
            this._moveRect.graphics.endFill();
        }

        public function dispose():void
        {
            this.remvoeEvents();
            this._qqInfo = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._closeBtn)
            {
                ObjectUtils.disposeObject(this._closeBtn);
            };
            this._closeBtn = null;
            if (this._titleTxt)
            {
                ObjectUtils.disposeObject(this._titleTxt);
            };
            this._titleTxt = null;
            if (this._outUrlTxt)
            {
                ObjectUtils.disposeObject(this._outUrlTxt);
            };
            this._outUrlTxt = null;
            if (this._moveRect)
            {
                ObjectUtils.disposeObject(this._moveRect);
            };
            this._moveRect = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            QQtipsManager.instance.isShowTipNow = false;
        }


    }
}//package ddt.view.qqTips

