// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.VipInfoTipList

package ddt.view.bossbox
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PlayerManager;
    import ddt.events.CellEvent;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class VipInfoTipList extends Sprite implements Disposeable 
    {

        private var _goodsList:Array;
        private var _list:SimpleTileList;
        private var _cells:Vector.<BoxVipTipsInfoCell>;
        private var _currentCell:BoxVipTipsInfoCell;

        public function VipInfoTipList()
        {
            this.initList();
        }

        public function get currentCell():BoxVipTipsInfoCell
        {
            return (this._currentCell);
        }

        protected function initList():void
        {
            this._list = new SimpleTileList(2);
        }

        public function showForVipAward(_arg_1:Array):void
        {
            var _local_2:int;
            var _local_3:BoxVipTipsInfoCell;
            if (((!(_arg_1)) || (_arg_1.length < 1)))
            {
                return;
            };
            this._goodsList = _arg_1;
            this._cells = new Vector.<BoxVipTipsInfoCell>();
            this._list.dispose();
            this._list = new SimpleTileList(this._goodsList.length);
            this._list.vSpace = 12;
            this._list.hSpace = 120;
            this._list.beginChanges();
            _local_2 = 0;
            while (_local_2 < this._goodsList.length)
            {
                _local_3 = ComponentFactory.Instance.creatCustomObject("bossbox.BoxVipTipsInfoCell");
                if (this._goodsList[_local_2])
                {
                    _local_3.info = (this._goodsList[_local_2] as ItemTemplateInfo);
                    _local_3.itemName = (this._goodsList[_local_2] as ItemTemplateInfo).Name;
                    _local_3.isSelect = this.isCanSelect(_local_2);
                    if (this.isCanSelect(_local_2))
                    {
                        this._currentCell = _local_3;
                    };
                    this._list.addChild(_local_3);
                    this._cells.push(_local_3);
                };
                _local_2++;
            };
            this._list.commitChanges();
            addChild(this._list);
        }

        private function isCanSelect(_arg_1:int):Boolean
        {
            var _local_2:Boolean;
            var _local_3:int = PlayerManager.Instance.Self.VIPLevel;
            switch (_arg_1)
            {
                case 0:
                    _local_2 = ((true) && (_local_3 < 12));
                    break;
                case 1:
                    _local_2 = ((false) || (_local_3 == 12));
                    break;
            };
            return (_local_2);
        }

        private function __cellClick(_arg_1:CellEvent):void
        {
            this._currentCell = (_arg_1.data as BoxVipTipsInfoCell);
        }

        private function getTemplateInfo(_arg_1:int):InventoryItemInfo
        {
            var _local_2:InventoryItemInfo = new InventoryItemInfo();
            _local_2.TemplateID = _arg_1;
            ItemManager.fill(_local_2);
            return (_local_2);
        }

        public function dispose():void
        {
            var _local_1:BoxVipTipsInfoCell;
            for each (_local_1 in this._cells)
            {
                _local_1.dispose();
            };
            this._cells.splice(0, this._cells.length);
            this._cells = null;
            if (this._list)
            {
                ObjectUtils.disposeObject(this._list);
            };
            this._list = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.bossbox

