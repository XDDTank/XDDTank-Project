// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.closeFriend.CloseFriendListView

package platformapi.tencent.view.closeFriend
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.container.VBox;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import __AS3__.vec.*;

    public class CloseFriendListView extends Sprite implements Disposeable 
    {

        private static const MAXITEM:int = 6;

        private var _bg:Bitmap;
        private var _listView:VBox;
        private var _playerList:Array;
        private var _items:Vector.<CloseFriendItemFrame>;
        private var _selectedItem:CloseFriendItemFrame;

        public function CloseFriendListView()
        {
            this.init();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.IM.CloseFriend.listBg");
            addChild(this._bg);
            this._listView = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.vBox");
            addChild(this._listView);
            this._items = new Vector.<CloseFriendItemFrame>();
        }

        public function clearList():void
        {
            if ((!(this._items)))
            {
                return;
            };
            var _local_1:int;
            while (_local_1 < this._items.length)
            {
                this._items[_local_1].removeEventListener(MouseEvent.CLICK, this.__onItemClick);
                ObjectUtils.disposeObject(this._items[_local_1]);
                this._items[_local_1] = null;
                _local_1++;
            };
            this._items = new Vector.<CloseFriendItemFrame>();
            this._playerList = [];
            this._selectedItem = null;
        }

        public function get playerList():Array
        {
            return (this._playerList);
        }

        public function set playerList(_arg_1:Array):void
        {
            var _local_4:CloseFriendItemFrame;
            this.clearList();
            this._playerList = _arg_1;
            if (((!(this._playerList)) || (this._playerList.length == 0)))
            {
                return;
            };
            var _local_2:int = ((this._playerList.length > MAXITEM) ? MAXITEM : this._playerList.length);
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                if (!(!(this._playerList[_local_3])))
                {
                    _local_4 = new CloseFriendItemFrame();
                    _local_4.info = this._playerList[_local_3];
                    _local_4.addEventListener(MouseEvent.CLICK, this.__onItemClick);
                    this._listView.addChild(_local_4);
                    this._items.push(_local_4);
                    if (_local_3 == 0)
                    {
                        this.selectedItem = _local_4;
                    };
                };
                _local_3++;
            };
        }

        private function __onItemClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:CloseFriendItemFrame = (_arg_1.currentTarget as CloseFriendItemFrame);
            if ((!(_local_2.selected)))
            {
                this.selectedItem = _local_2;
            };
        }

        public function get selectedItem():CloseFriendItemFrame
        {
            return (this._selectedItem);
        }

        public function set selectedItem(_arg_1:CloseFriendItemFrame):void
        {
            var _local_2:CloseFriendItemFrame;
            if (this._selectedItem != _arg_1)
            {
                _local_2 = this._selectedItem;
                this._selectedItem = _arg_1;
                if (this._selectedItem)
                {
                    this._selectedItem.selected = true;
                };
                if (_local_2)
                {
                    _local_2.selected = false;
                };
            };
        }

        public function dispose():void
        {
            this.clearList();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            if (this._listView)
            {
                this._listView.dispose();
            };
            this._listView = null;
            if (this.selectedItem)
            {
                this.selectedItem.dispose();
            };
            this.selectedItem = null;
            this._items = null;
        }


    }
}//package platformapi.tencent.view.closeFriend

