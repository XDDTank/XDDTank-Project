package activity.view.viewInDetail.open
{
   import activity.ActivityController;
   import activity.data.ActivityConditionInfo;
   import activity.data.ActivityGiftbagInfo;
   import activity.data.ActivityInfo;
   import activity.data.ActivityRewardInfo;
   import activity.view.ActivityCell;
   import activity.view.viewInDetail.ActivityBaseDetailView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import road7th.data.DictionaryData;
   
   public class ActivityOpenConsortiaLevel extends ActivityBaseDetailView
   {
       
      
      private var _cellList2:SimpleTileList;
      
      private var _rewars2:DictionaryData;
      
      private var _panel2:ScrollPanel;
      
      public function ActivityOpenConsortiaLevel()
      {
         super();
      }
      
      override public function get enable() : Boolean
      {
         if(PlayerManager.Instance.isLeadOfConsortia)
         {
            return super.enable;
         }
         return false;
      }
      
      override public function set info(param1:ActivityInfo) : void
      {
         var _loc3_:ActivityGiftbagInfo = null;
         var _loc4_:Array = null;
         var _loc5_:ActivityConditionInfo = null;
         var _loc6_:DictionaryData = null;
         var _loc7_:ActivityRewardInfo = null;
         _info = param1;
         _rewars = new DictionaryData();
         this._rewars2 = new DictionaryData();
         _giftBags = new DictionaryData();
         _conditions = new Vector.<ActivityConditionInfo>();
         _cellList.disposeAllChildren();
         this._cellList2.disposeAllChildren();
         var _loc2_:Array = ActivityController.instance.getAcitivityGiftBagByActID(info.ActivityId);
         for each(_loc3_ in _loc2_)
         {
            if(!_giftBags[_loc3_.GiftbagOrder])
            {
               _giftBags[_loc3_.GiftbagOrder] = new DictionaryData();
            }
            _giftBags[_loc3_.GiftbagOrder][_loc3_.GiftbagId] = _loc3_;
            _loc4_ = ActivityController.instance.getActivityConditionByGiftbagID(_loc3_.GiftbagId);
            for each(_loc5_ in _loc4_)
            {
               _conditions.push(_loc5_);
            }
            _loc6_ = ActivityController.instance.getRewardsByGiftbagID(_loc3_.GiftbagId);
            for each(_loc7_ in _loc6_)
            {
               if(_loc3_.RewardMark == 0)
               {
                  _rewars.add(_loc7_.TemplateId,_loc7_);
               }
               else if(_loc3_.RewardMark == 1)
               {
                  this._rewars2.add(_loc7_.TemplateId,_loc7_);
               }
            }
         }
         this.initCells();
      }
      
      override protected function initCells() : void
      {
         var _loc1_:ActivityCell = null;
         var _loc2_:int = 0;
         while(_loc2_ < _rewars.length)
         {
            _loc1_ = new ActivityCell(_rewars.list[_loc2_]);
            _loc1_.count = _rewars.list[_loc2_].Count;
            setCellFilter(_loc1_,conditions[0]);
            _cellList.addChild(_loc1_);
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._rewars2.length)
         {
            _loc1_ = new ActivityCell(this._rewars2.list[_loc3_]);
            _loc1_.count = this._rewars2.list[_loc3_].Count;
            setCellFilter(_loc1_,conditions[0]);
            this._cellList2.addChild(_loc1_);
            _loc3_++;
         }
         _panel.vScrollProxy = _cellList.numChildren > _cellNumInRow ? int(0) : int(2);
         this._panel2.vScrollProxy = this._cellList2.numChildren > _cellNumInRow ? int(0) : int(2);
      }
      
      override protected function initView() : void
      {
         _cellNumInRow = 2;
         _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenConsortiaLevel.cellList",[_cellNumInRow]);
         addChild(_cellList);
         _panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.OpenConsortiaLevel.cellPanel");
         addChild(_panel);
         _panel.setView(_cellList);
         this._cellList2 = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenConsortiaLevel.cellList2",[_cellNumInRow]);
         addChild(this._cellList2);
         this._panel2 = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.OpenConsortiaLevel.cellPanel2");
         addChild(this._panel2);
         this._panel2.setView(this._cellList2);
         super.initView();
      }
      
      override public function dispose() : void
      {
         this._cellList2.disposeAllChildren();
         ObjectUtils.disposeObject(this._cellList2);
         this._cellList2 = null;
         ObjectUtils.disposeObject(this._panel2);
         this._panel2 = null;
         super.dispose();
      }
   }
}
