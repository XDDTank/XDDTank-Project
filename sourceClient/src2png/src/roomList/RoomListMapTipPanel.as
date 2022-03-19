// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.RoomListMapTipPanel

package roomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.UICreatShortcut;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class RoomListMapTipPanel extends Sprite implements Disposeable 
    {

        public static const FB_CHANGE:String = "fbChange";

        private var _bg:Scale9CornerImage;
        private var _listContent:VBox;
        private var _itemArray:Array;
        private var _cellWidth:int;
        private var _cellheight:int;
        private var _list:ScrollPanel;
        private var _value:int;

        public function RoomListMapTipPanel(_arg_1:int, _arg_2:int)
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
            this._value = 10000;
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creat("asset.ddtroomList.RoomList.tipItemBg");
            this._bg.width = this._cellWidth;
            this._bg.height = 0;
            addChild(this._bg);
            this._listContent = new VBox();
            this._itemArray = [];
            this._list = UICreatShortcut.creatAndAdd("asset.ddtroomList.RoomListMapTipPanel.SrollPanel", this);
            this._list.setView(this._listContent);
        }

        public function addItem(_arg_1:int):void
        {
            var _local_2:MapItemView = new MapItemView(_arg_1, this._cellWidth, this._cellheight);
            _local_2.addEventListener(MouseEvent.CLICK, this.__itemClick);
            this._listContent.addChild(_local_2);
            this._itemArray.push(_local_2);
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.RoomListMapTipPanel.BGSize");
            this._bg.width = _local_3.x;
            this._bg.height = _local_3.y;
            this._list.invalidateViewport();
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._value = (_arg_1.target as MapItemView).id;
            dispatchEvent(new Event(FB_CHANGE));
            this.visible = false;
        }

        private function cleanItem():void
        {
            var _local_1:int;
            while (_local_1 < this._itemArray.length)
            {
                (this._itemArray[_local_1] as MapItemView).removeEventListener(MouseEvent.CLICK, this.__itemClick);
                (this._itemArray[_local_1] as MapItemView).dispose();
                _local_1++;
            };
            this._itemArray = [];
        }

        public function dispose():void
        {
            this.cleanItem();
            ObjectUtils.disposeObject(this._listContent);
            this._listContent = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._list);
            this._list = null;
        }


    }
}//package roomList

