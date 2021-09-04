package bead.view
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class BeadLockBtn extends BaseButton implements IDragable
   {
       
      
      public function BeadLockBtn()
      {
         super();
      }
      
      public function dragStart(param1:Number, param2:Number) : void
      {
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon");
         DragManager.startDrag(this,this,_loc3_,param1,param2,DragEffect.MOVE,false);
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
         if(param1.target is BeadCell)
         {
            (param1.target as BeadCell).changeLockStatus();
         }
      }
   }
}
