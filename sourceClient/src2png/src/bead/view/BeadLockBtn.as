// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadLockBtn

package bead.view
{
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.interfaces.IDragable;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import ddt.manager.DragManager;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.SoundManager;

    public class BeadLockBtn extends BaseButton implements IDragable 
    {


        public function dragStart(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon");
            DragManager.startDrag(this, this, _local_3, _arg_1, _arg_2, DragEffect.MOVE, false);
        }

        public function getSource():IDragable
        {
            return (this);
        }

        public function dragStop(_arg_1:DragEffect):void
        {
            SoundManager.instance.play("008");
            if ((_arg_1.target is BeadCell))
            {
                (_arg_1.target as BeadCell).changeLockStatus();
            };
        }


    }
}//package bead.view

