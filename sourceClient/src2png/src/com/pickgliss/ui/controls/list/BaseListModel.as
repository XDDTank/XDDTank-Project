// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.list.BaseListModel

package com.pickgliss.ui.controls.list
{
    import com.pickgliss.utils.ArrayUtils;

    public class BaseListModel 
    {

        private var listeners:Array;

        public function BaseListModel()
        {
            this.listeners = new Array();
        }

        public function addListDataListener(_arg_1:ListDataListener):void
        {
            this.listeners.push(_arg_1);
        }

        public function removeListDataListener(_arg_1:ListDataListener):void
        {
            ArrayUtils.removeFromArray(this.listeners, _arg_1);
        }

        protected function fireContentsChanged(_arg_1:Object, _arg_2:int, _arg_3:int, _arg_4:Array):void
        {
            var _local_7:ListDataListener;
            var _local_5:ListDataEvent = new ListDataEvent(_arg_1, _arg_2, _arg_3, _arg_4);
            var _local_6:int = (this.listeners.length - 1);
            while (_local_6 >= 0)
            {
                _local_7 = ListDataListener(this.listeners[_local_6]);
                _local_7.contentsChanged(_local_5);
                _local_6--;
            };
        }

        protected function fireIntervalAdded(_arg_1:Object, _arg_2:int, _arg_3:int):void
        {
            var _local_6:ListDataListener;
            var _local_4:ListDataEvent = new ListDataEvent(_arg_1, _arg_2, _arg_3, []);
            var _local_5:int = (this.listeners.length - 1);
            while (_local_5 >= 0)
            {
                _local_6 = ListDataListener(this.listeners[_local_5]);
                _local_6.intervalAdded(_local_4);
                _local_5--;
            };
        }

        protected function fireIntervalRemoved(_arg_1:Object, _arg_2:int, _arg_3:int, _arg_4:Array):void
        {
            var _local_7:ListDataListener;
            var _local_5:ListDataEvent = new ListDataEvent(_arg_1, _arg_2, _arg_3, _arg_4);
            var _local_6:int = (this.listeners.length - 1);
            while (_local_6 >= 0)
            {
                _local_7 = ListDataListener(this.listeners[_local_6]);
                _local_7.intervalRemoved(_local_5);
                _local_6--;
            };
        }


    }
}//package com.pickgliss.ui.controls.list

