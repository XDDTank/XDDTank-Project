// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//farm.FarmModelController

package farm
{
    import flash.events.EventDispatcher;
    import farm.model.FarmModel;
    import farm.view.FarmCell;
    import farm.view.FarmGainFram;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.data.DictionaryData;
    import road7th.comm.PackageIn;
    import farm.model.FieldVO;
    import farm.event.FarmEvent;
    import ddt.data.goods.ItemTemplateInfo;
    import bagAndInfo.cell.BaseCell;
    import flash.geom.Point;
    import game.view.DropGoods;
    import ddt.utils.PositionUtils;
    import ddt.manager.ItemManager;
    import flash.display.Sprite;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import farm.view.*;

    public class FarmModelController extends EventDispatcher 
    {

        private static var _instance:FarmModelController;

        private var _model:FarmModel;
        private var _canGoFarm:Boolean = true;
        public var _moneyReflashCount:int;
        public var _cell:FarmCell;
        private var _frame:FarmGainFram;
        private var _frameOpen:Boolean = true;


        public static function get instance():FarmModelController
        {
            return (_instance = ((_instance) || (new (FarmModelController)())));
        }


        public function setup():void
        {
            this._model = new FarmModel();
            this.initEvent();
        }

        public function get model():FarmModel
        {
            return (this._model);
        }

        public function refreshFarm():void
        {
            this._model.currentFarmerName = PlayerManager.Instance.Self.NickName;
            SocketManager.Instance.out.refreshFarm();
        }

        public function sowSeed(_arg_1:int, _arg_2:int):void
        {
            SocketManager.Instance.out.seeding(_arg_1, _arg_2);
        }

        public function getHarvest(_arg_1:int):void
        {
            SocketManager.Instance.out.toGather(_arg_1);
        }

        public function farmPlantSpeed(_arg_1:int, _arg_2:int):void
        {
            SocketManager.Instance.out.farmSpeed(_arg_1, _arg_2);
        }

        public function farmPlantDelete(_arg_1:int):void
        {
            SocketManager.Instance.out.FieldDelete(_arg_1);
        }

        public function farmBack():void
        {
            SocketManager.Instance.out.farmLeaving();
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REFRASH_FARM, this.__refreshFarm);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEEDING, this.__seeding);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAIN_FIELD, this.__gainFarm);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACCELERATE_FIELD, this.__speedFarm);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPROOT_FIELD, this.__farmPlantDelete);
        }

        protected function __seeding(_arg_1:CrazyTankSocketEvent):void
        {
            this.model.fieldsInfo = null;
            this.model.fieldsInfo = new DictionaryData();
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:FieldVO = new FieldVO();
            _local_3.fieldID = _local_2.readInt();
            _local_3.seedID = _local_2.readInt();
            _local_3.plantTime = _local_2.readDate();
            _local_3.gainTime = _local_2.readInt();
            this.model.fieldsInfo.add(_local_3.fieldID, _local_3);
            dispatchEvent(new FarmEvent(FarmEvent.SEED, _local_3));
        }

        protected function __farmPlantDelete(_arg_1:CrazyTankSocketEvent):void
        {
            this.model.fieldsInfo = null;
            this.model.fieldsInfo = new DictionaryData();
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:FieldVO = new FieldVO();
            _local_3.fieldID = _local_2.readInt();
            _local_3.seedID = _local_2.readInt();
            _local_3.plantTime = _local_2.readDate();
            _local_3.gainTime = _local_2.readInt();
            this.model.fieldsInfo.add(_local_3.fieldID, _local_3);
            dispatchEvent(new FarmEvent(FarmEvent.PLANETDELETE, _local_3));
        }

        private function __refreshFarm(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:FieldVO;
            this.model.fieldsInfo = null;
            this.model.fieldsInfo = new DictionaryData();
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = new FieldVO();
                _local_5.fieldID = _local_2.readInt();
                _local_5.seedID = _local_2.readInt();
                _local_5.plantTime = _local_2.readDate();
                _local_5.gainTime = _local_2.readInt();
                this.model.fieldsInfo.add(_local_5.fieldID, _local_5);
                _local_4++;
            };
            dispatchEvent(new FarmEvent(FarmEvent.FIELDS_INFO_READY));
        }

        private function __speedFarm(_arg_1:CrazyTankSocketEvent):void
        {
            this.model.fieldsInfo = null;
            this.model.fieldsInfo = new DictionaryData();
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:FieldVO = new FieldVO();
            _local_3.fieldID = _local_2.readInt();
            _local_3.seedID = _local_2.readInt();
            _local_3.plantTime = _local_2.readDate();
            _local_3.gainTime = _local_2.readInt();
            this.model.fieldsInfo.remove(_local_3.fieldID);
            this._frameOpen = true;
            dispatchEvent(new FarmEvent(FarmEvent.PLANTSPEED, _local_3));
        }

        private function __gainFarm(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:int;
            var _local_9:ItemTemplateInfo;
            var _local_10:BaseCell;
            var _local_11:Point;
            var _local_12:DropGoods;
            this.model.fieldsInfo = null;
            this.model.fieldsInfo = new DictionaryData();
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:FieldVO = new FieldVO();
            _local_3.fieldID = _local_2.readInt();
            _local_3.seedID = _local_2.readInt();
            _local_3.plantTime = _local_2.readDate();
            _local_3.gainTime = _local_2.readInt();
            this.model.fieldsInfo.remove(_local_3.fieldID);
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            if (_local_5 <= 1)
            {
                _local_6 = 1;
            }
            else
            {
                _local_6 = 2;
            };
            var _local_7:Point = new Point();
            PositionUtils.setPos(_local_7, ("farm.fieldsView.fieldPos" + _local_3.fieldID));
            _local_7.x = (_local_7.x + 386);
            _local_7.y = (_local_7.y + 228);
            var _local_8:int;
            while (_local_8 < _local_6)
            {
                _local_9 = ItemManager.Instance.getTemplateById(_local_4);
                _local_10 = new BaseCell(new Sprite(), _local_9, false, false);
                _local_10.setContentSize(40, 40);
                _local_11 = new Point(650, 540);
                _local_12 = new DropGoods(StageReferance.stage, _local_10, _local_7, _local_11, (_local_5 / _local_6));
                _local_12.start(_local_12.CHESTS_DROP);
                _local_8++;
            };
            this._frameOpen = true;
            dispatchEvent(new FarmEvent(FarmEvent.GAIN_FIELD, _local_3));
        }

        public function fieldGain():Boolean
        {
            var _local_1:Boolean;
            _local_1 = false;
            var _local_2:int;
            while (_local_2 < this._model.fieldsInfo.length)
            {
                if (this.model.fieldsInfo[_local_2])
                {
                    if (((!(this.model.fieldsInfo[_local_2].seedID == 0)) && (this.model.fieldsInfo[_local_2].isGrownUp)))
                    {
                        _local_1 = true;
                        break;
                    };
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function showFeildGain():void
        {
            if (this._frameOpen)
            {
                if (this.fieldGain())
                {
                    if ((!(this._frame)))
                    {
                        this._frame = ComponentFactory.Instance.creatComponentByStylename("trainer.view.farmGainPlant");
                        LayerManager.Instance.addToLayer(this._frame, LayerManager.GAME_DYNAMIC_LAYER, false, 0, false);
                        LayerManager.Instance.getLayerByType(LayerManager.GAME_DYNAMIC_LAYER).setChildIndex(this._frame, 0);
                        this._frame.addEventListener(FrameEvent.RESPONSE, this.__frameResponse1);
                    };
                };
            };
        }

        public function deleteGainPlant():void
        {
            if (this._frame)
            {
                this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse1);
                ObjectUtils.disposeObject(this._frame);
                this._frame = null;
            };
        }

        private function __frameResponse1(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse1);
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                StateManager.setState(StateType.FARM);
            }
            else
            {
                this._frameOpen = false;
            };
        }


    }
}//package farm

