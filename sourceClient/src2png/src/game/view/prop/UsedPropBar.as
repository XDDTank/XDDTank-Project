// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.UsedPropBar

package game.view.prop
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObjectContainer;
    import game.model.Living;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import ddt.events.LivingEvent;

    public class UsedPropBar extends Sprite implements Disposeable 
    {

        private var _container:DisplayObjectContainer;
        private var _living:Living;
        private var _cells:Vector.<DisplayObject>;


        private function clearCells():void
        {
        }

        public function setInfo(_arg_1:Living):void
        {
            this.clearCells();
            var _local_2:Living = this._living;
            this._living = this._living;
            this.addEventToLiving(this._living);
            if (_local_2 != null)
            {
                this.removeEventFromLiving(_local_2);
            };
        }

        private function addEventToLiving(_arg_1:Living):void
        {
            _arg_1.addEventListener(LivingEvent.USING_ITEM, this.__usingItem);
        }

        private function __usingItem(_arg_1:LivingEvent):void
        {
        }

        private function removeEventFromLiving(_arg_1:Living):void
        {
            _arg_1.removeEventListener(LivingEvent.USING_ITEM, this.__usingItem);
        }

        public function dispose():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.prop

