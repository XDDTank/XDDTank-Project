// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadAcceptDragSprite

package bead.view
{
    import flash.display.Sprite;
    import ddt.interfaces.IAcceptDrag;
    import ddt.manager.DragManager;
    import bagAndInfo.cell.DragEffect;

    public class BeadAcceptDragSprite extends Sprite implements IAcceptDrag 
    {


        public function dragDrop(_arg_1:DragEffect):void
        {
            DragManager.acceptDrag(this, DragEffect.NONE);
        }


    }
}//package bead.view

