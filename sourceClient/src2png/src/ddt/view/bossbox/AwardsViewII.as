// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.AwardsViewII

package ddt.view.bossbox
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import ddt.manager.PlayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.data.box.BoxGoodsTempInfo;
    import ddt.manager.SoundManager;
    import mainbutton.MainButtnController;
    import flash.events.Event;
    import ddt.manager.BossBoxManager;
    import ddt.manager.TimeManager;
    import com.pickgliss.utils.ObjectUtils;

    public class AwardsViewII extends Frame 
    {

        public static const HAVEBTNCLICK:String = "_haveBtnClick";

        private var _timeTypeTxt:FilterFrameText;
        private var _goodsList:Array;
        private var _boxType:int;
        private var _button:TextButton;
        private var list:AwardsGoodsList;
        private var GoodsBG:ScaleBitmapImage;

        public function AwardsViewII()
        {
            this.initII();
            this.initEvent();
        }

        private function initII():void
        {
            titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
            this.GoodsBG = ComponentFactory.Instance.creat("bossbox.scale9GoodsImageII");
            addToContent(this.GoodsBG);
            var _local_1:Bitmap = ComponentFactory.Instance.creatBitmap("asset.vip.monyBG");
            addToContent(_local_1);
            this._timeTypeTxt = ComponentFactory.Instance.creat("bossbox.awardsTitleTxt");
            this._timeTypeTxt.text = LanguageMgr.GetTranslation("ddt.vip.awardsTitleTxt");
            addToContent(this._timeTypeTxt);
            this._button = ComponentFactory.Instance.creat("bossbox.BoxGetButtonII");
            this._button.text = LanguageMgr.GetTranslation("ok");
            addToContent(this._button);
            if ((!(PlayerManager.Instance.Self.IsVIP)))
            {
                this._button.enable = false;
            };
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._button.addEventListener(MouseEvent.CLICK, this._click);
        }

        private function _click(_arg_1:MouseEvent):void
        {
            var _local_3:BoxGoodsTempInfo;
            SoundManager.instance.play("008");
            var _local_2:int;
            for each (_local_3 in this._goodsList)
            {
                if (_local_3.TemplateId == -300)
                {
                    _local_2 = _local_3.ItemCount;
                    break;
                };
            };
            PlayerManager.Instance.Self.canTakeVipReward = false;
            MainButtnController.instance.dispatchEvent(new Event(MainButtnController.ICONCLOSE));
            dispatchEvent(new Event(AwardsView.HAVEBTNCLICK));
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    this.dispose();
                    return;
            };
        }

        public function set boxType(_arg_1:int):void
        {
            this._boxType = (_arg_1 + 1);
        }

        public function get boxType():int
        {
            return (this._boxType);
        }

        public function set goodsList(_arg_1:Array):void
        {
            this._goodsList = _arg_1;
            this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
            this.list.show(this._goodsList);
            addChild(this.list);
        }

        public function set vipAwardGoodsList(_arg_1:Array):void
        {
            this._goodsList = _arg_1;
            this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
            this.list.showForVipAward(this._goodsList);
            addChild(this.list);
        }

        public function set fightLibAwardGoodList(_arg_1:Array):void
        {
            this.goodsList = _arg_1;
            this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
            this.list.show(this._goodsList);
            addChild(this.list);
        }

        public function setCheck():void
        {
            closeButton.visible = true;
            this._button.enable = false;
            this._timeTypeTxt.visible = false;
            var _local_1:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("bossbox.TheNextTimeText");
            addToContent(_local_1);
            _local_1.text = LanguageMgr.GetTranslation("ddt.view.bossbox.AwardsView.TheNextTimeText", this.updateTime());
        }

        private function updateTime():String
        {
            var _local_1:Number = ((BossBoxManager.instance.delaySumTime * 1000) + TimeManager.Instance.Now().time);
            var _local_2:Date = new Date(_local_1);
            var _local_3:int = _local_2.hours;
            var _local_4:int = _local_2.minutes;
            var _local_5:String = "";
            if (_local_3 < 10)
            {
                _local_5 = (_local_5 + ("0" + _local_3));
            }
            else
            {
                _local_5 = (_local_5 + _local_3);
            };
            _local_5 = (_local_5 + "点");
            if (_local_4 < 10)
            {
                _local_5 = (_local_5 + ("0" + _local_4));
            }
            else
            {
                _local_5 = (_local_5 + _local_4);
            };
            return (_local_5 + "分");
        }

        override public function dispose():void
        {
            super.dispose();
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            if (this._timeTypeTxt)
            {
                ObjectUtils.disposeObject(this._timeTypeTxt);
            };
            this._timeTypeTxt = null;
            if (this._button)
            {
                this._button.removeEventListener(MouseEvent.CLICK, this._click);
                ObjectUtils.disposeObject(this._button);
            };
            this._button = null;
            if (this.list)
            {
                ObjectUtils.disposeObject(this.list);
            };
            this.list = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.bossbox

