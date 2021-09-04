package activity.view.viewInDetail.tuan
{
   import activity.ActivityController;
   import activity.data.ActivityInfo;
   import activity.data.ActivityTuanInfo;
   import activity.view.ActivityCell;
   import activity.view.viewInDetail.ActivityBaseDetailView;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class ActivityTuanView extends ActivityBaseDetailView
   {
       
      
      private var _tuanInfo:ActivityTuanInfo;
      
      private var _cell:ActivityCell;
      
      private var _buyButton:TextButton;
      
      private var _timeLast:FilterFrameText;
      
      private var _currentRebackRate:FilterFrameText;
      
      private var _nextRebackRate:FilterFrameText;
      
      private var _needBuyCount:FilterFrameText;
      
      private var _alreadyCountArea:FilterFrameText;
      
      private var _alreadyCountSelf:FilterFrameText;
      
      private var _currentRebackMoney:FilterFrameText;
      
      private var _nextRebackMoney:FilterFrameText;
      
      public function ActivityTuanView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this._cell = new ActivityCell(null);
         this._cell.showBg(false);
         this._cell.showCount(false);
         PositionUtils.setPos(this._cell,"activity.view.viewInDetail.tuan.cellPos");
         addChild(this._cell);
         this._buyButton = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.buyButton");
         this._buyButton.text = LanguageMgr.GetTranslation("tank.calendar.ActivityTuanView.buy");
         addChild(this._buyButton);
         this._timeLast = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.timeLast");
         addChild(this._timeLast);
         this._currentRebackRate = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.currentRebackRate");
         addChild(this._currentRebackRate);
         this._nextRebackRate = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.nextRebackRate");
         addChild(this._nextRebackRate);
         this._needBuyCount = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.needBuyCount");
         addChild(this._needBuyCount);
         this._alreadyCountArea = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.alreadyCountArea");
         addChild(this._alreadyCountArea);
         this._alreadyCountSelf = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.alreadyCountSelf");
         addChild(this._alreadyCountSelf);
         this._currentRebackMoney = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.currentRebackMoney");
         addChild(this._currentRebackMoney);
         this._nextRebackMoney = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.nextRebackMoney");
         addChild(this._nextRebackMoney);
      }
      
      override protected function initEvent() : void
      {
         this._buyButton.addEventListener(MouseEvent.CLICK,this.__buyItem);
      }
      
      override public function set info(param1:ActivityInfo) : void
      {
         var _loc5_:DictionaryData = null;
         var _loc6_:DictionaryData = null;
         super.info = param1;
         this._tuanInfo = ActivityController.instance.model.getTuanInfoByID(info.ActivityId);
         var _loc2_:int = int((info.endShowDate.time - TimeManager.Instance.Now().time) / 1000 / 60 / 60 / 24);
         var _loc3_:String = LanguageMgr.GetTranslation("tank.calendar.activityDay");
         if(_loc2_ <= 0)
         {
            _loc2_ = int((info.endShowDate.time - TimeManager.Instance.Now().time) / 1000 / 60 / 60);
            _loc3_ = LanguageMgr.GetTranslation("tank.calendar.activityHour");
         }
         if(_loc2_ <= 0)
         {
            _loc2_ = int((info.endShowDate.time - TimeManager.Instance.Now().time) / 1000 / 60);
            if(_loc2_ == 0 && info.endShowDate.time > TimeManager.Instance.Now().time)
            {
               _loc2_ = 1;
            }
            _loc3_ = LanguageMgr.GetTranslation("tank.calendar.activityMinute");
         }
         this._timeLast.text = _loc2_ + " " + _loc3_;
         var _loc4_:int = 0;
         while(_loc4_ < _conditions.length)
         {
            switch(_conditions[_loc4_].Remain2)
            {
               case "Item":
                  this._tuanInfo.itemID = int(_conditions[_loc4_].ConditionValue);
                  this._tuanInfo.itemPrice = _conditions[_loc4_].Remain1;
                  break;
               case "BackRate":
                  _loc5_ = new DictionaryData();
                  _loc5_.add("level",_conditions[_loc4_].ConditionIndex);
                  _loc5_.add("fp",_conditions[_loc4_].ConditionValue);
                  _loc5_.add("count",_conditions[_loc4_].Remain1);
                  this._tuanInfo.backRate.add(_conditions[_loc4_].ConditionIndex,_loc5_);
                  break;
               case "AdjustTime":
                  _loc6_ = new DictionaryData();
                  _loc6_.add("time",_conditions[_loc4_].ConditionIndex);
                  _loc6_.add("value",_conditions[_loc4_].ConditionValue);
                  _loc6_.add("count",_conditions[_loc4_].Remain1);
                  this._tuanInfo.adjustTime.add(_conditions[_loc4_].ConditionIndex,_loc6_);
                  break;
               case "PriceType":
                  this._tuanInfo.priceType = int(_conditions[_loc4_].ConditionValue);
                  break;
            }
            _loc4_++;
         }
         this._cell.info = ItemManager.Instance.getTemplateById(this._tuanInfo.itemID);
         this.setText();
      }
      
      private function setText() : void
      {
         var _loc1_:DictionaryData = null;
         var _loc5_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < this._tuanInfo.backRate.list.length)
         {
            if(this._tuanInfo.backRate.list[_loc2_]["count"] <= this._tuanInfo.allCount)
            {
               _loc1_ = this._tuanInfo.backRate.list[_loc2_];
            }
            _loc2_++;
         }
         if(_loc1_ == null)
         {
            _loc1_ = new DictionaryData();
            _loc1_.add("fp",10);
            _loc1_.add("level",-1);
         }
         if(_loc1_["fp"] == 10)
         {
            this._currentRebackRate.text = LanguageMgr.GetTranslation("tank.calendar.activityWu");
         }
         else
         {
            this._currentRebackRate.text = (10 - _loc1_["fp"]) * 10 + "%";
         }
         var _loc3_:DictionaryData = this._tuanInfo.backRate[_loc1_["level"] + 1];
         if(_loc3_ == null)
         {
            this._nextRebackRate.text = LanguageMgr.GetTranslation("tank.calendar.ActivityTuanView.toohight");
            this._nextRebackMoney.text = "0";
            this._needBuyCount.text = "";
         }
         else
         {
            this._nextRebackRate.text = (10 - _loc3_["fp"]) * 10 + "%";
            _loc5_ = (10 - _loc3_["fp"]) / 10;
            this._nextRebackMoney.text = (this._tuanInfo.alreadyMoney * _loc5_).toString().toString();
            this._needBuyCount.text = LanguageMgr.GetTranslation("tank.calendar.ActivityTuanView.needBuyCount",_loc3_["count"]);
         }
         this._alreadyCountArea.text = this._tuanInfo.allCount.toString();
         this._alreadyCountSelf.text = this._tuanInfo.alreadyCount.toString();
         var _loc4_:Number = (10 - _loc1_["fp"]) / 10;
         this._currentRebackMoney.text = (this._tuanInfo.alreadyMoney * _loc4_).toString();
      }
      
      override protected function initCells() : void
      {
      }
      
      private function __buyItem(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!ActivityController.instance.isInValidShowDate(_info))
         {
            return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.ActiveState.TimeOut"));
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _loc2_.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
         _loc2_.buyFrom = QuickBuyFrame.ACTIVITY;
         _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc2_.unitPrice = this._tuanInfo.itemPrice;
         _loc2_.priceType = this._tuanInfo.priceType;
         _loc2_.setItemID(this._tuanInfo.itemID,false);
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __shortCutBuyHandler(param1:ShortcutBuyEvent) : void
      {
         var _loc2_:QuickBuyFrame = param1.target as QuickBuyFrame;
         _loc2_.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
         if(param1.ItemID > 0 && param1.ItemNum > 0)
         {
            ActivityController.instance.sendBuyItem(info.ActivityType,info.ActivityId,param1.ItemID,param1.ItemNum);
         }
      }
      
      override protected function removeEvent() : void
      {
         this._buyButton.removeEventListener(MouseEvent.CLICK,this.__buyItem);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._buyButton);
         this._buyButton = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         ObjectUtils.disposeObject(this._alreadyCountArea);
         this._alreadyCountArea = null;
         ObjectUtils.disposeObject(this._alreadyCountSelf);
         this._alreadyCountSelf = null;
         ObjectUtils.disposeObject(this._currentRebackMoney);
         this._currentRebackMoney = null;
         ObjectUtils.disposeObject(this._needBuyCount);
         this._needBuyCount = null;
         ObjectUtils.disposeObject(this._nextRebackMoney);
         this._nextRebackMoney = null;
         ObjectUtils.disposeObject(this._nextRebackRate);
         this._nextRebackRate = null;
         ObjectUtils.disposeObject(this._currentRebackRate);
         this._currentRebackRate = null;
      }
   }
}
