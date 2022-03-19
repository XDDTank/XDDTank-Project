// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.model.DiamondModel

package platformapi.tencent.model
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import platformapi.tencent.TencentPlatformData;
    import platformapi.tencent.DiamondManager;
    import platformapi.tencent.DiamondType;
    import flash.events.Event;

    public class DiamondModel extends EventDispatcher 
    {

        private var _yellowAwardList:DictionaryData;
        private var _yellowYearAwardList:DictionaryData;
        private var _yellowNewHandAwardList:DictionaryData;
        private var _blueAwardList:DictionaryData;
        private var _blueYearAwardList:DictionaryData;
        private var _blueNewHandAwardList:DictionaryData;
        private var _memberAwardList:DictionaryData;
        private var _memberYearAwardList:DictionaryData;
        private var _memberNewHandAwardList:DictionaryData;
        private var _bunAwardList:DictionaryData;
        private var _hasData:Boolean;
        private var _pfdata:TencentPlatformData;


        public function setList(_arg_1:DictionaryData, _arg_2:DictionaryData, _arg_3:DictionaryData, _arg_4:DictionaryData, _arg_5:DictionaryData, _arg_6:DictionaryData, _arg_7:DictionaryData, _arg_8:DictionaryData, _arg_9:DictionaryData, _arg_10:DictionaryData):void
        {
            this._yellowAwardList = _arg_1;
            this._yellowYearAwardList = _arg_2;
            this._yellowNewHandAwardList = _arg_3;
            this._blueAwardList = _arg_4;
            this._blueYearAwardList = _arg_5;
            this._blueNewHandAwardList = _arg_6;
            this._memberAwardList = _arg_7;
            this._memberYearAwardList = _arg_8;
            this._memberNewHandAwardList = _arg_9;
            this._bunAwardList = _arg_10;
            this._hasData = true;
        }

        public function get awardList():DictionaryData
        {
            switch (DiamondManager.instance.model.pfdata.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    return (this._yellowAwardList);
                case DiamondType.BLUE_DIAMOND:
                    return (this._blueAwardList);
                case DiamondType.MEMBER_DIAMOND:
                    return (this._memberAwardList);
            };
            return (null);
        }

        public function get yearAwardList():DictionaryData
        {
            switch (DiamondManager.instance.model.pfdata.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    return (this._yellowYearAwardList);
                case DiamondType.BLUE_DIAMOND:
                    return (this._blueYearAwardList);
                case DiamondType.MEMBER_DIAMOND:
                    return (this._memberYearAwardList);
            };
            return (null);
        }

        public function get newHandAwardList():DictionaryData
        {
            switch (DiamondManager.instance.model.pfdata.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    return (this._yellowNewHandAwardList);
                case DiamondType.BLUE_DIAMOND:
                    return (this._blueNewHandAwardList);
                case DiamondType.MEMBER_DIAMOND:
                    return (this._memberNewHandAwardList);
            };
            return (null);
        }

        public function get bunAwardList():DictionaryData
        {
            return (this._bunAwardList);
        }

        public function get pfdata():TencentPlatformData
        {
            return (this._pfdata = ((this._pfdata) || (new TencentPlatformData())));
        }

        public function update():void
        {
            dispatchEvent(new Event(Event.CHANGE));
        }


    }
}//package platformapi.tencent.model

