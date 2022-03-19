// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.model.EmailModel

package email.model
{
    import flash.events.EventDispatcher;
    import email.data.EmailInfo;
    import flash.events.IEventDispatcher;
    import email.data.EmailState;
    import email.view.EmailEvent;
    import email.manager.MailManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.SharedManager;
    import ddt.manager.TimeManager;
    import email.data.EmailInfoOfSended;

    public class EmailModel extends EventDispatcher 
    {

        public var isLoaded:Boolean = false;
        private var _sendedMails:Array = [];
        private var _noReadMails:Array;
        private var _emails:Array = [];
        private var _currentEmail:Array = [];
        private var _mailType:String = "all mails";
        private var _currentDate:Array;
        private var _state:String = "read";
        private var _currentPage:int = 1;
        private var _selectEmail:EmailInfo;

        public function EmailModel(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public function set sendedMails(_arg_1:Array):void
        {
            this._sendedMails = _arg_1;
            if (this._mailType == EmailState.SENDED)
            {
                dispatchEvent(new EmailEvent(EmailEvent.INIT_EMAIL));
            };
        }

        public function get sendedMails():Array
        {
            return (this._sendedMails);
        }

        public function get noReadMails():Array
        {
            return (this._noReadMails);
        }

        public function get currentEmail():Array
        {
            return (this._currentEmail);
        }

        public function set currentEmail(_arg_1:Array):void
        {
            this._currentEmail = _arg_1;
        }

        public function get emails():Array
        {
            return (this._emails.slice(0));
        }

        public function set emails(_arg_1:Array):void
        {
            var _local_3:Number;
            this._emails = [];
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = this.calculateRemainTime(_arg_1[_local_2].SendTime, _arg_1[_local_2].ValidDate);
                if (_local_3 > -1)
                {
                    this._emails.push(_arg_1[_local_2]);
                };
                _local_2++;
            };
            this.getNoReadMails();
            this.isLoaded = true;
            dispatchEvent(new EmailEvent(EmailEvent.INIT_EMAIL));
        }

        public function getValidateMails(_arg_1:Array):Array
        {
            var _local_4:EmailInfo;
            var _local_2:Array = [];
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_4 = (_arg_1[_local_3] as EmailInfo);
                if (_local_4)
                {
                    if (MailManager.Instance.calculateRemainTime(_local_4.SendTime, _local_4.ValidDate) > 0)
                    {
                        _local_2.push(_local_4);
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function set mailType(_arg_1:String):void
        {
            this._mailType = _arg_1;
            this.resetModel();
            dispatchEvent(new EmailEvent(EmailEvent.CHANGE_TYPE));
        }

        public function get mailType():String
        {
            return (this._mailType);
        }

        public function get currentDate():Array
        {
            switch (this._mailType)
            {
                case EmailState.ALL:
                    this._currentDate = this._emails;
                    break;
                case EmailState.NOREAD:
                    this._currentDate = this._noReadMails;
                    break;
                case EmailState.SENDED:
                    this._currentDate = this._sendedMails;
                    break;
                default:
                    this._currentDate = this._emails;
            };
            return (this._currentDate);
        }

        public function set state(_arg_1:String):void
        {
            this._state = _arg_1;
            dispatchEvent(new EmailEvent(EmailEvent.CHANE_STATE));
        }

        public function get state():String
        {
            return (this._state);
        }

        private function resetModel():void
        {
            this._currentPage = 1;
            this.selectEmail = null;
        }

        public function get totalPage():int
        {
            if (this.currentDate)
            {
                if (this.currentDate.length == 0)
                {
                    return (1);
                };
                return (Math.ceil((this.currentDate.length / 7)));
            };
            return (1);
        }

        public function get currentPage():int
        {
            if (this._currentPage > this.totalPage)
            {
                this._currentPage = this.totalPage;
            };
            return (this._currentPage);
        }

        public function set currentPage(_arg_1:int):void
        {
            this._currentPage = _arg_1;
            dispatchEvent(new EmailEvent(EmailEvent.CHANE_PAGE));
        }

        public function getNoReadMails():void
        {
            var _local_1:EmailInfo;
            this._noReadMails = [];
            for each (_local_1 in this._emails)
            {
                if (((SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID]) && (SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID].indexOf(_local_1.ID) > -1)))
                {
                    _local_1.IsRead = true;
                };
                if ((!(_local_1.IsRead)))
                {
                    this._noReadMails.push(_local_1);
                };
            };
        }

        public function getMailByID(_arg_1:int):EmailInfo
        {
            var _local_2:int = this._emails.length;
            var _local_3:uint;
            while (_local_3 < _local_2)
            {
                if ((this._emails[_local_3] as EmailInfo).ID == _arg_1)
                {
                    return (this._emails[_local_3] as EmailInfo);
                };
                _local_3++;
            };
            return (null);
        }

        public function getViewData():Array
        {
            var _local_2:int;
            var _local_3:int;
            if (this._mailType == EmailState.NOREAD)
            {
                this.getNoReadMails();
            };
            var _local_1:Array = new Array();
            if (this.currentDate)
            {
                _local_2 = ((this.currentPage * 7) - 7);
                _local_3 = (((_local_2 + 7) > this.currentDate.length) ? this.currentDate.length : (_local_2 + 7));
                _local_1 = this.currentDate.slice(_local_2, _local_3);
            };
            if (_local_1.length > 7)
            {
            };
            return (_local_1);
        }

        private function calculateRemainTime(_arg_1:String, _arg_2:Number):Number
        {
            var _local_3:String = _arg_1;
            var _local_4:Date = new Date(Number(_local_3.substr(0, 4)), (Number(_local_3.substr(5, 2)) - 1), Number(_local_3.substr(8, 2)), Number(_local_3.substr(11, 2)), Number(_local_3.substr(14, 2)), Number(_local_3.substr(17, 2)));
            var _local_5:Date = TimeManager.Instance.Now();
            var _local_6:Number = (_arg_2 - ((_local_5.time - _local_4.time) / ((60 * 60) * 1000)));
            if (_local_6 < 0)
            {
                return (-1);
            };
            return (_local_6);
        }

        public function get selectEmail():EmailInfo
        {
            return (this._selectEmail);
        }

        public function set selectEmail(_arg_1:EmailInfo):void
        {
            if (_arg_1)
            {
                if (((this._emails.indexOf(_arg_1) <= -1) && (this._sendedMails.indexOf(_arg_1) <= -1)))
                {
                    this._selectEmail = null;
                }
                else
                {
                    this._selectEmail = _arg_1;
                };
            }
            else
            {
                this._selectEmail = null;
            };
            dispatchEvent(new EmailEvent(EmailEvent.SELECT_EMAIL, this._selectEmail));
        }

        public function addEmail(_arg_1:EmailInfo):void
        {
            this._emails.push(_arg_1);
            dispatchEvent(new EmailEvent(EmailEvent.ADD_EMAIL, _arg_1));
        }

        public function addEmailToSended(_arg_1:EmailInfoOfSended):void
        {
            this._sendedMails.unshift(_arg_1);
            if (this._sendedMails.length > 21)
            {
                this._sendedMails.pop();
            };
        }

        public function removeFromNoRead(_arg_1:EmailInfo):void
        {
            var _local_2:int = this._noReadMails.indexOf(_arg_1);
            if (_local_2 > -1)
            {
                this._noReadMails.splice(_local_2, 1);
            };
        }

        public function removeEmail(_arg_1:EmailInfo):void
        {
            var _local_2:int = this._emails.indexOf(_arg_1);
            if (_local_2 > -1)
            {
                this._emails.splice(_local_2, 1);
                this.getNoReadMails();
                dispatchEvent(new EmailEvent(EmailEvent.REMOVE_EMAIL, _arg_1));
            };
        }

        public function removeEmailArray(_arg_1:Array):void
        {
            var _local_2:EmailInfo;
            var _local_3:int;
            for each (_local_2 in _arg_1)
            {
                _local_3 = this._emails.indexOf(_local_2);
                if (_local_3 > -1)
                {
                    this._emails.splice(_local_3, 1);
                };
            };
            this.getNoReadMails();
            dispatchEvent(new EmailEvent(EmailEvent.REMOVE_EMAIL));
        }

        public function changeEmail(_arg_1:EmailInfo):void
        {
            var _local_2:int = this._emails.indexOf(_arg_1);
            _arg_1.IsRead = true;
            if (_local_2 > -1)
            {
                dispatchEvent(new EmailEvent(EmailEvent.SELECT_EMAIL, _arg_1));
            };
        }

        public function clearEmail():void
        {
            this._emails = new Array();
            dispatchEvent(new EmailEvent(EmailEvent.CLEAR_EMAIL));
        }

        public function dispose():void
        {
            this._emails = new Array();
        }

        public function hasUnReadEmail():Boolean
        {
            var _local_1:EmailInfo;
            for each (_local_1 in this._emails)
            {
                if ((!(_local_1.IsRead)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function hasUnReadGiftEmail():Boolean
        {
            var _local_1:EmailInfo;
            for each (_local_1 in this._emails)
            {
                if (((!(_local_1.IsRead)) && (_local_1.MailType == 1)))
                {
                    return (true);
                };
            };
            return (false);
        }


    }
}//package email.model

