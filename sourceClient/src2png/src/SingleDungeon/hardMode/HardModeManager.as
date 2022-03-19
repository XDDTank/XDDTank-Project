// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.hardMode.HardModeManager

package SingleDungeon.hardMode
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.utils.ByteArray;
    import ddt.manager.ServerConfigManager;
    import SingleDungeon.model.MapSceneModel;
    import SingleDungeon.SingleDungeonManager;
    import SingleDungeon.expedition.ExpeditionHistory;
    import SingleDungeon.expedition.ExpeditionInfo;
    import SingleDungeon.expedition.ExpeditionController;
    import ddt.manager.PlayerManager;
    import __AS3__.vec.*;

    public class HardModeManager extends EventDispatcher 
    {

        private static var _instance:HardModeManager;

        private var _hardModeSceneList:Vector.<int> = new Vector.<int>();
        private var _hardModeChooseSceneList:Vector.<int> = new Vector.<int>();
        public var baseNum:int = 101;
        public var enterDgCountArr:ByteArray;


        public static function get instance():HardModeManager
        {
            if ((!(_instance)))
            {
                _instance = new (HardModeManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
        }

        public function getRemainFightCount(_arg_1:int):int
        {
            return (ServerConfigManager.instance.getHardModeEnterLimit() - this.getEnterDgCount(_arg_1));
        }

        public function getAllowEnter(_arg_1:int):Boolean
        {
            return (this.getRemainFightCount(_arg_1) > 0);
        }

        public function checkEnter(_arg_1:int):Boolean
        {
            return (this.getEnterDgCount(_arg_1) > 0);
        }

        public function getEnterDgCount(_arg_1:int):int
        {
            var _local_2:int = (_arg_1 - this.baseNum);
            if (this.enterDgCountArr[_local_2])
            {
                return (this.enterDgCountArr[_local_2]);
            };
            return (0);
        }

        public function getCanExpeditionDungeon():Vector.<MapSceneModel>
        {
            var _local_3:MapSceneModel;
            var _local_1:Vector.<MapSceneModel> = new Vector.<MapSceneModel>();
            var _local_2:Vector.<MapSceneModel> = SingleDungeonManager.Instance.mapHardSceneList;
            for each (_local_3 in _local_2)
            {
                if (((ExpeditionHistory.instance.get(_local_3.MissionID)) && (this.getAllowEnter(_local_3.ID))))
                {
                    _local_1.push(_local_3);
                };
            };
            _local_1.sort(this.sortDungeonById);
            return (_local_1);
        }

        private function sortDungeonById(_arg_1:MapSceneModel, _arg_2:MapSceneModel):int
        {
            if (_arg_1.ID > _arg_2.ID)
            {
                return (-1);
            };
            return (1);
        }

        public function getNeedFatigue():int
        {
            var _local_2:int;
            var _local_3:ExpeditionInfo;
            var _local_1:int;
            for each (_local_2 in this._hardModeSceneList)
            {
                _local_3 = ExpeditionController.instance.model.expeditionInfoDic[_local_2];
                _local_1 = (_local_1 + _local_3.ExpeditionEnergy);
            };
            return (_local_1);
        }

        public function getNeedTime():int
        {
            var _local_2:int;
            var _local_3:ExpeditionInfo;
            var _local_1:int;
            for each (_local_2 in this._hardModeSceneList)
            {
                _local_3 = ExpeditionController.instance.model.expeditionInfoDic[_local_2];
                _local_1 = (_local_1 + ((_local_3.ExpeditionTime * 60) * 1000));
            };
            return (_local_1);
        }

        public function getNeedMoney():int
        {
            var _local_3:ExpeditionInfo;
            var _local_1:int;
            var _local_2:uint = (PlayerManager.Instance.Self.expeditionNumCur - 1);
            while (_local_2 < this._hardModeSceneList.length)
            {
                _local_3 = ExpeditionController.instance.model.expeditionInfoDic[this._hardModeSceneList[_local_2]];
                _local_1 = (_local_1 + _local_3.AccelerateMoney);
                _local_2++;
            };
            return (_local_1);
        }

        public function getChooseNeedFatigue():int
        {
            var _local_2:int;
            var _local_3:ExpeditionInfo;
            var _local_1:int;
            for each (_local_2 in this._hardModeChooseSceneList)
            {
                _local_3 = ExpeditionController.instance.model.expeditionInfoDic[_local_2];
                _local_1 = (_local_1 + _local_3.ExpeditionEnergy);
            };
            return (_local_1);
        }

        public function getChooseNeedTime():int
        {
            var _local_2:int;
            var _local_3:ExpeditionInfo;
            var _local_1:int;
            for each (_local_2 in this._hardModeChooseSceneList)
            {
                _local_3 = ExpeditionController.instance.model.expeditionInfoDic[_local_2];
                _local_1 = (_local_1 + ((_local_3.ExpeditionTime * 60) * 1000));
            };
            return (_local_1);
        }

        public function getChooseNeedMoney():int
        {
            var _local_2:int;
            var _local_3:ExpeditionInfo;
            var _local_1:int;
            for each (_local_2 in this._hardModeChooseSceneList)
            {
                _local_3 = ExpeditionController.instance.model.expeditionInfoDic[_local_2];
                _local_1 = (_local_1 + _local_3.AccelerateMoney);
            };
            return (_local_1);
        }

        public function get hardModeSceneList():Vector.<int>
        {
            return (this._hardModeSceneList);
        }

        public function set hardModeSceneList(_arg_1:Vector.<int>):void
        {
            this._hardModeSceneList = _arg_1;
        }

        public function get hardModeChooseSceneList():Vector.<int>
        {
            return (this._hardModeChooseSceneList);
        }

        public function set hardModeChooseSceneList(_arg_1:Vector.<int>):void
        {
            this._hardModeChooseSceneList = _arg_1;
        }

        public function resetChooseSceneList():void
        {
            this._hardModeChooseSceneList = new Vector.<int>();
        }

        public function resetHardModeSceneList():void
        {
            this._hardModeSceneList = new Vector.<int>();
        }


    }
}//package SingleDungeon.hardMode

