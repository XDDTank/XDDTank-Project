// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.LivenessAwardManager

package liveness
{
    import flash.events.EventDispatcher;
    import ddt.data.analyze.DaylyGiveAnalyzer;

    public class LivenessAwardManager extends EventDispatcher 
    {

        private static var _instance:LivenessAwardManager;

        private var _today:Date;
        private var _model:LivenessModel;
        private var _todayIndex:uint;
        private var _signAwards:Array;
        private var _currentSingleDungeonId:int;

        public function LivenessAwardManager()
        {
            this._model = new LivenessModel();
        }

        public static function get Instance():LivenessAwardManager
        {
            if ((!(_instance)))
            {
                _instance = new (LivenessAwardManager)();
            };
            return (_instance);
        }


        private function changeToBoolean(_arg_1:Array):void
        {
            var _local_2:uint;
            while (_local_2 < _arg_1.length)
            {
                _arg_1[_local_2] = (!(_arg_1[_local_2] == "0"));
                _local_2++;
            };
        }

        public function signToday():void
        {
            this._model.statusList[(this._todayIndex - 1)] = LivenessModel.NOT_GET_AWARD;
            this.checkBigStar();
        }

        public function checkBigStar():Boolean
        {
            var _local_1:Boolean = true;
            var _local_2:uint;
            while (_local_2 < (this._model.statusList.length - 1))
            {
                if (((this._model.statusList[_local_2] == LivenessModel.DAY_PASS) || (this._model.statusList[_local_2] == LivenessModel.NOT_THE_TIME)))
                {
                    _local_1 = false;
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function getRewardByIndex(_arg_1:uint):void
        {
            this._model.statusList[_arg_1] = LivenessModel.HAS_GET_AWARD;
        }

        public function setDailyInfo(_arg_1:DaylyGiveAnalyzer):void
        {
            this._signAwards = _arg_1.signAwardList;
        }

        public function get model():LivenessModel
        {
            return (this._model);
        }

        public function get todayIndex():uint
        {
            return (this._todayIndex);
        }

        public function get currentSingleDungeonId():int
        {
            return (this._currentSingleDungeonId);
        }

        public function set currentSingleDungeonId(_arg_1:int):void
        {
            this._currentSingleDungeonId = _arg_1;
        }


    }
}//package liveness

