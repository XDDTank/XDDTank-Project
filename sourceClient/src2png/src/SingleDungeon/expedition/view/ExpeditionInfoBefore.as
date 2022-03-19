// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.view.ExpeditionInfoBefore

package SingleDungeon.expedition.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.text.FilterFrameText;
    import SingleDungeon.expedition.ExpeditionInfo;
    import flash.display.Bitmap;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.events.PlayerPropertyEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class ExpeditionInfoBefore extends Sprite implements Disposeable 
    {

        private var _timesBg:Scale9CornerImage;
        private var _timesText:TextInput;
        private var _currentPowerText:FilterFrameText;
        private var _needPowerText:FilterFrameText;
        private var _needTimeText:FilterFrameText;
        private var _needTimeNum:int;
        private var _needPowerNum:int;
        private var _expeditionInfo:ExpeditionInfo;
        private var _infoFontBmp:Bitmap;

        public function ExpeditionInfoBefore()
        {
            this.initView();
            this.initEvent();
        }

        public function get times():int
        {
            if (this._timesText.text == "")
            {
                return (-1);
            };
            return (int(this._timesText.text));
        }

        public function setinfo(_arg_1:ExpeditionInfo):void
        {
            this._expeditionInfo = _arg_1;
            this._needPowerNum = this._expeditionInfo.ExpeditionEnergy;
            this._needTimeNum = this._expeditionInfo.ExpeditionTime;
            this.refreshTimesTxt();
            this.update();
        }

        private function refreshTimesTxt():void
        {
            this._timesText.text = int((PlayerManager.Instance.Self.Fatigue / this._needPowerNum)).toString();
            this._timesText.text = ((int(this._timesText.text) == 0) ? "1" : this._timesText.text);
            this._timesText.text = ((int(this._timesText.text) >= 50) ? "50" : this._timesText.text);
        }

        public function checkFatigue():Boolean
        {
            if (PlayerManager.Instance.Self.Fatigue < this._needPowerNum)
            {
                return (false);
            };
            return (true);
        }

        public function update():void
        {
            this._currentPowerText.text = PlayerManager.Instance.Self.Fatigue.toString();
            this._needPowerText.text = (int(this._timesText.text) * this._needPowerNum).toString();
            this.refreshTimesTxt();
            this.setNeedTimeText();
        }

        private function setNeedTimeText():void
        {
            var _local_1:int = (this._needTimeNum * int(this._timesText.text));
            var _local_2:int = int((_local_1 / 60));
            var _local_3:int = (_local_1 % 60);
            this._needTimeText.text = ((((this.deelNum(_local_2) + ":") + this.deelNum(_local_3)) + ":") + "00");
        }

        private function deelNum(_arg_1:int):String
        {
            if (_arg_1 >= 10)
            {
                return (_arg_1.toString());
            };
            return ("0" + _arg_1.toString());
        }

        private function initView():void
        {
            this._infoFontBmp = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.expeditionInfo");
            addChild(this._infoFontBmp);
            this._timesBg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.timeBg");
            addChild(this._timesBg);
            this._timesText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.expeditionInfoBefore.times.text");
            addChild(this._timesText);
            this._timesText.textField.restrict = "0-9";
            this._currentPowerText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.expeditionInfoBefore.currentEnergy.text");
            addChild(this._currentPowerText);
            this._needPowerText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.expeditionInfoBefore.needEnergy.text");
            addChild(this._needPowerText);
            this._needTimeText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.expeditionInfoBefore.needTime.text");
            addChild(this._needTimeText);
        }

        private function __timesChange(_arg_1:Event):void
        {
            if ((!(this.checkFatigue())))
            {
                this._timesText.text = "1";
            }
            else
            {
                if (int(this._timesText.text) > (PlayerManager.Instance.Self.Fatigue / this._needPowerNum))
                {
                    this._timesText.text = int((PlayerManager.Instance.Self.Fatigue / this._needPowerNum)).toString();
                }
                else
                {
                    if (((this._timesText.text == "0") || (this._timesText.text == "")))
                    {
                        this._timesText.text = "1";
                    };
                };
            };
            if (int(this._timesText.text) >= 50)
            {
                this._timesText.text = "50";
            };
            this._needPowerText.text = (int(this._timesText.text) * this._needPowerNum).toString();
            this.setNeedTimeText();
        }

        private function __updateFatigue(_arg_1:PlayerPropertyEvent):void
        {
            this.update();
        }

        private function initEvent():void
        {
            this._timesText.addEventListener(Event.CHANGE, this.__timesChange);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__updateFatigue);
        }

        private function removeView():void
        {
            if (this._timesBg)
            {
                ObjectUtils.disposeObject(this._timesBg);
                this._timesBg = null;
            };
            if (this._timesText)
            {
                ObjectUtils.disposeObject(this._timesText);
                this._timesText = null;
            };
            if (this._currentPowerText)
            {
                ObjectUtils.disposeObject(this._currentPowerText);
                this._currentPowerText = null;
            };
            if (this._needPowerText)
            {
                ObjectUtils.disposeObject(this._needPowerText);
                this._needPowerText = null;
            };
            if (this._needTimeText)
            {
                ObjectUtils.disposeObject(this._needTimeText);
                this._needTimeText = null;
            };
            ObjectUtils.disposeObject(this._infoFontBmp);
            this._infoFontBmp = null;
        }

        private function removeEvent():void
        {
            this._timesText.removeEventListener(Event.CHANGE, this.__timesChange);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__updateFatigue);
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeView();
        }


    }
}//package SingleDungeon.expedition.view

