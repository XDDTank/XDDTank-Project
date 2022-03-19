// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//exitPrompt.ExitPromptModel

package exitPrompt
{
    import ddt.manager.TaskManager;
    import email.manager.MailManager;
    import ddt.data.quest.QuestInfo;
    import ddt.manager.LanguageMgr;

    public class ExitPromptModel 
    {

        private var _list0Arr:Array;
        private var _list1Arr:Array;
        private var _list2Num:int;

        public function ExitPromptModel()
        {
            this._init();
        }

        private function _init():void
        {
            this._list0Arr = new Array();
            this._list1Arr = new Array();
            if (((TaskManager.instance.getAvailableQuests(2).list) && (TaskManager.instance.getAvailableQuests(3).list)))
            {
                this._list0Arr = this._returnList0Arr(TaskManager.instance.getAvailableQuests(2).list);
                this._list1Arr = this._returnList1Arr(TaskManager.instance.getAvailableQuests(3).list);
            };
            if (((MailManager.Instance.Model) && (MailManager.Instance.Model.noReadMails)))
            {
                this._list2Num = MailManager.Instance.Model.noReadMails.length;
            };
        }

        private function _returnList0Arr(_arg_1:Array):Array
        {
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2[_local_3] = new Array();
                _local_2[_local_3][0] = QuestInfo(_arg_1[_local_3]).Title;
                if (QuestInfo(_arg_1[_local_3]).RepeatMax > 50)
                {
                    _local_2[_local_3][1] = LanguageMgr.GetTranslation("ddt.exitPrompt.alotofTask");
                }
                else
                {
                    if (QuestInfo(_arg_1[_local_3]).RepeatMax == 1)
                    {
                        _local_2[_local_3][1] = (("0" + "/") + String(QuestInfo(_arg_1[_local_3]).RepeatMax));
                    }
                    else
                    {
                        _local_2[_local_3][1] = ((String((QuestInfo(_arg_1[_local_3]).RepeatMax - QuestInfo(_arg_1[_local_3]).data.repeatLeft)) + "/") + String(QuestInfo(_arg_1[_local_3]).RepeatMax));
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function _returnList1Arr(_arg_1:Array):Array
        {
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2[_local_3] = new Array();
                _local_2[_local_3][0] = QuestInfo(_arg_1[_local_3]).Title;
                if (QuestInfo(_arg_1[_local_3]).RepeatMax > 50)
                {
                    _local_2[_local_3][1] = LanguageMgr.GetTranslation("ddt.exitPrompt.alotofTask");
                }
                else
                {
                    if (QuestInfo(_arg_1[_local_3]).RepeatMax == 1)
                    {
                        _local_2[_local_3][1] = (("0" + "/") + String(QuestInfo(_arg_1[_local_3]).RepeatMax));
                    }
                    else
                    {
                        _local_2[_local_3][1] = ((String((QuestInfo(_arg_1[_local_3]).RepeatMax - QuestInfo(_arg_1[_local_3]).data.repeatLeft)) + "/") + String(QuestInfo(_arg_1[_local_3]).RepeatMax));
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function get list0Arr():Array
        {
            return (this._list0Arr);
        }

        public function get list1Arr():Array
        {
            return (this._list1Arr);
        }

        public function get list2Num():int
        {
            return (this._list2Num);
        }


    }
}//package exitPrompt

