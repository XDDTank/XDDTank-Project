// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.list.ListDataEvent

package com.pickgliss.ui.controls.list
{
    import com.pickgliss.events.ModelEvent;

    public class ListDataEvent extends ModelEvent 
    {

        private var index0:int;
        private var index1:int;
        private var removedItems:Array;

        public function ListDataEvent(_arg_1:Object, _arg_2:int, _arg_3:int, _arg_4:Array)
        {
            super(_arg_1);
            this.index0 = _arg_2;
            this.index1 = _arg_3;
            this.removedItems = _arg_4.concat();
        }

        public function getIndex0():int
        {
            return (this.index0);
        }

        public function getIndex1():int
        {
            return (this.index1);
        }

        public function getRemovedItems():Array
        {
            return (this.removedItems.concat());
        }


    }
}//package com.pickgliss.ui.controls.list

