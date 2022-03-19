// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.DiamondOfReading

package email.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.events.MouseEvent;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import email.manager.MailManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LeavePageManager;

    public class DiamondOfReading extends DiamondBase 
    {

        private var type:int;
        private var payAlertFrame:BaseAlerFrame;


        public function set readOnly(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.removeEvent();
            }
            else
            {
                this.addEvent();
            };
        }

        override protected function addEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__distill);
        }

        override protected function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__distill);
        }

        override protected function update():void
        {
            var _local_1:*;
            _local_1 = _info.getAnnexByIndex(index);
            chargedImg.visible = false;
            if (((_local_1) && (_local_1 is String)))
            {
                this.buttonMode = true;
                _cell.visible = false;
                centerMC.visible = true;
                countTxt.text = "";
                mouseEnabled = true;
                mouseChildren = true;
                if (_local_1 == "gold")
                {
                    centerMC.setFrame(3);
                    countTxt.text = String(_info.Gold);
                    mouseChildren = false;
                }
                else
                {
                    if (_local_1 == "money")
                    {
                        if (_info.Type > 100)
                        {
                            centerMC.visible = false;
                            mouseEnabled = false;
                            mouseChildren = false;
                        }
                        else
                        {
                            centerMC.setFrame(2);
                            countTxt.text = String(_info.Money);
                            mouseChildren = false;
                        };
                    }
                    else
                    {
                        if (_local_1 == "bindMoney")
                        {
                            centerMC.setFrame(6);
                            countTxt.text = String(_info.BindMoney);
                            mouseChildren = false;
                        };
                    };
                };
            }
            else
            {
                if (_local_1)
                {
                    _cell.visible = true;
                    _cell.info = (_local_1 as InventoryItemInfo);
                    mouseEnabled = true;
                    mouseChildren = true;
                    countTxt.text = "";
                    if (((_info.Type > 100) && (_info.Money > 0)))
                    {
                        centerMC.visible = false;
                        chargedImg.visible = true;
                    }
                    else
                    {
                        centerMC.visible = false;
                    };
                }
                else
                {
                    mouseEnabled = false;
                    mouseChildren = false;
                    centerMC.visible = false;
                    _cell.visible = false;
                    countTxt.text = "";
                };
            };
        }

        private function __distill(_arg_1:MouseEvent):void
        {
            var _local_3:uint;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (_info == null)
            {
                return;
            };
            var _local_2:* = _info.getAnnexByIndex(index);
            if (_local_2)
            {
                _local_3 = 1;
                while (_local_3 <= 5)
                {
                    if (_local_2 == _info[("Annex" + _local_3)])
                    {
                        this.type = _local_3;
                        break;
                    };
                    _local_3++;
                };
                if (_local_2 == "gold")
                {
                    this.type = 6;
                }
                else
                {
                    if (_local_2 == "money")
                    {
                        this.type = 7;
                    }
                    else
                    {
                        if (_local_2 == "bindMoney")
                        {
                            this.type = 8;
                        };
                    };
                };
            };
            if (this.type > -1)
            {
                if ((((_info.Type > 100) && ((this.type >= 1) && (this.type <= 5))) && (_info.Money > 0)))
                {
                    this.payAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.emailII.EmailIIDiamondView.emailTip"), (((LanguageMgr.GetTranslation("tank.view.emailII.EmailIIDiamondView.deleteTip") + " ") + _info.Money) + LanguageMgr.GetTranslation("tank.view.emailII.EmailIIDiamondView.money")), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    this.payAlertFrame.addEventListener(FrameEvent.RESPONSE, this.__payFrameResponse);
                    return;
                };
                MailManager.Instance.getAnnexToBag(_info, this.type);
            };
        }

        private function __payFrameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.payAlertFrame.removeEventListener(FrameEvent.RESPONSE, this.__payFrameResponse);
            this.payAlertFrame.dispose();
            this.payAlertFrame = null;
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                this.confirmPay();
            }
            else
            {
                if ((((_arg_1.responseCode == FrameEvent.CANCEL_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
                {
                    this.canclePay();
                };
            };
        }

        private function confirmPay():void
        {
            var _local_1:BaseAlerFrame;
            if (PlayerManager.Instance.Self.Money >= _info.Money)
            {
                MailManager.Instance.getAnnexToBag(_info, this.type);
                mouseEnabled = false;
                mouseChildren = false;
            }
            else
            {
                _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_1.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
                mouseEnabled = true;
                mouseChildren = true;
            };
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            ObjectUtils.disposeObject(_local_2);
            if (_local_2.parent)
            {
                _local_2.parent.removeChild(_local_2);
            };
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                LeavePageManager.leaveToFillPath();
            };
        }

        private function canclePay():void
        {
            mouseEnabled = true;
            mouseChildren = true;
        }

        override public function dispose():void
        {
            if (this.payAlertFrame)
            {
                this.payAlertFrame.removeEventListener(FrameEvent.RESPONSE, this.__payFrameResponse);
                this.payAlertFrame.dispose();
            };
            this.payAlertFrame = null;
            super.dispose();
        }


    }
}//package email.view

