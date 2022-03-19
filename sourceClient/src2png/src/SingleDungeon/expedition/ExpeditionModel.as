// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.ExpeditionModel

package SingleDungeon.expedition
{
    import road7th.data.DictionaryData;

    public class ExpeditionModel 
    {

        public static const NORMAL_MODE:uint = 1;
        public static const HARD_MODE:uint = 2;

        private var _expeditionInfoDic:DictionaryData;
        private var _getItemsDic:DictionaryData = new DictionaryData();
        private var _scenceNameDic:DictionaryData = new DictionaryData();
        private var _lastScenceID:int = 0;
        private var _expeditionEndTime:Number;
        private var _currentMapId:int;


        public function get expeditionInfoDic():DictionaryData
        {
            return (this._expeditionInfoDic);
        }

        public function set expeditionInfoDic(_arg_1:DictionaryData):void
        {
            this._expeditionInfoDic = _arg_1;
        }

        public function get getItemsDic():DictionaryData
        {
            return (this._getItemsDic);
        }

        public function set getItemsDic(_arg_1:DictionaryData):void
        {
            this._getItemsDic = _arg_1;
        }

        public function clearGetItemsDic():void
        {
            this._getItemsDic.clear();
        }

        public function getscenceNameByID(_arg_1:int):String
        {
            return (this._scenceNameDic[_arg_1]);
        }

        public function addscenceNameDic(_arg_1:int, _arg_2:String):void
        {
            this._scenceNameDic[_arg_1] = _arg_2;
        }

        public function get lastScenceID():int
        {
            return (this._lastScenceID);
        }

        public function set lastScenceID(_arg_1:int):void
        {
            this._lastScenceID = _arg_1;
        }

        public function get expeditionEndTime():Number
        {
            return (this._expeditionEndTime);
        }

        public function set expeditionEndTime(_arg_1:Number):void
        {
            this._expeditionEndTime = _arg_1;
        }

        public function get currentMapId():int
        {
            return (this._currentMapId);
        }

        public function set currentMapId(_arg_1:int):void
        {
            this._currentMapId = _arg_1;
        }


    }
}//package SingleDungeon.expedition

