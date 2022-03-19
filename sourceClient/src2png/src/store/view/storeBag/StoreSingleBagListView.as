// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.storeBag.StoreSingleBagListView

package store.view.storeBag
{
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.controls.ScrollPanel;
    import store.StoreController;
    import store.events.StoreIIEvent;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import road7th.data.DictionaryEvent;
    import store.events.StoreBagEvent;

    public class StoreSingleBagListView extends StoreBagListView 
    {

        public static const SINGLEBAG:int = 49;

        private var _templateID:int = -1;
        private var _categoryID:Number = -1;
        private var _templeteType:int = -1;
        private var _showLight:Boolean = false;


        override protected function createPanel():void
        {
            panel = ComponentFactory.Instance.creat("ddtstore.StoreBagView.BagSingleScrollPanel");
            addChild(panel);
            panel.hScrollProxy = ScrollPanel.OFF;
            panel.vScrollProxy = ScrollPanel.ON;
            StoreController.instance.Model.addEventListener(StoreIIEvent.TRANSFER_LIGHT, this.__showLight);
        }

        private function __showLight(_arg_1:StoreIIEvent):void
        {
            var _local_2:EquipmentTemplateInfo;
            if (_arg_1.data)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(_arg_1.data.TemplateID);
                this._templateID = _arg_1.data.TemplateID;
                this._categoryID = _arg_1.data.CategoryID;
                this._templeteType = _local_2.TemplateType;
                this._showLight = _arg_1.bool;
            }
            else
            {
                this._categoryID = -1;
                this._showLight = _arg_1.bool;
            };
            this.showLight(this._categoryID, this._showLight, this._templeteType);
        }

        private function showLight(_arg_1:Number, _arg_2:Boolean, _arg_3:int=-1):void
        {
            var _local_4:StoreBagCell;
            var _local_5:StoreBagCell;
            var _local_6:EquipmentTemplateInfo;
            for each (_local_4 in _cells)
            {
                if ((!((SavePointManager.Instance.isInSavePoint(9)) && (!(TaskManager.instance.isNewHandTaskCompleted(7))))))
                {
                    if ((!(_local_4.locked)))
                    {
                        _local_4.light = false;
                    };
                };
            };
            if (_arg_1 != -1)
            {
                for each (_local_5 in _cells)
                {
                    if (((_local_5.info) && (_local_5.info.CategoryID == _arg_1)))
                    {
                        if (this._templeteType != -1)
                        {
                            _local_6 = ItemManager.Instance.getEquipTemplateById(_local_5.info.TemplateID);
                            if (_local_6.TemplateType == this._templeteType)
                            {
                                _local_5.light = _arg_2;
                            };
                        }
                        else
                        {
                            _local_5.light = _arg_2;
                        };
                    };
                };
            };
        }

        override public function dispose():void
        {
            StoreController.instance.Model.removeEventListener(StoreIIEvent.TRANSFER_LIGHT, this.__showLight);
            super.dispose();
        }

        override protected function __addGoods(_arg_1:DictionaryEvent):void
        {
            super.__addGoods(_arg_1);
            this.showLight(this._categoryID, true);
        }

        override protected function __removeGoods(_arg_1:StoreBagEvent):void
        {
            super.__removeGoods(_arg_1);
        }


    }
}//package store.view.storeBag

