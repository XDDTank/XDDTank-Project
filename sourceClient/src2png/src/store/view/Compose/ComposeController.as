// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.ComposeController

package store.view.Compose
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import store.analyze.ComposeItemAnalyzer;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import ddt.data.goods.ComposeListInfo;
    import flash.events.Event;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.manager.TaskManager;

    public class ComposeController extends EventDispatcher 
    {

        private static var _instance:ComposeController;
        public static const COMPOSE_PLAY:String = "composeplaye";

        private var _model:ComposeModel;
        private var _playerComposeItemList:DictionaryData;

        public function ComposeController()
        {
            this._model = new ComposeModel();
        }

        public static function get instance():ComposeController
        {
            if ((!(_instance)))
            {
                _instance = new (ComposeController)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this._model.composeBigDic.add(1, "equip");
            this._model.composeBigDic.add(2, "jewelry");
            this._model.composeBigDic.add(3, "material");
            this._model.composeBigDic.add(4, "embedStone");
            this.initEvent();
        }

        public function get model():ComposeModel
        {
            return (this._model);
        }

        public function intComposeItemInfoDic(_arg_1:ComposeItemAnalyzer):void
        {
            this.model.composeItemInfoDic = _arg_1.list;
        }

        public function getplayerComposeItemList(_arg_1:int, _arg_2:int):DictionaryData
        {
            var _local_6:ItemTemplateInfo;
            var _local_7:EquipmentTemplateInfo;
            var _local_8:Boolean;
            this._playerComposeItemList = new DictionaryData();
            var _local_3:DictionaryData = ItemManager.Instance.getComposeInfoList(_arg_2, 0);
            var _local_4:DictionaryData = PlayerManager.Instance.Self.composeSkills;
            var _local_5:int;
            for each (_local_6 in _local_3[_arg_1])
            {
                _local_7 = ItemManager.Instance.getEquipTemplateById(_local_6.TemplateID);
                _arg_2 = this.getInfoType(_local_7);
                _local_8 = false;
                switch (_arg_2)
                {
                    case 1:
                        _local_8 = ((_local_7) && ((_local_7.FormulaID == 0) || (_local_4[_local_6.TemplateID])));
                        break;
                    case 2:
                        _local_8 = true;
                        break;
                    case 3:
                        _local_8 = true;
                        break;
                    case 4:
                        _local_8 = ((_local_7) && ((_local_7.FormulaID == 0) || (_local_4[_local_6.TemplateID])));
                        break;
                };
                if (_local_8)
                {
                    this._playerComposeItemList.add(_local_5, _local_6);
                    _local_5++;
                };
            };
            return (this._playerComposeItemList);
        }

        private function getInfoType(_arg_1:EquipmentTemplateInfo):int
        {
            if (_arg_1)
            {
                if (_arg_1.TemplateType == 12)
                {
                    return (4);
                };
                if (_arg_1.TemplateType > 6)
                {
                    return (2);
                };
                return (1);
            };
            return (3);
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_COMPOSE_SKILL, this.__getComposeSkill);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_COMPOSE, this.__composeResponse);
        }

        private function __getComposeSkill(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:DictionaryData = new DictionaryData();
            var _local_5:int;
            while (_local_5 < _local_3)
            {
                _local_6 = _local_2.readInt();
                if (_local_6 != 0)
                {
                    _local_4.add(_local_6, true);
                };
                _local_5++;
            };
            if (PlayerManager.Instance.Self.composeSkills)
            {
                PlayerManager.Instance.Self.composeSkills.clear();
            };
            PlayerManager.Instance.Self.composeSkills = _local_4;
            this.getMiddleItemDic();
            this.getSmallItemDic();
            this.model.dispatchEvent(new ComposeEvents(ComposeEvents.GET_SKILLS_COMPLETE));
        }

        private function getMiddleItemDic():void
        {
            var _local_2:Array;
            var _local_3:DictionaryData;
            var _local_4:ComposeListInfo;
            var _local_1:int = 1;
            while (_local_1 <= this.model.composeBigDic.length)
            {
                _local_2 = new Array();
                _local_3 = ItemManager.Instance.getComposeList(_local_1);
                for each (_local_4 in _local_3.list)
                {
                    if (_local_1 == ComposeType.EQUIP)
                    {
                        if ((!(this.judegLearnSuitBySuitID(_local_4.ID)))) continue;
                    };
                    _local_2.push(_local_4);
                };
                this.model.composeMiddelDic.add(this.model.composeBigDic[_local_1], _local_2);
                _local_1++;
            };
        }

        private function getSmallItemDic():void
        {
            var _local_1:Array;
            var _local_2:Array;
            var _local_3:ComposeListInfo;
            for each (_local_1 in this.model.composeMiddelDic)
            {
                _local_2 = new Array();
                for each (_local_3 in _local_1)
                {
                    _local_2.push(this.getplayerComposeItemList(_local_3.ID, _local_3.Type));
                };
                this.model.composeSmallDic.add(this.model.composeBigDic[_local_1[0].Type], _local_2);
            };
        }

        private function __composeResponse(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            dispatchEvent(new Event(COMPOSE_PLAY));
            if (NewHandContainer.Instance.hasArrow(ArrowType.STR_WEAPON))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
            };
            TaskManager.instance.checkHighLight();
        }

        private function judegLearnSuitBySuitID(_arg_1:int):Boolean
        {
            var _local_4:Array;
            var _local_6:int;
            var _local_2:DictionaryData = ItemManager.Instance.getComposeList(ComposeType.EQUIP);
            var _local_3:DictionaryData = PlayerManager.Instance.Self.composeSkills;
            var _local_5:int = 1;
            while (_local_5 <= 5)
            {
                _local_4 = _local_2[_arg_1][("TemplateArray" + _local_5)];
                for each (_local_6 in _local_4)
                {
                    if (_local_3[_local_6])
                    {
                        return (true);
                    };
                };
                _local_5++;
            };
            return (false);
        }


    }
}//package store.view.Compose

