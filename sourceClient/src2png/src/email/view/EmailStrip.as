// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.EmailStrip

package email.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import email.data.EmailInfo;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.media.SoundTransform;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import email.data.EmailType;
    import ddt.manager.LanguageMgr;
    import email.manager.MailManager;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BagLockedController;
    import baglocked.SetPassEvent;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.EquipType;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SocketManager;
    import ddt.manager.SharedManager;
    import ddt.manager.TimeManager;
    import flash.events.Event;

    public class EmailStrip extends Sprite implements Disposeable 
    {

        public static const SELECT:String = "select";

        protected var _info:EmailInfo;
        protected var _isReading:Boolean;
        protected var _checkBox:SelectedCheckButton;
        protected var _cell:DiamondOfStrip;
        protected var _emailStripBg:MovieClip;
        protected var _deleteBtn:BaseButton;
        protected var _GMImg:Bitmap;
        protected var _emailType:ScaleFrameImage;
        protected var _EggKingImg:Bitmap;
        protected var _topicTxt:FilterFrameText;
        protected var _senderTxt:FilterFrameText;
        protected var _validityTxt:FilterFrameText;
        protected var _payImg:Bitmap;
        protected var _unReadImg:Bitmap;
        private var _deleteAlert:BaseAlerFrame;
        private var _emptyItem:Boolean = false;
        private var _movie:MovieClip;
        private var _soundControl:SoundTransform;

        public function EmailStrip()
        {
            this.initView();
            this.addEvent();
        }

        protected function initView():void
        {
            var _local_2:Sprite;
            this._emailStripBg = ComponentFactory.Instance.creat("asset.email.EmailStripBG");
            addChildAt(this._emailStripBg, 0);
            this._emailStripBg.bg.gotoAndStop(1);
            this._cell = ComponentFactory.Instance.creatCustomObject("email.emailStrip.cell");
            addChild(this._cell);
            var _local_1:Sprite = this.creatMaskSprit();
            addChild(_local_1);
            this._cell.mask = _local_1;
            this._emailType = ComponentFactory.Instance.creat("email.emailType");
            addChild(this._emailType);
            this._EggKingImg = ComponentFactory.Instance.creatBitmap("asset.email.eggKingAsset");
            addChild(this._EggKingImg);
            this._EggKingImg.visible = false;
            this._topicTxt = ComponentFactory.Instance.creat("email.strip.topicTxt");
            addChild(this._topicTxt);
            _local_2 = new Sprite();
            _local_2.graphics.beginFill(0xFF0000);
            _local_2.graphics.drawRect(0, 0, 218, 18);
            _local_2.graphics.endFill();
            _local_2.x = this._topicTxt.x;
            _local_2.y = this._topicTxt.y;
            addChild(_local_2);
            this._topicTxt.mask = _local_2;
            this._senderTxt = ComponentFactory.Instance.creat("email.strip.senderTxt");
            addChild(this._senderTxt);
            this._validityTxt = ComponentFactory.Instance.creat("email.strip.validityTxt");
            addChild(this._validityTxt);
            this._payImg = ComponentFactory.Instance.creatBitmap("asset.email.payImg");
            addChild(this._payImg);
            this._payImg.visible = true;
            this._unReadImg = ComponentFactory.Instance.creatBitmap("asset.email.unReadImg");
            addChild(this._unReadImg);
            this._unReadImg.visible = false;
            this._deleteBtn = ComponentFactory.Instance.creat("email.stripDeleteBtn");
            addChild(this._deleteBtn);
            buttonMode = true;
            this._checkBox = ComponentFactory.Instance.creat("email.stripCheckBtn");
            addChild(this._checkBox);
            this._checkBox.selected = false;
        }

        private function creatMaskSprit():Sprite
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0xFFFFFF);
            _local_1.graphics.drawRect(24, 4, 45, 45);
            _local_1.graphics.endFill();
            return (_local_1);
        }

        private function addEvent():void
        {
            this._deleteBtn.addEventListener(MouseEvent.CLICK, this.__delete);
            addEventListener(MouseEvent.CLICK, this.__click);
            addEventListener(MouseEvent.MOUSE_OVER, this.__over);
            addEventListener(MouseEvent.MOUSE_OUT, this.__out);
        }

        private function removeEvent():void
        {
            if (this._deleteBtn)
            {
                this._deleteBtn.removeEventListener(MouseEvent.CLICK, this.__delete);
            };
            removeEventListener(MouseEvent.CLICK, this.__click);
            removeEventListener(MouseEvent.MOUSE_OVER, this.__over);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__out);
        }

        public function set info(_arg_1:EmailInfo):void
        {
            this._info = _arg_1;
            this.update();
        }

        public function get info():EmailInfo
        {
            return (this._info);
        }

        public function set isReading(_arg_1:Boolean):void
        {
            if (this._isReading == _arg_1)
            {
                return;
            };
            this._isReading = _arg_1;
            this.update();
        }

        public function get selected():Boolean
        {
            return (this._checkBox.selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (((this._info.Type == EmailType.ADVERT_MAIL) || (this._info.Type == EmailType.CONSORTION_EMAIL)))
            {
                _arg_1 = false;
            };
            this._checkBox.selected = _arg_1;
        }

        public function update():void
        {
            var _local_1:Number;
            this._topicTxt.text = this._info.Title;
            this._senderTxt.text = (LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.sender") + this._info.Sender);
            _local_1 = MailManager.Instance.calculateRemainTime(this._info.SendTime, this._info.ValidDate);
            if (_local_1 >= 24)
            {
                this._validityTxt.text = ((LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.validity") + String(Math.ceil((_local_1 / 24)))) + LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.day"));
            }
            else
            {
                if (((_local_1 > 0) && (_local_1 < 24)))
                {
                    this._validityTxt.text = ((LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.validity") + String(Math.ceil(_local_1))) + LanguageMgr.GetTranslation("hours"));
                }
                else
                {
                    MailManager.Instance.removeMail(this.info);
                    MailManager.Instance.changeSelected(null);
                    this.clearItem();
                };
            };
            this._unReadImg.visible = (!(this._info.IsRead));
            if (this._info.Type > 100)
            {
                this._unReadImg.visible = false;
                this._payImg.visible = (this._info.Money > 0);
            }
            else
            {
                this._deleteBtn.enable = (!((this._info.Type == 58) || (this._info.Type == EmailType.CONSORTION_EMAIL)));
                this._EggKingImg.visible = (this._info.Type == 58);
                this._checkBox.enable = (!((this._info.Type == 58) || (this._info.Type == EmailType.CONSORTION_EMAIL)));
                this._payImg.visible = false;
            };
            if ((((((!(this._info.ReceiverID == this._info.SenderID)) && (this._info.Type == 1)) || (this._info.Type == 67)) || (this._info.Type == 59)) || (this._info.Type == 101)))
            {
                this._emailType.setFrame(1);
            }
            else
            {
                if (this._info.Type == 51)
                {
                    this._emailType.setFrame(2);
                }
                else
                {
                    this._emailType.visible = false;
                };
            };
            if (this._isReading)
            {
                this._emailStripBg.bg.gotoAndStop(2);
            }
            else
            {
                this._emailStripBg.bg.gotoAndStop(1);
            };
            this._cell.info = this._info;
        }

        private function __delete(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            if (((((this.info.hasAnnexs()) || (!(this.info.Money == 0))) || (!(this.info.BindMoney == 0))) || (!(this.info.Gold == 0))))
            {
                this.hightGoods(this.info);
            }
            else
            {
                if (PlayerManager.Instance.Self.bagPwdState)
                {
                    if ((!(PlayerManager.Instance.Self.bagLocked)))
                    {
                        this.ok();
                    }
                    else
                    {
                        BagLockedController.Instance.addEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
                        BaglockedManager.Instance.show();
                        return;
                    };
                }
                else
                {
                    this.ok();
                };
            };
        }

        private function hightGoods(_arg_1:EmailInfo):void
        {
            var _local_4:String;
            var _local_5:InventoryItemInfo;
            if (((!(_arg_1.Money == 0)) || (!(_arg_1.BindMoney == 0))))
            {
                if (PlayerManager.Instance.Self.bagPwdState)
                {
                    if ((!(PlayerManager.Instance.Self.bagLocked)))
                    {
                        this.showAlert();
                    }
                    else
                    {
                        BagLockedController.Instance.addEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
                        BaglockedManager.Instance.show();
                        return;
                    };
                }
                else
                {
                    this.showAlert();
                };
                return;
            };
            var _local_2:Boolean;
            var _local_3:int = 1;
            while (_local_3 <= 5)
            {
                _local_4 = ("Annex" + _local_3);
                if (_arg_1.hasOwnProperty(_local_4))
                {
                    _local_5 = (_arg_1[_local_4] as InventoryItemInfo);
                    if (EquipType.isValuableEquip(_local_5))
                    {
                        _local_2 = true;
                        break;
                    };
                };
                _local_3++;
            };
            if (_local_2)
            {
                if (PlayerManager.Instance.Self.bagPwdState)
                {
                    if ((!(PlayerManager.Instance.Self.bagLocked)))
                    {
                        this.showAlert();
                    }
                    else
                    {
                        BagLockedController.Instance.addEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
                        BaglockedManager.Instance.show();
                        return;
                    };
                }
                else
                {
                    this.showAlert();
                };
            }
            else
            {
                if (PlayerManager.Instance.Self.bagPwdState)
                {
                    if ((!(PlayerManager.Instance.Self.bagLocked)))
                    {
                        this.showAlert();
                    }
                    else
                    {
                        BagLockedController.Instance.addEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
                        BaglockedManager.Instance.show();
                        return;
                    };
                }
                else
                {
                    this.showAlert();
                };
            };
        }

        private function showAlert():void
        {
            if (this._deleteAlert == null)
            {
                this._deleteAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"), LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.delectEmail"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.BLCAK_BLOCKGOUND);
                this._deleteAlert.addEventListener(FrameEvent.RESPONSE, this.__deleteAlertResponse);
            };
        }

        private function disposeAlert():void
        {
            if (this._deleteAlert)
            {
                this._deleteAlert.removeEventListener(FrameEvent.RESPONSE, this.__deleteAlertResponse);
                this._deleteAlert.dispose();
            };
            this._deleteAlert = null;
        }

        private function __cancelBtn(_arg_1:SetPassEvent):void
        {
            BagLockedController.Instance.removeEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
            this.disposeAlert();
        }

        private function __deleteAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._deleteAlert.removeEventListener(FrameEvent.RESPONSE, this.__deleteAlertResponse);
            ObjectUtils.disposeObject(this._deleteAlert);
            if ((((_arg_1.responseCode == FrameEvent.CANCEL_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.cancel();
            };
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.ok();
            };
        }

        private function cancel():void
        {
            SoundManager.instance.play("008");
            this.disposeAlert();
        }

        private function ok():void
        {
            SoundManager.instance.play("008");
            var _local_1:Array = new Array();
            _local_1.push(this.info);
            SocketManager.Instance.out.sendDeleteMail(_local_1);
            this.disposeAlert();
            MailManager.Instance.deleteEmail(this._info);
            this.clearItem();
            MailManager.Instance.removeMail(this.info);
            MailManager.Instance.changeSelected(null);
        }

        public function get emptyItem():Boolean
        {
            return (this._emptyItem);
        }

        private function clearItem():void
        {
            this.removeEvent();
            buttonMode = false;
            this._emptyItem = true;
            this._topicTxt.text = "";
            this._senderTxt.text = "";
            this._validityTxt.text = "";
            if (this._emailType.parent)
            {
                removeChild(this._emailType);
            };
            if (this._topicTxt.parent)
            {
                removeChild(this._topicTxt);
            };
            if (this._senderTxt.parent)
            {
                removeChild(this._senderTxt);
            };
            if (this._validityTxt.parent)
            {
                removeChild(this._validityTxt);
            };
            if (this._unReadImg.parent)
            {
                removeChild(this._unReadImg);
            };
            if (this._payImg.parent)
            {
                removeChild(this._payImg);
            };
            if (this._checkBox.parent)
            {
                removeChild(this._checkBox);
            };
            if (this._cell.parent)
            {
                removeChild(this._cell);
            };
            this._emailStripBg.bg.gotoAndStop(1);
        }

        private function __over(_arg_1:MouseEvent):void
        {
            if ((!(this._isReading)))
            {
                this._emailStripBg.bg.gotoAndStop(2);
            };
        }

        private function __out(_arg_1:MouseEvent):void
        {
            if ((!(this._isReading)))
            {
                this._emailStripBg.bg.gotoAndStop(1);
            };
        }

        private function __click(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            var _local_3:Date;
            var _local_4:Array;
            SoundManager.instance.play("008");
            if (MailManager.Instance.Model.currentEmail.length == 0)
            {
                MailManager.Instance.Model.currentEmail.push(((_arg_1.currentTarget as EmailStrip).info as EmailInfo));
            }
            else
            {
                MailManager.Instance.Model.currentEmail.length = 0;
                MailManager.Instance.Model.currentEmail.push(((_arg_1.currentTarget as EmailStrip).info as EmailInfo));
            };
            if ((!(this._info.IsRead)))
            {
                MailManager.Instance.readEmail(this._info);
                this._info.IsRead = true;
                if (((this._info.Type == EmailType.ADVERT_MAIL) || (this._info.Type == EmailType.CONSORTION_EMAIL)))
                {
                    if (SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID])
                    {
                        _local_4 = (SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID] as Array);
                        if (_local_4.indexOf(this._info.ID) < 0)
                        {
                            _local_4.push(this._info.ID);
                        };
                    }
                    else
                    {
                        SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID] = [this._info.ID];
                    };
                    SharedManager.Instance.save();
                };
                _local_2 = this._info.SendTime;
                _local_3 = new Date(Number(_local_2.substr(0, 4)), (Number(_local_2.substr(5, 2)) - 1), Number(_local_2.substr(8, 2)), Number(_local_2.substr(11, 2)), Number(_local_2.substr(14, 2)), Number(_local_2.substr(17, 2)));
                if (((!((this._info.Type > 100) && (this._info.Money > 0))) && (!(this._info.Type == 58))))
                {
                    this._info.ValidDate = (72 + ((TimeManager.Instance.Now().time - _local_3.time) / ((60 * 60) * 1000)));
                };
                this.update();
            };
            this.isReading = true;
            dispatchEvent(new Event(SELECT));
            MailManager.Instance.changeSelected(this._info);
        }

        protected function __removeMovie(_arg_1:Event):void
        {
            this._movie.removeEventListener(Event.CLOSE, this.__removeMovie);
            this._movie.removeEventListener(MouseEvent.CLICK, this.__movieClickHandler);
            this._soundControl.volume = 0;
            this._movie.soundTransform = this._soundControl;
            this._soundControl = null;
            ObjectUtils.disposeObject(this._movie);
            this._movie = null;
        }

        protected function __addClickEvent(_arg_1:Event):void
        {
            if (this._movie["ikNode_5"])
            {
                this._movie.removeEventListener(Event.ENTER_FRAME, this.__addClickEvent);
                this._movie.addEventListener(MouseEvent.CLICK, this.__movieClickHandler);
                this._movie.buttonMode = true;
            };
        }

        protected function __movieClickHandler(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            MailManager.Instance.hide();
            this.__removeMovie(null);
        }

        override public function get height():Number
        {
            return (this._emailStripBg.height);
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._checkBox)
            {
                ObjectUtils.disposeObject(this._checkBox);
            };
            this._checkBox = null;
            if (this._emailType)
            {
                ObjectUtils.disposeObject(this._emailType);
            };
            this._emailType = null;
            if (this._payImg)
            {
                ObjectUtils.disposeObject(this._payImg);
            };
            this._payImg = null;
            if (this._unReadImg)
            {
                ObjectUtils.disposeObject(this._unReadImg);
            };
            this._unReadImg = null;
            if (this._deleteBtn)
            {
                ObjectUtils.disposeObject(this._deleteBtn);
            };
            this._deleteBtn = null;
            if (this._topicTxt)
            {
                ObjectUtils.disposeObject(this._topicTxt);
            };
            this._topicTxt = null;
            if (this._senderTxt)
            {
                ObjectUtils.disposeObject(this._senderTxt);
            };
            this._senderTxt = null;
            if (this._validityTxt)
            {
                ObjectUtils.disposeObject(this._validityTxt);
            };
            this._validityTxt = null;
            if (this._emailStripBg)
            {
                ObjectUtils.disposeObject(this._emailStripBg);
            };
            this._emailStripBg = null;
            if (this._cell)
            {
                ObjectUtils.disposeObject(this._cell);
            };
            this._cell = null;
            if (this._deleteAlert)
            {
                ObjectUtils.disposeObject(this._deleteAlert);
            };
            this._deleteAlert = null;
            this._info = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            MailManager.Instance.Model.currentEmail.length = 0;
        }


    }
}//package email.view

