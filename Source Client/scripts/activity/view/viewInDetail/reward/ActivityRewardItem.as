package activity.view.viewInDetail.reward
{
   import activity.ActivityController;
   import activity.ActivityEvent;
   import activity.data.ActivityChildTypes;
   import activity.data.ActivityConditionInfo;
   import activity.data.ActivityGiftbagInfo;
   import activity.data.ActivityInfo;
   import activity.view.ActivityCell;
   import activity.view.ActivityNum;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class ActivityRewardItem extends Sprite implements Disposeable
   {
       
      
      private var _cellNum:int;
      
      private var _cellList:SimpleTileList;
      
      private var _giftBagInfoDic:DictionaryData;
      
      private var _conditionInfo:ActivityConditionInfo;
      
      private var _bg:Bitmap;
      
      private var _moneyTxt:Bitmap;
      
      private var _moneyMC:ActivityNum;
      
      private var _button:TextButton;
      
      private var _type:String;
      
      private var _activityInfo:ActivityInfo;
      
      public function ActivityRewardItem(param1:ActivityInfo, param2:DictionaryData, param3:ActivityConditionInfo, param4:int)
      {
         super();
         this._activityInfo = param1;
         this._cellNum = param4;
         this._giftBagInfoDic = param2;
         this._conditionInfo = param3;
         this._type = !!ActivityController.instance.checkCostReward(this._activityInfo) ? "Cost" : "Charge";
         this.initView();
         this.initCells();
      }
      
      private function initView() : void
      {
         var _loc1_:String = "ddtactivity.total" + this._type + "bg";
         if(this._activityInfo.ActivityChildType == ActivityChildTypes.COST_REWARD_ONCE || this._activityInfo.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_ONCE)
         {
            _loc1_ = "ddtactivity.one" + this._type + "bg";
         }
         this._bg = ComponentFactory.Instance.creatBitmap(_loc1_);
         addChild(this._bg);
         this._moneyTxt = ComponentFactory.Instance.creatBitmap("ddtactivity." + this._type + "moneyTxt");
         if(this._activityInfo.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_ONCE)
         {
            this._moneyTxt.x = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityRewardItem.MoneyTxt").y;
         }
         addChild(this._moneyTxt);
         this._cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityCoseReward.cellList",[this._cellNum]);
         addChild(this._cellList);
         this._button = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityCoseReward.itemButton");
         this._button.text = LanguageMgr.GetTranslation("tank.timeBox.awardsBtn");
         this._button.enable = this.checkEnable();
         this._button.addEventListener(MouseEvent.CLICK,this.__clickButton);
         addChild(this._button);
         this._moneyMC = new ActivityNum();
         if(this._activityInfo.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_ONCE)
         {
            this._moneyMC.type = "ChargeOnce";
         }
         else
         {
            this._moneyMC.type = this._type;
         }
         this._moneyMC.setNum(int(this._conditionInfo.ConditionValue));
         addChild(this._moneyMC);
         this._moneyTxt.x = this._moneyMC.x + this._moneyMC.width;
      }
      
      private function __clickButton(param1:MouseEvent) : void
      {
         if(!ActivityController.instance.isInValidShowDate(this._activityInfo))
         {
            return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.ActiveState.TimeOut"));
         }
         var _loc2_:Object = new Object();
         _loc2_["ID"] = this._activityInfo.ActivityId;
         _loc2_["giftbagOrder"] = this._giftBagInfoDic.list[0].GiftbagOrder;
         ActivityController.instance.model.dispatchEvent(new ActivityEvent(ActivityEvent.GET_RAWARD,_loc2_));
      }
      
      private function checkEnable() : Boolean
      {
         if(ActivityController.instance.model.getGiftbagRecordByID(this._activityInfo.ActivityId,this._giftBagInfoDic.list[0].GiftbagOrder).value > 0)
         {
            return true;
         }
         return false;
      }
      
      private function initCells() : void
      {
         var _loc1_:ActivityCell = null;
         var _loc2_:DictionaryData = null;
         var _loc3_:ActivityGiftbagInfo = null;
         var _loc4_:int = 0;
         for each(_loc3_ in this._giftBagInfoDic)
         {
            _loc2_ = ActivityController.instance.getRewardsByGiftbagID(_loc3_.GiftbagId);
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(this._type == "Cost")
               {
                  _loc1_ = new ActivityCell(_loc2_.list[_loc4_],true,ComponentFactory.Instance.creatBitmap("ddtactivity.CostReward.cellBg"));
               }
               else
               {
                  _loc1_ = new ActivityCell(_loc2_.list[_loc4_]);
               }
               _loc1_.count = _loc2_.list[_loc4_].Count;
               this._cellList.addChild(_loc1_);
               _loc4_++;
            }
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._moneyTxt);
         this._moneyTxt = null;
         this._cellList.disposeAllChildren();
         ObjectUtils.disposeObject(this._cellList);
         this._cellList = null;
         if(this._button)
         {
            this._button.removeEventListener(MouseEvent.CLICK,this.__clickButton);
            ObjectUtils.disposeObject(this._button);
            this._button = null;
         }
         ObjectUtils.disposeObject(this._moneyMC);
         this._moneyMC = null;
      }
   }
}
