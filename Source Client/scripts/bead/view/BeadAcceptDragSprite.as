package bead.view
{
   import bagAndInfo.cell.DragEffect;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import flash.display.Sprite;
   
   public class BeadAcceptDragSprite extends Sprite implements IAcceptDrag
   {
       
      
      public function BeadAcceptDragSprite()
      {
         super();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         DragManager.acceptDrag(this,DragEffect.NONE);
      }
   }
}
