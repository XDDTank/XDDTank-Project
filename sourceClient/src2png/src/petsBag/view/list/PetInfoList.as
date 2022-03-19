// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.list.PetInfoList

package petsBag.view.list
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.container.VBox;
    import flash.display.Bitmap;
    import __AS3__.vec.Vector;
    import petsBag.view.item.PetSelectItem;
    import pet.date.PetInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import petsBag.event.PetItemEvent;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PetInfoList extends Sprite implements Disposeable 
    {

        public static const MIN_COUNT:int = 7;

        private var _list:VBox;
        private var _fightFlag:Bitmap;
        private var _itemList:Vector.<PetSelectItem>;
        private var _count:int;
        private var _items:Vector.<PetInfo>;
        private var _selectedIndex:int;

        public function PetInfoList(_arg_1:int)
        {
            this._count = ((_arg_1 < MIN_COUNT) ? MIN_COUNT : _arg_1);
            this.init();
        }

        protected function init():void
        {
            this._list = ComponentFactory.Instance.creat("petsBag.view.list.petInfoList.vbox");
            addChild(this._list);
            this._fightFlag = ComponentFactory.Instance.creat("asset.petsBag.petInfoList.fightFlag");
            this._fightFlag.visible = false;
            addChild(this._fightFlag);
            this._itemList = new Vector.<PetSelectItem>();
        }

        protected function clearItems():void
        {
            var _local_1:PetSelectItem;
            while (((this._itemList) && (this._itemList.length > 0)))
            {
                _local_1 = this._itemList.shift();
                _local_1.removeEventListener(MouseEvent.CLICK, this.__click);
                if (this._list.contains(_local_1))
                {
                    this._list.removeChild(_local_1);
                };
                _local_1.dispose();
            };
            this._itemList = null;
        }

        protected function __click(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            var _local_2:PetSelectItem = (_arg_1.currentTarget as PetSelectItem);
            if (_local_2.info)
            {
                SoundManager.instance.play("008");
                this.selectedIndex = _local_2.index;
            };
        }

        public function get items():Vector.<PetInfo>
        {
            return (this._items);
        }

        public function set items(_arg_1:Vector.<PetInfo>):void
        {
            var _local_2:int;
            var _local_3:PetSelectItem;
            var _local_4:PetInfo;
            this._items = _arg_1;
            this._count = Math.max(this._count, this.items.length);
            if (this._itemList.length < this._count)
            {
                _local_2 = this._itemList.length;
                while (_local_2 < this._count)
                {
                    _local_3 = new PetSelectItem(_local_2);
                    _local_3.addEventListener(MouseEvent.CLICK, this.__click);
                    this._list.addChild(_local_3);
                    this._itemList.push(_local_3);
                    _local_2++;
                };
            };
            this._fightFlag.visible = false;
            _local_2 = 0;
            while (_local_2 < this._count)
            {
                _local_4 = ((_local_2 < this._items.length) ? this._items[_local_2] : null);
                if (((_local_4) && (_local_4.Place == 0)))
                {
                    this._fightFlag.visible = true;
                    this._fightFlag.x = (this._itemList[_local_2].x + 85);
                    this._fightFlag.y = (this._itemList[_local_2].y - -2);
                };
                this._itemList[_local_2].info = ((_local_2 < this._items.length) ? this._items[_local_2] : null);
                _local_2++;
            };
        }

        public function get selectedIndex():int
        {
            return (this._selectedIndex);
        }

        public function set selectedIndex(_arg_1:int):void
        {
            var _local_2:PetSelectItem;
            this._selectedIndex = _arg_1;
            for each (_local_2 in this._itemList)
            {
                _local_2.selected = (this._selectedIndex == _local_2.index);
            };
            dispatchEvent(new PetItemEvent(PetItemEvent.ITEM_CHANGE, this._itemList[this._selectedIndex].info));
        }

        public function dispose():void
        {
            this.clearItems();
            ObjectUtils.disposeObject(this._list);
            this._list = null;
            ObjectUtils.disposeObject(this._fightFlag);
            this._fightFlag = null;
            if (this._items)
            {
                this._items.length = 0;
            };
            this._items = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package petsBag.view.list

