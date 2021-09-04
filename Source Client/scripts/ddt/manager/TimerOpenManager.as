package ddt.manager
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.TimeEvents;
   import ddt.view.MainToolBar;
   import flash.events.EventDispatcher;
   import game.view.GetGoodsTipView;
   import road7th.utils.DateUtils;
   
   public class TimerOpenManager extends EventDispatcher
   {
      
      private static var _instance:TimerOpenManager;
       
      
      private var _checkList:Vector.<InventoryItemInfo>;
      
      private var _info:InventoryItemInfo;
      
      private var _Open:Boolean = true;
      
      public function TimerOpenManager()
      {
         super();
      }
      
      public static function get Instance() : TimerOpenManager
      {
         if(_instance == null)
         {
            _instance = new TimerOpenManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._checkList = new Vector.<InventoryItemInfo>();
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__timerTick);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__bagUpdate);
      }
      
      private function __timerTick(param1:TimeEvents) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Date = null;
         var _loc4_:int = 0;
         if(this._checkList.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._checkList.length)
            {
               if(EquipType.isPetsEgg(this._checkList[_loc2_]))
               {
                  _loc3_ = DateUtils.getDateByStr(this._checkList[_loc2_].BeginDate);
                  _loc4_ = int(this._checkList[_loc2_].Property3) * 60 - (TimeManager.Instance.Now().getTime() - _loc3_.getTime()) / 1000;
                  if(_loc4_ <= 0)
                  {
                     this._info = this._checkList[_loc2_];
                     this.show();
                     this._checkList.splice(_loc2_,1);
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function firstLogin() : void
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:Date = null;
         var _loc3_:int = 0;
         for each(_loc1_ in PlayerManager.Instance.Self.Bag.items)
         {
            if(EquipType.isTimeBox(_loc1_))
            {
               _loc2_ = DateUtils.getDateByStr((_loc1_ as InventoryItemInfo).BeginDate);
               _loc3_ = int(_loc1_.Property3) * 60 - (TimeManager.Instance.Now().getTime() - _loc2_.getTime()) / 1000;
               if(_loc3_ <= 0)
               {
                  this._checkList.push(_loc1_);
               }
            }
         }
         this.__timerTick(null);
      }
      
      private function __bagUpdate(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Boolean = false;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:Date = null;
         var _loc6_:int = 0;
         for each(_loc2_ in param1.changedSlots)
         {
            _loc3_ = false;
            for each(_loc4_ in this._checkList)
            {
               if(_loc4_.ItemID == _loc2_.ItemID)
               {
                  _loc3_ = true;
                  break;
               }
            }
            if(!_loc3_ && EquipType.isTimeBox(_loc2_))
            {
               _loc5_ = DateUtils.getDateByStr((_loc2_ as InventoryItemInfo).BeginDate);
               _loc6_ = int(_loc2_.Property3) * 60 - (TimeManager.Instance.Now().getTime() - _loc5_.getTime()) / 1000;
               if(_loc6_ > 0)
               {
                  this._checkList.push(_loc2_);
               }
            }
         }
      }
      
      public function show() : void
      {
         var _alert:GetGoodsTipView = null;
         var showFunc:Function = null;
         if(this._info && this._Open)
         {
            _alert = ComponentFactory.Instance.creatComponentByStylename("trainer.view.GetGoodsTip");
            _alert.item = this._info;
            _alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            showFunc = function():void
            {
               LayerManager.Instance.addToLayer(_alert,LayerManager.GAME_DYNAMIC_LAYER,false,0,false);
               LayerManager.Instance.getLayerByType(LayerManager.GAME_DYNAMIC_LAYER).setChildIndex(_alert,0);
            };
            if(!MainToolBar.Instance.canOpenBag())
            {
               CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT,new FunctionAction(showFunc));
            }
            else
            {
               showFunc();
            }
         }
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Array = null;
         SoundManager.instance.play("008");
         var _loc2_:GetGoodsTipView = param1.target as GetGoodsTipView;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc4_ = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(_loc2_.item.TemplateID);
            _loc3_ = _loc4_[0];
            _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
            PlayerManager.Instance.Self.EquipInfo = _loc3_;
            BagAndInfoManager.Instance.showBagAndInfo();
            this._Open = false;
         }
         else
         {
            _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
            this._Open = false;
         }
      }
   }
}
