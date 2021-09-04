package activity.view.goodsExchange
{
   import activity.ActivityController;
   import activity.data.ActivityGiftbagInfo;
   import activity.data.ActivityInfo;
   import activity.data.ActivityRewardInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import store.StoreController;
   
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
         super();
         this._activityGiftBagsNeed = new DictionaryData();
         this._activityGiftBagsReward = new DictionaryData();
         this._cellVectorNeed = new Vector.<GoodsExchangeCell>();
         this._cellVectorReward = new Vector.<GoodsExchangeCell>();
         this.initView();
         this.initEvent();
      }
      
      public function set info(param1:ActivityInfo) : void
      {
         this._activityInfo = param1;
         this.udpateView();
      }
      
      public function get info() : ActivityInfo
      {
         return this._activityInfo;
      }
      
      public function sendGoods() : void
      {
         var _loc2_:GoodsExchangeCell = null;
         var _loc3_:Array = null;
         var _loc4_:InventoryItemInfo = null;
         if(this._cellVectorNeed.length <= 0)
         {
            return;
         }
         var _loc1_:Boolean = true;
         for each(_loc2_ in this._cellVectorNeed)
         {
            _loc3_ = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(_loc2_.info.TemplateID);
            for each(_loc4_ in _loc3_)
            {
               if(StoreController.instance.Model.judgeEmbedIn(_loc4_))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.noEnoughMaterial1"));
                  return;
               }
            }
            _loc1_ = _loc1_ && _loc2_.checkCount();
         }
         if(_loc1_)
         {
            SocketManager.Instance.out.sendGoodsExchange(this._activityInfo.ActivityId,this._currentIndex);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.noenought"));
         }
      }
      
      public function updateTimes() : void
      {
         if(this._activityInfo.GetWay == 0)
         {
            this._exchangGoodsCount.text = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.infinity");
            this._exchangGoodsCount.x = 336;
         }
         else
         {
            this._exchangGoodsCount.text = (this._activityInfo.GetWay - this._activityInfo.receiveNum).toString();
            this._exchangGoodsCount.x = 345;
         }
      }
      
      private function initView() : void
      {
         this.showTime();
         this.haveGoods();
         this.exchangGoods();
      }
      
      private function udpateView() : void
      {
         this._awardBtnGroup.selectIndex = 0;
         this.updateTimes();
         this.initData();
         this.updateTimeShow();
         this.updateNeedGoodsBox();
         this.updateExchangeGoodsBox();
      }
      
      private function initData() : void
      {
         var _loc2_:ActivityGiftbagInfo = null;
         this._activityGiftBagsReward = new DictionaryData();
         this._activityGiftBagsNeed = new DictionaryData();
         var _loc1_:Array = ActivityController.instance.getAcitivityGiftBagByActID(this.info.ActivityId);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.RewardMark == 0)
            {
               this._activityGiftBagsReward.add(_loc2_.GiftbagId,_loc2_);
            }
            else if(_loc2_.RewardMark == 1)
            {
               this._activityGiftBagsNeed.add(_loc2_.GiftbagId,_loc2_);
            }
         }
      }
      
      private function initEvent() : void
      {
         this._awardBtnGroup.addEventListener(Event.CHANGE,this.__selectedChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTIVE_EXCHANGE,this.__exchangeHandle);
      }
      
      private function __exchangeHandle(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:int = _loc2_.readInt();
         this._activityInfo.receiveNum = _loc5_;
         if(_loc4_ == this._activityInfo.ActivityId)
         {
            this.updateTimes();
         }
      }
      
      private function __selectedChange(param1:Event) : void
      {
         if(this._currentIndex == this._awardBtnGroup.selectIndex)
         {
            return;
         }
         this._currentIndex = this._awardBtnGroup.selectIndex;
         this.updateNeedGoodsBox(this._currentIndex);
         this.updateExchangeGoodsBox(this._currentIndex);
      }
      
      private function showTime() : void
      {
         this._time = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.TimeIcon");
         PositionUtils.setPos(this._time,"ddtcalendar.GoodsExchangeView.timeImgPos");
         addChild(this._time);
         this._actTimeText = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.TimeFieldTitle");
         addChild(this._actTimeText);
         PositionUtils.setPos(this._actTimeText,"ddtcalendar.ActivityState.TimeFieldTitlePos");
         this._actTime = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.actTime");
         addChild(this._actTime);
      }
      
      private function haveGoods() : void
      {
         this._goodsBg = ComponentFactory.Instance.creatComponentByStylename("asset.GoodsExchangeView.bg");
         addChild(this._goodsBg);
         this._haveImg = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.haveGoodsExchangeImage");
         PositionUtils.setPos(this._haveImg,"ddtcalendar.GoodsExchangeView.HaveImgPos");
         addChild(this._haveImg);
         this._haveGoodsExplain = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.haveGoodsExplain");
         this._haveGoodsExplain.text = LanguageMgr.GetTranslation("tank.calendar.GoodsExchangeView.haveGoodsExplainText");
         addChild(this._haveGoodsExplain);
         this._needGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.exchange.haveGoodsBox",[4]);
         addChild(this._needGoodsBox);
         this._needGoddsPanel = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.haveGoods.srollPanel");
         addChild(this._needGoddsPanel);
         this._needGoddsPanel.setView(this._needGoodsBox);
         this._line = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
         PositionUtils.setPos(this._line,"ddtcalendar.exchange.LinePos");
      }
      
      private function exchangGoods() : void
      {
         this._awardBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.awardBack");
         addChild(this._awardBg1);
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.TextFieldBg");
         addChild(this._textBg);
         this._exchangImg = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.ContentIcon");
         PositionUtils.setPos(this._exchangImg,"ddtcalendar.GoodsExchangeView.changeImgPos");
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
         this._exchangGoodsBox = ComponentFactory.Instance.creatCustomObject("ddtcalendar.exchange.exchangeGoodsBox",[this._cellNumInRow]);
         addChild(this._exchangGoodsBox);
         this._exchangGoodsPanel = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.GoodsExchangeView.changeGoods.srollPanel");
         addChild(this._exchangGoodsPanel);
         this._exchangGoodsPanel.setView(this._exchangGoodsBox);
      }
      
      private function updateTimeShow() : void
      {
         var _loc1_:Date = this.info.beginDate;
         var _loc2_:Date = this.info.endDate;
         this._actTime.text = this.addZero(_loc1_.fullYear) + "." + this.addZero(_loc1_.month + 1) + "." + this.addZero(_loc1_.date);
         this._actTime.text += "-" + this.addZero(_loc2_.fullYear) + "." + this.addZero(_loc2_.month + 1) + "." + this.addZero(_loc2_.date);
      }
      
      private function updateNeedGoodsBox(param1:int = 0) : void
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:ActivityGiftbagInfo = null;
         var _loc4_:ActivityRewardInfo = null;
         var _loc5_:GoodsExchangeCell = null;
         this.cleanCell();
         this._needGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._needGoodsBox);
         for each(_loc3_ in this._activityGiftBagsNeed)
         {
            if(_loc3_.GiftbagOrder == param1)
            {
               _loc2_ = ActivityController.instance.getRewardsByGiftbagID(_loc3_.GiftbagId);
               for each(_loc4_ in _loc2_)
               {
                  _loc5_ = new GoodsExchangeCell(_loc4_,1);
                  this._needGoodsBox.addChild(_loc5_);
                  this._cellVectorNeed.push(_loc5_);
               }
            }
         }
         this._needGoddsPanel.vScrollProxy = this._needGoodsBox.numChildren > this._cellNumInRow ? int(0) : int(0);
      }
      
      private function updateExchangeGoodsBox(param1:int = 0) : void
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:ActivityGiftbagInfo = null;
         var _loc4_:ActivityRewardInfo = null;
         var _loc5_:GoodsExchangeCell = null;
         this._exchangGoodsBox.disposeAllChildren();
         ObjectUtils.removeChildAllChildren(this._exchangGoodsBox);
         for each(_loc3_ in this._activityGiftBagsReward)
         {
            if(_loc3_.GiftbagOrder == param1)
            {
               _loc2_ = ActivityController.instance.getRewardsByGiftbagID(_loc3_.GiftbagId);
               for each(_loc4_ in _loc2_)
               {
                  _loc5_ = new GoodsExchangeCell(_loc4_,0);
                  this._exchangGoodsBox.addChild(_loc5_);
                  this._cellVectorReward.push(_loc5_);
               }
            }
         }
         this._exchangGoodsPanel.vScrollProxy = this._exchangGoodsBox.numChildren > this._cellNumInRow ? int(0) : int(0);
      }
      
      private function cleanCell() : void
      {
         var _loc1_:GoodsExchangeCell = null;
         var _loc2_:GoodsExchangeCell = null;
         for each(_loc1_ in this._cellVectorNeed)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         for each(_loc2_ in this._cellVectorReward)
         {
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
         }
         this._cellVectorNeed = new Vector.<GoodsExchangeCell>();
         this._cellVectorReward = new Vector.<GoodsExchangeCell>();
      }
      
      private function addZero(param1:Number) : String
      {
         var _loc2_:String = null;
         if(param1 < 10)
         {
            _loc2_ = "0" + param1.toString();
         }
         else
         {
            _loc2_ = param1.toString();
         }
         return _loc2_;
      }
      
      private function removeEvent() : void
      {
         this._awardBtnGroup.removeEventListener(Event.CHANGE,this.__selectedChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ACTIVE_EXCHANGE,this.__exchangeHandle);
      }
      
      private function removeView() : void
      {
         if(this._time)
         {
            ObjectUtils.disposeObject(this._time);
            this._time = null;
         }
         if(this._actTimeText)
         {
            ObjectUtils.disposeObject(this._actTimeText);
            this._actTimeText = null;
         }
         if(this._actTime)
         {
            ObjectUtils.disposeObject(this._actTime);
            this._actTime = null;
         }
         if(this._haveImg)
         {
            ObjectUtils.disposeObject(this._haveImg);
            this._haveImg = null;
         }
         if(this._haveGoodsExplain)
         {
            ObjectUtils.disposeObject(this._haveGoodsExplain);
            this._haveGoodsExplain = null;
         }
         if(this._needGoodsBox)
         {
            ObjectUtils.disposeObject(this._needGoodsBox);
            this._needGoodsBox = null;
         }
         if(this._line)
         {
            ObjectUtils.disposeObject(this._line);
            this._line = null;
         }
         if(this._exchangImg)
         {
            ObjectUtils.disposeObject(this._exchangImg);
            this._exchangImg = null;
         }
         if(this._exchangGoodsExplain)
         {
            ObjectUtils.disposeObject(this._exchangGoodsExplain);
            this._exchangGoodsExplain = null;
         }
         if(this._exchangGoodsCountText)
         {
            ObjectUtils.disposeObject(this._exchangGoodsCountText);
            this._exchangGoodsCountText = null;
         }
         if(this._exchangGoodsBox)
         {
            ObjectUtils.disposeObject(this._exchangGoodsBox);
            this._exchangGoodsBox = null;
         }
         if(this._awardBg1)
         {
            ObjectUtils.disposeObject(this._awardBg1);
            this._awardBg1 = null;
         }
         if(this._awardBtn1)
         {
            ObjectUtils.disposeObject(this._awardBtn1);
            this._awardBtn1 = null;
         }
         if(this._awardBtn2)
         {
            ObjectUtils.disposeObject(this._awardBtn2);
            this._awardBtn2 = null;
         }
         if(this._awardBtn3)
         {
            ObjectUtils.disposeObject(this._awardBtn3);
            this._awardBtn3 = null;
         }
         if(this._awardBtn4)
         {
            ObjectUtils.disposeObject(this._awardBtn4);
            this._awardBtn4 = null;
         }
         if(this._textBg)
         {
            ObjectUtils.disposeObject(this._textBg);
            this._textBg = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeView();
         this.removeEvent();
      }
   }
}
