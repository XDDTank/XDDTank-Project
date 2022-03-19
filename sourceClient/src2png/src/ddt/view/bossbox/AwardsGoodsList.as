// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.AwardsGoodsList

package ddt.view.bossbox
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.box.BoxGoodsTempInfo;
    import ddt.manager.ItemManager;
    import com.pickgliss.utils.ObjectUtils;

    public class AwardsGoodsList extends Sprite implements Disposeable 
    {

        private var _goodsList:Array;
        private var _list:SimpleTileList;
        private var panel:ScrollPanel;
        private var _cells:Array;

        public function AwardsGoodsList()
        {
            this.initList();
        }

        protected function initList():void
        {
            this._list = new SimpleTileList(2);
            this._list.vSpace = 4;
            this._list.hSpace = 122;
            this.panel = ComponentFactory.Instance.creat("TimeBoxScrollpanel");
            addChild(this.panel);
        }

        public function show(_arg_1:Array):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:BoxAwardsCell;
            var _local_5:BoxGoodsTempInfo;
            this._goodsList = _arg_1;
            this._cells = new Array();
            this._list.beginChanges();
            var _local_2:int;
            while (_local_2 < this._goodsList.length)
            {
                if ((this._goodsList[_local_2] is InventoryItemInfo))
                {
                    _local_3 = this._goodsList[_local_2];
                    _local_3.IsJudge = true;
                }
                else
                {
                    _local_5 = (this._goodsList[_local_2] as BoxGoodsTempInfo);
                    _local_3 = (this.getTemplateInfo(_local_5.TemplateId) as InventoryItemInfo);
                    _local_3.IsBinds = _local_5.IsBind;
                    _local_3.LuckCompose = _local_5.LuckCompose;
                    _local_3.DefendCompose = _local_5.DefendCompose;
                    _local_3.AttackCompose = _local_5.AttackCompose;
                    _local_3.AgilityCompose = _local_5.AgilityCompose;
                    _local_3.StrengthenLevel = _local_5.StrengthenLevel;
                    _local_3.ValidDate = _local_5.ItemValid;
                    _local_3.IsJudge = true;
                    _local_3.Count = _local_5.ItemCount;
                };
                _local_4 = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
                _local_4.info = _local_3;
                _local_4.count = _local_3.Count;
                this._list.addChild(_local_4);
                this._cells.push(_local_4);
                _local_2++;
            };
            this._list.commitChanges();
            this.panel.beginChanges();
            this.panel.setView(this._list);
            this.panel.hScrollProxy = ScrollPanel.OFF;
            this.panel.vScrollProxy = ((this._goodsList.length > 6) ? ScrollPanel.ON : ScrollPanel.ON);
            this.panel.commitChanges();
        }

        public function showForVipAward(_arg_1:Array):void
        {
            var _local_2:int;
            var _local_3:BoxAwardsCell;
            this._goodsList = _arg_1;
            this._cells = new Array();
            this._list.dispose();
            this._list = new SimpleTileList(3);
            this._list.vSpace = 6;
            this._list.hSpace = 110;
            this._list.beginChanges();
            _local_2 = 0;
            while (_local_2 < this._goodsList.length)
            {
                _local_3 = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
                _local_3.mouseChildren = false;
                _local_3.mouseEnabled = false;
                if (this._goodsList[_local_2])
                {
                    _local_3.info = ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[_local_2]).TemplateId);
                    _local_3.count = 1;
                    _local_3.itemName = ((ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[_local_2]).TemplateId).Name + "X") + String(BoxGoodsTempInfo(this._goodsList[_local_2]).ItemCount));
                    this._list.addChild(_local_3);
                    this._cells.push(_local_3);
                };
                _local_2++;
            };
            this._list.commitChanges();
            this.panel.beginChanges();
            this.panel.width = 500;
            this.panel.height = 178;
            this.panel.setView(this._list);
            this.panel.hScrollProxy = ScrollPanel.OFF;
            this.panel.vScrollProxy = ScrollPanel.OFF;
            this.panel.commitChanges();
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
            var _local_1:BoxAwardsCell;
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
            if (this.panel)
            {
                ObjectUtils.disposeObject(this.panel);
            };
            this.panel = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.bossbox

