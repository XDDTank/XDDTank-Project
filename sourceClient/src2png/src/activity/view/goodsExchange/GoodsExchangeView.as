// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.goodsExchange.GoodsExchangeView

package activity.view.goodsExchange
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.SelectedButton;
    import com.pickgliss.ui.image.MutipleImage;
    import activity.data.ActivityInfo;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import store.StoreController;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SocketManager;
    import activity.data.ActivityGiftbagInfo;
    import activity.ActivityController;
    import flash.events.Event;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import activity.data.ActivityRewardInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class GoodsExchangeView extends Sprite implements Disposeable 
    {

        public static const EXCHANGE_NUM:int = 4;

        private var _goodsBg:Scale9CornerImage;
        private var _goodsBgI:Scale9CornerImage;
        private var _time:Bitmap;
        private var _actTimeText:Bitmap;
        private var _actTime:FilterFrameText;
        private var _haveImg:Bitmap;
        private var _haveGoodsExplain:FilterFrameText;
        private var _needGoodsBox:SimpleTileList;
        private var _needGoddsPanel:ScrollPanel;
        private var _line:Bitmap;
        private var _exchangImg:Bitmap;
        private var _exchangGoodsExplain:FilterFrameText;
        private var _exchangGoodsCountText:FilterFrameText;
        private var _exchangGoodsCount:FilterFrameText;
        private var _awardBtnGroup:SelectedButtonGroup;
        private var _awardBtn1:SelectedButton;
        private var _awardBtn2:SelectedButton;
        private var _awardBtn3:SelectedButton;
        private var _awardBtn4:SelectedButton;
        private var _exchangGoodsBox:SimpleTileList;
        private var _exchangGoodsPanel:ScrollPanel;
        private var _awardBg1:MutipleImage;
        private var _textBg:Scale9CornerImage;
        private var _activityInfo:ActivityInfo;
        private var _activityGiftBagsNeed:DictionaryData;
        private var _activityGiftBagsReward:DictionaryData;
        private var _cellVectorNeed:Vector.<GoodsExchangeCell>;
        private var _cellVectorReward:Vector.<GoodsExchangeCell>;
        private var _currentIndex:int = 0;
        protected var _cellNumInRow:int = 6;

        public function GoodsExchangeView()
        {
            this._activityGiftBagsNeed = new DictionaryData();
            this._activityGiftBagsReward = new DictionaryData();
            this._cellVectorNeed = new Vector.<GoodsExchangeCell>();
            this._cellVectorReward = new Vector.<GoodsExchangeCell>();
            this.initView();
            this.initEvent();
        }

        public function set info(_arg_1:ActivityInfo):void
        {
            this._activityInfo = _arg_1;
            this.udpateView();
        }

        public function get info():ActivityInfo
        {
            return (this._activityInfo);
        }

        public function sendGoods():void
        {
            var _local_2:GoodsExchangeCell;
            var _local_3:Array;
            var _local_4:InventoryItemInfo;
            if (this._cellVectorNeed.length <= 0)
            {
                return;
            };
            var _local_1:Boolean = true;
            for each (_local_2 in this._cellVectorNeed)
            {
                _local_3 = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(_local_2.info.TemplateID);
                for each (_local_4 in _local_3)
                {
                    if (StoreController.instance.Model.judgeEmbedIn(_local_4))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.noEnoughMaterial1"));
                        return;
                    };
                };
                _local_1 = ((_local_1) && (_local_2.checkCount()));
            };
            if (_local_1)
            {
                SocketManager.Instance.out.sendGoodsExchange(this._activityInfo.ActivityId, this._currentIndex);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.noenought"));
            };
        }

        public function updateTimes():void
        {
            if (this._activityInfo.GetWay == 0)
            {
                this._exchangGoodsCount.text = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.infinity");
                this._exchangGoodsCount.x = 336;
            }
            else
            {
                this._exchangGoodsCount.text = (this._activityInfo.GetWay - this._activityInfo.receiveNum).toString();
                this._exchangGoodsCount.x = 345;
            };
        }

        private function initView():void
        {
            this.showTime();
            this.haveGoods();
            this.exchangGoods();
        }

        private function udpateView():void
        {
            this._awardBtnGroup.selectIndex = 0;
            this.updateTimes();
            this.initData();
            this.updateTimeShow();
            this.updateNeedGoodsBox();
            this.updateExchangeGoodsBox();
        }

        private function initData():void
        {
            var _local_2:ActivityGiftbagInfo;
            this._activityGiftBagsReward = new DictionaryData();
            this._activityGiftBagsNeed = new DictionaryData();
            var _local_1:Array = ActivityController.instance.getAcitivityGiftBagByActID(this.info.ActivityId);
            for each (_local_2 in _local_1)
            {
                if (_local_2.RewardMark == 0)
                {
                    this._activityGiftBagsReward.add(_local_2.GiftbagId, _local_2);
                }
                else
                {
                    if (_local_2.RewardMark == 1)
                    {
                        this._activityGiftBagsNeed.add(_local_2.GiftbagId, _local_2);
                    };
                };
            };
        }

        private function initEvent():void
        {
            this._awardBtnGroup.addEventListener(Event.CHANGE, this.__selectedChange);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTIVE_EXCHANGE, this.__exchangeHandle);
        }

        private function __exchangeHandle(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Boolean = _local_2.readBoolean();
            var _local_4:String = _local_2.readUTF();
            var _local_5:int = _local_2.readInt();
            this._activityInfo.receiveNum = _local_5;
            if (_local_4 == this._activityInfo.ActivityId)
            {
                this.updateTimes();
            };
        }

        private function __selectedChange(_arg_1:Event):void
        {
            if (this._currentIndex == this._awardBtnGroup.selectIndex)
            {
                return;
            };
            this._currentIndex = this._awardBtnGroup.selectIndex;
            this.updateNeedGoodsBox(this._currentIndex);
            this.updateExchangeGoodsBox(this._currentIndex);
        }

        private function showTime():void
        {
            this._time = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.TimeIcon");
            PositionUtils.setPos(this._time, "ddtcalendar.GoodsExchangeView.timeImgPos");
            addChild(this._time);
            this._actTimeText = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.TimeFieldTitle");
            addChild(this._actTimeText);
            PositionUtils.setPos(this._actTimeText, "ddtcalendar.ActivityState.TimeFieldTitlePos");
            this._actTime = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.actTime");
            addChild(this._actTime);
        }

        private function haveGoods():void
        {
            this._goodsBg = ComponentFactory.Instance.creatComponentByStylename("asset.GoodsExchangeView.bg");
            addChild(this._goodsBg);
            this._haveImg = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.haveGoodsExchangeImage");
            PositionUtils.setPos(this._haveImg, "ddtcalendar.GoodsExchangeView.HaveImgPos");
            addChild(this._haveImg);
            this._haveGoodsExplain = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.haveGoodsExplain");
            this._haveGoodsExplain.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.haveGoodsExplainText");
            addChild(this._haveGoodsExplain);
            this._needGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.exchange.haveGoodsBox", [4]);
            addChild(this._needGoodsBox);
            this._needGoddsPanel = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.haveGoods.srollPanel");
            addChild(this._needGoddsPanel);
            this._needGoddsPanel.setView(this._needGoodsBox);
            this._line = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
            PositionUtils.setPos(this._line, "ddtcalendar.exchange.LinePos");
        }

        private function exchangGoods():void
        {
            this._awardBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBack");
            addChild(this._awardBg1);
            this._textBg = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.TextFieldBg");
            addChild(this._textBg);
            this._exchangImg = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.ContentIcon");
            PositionUtils.setPos(this._exchangImg, "ddtcalendar.GoodsExchangeView.changeImgPos");
            addChild(this._exchangImg);
            this._exchangGoodsExplain = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoodsExplain");
            this._exchangGoodsExplain.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.changeGoodsExplainText");
            addChild(this._exchangGoodsExplain);
            this._exchangGoodsCountText = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoodsCountText");
            this._exchangGoodsCountText.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.changeGoodsCountText");
            addChild(this._exchangGoodsCountText);
            this._exchangGoodsCount = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoodsCount");
            addChild(this._exchangGoodsCount);
            this._awardBtnGroup = new SelectedButtonGroup();
            this._awardBtn1 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn1");
            addChild(this._awardBtn1);
            this._awardBtn2 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn2");
            addChild(this._awardBtn2);
            this._awardBtn3 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn3");
            addChild(this._awardBtn3);
            this._awardBtn4 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBtn4");
            addChild(this._awardBtn4);
            this._awardBtnGroup.addSelectItem(this._awardBtn1);
            this._awardBtnGroup.addSelectItem(this._awardBtn2);
            this._awardBtnGroup.addSelectItem(this._awardBtn3);
            this._awardBtnGroup.addSelectItem(this._awardBtn4);
            this._awardBtnGroup.selectIndex = 0;
            this._exchangGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.exchange.exchangeGoodsBox", [this._cellNumInRow]);
            addChild(this._exchangGoodsBox);
            this._exchangGoodsPanel = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoods.srollPanel");
            addChild(this._exchangGoodsPanel);
            this._exchangGoodsPanel.setView(this._exchangGoodsBox);
        }

        private function updateTimeShow():void
        {
            var _local_1:Date = this.info.beginDate;
            var _local_2:Date = this.info.endDate;
            this._actTime.text = ((((this.addZero(_local_1.fullYear) + ".") + this.addZero((_local_1.month + 1))) + ".") + this.addZero(_local_1.date));
            this._actTime.text = (this._actTime.text + ((((("-" + this.addZero(_local_2.fullYear)) + ".") + this.addZero((_local_2.month + 1))) + ".") + this.addZero(_local_2.date)));
        }

        private function updateNeedGoodsBox(_arg_1:int=0):void
        {
            var _local_2:DictionaryData;
            var _local_3:ActivityGiftbagInfo;
            var _local_4:ActivityRewardInfo;
            var _local_5:GoodsExchangeCell;
            this.cleanCell();
            this._needGoodsBox.disposeAllChildren();
            ObjectUtils.removeChildAllChildren(this._needGoodsBox);
            for each (_local_3 in this._activityGiftBagsNeed)
            {
                if (_local_3.GiftbagOrder == _arg_1)
                {
                    _local_2 = ActivityController.instance.getRewardsByGiftbagID(_local_3.GiftbagId);
                    for each (_local_4 in _local_2)
                    {
                        _local_5 = new GoodsExchangeCell(_local_4, 1);
                        this._needGoodsBox.addChild(_local_5);
                        this._cellVectorNeed.push(_local_5);
                    };
                };
            };
            this._needGoddsPanel.vScrollProxy = ((this._needGoodsBox.numChildren > this._cellNumInRow) ? 0 : 0);
        }

        private function updateExchangeGoodsBox(_arg_1:int=0):void
        {
            var _local_2:DictionaryData;
            var _local_3:ActivityGiftbagInfo;
            var _local_4:ActivityRewardInfo;
            var _local_5:GoodsExchangeCell;
            this._exchangGoodsBox.disposeAllChildren();
            ObjectUtils.removeChildAllChildren(this._exchangGoodsBox);
            for each (_local_3 in this._activityGiftBagsReward)
            {
                if (_local_3.GiftbagOrder == _arg_1)
                {
                    _local_2 = ActivityController.instance.getRewardsByGiftbagID(_local_3.GiftbagId);
                    for each (_local_4 in _local_2)
                    {
                        _local_5 = new GoodsExchangeCell(_local_4, 0);
                        this._exchangGoodsBox.addChild(_local_5);
                        this._cellVectorReward.push(_local_5);
                    };
                };
            };
            this._exchangGoodsPanel.vScrollProxy = ((this._exchangGoodsBox.numChildren > this._cellNumInRow) ? 0 : 0);
        }

        private function cleanCell():void
        {
            var _local_1:GoodsExchangeCell;
            var _local_2:GoodsExchangeCell;
            for each (_local_1 in this._cellVectorNeed)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
            };
            for each (_local_2 in this._cellVectorReward)
            {
                ObjectUtils.disposeObject(_local_2);
                _local_2 = null;
            };
            this._cellVectorNeed = new Vector.<GoodsExchangeCell>();
            this._cellVectorReward = new Vector.<GoodsExchangeCell>();
        }

        private function addZero(_arg_1:Number):String
        {
            var _local_2:String;
            if (_arg_1 < 10)
            {
                _local_2 = ("0" + _arg_1.toString());
            }
            else
            {
                _local_2 = _arg_1.toString();
            };
            return (_local_2);
        }

        private function removeEvent():void
        {
            this._awardBtnGroup.removeEventListener(Event.CHANGE, this.__selectedChange);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ACTIVE_EXCHANGE, this.__exchangeHandle);
        }

        private function removeView():void
        {
            if (this._time)
            {
                ObjectUtils.disposeObject(this._time);
                this._time = null;
            };
            if (this._actTimeText)
            {
                ObjectUtils.disposeObject(this._actTimeText);
                this._actTimeText = null;
            };
            if (this._actTime)
            {
                ObjectUtils.disposeObject(this._actTime);
                this._actTime = null;
            };
            if (this._haveImg)
            {
                ObjectUtils.disposeObject(this._haveImg);
                this._haveImg = null;
            };
            if (this._haveGoodsExplain)
            {
                ObjectUtils.disposeObject(this._haveGoodsExplain);
                this._haveGoodsExplain = null;
            };
            if (this._needGoodsBox)
            {
                ObjectUtils.disposeObject(this._needGoodsBox);
                this._needGoodsBox = null;
            };
            if (this._line)
            {
                ObjectUtils.disposeObject(this._line);
                this._line = null;
            };
            if (this._exchangImg)
            {
                ObjectUtils.disposeObject(this._exchangImg);
                this._exchangImg = null;
            };
            if (this._exchangGoodsExplain)
            {
                ObjectUtils.disposeObject(this._exchangGoodsExplain);
                this._exchangGoodsExplain = null;
            };
            if (this._exchangGoodsCountText)
            {
                ObjectUtils.disposeObject(this._exchangGoodsCountText);
                this._exchangGoodsCountText = null;
            };
            if (this._exchangGoodsBox)
            {
                ObjectUtils.disposeObject(this._exchangGoodsBox);
                this._exchangGoodsBox = null;
            };
            if (this._awardBg1)
            {
                ObjectUtils.disposeObject(this._awardBg1);
                this._awardBg1 = null;
            };
            if (this._awardBtn1)
            {
                ObjectUtils.disposeObject(this._awardBtn1);
                this._awardBtn1 = null;
            };
            if (this._awardBtn2)
            {
                ObjectUtils.disposeObject(this._awardBtn2);
                this._awardBtn2 = null;
            };
            if (this._awardBtn3)
            {
                ObjectUtils.disposeObject(this._awardBtn3);
                this._awardBtn3 = null;
            };
            if (this._awardBtn4)
            {
                ObjectUtils.disposeObject(this._awardBtn4);
                this._awardBtn4 = null;
            };
            if (this._textBg)
            {
                ObjectUtils.disposeObject(this._textBg);
                this._textBg = null;
            };
        }

        public function dispose():void
        {
            this.removeView();
            this.removeEvent();
        }


    }
}//package activity.view.goodsExchange

