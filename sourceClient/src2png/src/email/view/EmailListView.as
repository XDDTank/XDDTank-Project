// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.EmailListView

package email.view
{
    import com.pickgliss.ui.controls.container.VBox;
    import email.data.EmailInfo;
    import ddt.manager.LanguageMgr;
    import email.data.EmailType;
    import email.manager.MailManager;
    import flash.events.Event;

    public class EmailListView extends VBox 
    {

        private var _strips:Array;

        public function EmailListView()
        {
            this._strips = new Array();
        }

        private function addEvent():void
        {
        }

        private function removeEvent():void
        {
        }

        public function update(_arg_1:Array, _arg_2:Boolean=false):void
        {
            var _local_4:EmailStrip;
            this.clearElements();
            var _local_3:uint;
            while (_local_3 < _arg_1.length)
            {
                if (_arg_2)
                {
                    _local_4 = new EmailStripSended();
                }
                else
                {
                    _local_4 = new EmailStrip();
                };
                _local_4.addEventListener(EmailStrip.SELECT, this.__select);
                _local_4.info = (_arg_1[_local_3] as EmailInfo);
                if (((_local_4.info.Title == LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionCellView.Object")) && (_local_4.info.Type == 9)))
                {
                    if (_local_4.info.Annex1)
                    {
                        _local_4.info.Annex1.ValidDate = -1;
                    };
                };
                addChild(_local_4);
                this._strips.push(_local_4);
                _local_3++;
            };
            refreshChildPos();
        }

        public function switchSeleted():void
        {
            if (((this.allHasSelected()) || (this.isHaveConsortionMail())))
            {
                this.changeAll(false);
                return;
            };
            this.changeAll(true);
        }

        private function allHasSelected():Boolean
        {
            var _local_1:uint;
            while (_local_1 < this._strips.length)
            {
                if (EmailStrip(this._strips[_local_1]).info.Type != EmailType.ADVERT_MAIL)
                {
                    if ((!(EmailStrip(this._strips[_local_1]).selected)))
                    {
                        return (false);
                    };
                };
                _local_1++;
            };
            return (true);
        }

        private function changeAll(_arg_1:Boolean):void
        {
            var _local_2:uint;
            while (_local_2 < this._strips.length)
            {
                EmailStrip(this._strips[_local_2]).selected = _arg_1;
                _local_2++;
            };
        }

        private function isHaveConsortionMail():Boolean
        {
            var _local_3:EmailStrip;
            var _local_1:Boolean = true;
            var _local_2:Boolean;
            for each (_local_3 in this._strips)
            {
                if (_local_3.info.Type == EmailType.CONSORTION_EMAIL)
                {
                    _local_2 = true;
                }
                else
                {
                    if (((!(_local_3.selected)) && (!(_local_3.info.Type == EmailType.CONSORTION_EMAIL))))
                    {
                        _local_1 = false;
                        break;
                    };
                };
            };
            return ((_local_1) && (_local_2));
        }

        public function getSelectedMails():Array
        {
            var _local_3:Array;
            var _local_4:EmailInfo;
            var _local_1:Array = [];
            var _local_2:uint;
            while (_local_2 < this._strips.length)
            {
                if ((((EmailStrip(this._strips[_local_2]).selected) && (!(EmailStrip(this._strips[_local_2]).info.Type == EmailType.ADVERT_MAIL))) && (!(EmailStrip(this._strips[_local_2]).info.Type == EmailType.CONSORTION_EMAIL))))
                {
                    _local_1.push(EmailStrip(this._strips[_local_2]).info);
                };
                _local_2++;
            };
            if (_local_1.length == 0)
            {
                _local_3 = new Array();
                _local_3 = MailManager.Instance.Model.currentEmail;
                for each (_local_4 in _local_1)
                {
                    if (((!(_local_4.Type == EmailType.ADVERT_MAIL)) && (!(_local_4.Type == EmailType.CONSORTION_EMAIL))))
                    {
                        _local_1.push(_local_4);
                    };
                };
            };
            return (_local_1);
        }

        public function updateInfo(_arg_1:EmailInfo):void
        {
            var _local_2:EmailStrip;
            if (_arg_1 == null)
            {
                return;
            };
            for each (_local_2 in this._strips)
            {
                if (_arg_1 == _local_2.info)
                {
                    _local_2.info = _arg_1;
                    break;
                };
            };
        }

        private function clearElements():void
        {
            var _local_1:int;
            while (_local_1 < this._strips.length)
            {
                this._strips[_local_1].removeEventListener(EmailStrip.SELECT, this.__select);
                this._strips[_local_1].dispose();
                this._strips[_local_1] = null;
                _local_1++;
            };
            this._strips = new Array();
        }

        private function __select(_arg_1:Event):void
        {
            var _local_3:EmailStrip;
            var _local_2:EmailStrip = (_arg_1.target as EmailStrip);
            for each (_local_3 in this._strips)
            {
                if (_local_3 != _local_2)
                {
                    _local_3.isReading = false;
                };
            };
        }

        internal function canChangePage():Boolean
        {
            var _local_1:EmailStrip;
            for each (_local_1 in this._strips)
            {
                if (_local_1.emptyItem)
                {
                    return (false);
                };
            };
            return (true);
        }


    }
}//package email.view

