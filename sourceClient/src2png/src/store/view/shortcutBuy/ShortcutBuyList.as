// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.shortcutBuy.ShortcutBuyList

package store.view.shortcutBuy
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ShortcutBuyList extends Sprite implements Disposeable 
    {

        private var _list:SimpleTileList;
        private var _cells:Vector.<ShortcutBuyCell>;
        private var _cow:int;


        public function setup(_arg_1:Array):void
        {
            this._cow = Math.ceil((_arg_1.length / 4));
            this.init();
            this.createCells(_arg_1);
        }

        private function init():void
        {
            this._cells = new Vector.<ShortcutBuyCell>();
            this._list = new SimpleTileList(4);
            this._list.hSpace = 30;
            this._list.vSpace = 40;
            addChild(this._list);
        }

        override public function get height():Number
        {
            return (this._list.height);
        }

        private function createCells(_arg_1:Array):void
        {
            var _local_3:ItemTemplateInfo;
            var _local_4:ShortcutBuyCell;
            this._list.beginChanges();
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = ItemManager.Instance.getTemplateById(_arg_1[_local_2]);
                _local_4 = new ShortcutBuyCell(_local_3);
                _local_4.info = _local_3;
                _local_4.addEventListener(MouseEvent.CLICK, this.cellClickHandler);
                _local_4.buttonMode = true;
                _local_4.showBg();
                this._list.addChild(_local_4);
                this._cells.push(_local_4);
                _local_2++;
            };
            this._list.commitChanges();
        }

        public function shine():void
        {
            var _local_1:ShortcutBuyCell;
            for each (_local_1 in this._cells)
            {
                _local_1.hideBg();
                _local_1.startShine();
            };
        }

        public function noShine():void
        {
            var _local_1:ShortcutBuyCell;
            for each (_local_1 in this._cells)
            {
                _local_1.stopShine();
                _local_1.showBg();
            };
        }

        private function cellClickHandler(_arg_1:MouseEvent):void
        {
            var _local_2:ShortcutBuyCell;
            SoundManager.instance.play("008");
            for each (_local_2 in this._cells)
            {
                _local_2.selected = false;
                this.noShine();
            };
            ShortcutBuyCell(_arg_1.currentTarget).selected = true;
            dispatchEvent(new Event(Event.SELECT));
        }

        public function get selectedItemID():int
        {
            var _local_1:ShortcutBuyCell;
            for each (_local_1 in this._cells)
            {
                if (_local_1.selected)
                {
                    return (_local_1.info.TemplateID);
                };
            };
            return (-1);
        }

        public function set selectedItemID(_arg_1:int):void
        {
            var _local_2:ShortcutBuyCell;
            for each (_local_2 in this._cells)
            {
                if (_local_2.info.TemplateID == _arg_1)
                {
                    _local_2.selected = true;
                    return;
                };
            };
        }

        public function set selectedIndex(_arg_1:int):void
        {
            var _local_3:int;
            var _local_2:int = this._cells.length;
            if (((_arg_1 >= 0) && (_arg_1 < _local_2)))
            {
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    if (_local_3 == _arg_1)
                    {
                        this._cells[_local_3].selected = true;
                    }
                    else
                    {
                        this._cells[_local_3].selected = false;
                    };
                    _local_3++;
                };
            };
        }

        public function get list():SimpleTileList
        {
            return (this._list);
        }

        public function dispose():void
        {
            var _local_1:ShortcutBuyCell;
            for each (_local_1 in this._cells)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.cellClickHandler);
                ObjectUtils.disposeObject(_local_1);
            };
            this._cells = null;
            this._list.disposeAllChildren();
            this._list = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.shortcutBuy

