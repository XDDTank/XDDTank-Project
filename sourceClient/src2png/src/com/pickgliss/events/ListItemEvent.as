// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.events.ListItemEvent

package com.pickgliss.events
{
    import flash.events.Event;
    import com.pickgliss.ui.controls.cell.IListCell;

    public class ListItemEvent extends Event 
    {

        public static const LIST_ITEM_CLICK:String = "listItemClick";
        public static const LIST_ITEM_DOUBLE_CLICK:String = "listItemDoubleclick";
        public static const LIST_ITEM_MOUSE_DOWN:String = "listItemMouseDown";
        public static const LIST_ITEM_MOUSE_UP:String = "listItemMouseUp";
        public static const LIST_ITEM_ROLL_OVER:String = "listItemRollOver";
        public static const LIST_ITEM_ROLL_OUT:String = "listItemRollOut";

        public var cell:IListCell;
        public var cellValue:*;
        public var index:int;

        public function ListItemEvent(_arg_1:IListCell, _arg_2:*, _arg_3:String, _arg_4:int)
        {
            this.cell = _arg_1;
            this.cellValue = _arg_2;
            this.index = _arg_4;
            super(_arg_3);
        }

    }
}//package com.pickgliss.events

