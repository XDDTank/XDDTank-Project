// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//civil.view.CivilPlayerInfoList

package civil.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.container.VBox;
    import civil.CivilModel;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.player.CivilPlayerInfo;
    import civil.CivilEvent;
    import ddt.manager.SoundManager;
    import __AS3__.vec.*;

    public class CivilPlayerInfoList extends Sprite implements Disposeable 
    {

        private static const MAXITEM:int = 11;

        private var _currentItem:CivilPlayerItemFrame;
        private var _items:Vector.<CivilPlayerItemFrame>;
        private var _infoItems:Array;
        private var _list:VBox;
        private var _model:CivilModel;
        private var _selectedItem:CivilPlayerItemFrame;

        public function CivilPlayerInfoList()
        {
            this.init();
            this.addEvent();
        }

        private function init():void
        {
            this._infoItems = [];
            this._list = ComponentFactory.Instance.creatComponentByStylename("civil.memberList");
            addChild(this._list);
            this._items = new Vector.<CivilPlayerItemFrame>();
        }

        public function MemberList(_arg_1:Array):void
        {
            var _local_4:CivilPlayerItemFrame;
            this.clearList();
            if (((!(_arg_1)) || (_arg_1.length == 0)))
            {
                return;
            };
            var _local_2:int = ((_arg_1.length > MAXITEM) ? MAXITEM : _arg_1.length);
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = new CivilPlayerItemFrame(_local_3);
                _local_4.info = _arg_1[_local_3];
                _local_4.addEventListener(MouseEvent.CLICK, this.__onItemClick);
                this._list.addChild(_local_4);
                this._items.push(_local_4);
                if (_local_3 == 0)
                {
                    this.selectedItem = _local_4;
                };
                _local_3++;
            };
        }

        public function clearList():void
        {
            var _local_1:int;
            while (_local_1 < this._items.length)
            {
                this._items[_local_1].removeEventListener(MouseEvent.CLICK, this.__onItemClick);
                ObjectUtils.disposeObject(this._items[_local_1]);
                this._items[_local_1] = null;
                _local_1++;
            };
            this._items = new Vector.<CivilPlayerItemFrame>();
            this._selectedItem = null;
            this._currentItem = null;
            this._infoItems = [];
        }

        public function upItem(_arg_1:CivilPlayerInfo):void
        {
            var _local_3:CivilPlayerItemFrame;
            var _local_2:int;
            while (_local_2 < this._items.length)
            {
                _local_3 = (this._items[_local_2] as CivilPlayerItemFrame);
                if (_local_3.info.info.ID == _arg_1.info.ID)
                {
                    _local_3.info = _arg_1;
                    return;
                };
                _local_2++;
            };
        }

        private function addEvent():void
        {
        }

        private function removeEvent():void
        {
            if (this._model)
            {
                if (this._model.hasEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE))
                {
                    this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE, this.__civilListHandle);
                };
            };
        }

        private function __civilListHandle(_arg_1:CivilEvent):void
        {
            var _local_4:int;
            var _local_5:CivilPlayerItemFrame;
            if (this._model.civilPlayers == null)
            {
                return;
            };
            this.clearList();
            var _local_2:Array = this._model.civilPlayers;
            var _local_3:int = ((_local_2.length > MAXITEM) ? MAXITEM : _local_2.length);
            if (_local_3 <= 0)
            {
                this.selectedItem = null;
            }
            else
            {
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _local_5 = new CivilPlayerItemFrame(_local_4);
                    _local_5.info = _local_2[_local_4];
                    this._list.addChild(_local_5);
                    this._items.push(_local_5);
                    if (_local_4 == 0)
                    {
                        this.selectedItem = _local_5;
                    };
                    _local_5.addEventListener(MouseEvent.CLICK, this.__onItemClick);
                    _local_4++;
                };
            };
        }

        private function __onItemClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:CivilPlayerItemFrame = (_arg_1.currentTarget as CivilPlayerItemFrame);
            if ((!(_local_2.selected)))
            {
                this.selectedItem = _local_2;
            };
        }

        public function get selectedItem():CivilPlayerItemFrame
        {
            return (this._selectedItem);
        }

        public function set selectedItem(_arg_1:CivilPlayerItemFrame):void
        {
            var _local_2:CivilPlayerItemFrame;
            if (this._selectedItem != _arg_1)
            {
                _local_2 = this._selectedItem;
                this._selectedItem = _arg_1;
                if (this._selectedItem)
                {
                    this._selectedItem.selected = true;
                    this._model.currentcivilItemInfo = this._selectedItem.info;
                }
                else
                {
                    this._model.currentcivilItemInfo = null;
                };
                if (_local_2)
                {
                    _local_2.selected = false;
                };
                dispatchEvent(new CivilEvent(CivilEvent.SELECTED_CHANGE, _arg_1));
            };
        }

        public function get model():CivilModel
        {
            return (this._model);
        }

        public function set model(_arg_1:CivilModel):void
        {
            if (this._model != _arg_1)
            {
                if (this._model)
                {
                    this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE, this.__civilListHandle);
                };
                this._model = _arg_1;
                if (this._model)
                {
                    this._model.addEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE, this.__civilListHandle);
                };
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            this.clearList();
            if (this._list)
            {
                this._list.dispose();
                this._list = null;
            };
            if (this._currentItem)
            {
                this._currentItem.dispose();
            };
            this._currentItem = null;
            this.model = null;
            this._infoItems = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package civil.view

