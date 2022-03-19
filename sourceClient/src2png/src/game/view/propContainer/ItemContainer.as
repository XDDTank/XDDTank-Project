// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.propContainer.ItemContainer

package game.view.propContainer
{
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import bagAndInfo.bag.ItemCellView;
    import ddt.events.ItemEvent;
    import flash.display.DisplayObject;
    import ddt.data.PropInfo;
    import ddt.view.PropItemView;

    [Event(name="itemClick", type="ddt.events.ItemEvent")]
    [Event(name="itemOver", type="ddt.events.ItemEvent")]
    [Event(name="itemOut", type="ddt.events.ItemEvent")]
    [Event(name="itemMove", type="ddt.events.ItemEvent")]
    public class ItemContainer extends SimpleTileList 
    {

        public static var USE_THREE:String = "use_threeSkill";
        public static var PLANE:int = 1;
        public static var THREE_SKILL:int = 2;
        public static var BOTH:int = 3;

        private var list:Array;
        private var _ordinal:Boolean;
        private var _clickAble:Boolean;

        public function ItemContainer(_arg_1:Number, _arg_2:Number=1, _arg_3:Boolean=true, _arg_4:Boolean=false, _arg_5:Boolean=false, _arg_6:String="")
        {
            var _local_8:ItemCellView;
            super(_arg_2);
            vSpace = 4;
            hSpace = 6;
            this.list = new Array();
            var _local_7:int;
            while (_local_7 < _arg_1)
            {
                _local_8 = new ItemCellView(_local_7, null, false, _arg_6);
                _local_8.addEventListener(ItemEvent.ITEM_CLICK, this.__itemClick);
                _local_8.addEventListener(ItemEvent.ITEM_OVER, this.__itemOver);
                _local_8.addEventListener(ItemEvent.ITEM_OUT, this.__itemOut);
                _local_8.addEventListener(ItemEvent.ITEM_MOVE, this.__itemMove);
                addChild(_local_8);
                this.list.push(_local_8);
                _local_7++;
            };
            this._clickAble = _arg_5;
            this._ordinal = _arg_4;
        }

        public function setState(_arg_1:Boolean, _arg_2:Boolean):void
        {
            this._clickAble = _arg_1;
            this.setItemState(_arg_1, _arg_2);
        }

        public function get clickAble():Boolean
        {
            return (this._clickAble);
        }

        public function appendItem(_arg_1:DisplayObject):void
        {
            var _local_2:ItemCellView;
            for each (_local_2 in this.list)
            {
                if (_local_2.item == null)
                {
                    _local_2.setItem(_arg_1, false);
                    return;
                };
            };
        }

        public function get blankItems():Array
        {
            var _local_3:ItemCellView;
            var _local_1:Array = [];
            var _local_2:int;
            for each (_local_3 in this.list)
            {
                if (_local_3.item == null)
                {
                    _local_1.push(_local_2);
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function mouseClickAt(_arg_1:int):void
        {
            this.list[_arg_1].mouseClick();
        }

        private function __itemClick(_arg_1:ItemEvent):void
        {
            this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK, _arg_1.item, _arg_1.index));
        }

        private function __itemOver(_arg_1:ItemEvent):void
        {
            this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_OVER, _arg_1.item, _arg_1.index));
        }

        private function __itemOut(_arg_1:ItemEvent):void
        {
            this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_OUT, _arg_1.item, _arg_1.index));
        }

        private function __itemMove(_arg_1:ItemEvent):void
        {
            this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_MOVE, _arg_1.item, _arg_1.index));
        }

        public function appendItemAt(_arg_1:DisplayObject, _arg_2:int):void
        {
            var _local_3:ItemCellView;
            var _local_4:int;
            if (this._ordinal)
            {
                _local_3 = (this.list[(this.list.length - 1)] as ItemCellView);
                _local_4 = _arg_2;
                while (_local_4 < (this.list.length - 1))
                {
                    this.list[(_local_4 + 1)] = this.list[_local_4];
                    _local_4++;
                };
                this.list[_arg_2] = _local_3;
                _local_3.setItem(_arg_1, false);
            }
            else
            {
                _local_3 = this.list[_arg_2];
                _local_3.setItem(_arg_1, false);
            };
        }

        public function removeItem(_arg_1:DisplayObject):void
        {
            var _local_3:ItemCellView;
            var _local_2:int;
            while (_local_2 < this.list.length)
            {
                _local_3 = this.list[_local_2];
                if (_local_3.item == _arg_1)
                {
                    removeChild(_local_3);
                };
                _local_2++;
            };
        }

        public function removeItemAt(_arg_1:int):void
        {
            var _local_2:ItemCellView = this.list[_arg_1];
            _local_2.setItem(null, false);
            if (this._ordinal)
            {
                this.list.splice(_arg_1, 1);
                removeChild(_local_2);
                this.list.push(_local_2);
            };
        }

        public function clear():void
        {
            var _local_1:ItemCellView;
            for each (_local_1 in this.list)
            {
                _local_1.setItem(null, false);
            };
        }

        public function setItemClickAt(_arg_1:int, _arg_2:Boolean, _arg_3:Boolean):void
        {
            this.list[_arg_1].setClick(_arg_2, _arg_3, false);
        }

        public function disableCellIndex(_arg_1:int):void
        {
            this.list[_arg_1].disable();
        }

        public function disableSelfProp(_arg_1:int):void
        {
            var _local_2:ItemCellView;
            var _local_3:PropInfo;
            for each (_local_2 in this.list)
            {
                if (_local_2.item)
                {
                    _local_3 = PropItemView(_local_2.item).info;
                    if (((_local_3.Template.TemplateID == 10016) && ((_arg_1 == 1) || (_arg_1 == 3))))
                    {
                        _local_2.disable();
                    }
                    else
                    {
                        if (((_local_3.Template.TemplateID == 10003) && ((_arg_1 == 2) || (_arg_1 == 3))))
                        {
                            _local_2.disable();
                        };
                    };
                };
            };
        }

        public function disableCellArr():void
        {
            var _local_1:ItemCellView;
            for each (_local_1 in this.list)
            {
                _local_1.disable();
            };
        }

        public function setNoClickAt(_arg_1:int):void
        {
            this.list[_arg_1].setNoEnergyAsset();
        }

        private function setItemState(_arg_1:Boolean, _arg_2:Boolean):void
        {
            var _local_3:ItemCellView;
            var _local_4:Boolean;
            for each (_local_3 in this.list)
            {
                _local_4 = false;
                if (PropItemView(_local_3.item) != null)
                {
                    _local_4 = PropItemView(_local_3.item).isExist;
                };
                _local_3.setClick(_arg_1, _arg_2, _local_4);
            };
        }

        public function setClickByEnergy(_arg_1:int):void
        {
            var _local_2:ItemCellView;
            var _local_3:PropInfo;
            for each (_local_2 in this.list)
            {
                if (_local_2.item)
                {
                    _local_3 = PropItemView(_local_2.item).info;
                    if (_local_3)
                    {
                        if (_arg_1 < _local_3.needEnergy)
                        {
                            _local_2.setClick(true, true, PropItemView(_local_2.item).isExist);
                        };
                    };
                };
            };
        }

        public function setVisible(_arg_1:int, _arg_2:Boolean):void
        {
            this.list[_arg_1].visible = _arg_2;
        }

        override public function dispose():void
        {
            var _local_1:ItemCellView;
            super.dispose();
            while (this.list.length > 0)
            {
                _local_1 = (this.list.shift() as ItemCellView);
                _local_1.dispose();
            };
            this.list = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.propContainer

