package petsBag.view.space
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   public class PetSpaceBagCell extends BagCell
   {
       
      
      private var _selected:Boolean;
      
      private var _mask:Shape;
      
      public function PetSpaceBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         super(param1,param2,_showLoading,param4,param5);
         this._mask = new Shape();
         this._mask.graphics.beginFill(0,0.3);
         this._mask.graphics.drawRect(0,0,width - 3,height - 3);
      }
      
      override public function dragStart() : void
      {
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._mask);
         this._mask = null;
         super.dispose();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(this._selected)
         {
            addChild(this._mask);
         }
         else if(this._mask.parent)
         {
            this._mask.parent.removeChild(this._mask);
         }
         updateBgVisible(_cellMouseOverFormer && _cellMouseOverFormer.visible);
      }
   }
}
