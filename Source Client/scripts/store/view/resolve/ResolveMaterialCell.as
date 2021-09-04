package store.view.resolve
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   
   public class ResolveMaterialCell extends BaseCell
   {
       
      
      public function ResolveMaterialCell(param1:ItemTemplateInfo)
      {
         super(ComponentFactory.Instance.creatBitmap("asset.ddtstore.ComposeView.itemCellBg"),param1);
         _info = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
