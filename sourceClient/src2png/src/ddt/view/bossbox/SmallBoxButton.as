// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.SmallBoxButton

package ddt.view.bossbox
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MovieImage;
    import flash.display.MovieClip;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import ddt.view.tips.GoodTip;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import ddt.manager.LanguageMgr;
    import ddt.manager.BossBoxManager;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.TimeManager;
    import ddt.view.tips.GoodTipInfo;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class SmallBoxButton extends Sprite implements Disposeable 
    {

        public static const showTypeWait:int = 1;
        public static const showTypeCountDown:int = 2;
        public static const showTypeOpenbox:int = 3;
        public static const showTypeHide:int = 4;
        public static const HALL_POINT:int = 0;
        public static const PVR_ROOMLIST_POINT:int = 1;
        public static const PVP_ROOM_POINT:int = 2;
        public static const PVE_ROOMLIST_POINT:int = 3;
        public static const PVE_ROOM_POINT:int = 4;
        public static const HOTSPRING_ROOMLIST_POINT:int = 5;
        public static const HOTSPRING_ROOM_POINT:int = 6;

        private var _closeBox:MovieImage;
        private var _openBoxAsset:MovieClip;
        private var _openBox:Sprite;
        private var _delayText:Sprite;
        private var timeText:FilterFrameText;
        private var _timeSprite:TimeTip;
        private var _pointArray:Vector.<Point>;
        private var _boxGoodTip:GoodTip;

        public function SmallBoxButton(_arg_1:int)
        {
            this.init(_arg_1);
            this.initEvent();
        }

        private function init(_arg_1:int):void
        {
            this._getPoint();
            this._delayText = new Sprite();
            this._openBox = new Sprite();
            this._openBox.graphics.beginFill(0, 0);
            this._openBox.graphics.drawRect(-22, -2, 115, 70);
            this._openBox.graphics.endFill();
            this._closeBox = ComponentFactory.Instance.creat("bossbox.closeBox");
            this._openBoxAsset = ComponentFactory.Instance.creat("asset.timeBox.BGRotationAsset");
            this._openBoxAsset.x = -38;
            this._openBoxAsset.y = -40;
            this._openBoxAsset.mouseChildren = false;
            this._openBoxAsset.mouseEnabled = false;
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap("asset.timeBox.timeBGAsset");
            this.timeText = ComponentFactory.Instance.creat("bossbox.TimeBoxStyle");
            this._delayText.addChild(_local_2);
            this._delayText.addChild(this.timeText);
            this._timeSprite = ComponentFactory.Instance.creat("TimeBox.TimeTip");
            this._timeSprite.tipData = LanguageMgr.GetTranslation("tanl.timebox.tipMes");
            this._timeSprite.setView(this._closeBox, this._delayText);
            this._timeSprite.buttonMode = true;
            addChild(this._timeSprite);
            this._openBox.addChild(this._openBoxAsset);
            addChild(this._openBox);
            addChild(this._delayText);
            this._boxGoodTip = new GoodTip();
            this.showType(BossBoxManager.instance.boxButtonShowType);
            this.updateTime(BossBoxManager.instance.delaySumTime);
            x = this._pointArray[_arg_1].x;
            y = this._pointArray[_arg_1].y;
        }

        private function _getPoint():void
        {
            var _local_2:Point;
            this._pointArray = new Vector.<Point>();
            var _local_1:int;
            while (_local_1 < 7)
            {
                _local_2 = ComponentFactory.Instance.creatCustomObject(("smallBoxbutton.point" + _local_1));
                this._pointArray.push(_local_2);
                _local_1++;
            };
        }

        private function initEvent():void
        {
            this._openBox.buttonMode = true;
            this._openBox.addEventListener(MouseEvent.CLICK, this._click);
            this._openBox.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            this._openBox.addEventListener(MouseEvent.ROLL_OUT, this.__mouseOut);
            this._timeSprite.addEventListener(MouseEvent.CLICK, this._click);
            BossBoxManager.instance.addEventListener(TimeBoxEvent.UPDATESMALLBOXBUTTONSTATE, this._updateSmallBoxState);
            BossBoxManager.instance.addEventListener(TimeBoxEvent.UPDATETIMECOUNT, this._updateTimeCount);
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._boxGoodTip)
            {
                this._boxGoodTip.visible = true;
                LayerManager.Instance.addToLayer(this._boxGoodTip, LayerManager.GAME_TOP_LAYER);
                _local_2 = this._openBox.localToGlobal(new Point(0, 0));
                this._boxGoodTip.x = 114;
                this._boxGoodTip.y = 200;
            };
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            if (this._boxGoodTip)
            {
                this._boxGoodTip.visible = false;
            };
        }

        public function updateTime(_arg_1:int):void
        {
            var _local_2:int = _arg_1;
            this.timeText.text = TimeManager.Instance.formatTimeToString1((_local_2 * 1000));
        }

        public function showType(_arg_1:int):void
        {
            var _local_2:GoodTipInfo = new GoodTipInfo();
            var _local_3:ItemTemplateInfo = ItemManager.Instance.getTemplateById(BossBoxManager.instance.getBoxTemplateIDById());
            _local_2.itemInfo = _local_3;
            this._boxGoodTip.tipData = _local_2;
            switch (_arg_1)
            {
                case SmallBoxButton.showTypeWait:
                    this._openBox.visible = true;
                    this._openBoxAsset.gotoAndStop(1);
                    this._timeSprite.delayText.visible = true;
                    this._boxGoodTip.visible = false;
                    return;
                case SmallBoxButton.showTypeCountDown:
                    this._openBox.visible = true;
                    this._timeSprite.delayText.visible = true;
                    this._boxGoodTip.visible = false;
                    return;
                case SmallBoxButton.showTypeOpenbox:
                    this._openBox.visible = true;
                    this._openBoxAsset.gotoAndPlay(1);
                    this._timeSprite.delayText.visible = false;
                    this._boxGoodTip.visible = false;
                    return;
                case SmallBoxButton.showTypeHide:
                    this.visible = true;
                    this._openBox.visible = false;
                    this._timeSprite.delayText.visible = false;
                    this._boxGoodTip.visible = false;
                    return;
            };
        }

        private function _click(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (BossBoxManager.instance.delaySumTime != 0)
            {
                return (MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.AwardTipsI")));
            };
            SocketManager.Instance.out.sendGetTimeBox(1);
            this._boxGoodTip.visible = false;
        }

        private function _updateSmallBoxState(_arg_1:TimeBoxEvent):void
        {
            this.showType(_arg_1.boxButtonShowType);
        }

        private function _updateTimeCount(_arg_1:TimeBoxEvent):void
        {
            this.updateTime(_arg_1.delaySumTime);
        }

        private function removeEvent():void
        {
            this._openBox.removeEventListener(MouseEvent.CLICK, this._click);
            this._openBox.removeEventListener(MouseEvent.CLICK, this._click);
            this._openBox.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            this._timeSprite.removeEventListener(MouseEvent.CLICK, this._click);
            BossBoxManager.instance.removeEventListener(TimeBoxEvent.UPDATESMALLBOXBUTTONSTATE, this._updateSmallBoxState);
            BossBoxManager.instance.removeEventListener(TimeBoxEvent.UPDATETIMECOUNT, this._updateTimeCount);
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._closeBox)
            {
                ObjectUtils.disposeObject(this._closeBox);
            };
            this._closeBox = null;
            if (this._openBoxAsset)
            {
                ObjectUtils.disposeObject(this._openBoxAsset);
            };
            this._openBoxAsset = null;
            if (this._openBox)
            {
                ObjectUtils.disposeObject(this._openBox);
            };
            this._openBox = null;
            if (this._delayText)
            {
                ObjectUtils.disposeObject(this._delayText);
            };
            this._delayText = null;
            if (this.timeText)
            {
                ObjectUtils.disposeObject(this.timeText);
            };
            this.timeText = null;
            if (this._timeSprite)
            {
                ObjectUtils.disposeObject(this._timeSprite);
            };
            if (this._boxGoodTip)
            {
                ObjectUtils.disposeObject(this._boxGoodTip);
            };
            this._timeSprite = null;
            this._pointArray = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.bossbox

