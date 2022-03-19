// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.storeBag.StoreBagController

package store.view.storeBag
{
    import store.data.StoreModel;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;
    import bagAndInfo.cell.BagCell;
    import com.pickgliss.utils.ObjectUtils;

    public class StoreBagController 
    {

        private var _model:StoreModel;
        private var _view:StoreBagView;

        public function StoreBagController(_arg_1:StoreModel)
        {
            this._model = _arg_1;
            this._view = ComponentFactory.Instance.creat("ddtstore.StoreBagView");
            this._view.setup(this);
            this.loadList();
        }

        public function getView():DisplayObject
        {
            return (this._view);
        }

        public function getPropCell(_arg_1:int):BagCell
        {
            if (_arg_1 < 0)
            {
                return (null);
            };
            return (null);
        }

        public function getEquipCell(_arg_1:int):BagCell
        {
            if (_arg_1 < 0)
            {
                return (null);
            };
            return (null);
        }

        public function loadList():void
        {
            this.setList(this._model);
        }

        public function setList(_arg_1:StoreModel):void
        {
            this._view.setData(_arg_1);
        }

        public function changeMsg(_arg_1:int):void
        {
        }

        public function get currentPanel():int
        {
            return (this._model.currentPanel);
        }

        public function get model():StoreModel
        {
            return (this._model);
        }

        public function getEnabled():Boolean
        {
            return (false);
        }

        public function setEnabled(_arg_1:Boolean):void
        {
        }

        public function dispose():void
        {
            if (this._view)
            {
                ObjectUtils.disposeObject(this._view);
            };
            this._view = null;
            this._model = null;
        }


    }
}//package store.view.storeBag

