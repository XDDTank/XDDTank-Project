package activity.view.viewInDetail.reward
{
   import activity.ActivityController;
   import activity.data.ActivityChildTypes;
   import activity.data.ActivityInfo;
   import activity.view.viewInDetail.ActivityBaseDetailView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import road7th.data.DictionaryData;
   
   public class ActivityRewardView extends ActivityBaseDetailView
   {
       
      
      private var _totalTxt:ScaleFrameImage;
      
      private var _alreadyTxt:FilterFrameText;
      
      private var _type:String;
      
      public function ActivityRewardView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         _cellNumInRow = 5;
         _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityReward.itemList",[1]);
         addChild(_cellList);
         _panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityCoseReward.itemPanel");
         addChild(_panel);
         _panel.setView(_cellList);
         this._totalTxt = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.totalTxtImage");
         this._totalTxt.setFrame(1);
         addChild(this._totalTxt);
         this._alreadyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityReward.alreadyTxt");
         addChild(this._alreadyTxt);
      }
      
      override public function set info(param1:ActivityInfo) : void
      {
         if(ActivityController.instance.checkChargeReward(param1))
         {
            this._type = "Charge";
            this._totalTxt.setFrame(1);
            _panel.vScrollbarStyle = "core.newVScrollbar";
         }
         else if(ActivityController.instance.checkCostReward(param1))
         {
            this._type = "Cost";
            this._totalTxt.setFrame(2);
            _panel.vScrollbarStyle = "core.ddtchurchVScrollbar";
         }
         this._alreadyTxt.textFormatStyle = "ddtcalendar.ActivityRewardTxt." + this._type + "TF";
         this._alreadyTxt.filterString = "ddtcalendar.ActivityRewardTxt." + this._type + "GF";
         super.info = param1;
         this._alreadyTxt.text = nowState.toString();
         this._totalTxt.visible = this._alreadyTxt.visible = info.ActivityChildType == ActivityChildTypes.COST_REWARD_TOTAL || info.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_TOTAL;
      }
      
      override protected function initCells() : void
      {
         var _loc1_:ActivityRewardItem = null;
         var _loc3_:DictionaryData = null;
         var _loc2_:int = 0;
         for each(_loc3_ in _giftBags)
         {
            _loc1_ = new ActivityRewardItem(info,_loc3_,_conditions[_loc2_],_cellNumInRow);
            _cellList.addChild(_loc1_);
            _loc2_ += 2;
         }
      }
   }
}
