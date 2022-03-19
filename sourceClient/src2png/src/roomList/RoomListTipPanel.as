// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.RoomListTipPanel

package roomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.display.Bitmap;
    import flash.events.Event;

    public class RoomListTipPanel extends Sprite implements Disposeable 
    {

        public static const HARD_LV_CHANGE:String = "hardLvChange";

        private var _bg:Scale9CornerImage;
        private var _list:VBox;
        private var _itemArray:Array;
        private var _cellWidth:int;
        private var _cellheight:int;
        private var _value:int;

        public function RoomListTipPanel(_arg_1:int, _arg_2:int)
        {
            this._cellWidth = _arg_1;
            this._cellheight = _arg_2;
            super();
            this.init();
        }

        public function get value():int
        {
            return (this._value);
        }

        public function resetValue():void
        {
            this._value = LookupEnumerate.DUNGEON_LIST_ALL;
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creat("asset.ddtroomList.RoomList.tipItemBg");
            this._bg.width = this._cellWidth;
            this._bg.height = 0;
            addChild(this._bg);
            this._list = new VBox();
            addChild(this._list);
            this._itemArray = [];
        }

        public function addItem(_arg_1:Bitmap, _arg_2:int):void
        {
            var _local_3:TipItemView = new TipItemView(_arg_1, _arg_2, this._cellWidth, this._cellheight);
            _local_3.addEventListener(MouseEvent.CLICK, this.__itemClick);
            this._list.addChild(_local_3);
            this._itemArray.push(_local_3);
            this._bg.height = (this._bg.height + (this._cellheight + 1));
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            this._value = (_arg_1.target as TipItemView).value;
            dispatchEvent(new Event(HARD_LV_CHANGE));
            this.visible = false;
        }

        private function cleanItem():void
        {
            var _local_1:int;
            while (_local_1 < this._itemArray.length)
            {
                (this._itemArray[_local_1] as TipItemView).removeEventListener(MouseEvent.CLICK, this.__itemClick);
                (this._itemArray[_local_1] as TipItemView).dispose();
                _local_1++;
            };
            this._itemArray = [];
        }

        public function dispose():void
        {
            this.cleanItem();
            if (((this._list) && (this._list.parent)))
            {
                this._list.parent.removeChild(this._list);
                this._list.dispose();
                this._list = null;
            };
            if (((this._bg) && (this._bg.parent)))
            {
                this._bg.parent.removeChild(this._bg);
                this._bg.dispose();
                this._bg = null;
            };
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package roomList

