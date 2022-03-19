// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.EmailStripSended

package email.view
{
    import email.data.EmailType;
    import ddt.manager.LanguageMgr;
    import email.data.EmailInfoOfSended;

    public class EmailStripSended extends EmailStrip 
    {


        override protected function initView():void
        {
            super.initView();
            _checkBox.visible = false;
            _payImg.visible = false;
            _unReadImg.visible = false;
            _deleteBtn.visible = false;
            _emailType.visible = false;
        }

        override public function update():void
        {
            _topicTxt.text = _info.Title;
            if (_info.Type == EmailType.CONSORTION_EMAIL)
            {
                _senderTxt.text = LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripSended.sender_txtMember");
            }
            else
            {
                _senderTxt.text = (LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripSended.sender_txt") + (_info as EmailInfoOfSended).Receiver);
            };
            if (_isReading)
            {
                _emailStripBg.bg.gotoAndStop(2);
            }
            else
            {
                _emailStripBg.bg.gotoAndStop(1);
            };
            _cell.centerMC.visible = true;
            _cell.centerMC.setFrame(5);
        }


    }
}//package email.view

