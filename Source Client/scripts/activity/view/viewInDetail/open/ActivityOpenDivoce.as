package activity.view.viewInDetail.open
{
   import activity.view.ActivityCell;
   import activity.view.viewInDetail.ActivityBaseDetailView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   
   public class ActivityOpenDivoce extends ActivityBaseDetailView
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      public function ActivityOpenDivoce()
      {
         super();
      }
      
      override public function setCellFilter(param1:ActivityCell, param2:int) : void
      {
         if(!canAcceptByRecieveNum)
         {
            param1.canGet = false;
            param1.hasGet = true;
         }
      }
      
      override protected function initView() : void
      {
         _cellNumInRow = 4;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcalendar.ActivityChurchCell.bg");
         addChild(this._bg);
         _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenDivoce.cellList",[_cellNumInRow]);
         addChild(_cellList);
         _panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityOpenDivoce.cellPanel");
         addChild(_panel);
         _panel.setView(_cellList);
         super.initView();
      }
      
      override protected function initCells() : void
      {
         var _loc1_:ActivityCell = null;
         var _loc2_:int = 0;
         while(_loc2_ < _rewars.length)
         {
            _loc1_ = new ActivityCell(_rewars.list[_loc2_],true,ComponentFactory.Instance.creatBitmap("ddtcalendar.exchange.cellBgI"));
            _loc1_.count = _rewars.list[_loc2_].Count;
            _cellList.addChild(_loc1_);
            if(_loc2_ >= conditions.length)
            {
               this.setCellFilter(_loc1_,conditions[0]);
            }
            else
            {
               this.setCellFilter(_loc1_,conditions[_loc2_]);
            }
            _loc2_++;
         }
         if(_cellList.numChildren == 1)
         {
            this._bg.width = 126;
            this._bg.height = 89;
            this._bg.x = -46;
            this._bg.y = 44;
            _panel.x = -12;
            _panel.y = 44;
         }
         else if(_cellList.numChildren == 2)
         {
            this._bg.width = 226;
            this._bg.height = 89;
            this._bg.x = -98;
            this._bg.y = 42;
            _panel.x = -48;
            _panel.y = 42;
         }
         else if(_cellList.numChildren == 3)
         {
            this._bg.width = 226;
            this._bg.height = 89;
            this._bg.x = -98;
            this._bg.y = 42;
            _panel.x = -76;
            _panel.y = 42;
         }
         else
         {
            this._bg.width = 286;
            this._bg.height = 107;
            this._bg.x = -99;
            this._bg.y = 38;
         }
         _panel.vScrollProxy = _cellList.numChildren > _cellNumInRow ? int(0) : int(2);
      }
      
      override public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         super.dispose();
      }
   }
}
