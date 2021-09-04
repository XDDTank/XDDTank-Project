package activity.view.viewInDetail.open
{
   import activity.ActivityController;
   import activity.view.ActivityCell;
   import activity.view.viewInDetail.ActivityBaseDetailView;
   import com.pickgliss.ui.ComponentFactory;
   
   public class ActivityOpenLevel extends ActivityBaseDetailView
   {
       
      
      public function ActivityOpenLevel()
      {
         super();
      }
      
      override protected function initCells() : void
      {
         var _loc1_:ActivityCell = null;
         var _loc2_:int = 0;
         while(_loc2_ < _rewars.length)
         {
            _loc1_ = new ActivityCell(_rewars.list[_loc2_],false);
            _loc1_.count = _rewars.list[_loc2_].Count;
            _cellList.addChild(_loc1_);
            this.setCellFilter(_loc1_,conditions[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function setCellFilter(param1:ActivityCell, param2:int) : void
      {
         if(nowState < param2 || param2 <= ActivityController.instance.model.getLog(_info.ActivityId))
         {
            param1.canGet = false;
            if(param2 <= ActivityController.instance.model.getLog(_info.ActivityId))
            {
               param1.hasGet = true;
            }
         }
      }
      
      override protected function initView() : void
      {
         _cellNumInRow = 3;
         _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenLevel.cellList",[_cellNumInRow]);
         addChild(_cellList);
         super.initView();
      }
   }
}
