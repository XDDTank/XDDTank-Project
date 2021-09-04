package store.view.split
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   
   public class SplitMaterialCell extends BaseCell
   {
       
      
      private var _countText:FilterFrameText;
      
      private var _count:int;
      
      public function SplitMaterialCell()
      {
         super(ComponentFactory.Instance.creatBitmap("asset.ddtstore.materialCellBg"));
         this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.splitView.countText");
         addChild(this._countText);
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
         if(param1 == 0)
         {
            this._countText.visible = false;
         }
         else
         {
            this._countText.visible = true;
            this._countText.text = param1.toString();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._countText)
         {
            ObjectUtils.disposeObject(this._countText);
         }
         this._countText = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
