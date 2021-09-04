package SingleDungeon.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.MapManager;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DropList extends Component
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _list:SimpleTileList;
      
      private var _cells:Array;
      
      private var _scrollPanelRect:Rectangle;
      
      public function DropList()
      {
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("singledungeon.dropListBg");
         addChild(this._bg);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("singledungeon.dropListPanel");
         this._scrollPanel.vScrollProxy = ScrollPanel.ON;
         this._scrollPanel.hScrollProxy = ScrollPanel.OFF;
         addChild(this._scrollPanel);
         this._scrollPanelRect = ComponentFactory.Instance.creatCustomObject("singledungeon.dropList.scrollPanelRect");
         this._list = new SimpleTileList(6);
         this._list.hSpace = 3;
         this._list.vSpace = 3;
         this._cells = [];
      }
      
      public function updateList(param1:int) : void
      {
         var _loc2_:DungeonInfo = MapManager.getDungeonInfo(param1);
         if(_loc2_)
         {
            this.info = _loc2_.NormalTemplateIds.split(",");
         }
         else
         {
            this.removeChild(this._scrollPanel);
         }
      }
      
      public function set info(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:BaseCell = null;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:BaseCell = null;
         while(this._cells.length > 0)
         {
            _loc4_ = this._cells.shift();
            _loc4_.dispose();
         }
         var _loc2_:Rectangle = ComponentFactory.Instance.creatCustomObject("singledungeon.dropList.cellRect");
         for each(_loc3_ in param1)
         {
            _loc5_ = ItemManager.Instance.getTemplateById(_loc3_);
            _loc6_ = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.singleDungeon.dropCellBgAsset"),_loc5_);
            _loc6_.overBg = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.dropCellOverBgAsset");
            _loc6_.setContentSize(_loc2_.width,_loc2_.height);
            _loc6_.PicPos = new Point(_loc2_.x,_loc2_.y);
            this._list.addChild(_loc6_);
            this._cells.push(_loc6_);
         }
         this._scrollPanel.setView(this._list);
         this._scrollPanel.height = this._scrollPanelRect.height;
         this._scrollPanel.width = this._scrollPanelRect.width;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         while(this._cells && this._cells.length > 0)
         {
            ObjectUtils.disposeObject(this._cells.pop());
         }
         this._cells = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
