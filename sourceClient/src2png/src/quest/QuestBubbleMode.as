// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestBubbleMode

package quest
{
    import ddt.manager.TaskManager;
    import ddt.data.quest.QuestInfo;
    import ddt.manager.LanguageMgr;

    public class QuestBubbleMode 
    {

        private var _questInfoCompleteArr:Array;
        private var _questInfoArr:Array;
        private var _questInfoTxtArr:Array;
        private var _isShowIn:Boolean;


        public function get questsInfo():Array
        {
            var _local_1:Array = [];
            this._questInfoCompleteArr = [];
            this._questInfoArr = [];
            _local_1 = TaskManager.instance.getAvailableQuests().list;
            var _local_2:Array = new Array();
            var _local_3:uint;
            while (_local_3 < _local_1.length)
            {
                if (_local_1[_local_3].Type < 2)
                {
                    _local_2.push(_local_1[_local_3]);
                };
                _local_3++;
            };
            return (this._reseachComplete(_local_2));
        }

        private function _addInfoToArr(_arg_1:QuestInfo):void
        {
            if ((((_arg_1.canViewWithProgress) && (this._questInfoArr.length < 5)) && ((!(this._isShowIn)) || ((this._isShowIn) && (_arg_1.isCompleted)))))
            {
                this._questInfoArr.push(_arg_1);
            };
        }

        private function _reseachComplete(_arg_1:Array):Array
        {
            this._reseachInfoForId(_arg_1);
            return (this._setTxtInArr());
        }

        private function _setTxtInArr():Array
        {
            var _local_3:int;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:int;
            var _local_7:Object;
            var _local_8:int;
            var _local_9:int;
            var _local_1:Array = new Array();
            var _local_2:int;
            while (_local_2 < this._questInfoArr.length)
            {
                _local_3 = 0;
                _local_4 = QuestInfo(this._questInfoArr[_local_2]).progress[0];
                _local_5 = QuestInfo(this._questInfoArr[_local_2])._conditions[0].target;
                _local_6 = 1;
                while (QuestInfo(this._questInfoArr[_local_2])._conditions[_local_6])
                {
                    _local_8 = QuestInfo(this._questInfoArr[_local_2]).progress[_local_6];
                    _local_9 = QuestInfo(this._questInfoArr[_local_2])._conditions[_local_6].target;
                    if (_local_8 != 0)
                    {
                        if ((((_local_8 / _local_9) < (_local_4 / _local_5)) || (_local_4 == 0)))
                        {
                            _local_4 = _local_8;
                            _local_5 = _local_9;
                            _local_3 = _local_6;
                        };
                    };
                    _local_6++;
                };
                _local_7 = new Object();
                switch (QuestInfo(this._questInfoArr[_local_2]).Type)
                {
                    case 0:
                        _local_7.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.TankLink");
                        break;
                    case 1:
                        _local_7.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.BranchLine");
                        break;
                    case 2:
                        _local_7.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.Daily");
                        break;
                    case 3:
                        _local_7.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.Act");
                        break;
                    case 4:
                        _local_7.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.VIP");
                        break;
                };
                if (QuestInfo(this._questInfoArr[_local_2]).isCompleted)
                {
                    _local_7.txtI = (("<font COLOR='#8be961'>" + _local_7.txtI) + "</font>");
                    _local_7.txtII = (("<font COLOR='#8be961'>" + this._analysisStrII(this._analysisStrIII(QuestInfo(this._questInfoArr[_local_2])))) + "</font>");
                    _local_7.txtIII = (("<font COLOR='#8be961'>" + this._analysisStrIV(QuestInfo(this._questInfoArr[_local_2]))) + "</font>");
                }
                else
                {
                    _local_7.txtII = this._analysisStrII(QuestInfo(this._questInfoArr[_local_2])._conditions[_local_3].description);
                    _local_7.txtIII = QuestInfo(this._questInfoArr[_local_2]).conditionStatus[_local_3];
                };
                _local_1.push(_local_7);
                _local_2++;
            };
            return (_local_1);
        }

        private function _analysisStrII(_arg_1:String):String
        {
            var _local_2:String;
            if (_arg_1.length <= 6)
            {
                _local_2 = _arg_1;
            }
            else
            {
                _local_2 = _arg_1.substr(0, 6);
                _local_2 = (_local_2 + "...");
            };
            return (_local_2);
        }

        private function _analysisStrIII(_arg_1:QuestInfo):String
        {
            var _local_2:String = "";
            var _local_3:int;
            while (_local_3 < _arg_1._conditions.length)
            {
                if (_arg_1.progress[_local_3] <= 0)
                {
                    return (_arg_1._conditions[_local_3].description);
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function _analysisStrIV(_arg_1:QuestInfo):String
        {
            var _local_2:String = "";
            var _local_3:int;
            while (_local_3 < _arg_1._conditions.length)
            {
                if (_arg_1.progress[_local_3] <= 0)
                {
                    return (_arg_1.conditionStatus[_local_3]);
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function _reseachInfoForId(_arg_1:Array):void
        {
            var _local_5:Number;
            var _local_6:IndexObj;
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_5 = QuestInfo(_arg_1[_local_3]).questProgressNum;
                _local_6 = new IndexObj(_local_3, _local_5);
                _local_2.push(_local_6);
                _local_3++;
            };
            _local_2.sortOn("progressNum", Array.NUMERIC);
            _local_3 = 0;
            while (_local_3 < _local_2.length)
            {
                this._questInfoCompleteArr.push(QuestInfo(_arg_1[_local_2[_local_3].id]));
                _local_3++;
            };
            var _local_4:int;
            _local_3 = 0;
            while (_local_3 < this._questInfoCompleteArr.length)
            {
                if ((!(this._questInfoCompleteArr[_local_3].questProgressNum == this._questInfoCompleteArr[_local_4].questProgressNum)))
                {
                    this._checkInfoArr(4, _local_4, _local_3);
                    this._checkInfoArr(3, _local_4, _local_3);
                    this._checkInfoArr(2, _local_4, _local_3);
                    this._checkInfoArr(0, _local_4, _local_3);
                    this._checkInfoArr(1, _local_4, _local_3);
                    _local_4 = _local_3;
                };
                _local_3++;
            };
            this._checkInfoArr(4, _local_4, this._questInfoCompleteArr.length);
            this._checkInfoArr(3, _local_4, this._questInfoCompleteArr.length);
            this._checkInfoArr(2, _local_4, this._questInfoCompleteArr.length);
            this._checkInfoArr(0, _local_4, this._questInfoCompleteArr.length);
            this._checkInfoArr(1, _local_4, this._questInfoCompleteArr.length);
        }

        private function _checkInfoArr(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:int = _arg_2;
            while (_local_4 < _arg_3)
            {
                if (QuestInfo(this._questInfoCompleteArr[_local_4]).Type == _arg_1)
                {
                    this._addInfoToArr(this._questInfoCompleteArr[_local_4]);
                };
                _local_4++;
            };
        }

        public function getQuestInfoById(_arg_1:int):QuestInfo
        {
            return (this._questInfoArr[_arg_1]);
        }


    }
}//package quest

class IndexObj 
{

    public var id:int;
    public var progressNum:Number;

    public function IndexObj(_arg_1:int, _arg_2:Number)
    {
        this.id = _arg_1;
        this.progressNum = _arg_2;
    }

}


