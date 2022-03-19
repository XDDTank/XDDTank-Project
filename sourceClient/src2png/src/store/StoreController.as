// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.StoreController

package store
{
    import flash.events.EventDispatcher;
    import store.data.StoreModel;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PlayerManager;
    import store.view.Compose.ComposeController;
    import store.analyze.RefiningAnayzer;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import store.events.StoreIIEvent;
    import store.states.BaseStoreView;
    import ddt.utils.PositionUtils;

    public class StoreController extends EventDispatcher 
    {

        private static var _instance:StoreController;
        public static const TRANSFER_SUCCESS:String = "transferSuccess";

        private var _type:String;
        private var _model:StoreModel;
        private var _isShine:Boolean = false;
        private var _transform:ItemTemplateInfo;

        public function StoreController()
        {
            this.init();
            this.initEvents();
        }

        public static function get instance():StoreController
        {
            if ((!(_instance)))
            {
                _instance = new (StoreController)();
            };
            return (_instance);
        }


        private function init():void
        {
            this._model = new StoreModel(PlayerManager.Instance.Self);
            ComposeController.instance.setup();
        }

        public function setupRefining(_arg_1:RefiningAnayzer):void
        {
            this.Model.refiningConfig = _arg_1.list;
        }

        private function initEvents():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REFINING, this.__refiningReback);
        }

        private function __refiningReback(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Object = new Object();
            _local_3["isCrit"] = _local_2.readBoolean();
            _local_3["exp"] = _local_2.readInt();
            this.Model.dispatchEvent(new StoreIIEvent(StoreIIEvent.REFINING_REBACK, _local_3));
        }

        private function removeEvents():void
        {
        }

        public function startupEvent():void
        {
        }

        public function shutdownEvent():void
        {
        }

        public function getView(_arg_1:int):BaseStoreView
        {
            var _local_2:BaseStoreView = new BaseStoreView(this, _arg_1);
            PositionUtils.setPos(_local_2, "ddtstore.BagStoreViewPos");
            return (_local_2);
        }

        public function get Type():String
        {
            return (this._type);
        }

        public function get Model():StoreModel
        {
            return (this._model);
        }

        public function dispose():void
        {
            this.shutdownEvent();
            this.removeEvents();
            this._model.clear();
            this._model = null;
        }

        public function set isShine(_arg_1:Boolean):void
        {
            this._isShine = _arg_1;
        }

        public function get isShine():Boolean
        {
            return (this._isShine);
        }

        public function set transform(_arg_1:ItemTemplateInfo):void
        {
            this._transform = _arg_1;
        }

        public function get transform():ItemTemplateInfo
        {
            return (this._transform);
        }

        public function sendTransferShowLightEvent(_arg_1:ItemTemplateInfo, _arg_2:Boolean):void
        {
            if (_arg_2)
            {
                this.isShine = true;
                this.transform = _arg_1;
            }
            else
            {
                this.isShine = false;
                this.transform = null;
            };
            this.Model.dispatchEvent(new StoreIIEvent(StoreIIEvent.TRANSFER_LIGHT, _arg_1, _arg_2));
        }

        public function sendRefining():void
        {
            SocketManager.Instance.out.sendRefining();
        }


    }
}//package store

