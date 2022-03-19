// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.gametrainer.view.DropCell

package game.gametrainer.view
{
    import bagAndInfo.cell.LinkedBagCell;
    import com.pickgliss.events.InteractiveEvent;
    import bagAndInfo.cell.DragEffect;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class DropCell extends LinkedBagCell 
    {

        public function DropCell()
        {
            super(null);
            this.allowDrag = false;
            removeEventListener(InteractiveEvent.CLICK, __doubleClickHandler);
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
            dispatchEvent(new Event(Event.CHANGE));
            super.onMouseOver(_arg_1);
        }

        override protected function onMouseOut(_arg_1:MouseEvent):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            super.onMouseOut(_arg_1);
        }

        override protected function onMouseClick(_arg_1:MouseEvent):void
        {
        }

        override protected function createContentComplete():void
        {
            super.createContentComplete();
            _pic.width = 45;
            _pic.height = 46;
        }


    }
}//package game.gametrainer.view

