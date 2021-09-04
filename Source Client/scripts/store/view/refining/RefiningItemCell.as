package store.view.refining
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import store.StoreCell;
   
   public class RefiningItemCell extends StoreCell
   {
      
      public static const CONTENTSIZE:int = 62;
      
      public static const PICPOS:int = 17;
       
      
      private var _text:FilterFrameText;
      
      public function RefiningItemCell()
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.BlankCellBG");
         _loc1_.addChild(_loc2_);
         super(_loc1_,0);
         setContentSize(CONTENTSIZE,CONTENTSIZE);
         PicPos = new Point(PICPOS,PICPOS);
         this.info = info;
         DoubleClickEnabled = false;
      }
      
      public function get count() : int
      {
         return int(_tbxCount.text);
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:InventoryItemInfo = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(EquipType.REFINING_STONE)[0];
         super.info = _loc2_;
         _tbxCount.text = PlayerManager.Instance.Self.findItemCount(EquipType.REFINING_STONE).toString();
      }
      
      override public function dragStart() : void
      {
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         super.dispose();
      }
   }
}
