// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.buff.buffButton.BuffButton

package ddt.view.buff.buffButton
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import ddt.data.BuffInfo;
    import ddt.view.tips.BuffTipInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ShowTipManager;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import ddt.manager.ShopManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.TimeManager;
    import flash.display.DisplayObject;

    public class BuffButton extends Sprite implements Disposeable, ITipedDisplay 
    {

        protected static var Setting:Boolean = false;

        protected var _info:BuffInfo;
        private var _canClick:Boolean;
        protected var _tipStyle:String;
        protected var _tipData:BuffTipInfo;
        protected var _tipDirctions:String;
        protected var _tipGapV:int;
        protected var _tipGapH:int;

        public function BuffButton(_arg_1:String)
        {
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap(_arg_1);
            _local_2.width = (_local_2.height = 24);
            addChild(_local_2);
            this._canClick = true;
            buttonMode = this._canClick;
            this._tipStyle = "core.buffTip";
            this._tipGapV = 2;
            this._tipGapH = 2;
            this._tipDirctions = "7,6,5,1,6,4";
            ShowTipManager.Instance.addTip(this);
            this.initEvents();
        }

        public static function createBuffButton(_arg_1:int, _arg_2:String=""):BuffButton
        {
            var _local_3:BuffButton;
            var _local_4:BuffButton;
            var _local_5:BuffButton;
            switch (_arg_1)
            {
                case 1:
                    return (new DoubExpBuffButton());
                case 2:
                    return (new DoubGesteBuffButton());
                case 3:
                    return (new PreventKickBuffButton());
                case 4:
                    return (new PayBuffButton(_arg_2));
            };
            return (null);
        }


        private function initEvents():void
        {
            addEventListener(MouseEvent.CLICK, this.__onclick);
            addEventListener(MouseEvent.MOUSE_OVER, this.__onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__onMouseOut);
        }

        protected function __onclick(_arg_1:MouseEvent):void
        {
            if ((!(this.CanClick)))
            {
                return;
            };
            SoundManager.instance.play("008");
        }

        protected function __onMouseOver(_arg_1:MouseEvent):void
        {
            if (((this._info) && (this._info.IsExist)))
            {
                filters = ComponentFactory.Instance.creatFilters("lightFilter");
            };
        }

        protected function __onMouseOut(_arg_1:MouseEvent):void
        {
            if (((this._info) && (this._info.IsExist)))
            {
                filters = null;
            };
        }

        protected function checkBagLocked():Boolean
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return (false);
            };
            return (true);
        }

        protected function buyBuff():void
        {
            SocketManager.Instance.out.sendUseCard(-1, -1, [ShopManager.Instance.getMoneyShopItemByTemplateID(this._info.buffItemInfo.TemplateID).GoodsID], 1);
        }

        protected function createTipRender():Sprite
        {
            return (new Sprite());
        }

        public function setSize(_arg_1:Number, _arg_2:Number):void
        {
        }

        private function updateView():void
        {
            if (((!(this._info == null)) && (this._info.IsExist)))
            {
                filters = null;
            }
            else
            {
                filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        public function set CanClick(_arg_1:Boolean):void
        {
            this._canClick = _arg_1;
            buttonMode = this._canClick;
        }

        public function get CanClick():Boolean
        {
            return (this._canClick);
        }

        public function set info(_arg_1:BuffInfo):void
        {
            this._info = _arg_1;
            this.updateView();
        }

        protected function __onBuyResponse(_arg_1:FrameEvent):void
        {
            Setting = false;
            SoundManager.instance.play("008");
            (_arg_1.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this.__onBuyResponse);
            (_arg_1.target as BaseAlerFrame).dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                this.buyBuff();
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._info = null;
            ShowTipManager.Instance.removeTip(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function get tipData():Object
        {
            this._tipData = new BuffTipInfo();
            if (this._info)
            {
                this._tipData.isActive = this._info.IsExist;
                this._tipData.describe = this._info.description;
                this._tipData.name = this._info.buffName;
                this._tipData.isFree = false;
                this._tipData.day = this._info.getLeftTimeByUnit(TimeManager.DAY_TICKS);
                this._tipData.hour = this._info.getLeftTimeByUnit(TimeManager.HOUR_TICKS);
                this._tipData.min = this._info.getLeftTimeByUnit(TimeManager.Minute_TICKS);
            };
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = (_arg_1 as BuffTipInfo);
        }

        public function get tipDirctions():String
        {
            return (this._tipDirctions);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDirctions = _arg_1;
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }


    }
}//package ddt.view.buff.buffButton

