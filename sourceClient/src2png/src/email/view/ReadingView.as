// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.ReadingView

package email.view
{
    import com.pickgliss.ui.controls.Frame;
    import email.data.EmailInfo;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.container.HBox;
    import ddt.view.common.LevelIcon;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import ddt.manager.PathManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import feedback.data.FeedbackInfo;
    import feedback.FeedbackManager;
    import road7th.utils.DateUtils;
    import ddt.manager.MessageTipManager;
    import email.data.EmailInfoOfSended;
    import im.IMController;
    import email.data.EmailType;
    import email.manager.MailManager;
    import com.pickgliss.utils.ObjectUtils;
    import email.data.EmailState;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.EquipType;
    import ddt.manager.PlayerManager;
    import baglocked.BagLockedController;
    import baglocked.SetPassEvent;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import ddt.manager.TimeManager;
    import com.pickgliss.toplevel.StageReferance;

    public class ReadingView extends Frame 
    {

        private const _PRESENTGIFT:int = 16;

        private var _info:EmailInfo;
        private var _line:ScaleBitmapImage;
        private var _readViewBg:MovieClip;
        private var _readViewBgI:Bitmap;
        private var _readViewBgII:Scale9CornerImage;
        private var _senderTip:FilterFrameText;
        private var _topicTip:FilterFrameText;
        private var _sender:FilterFrameText;
        private var _topic:FilterFrameText;
        private var _content:TextArea;
        private var _leftTopBtnGroup:SelectedButtonGroup;
        private var _emailListButton:SelectedTextButton;
        private var _noReadButton:SelectedTextButton;
        private var _sendedButton:SelectedTextButton;
        private var _leftPageBtn:BaseButton;
        private var _rightPageBtn:BaseButton;
        private var _pageTxt:FilterFrameText;
        private var _selectAllBtn:TextButton;
        private var _deleteBtn:TextButton;
        private var _reciveMailBtn:TextButton;
        private var _help_btn:BaseButton;
        private var _helpPage:Frame;
        private var _helpPageCloseBtn:TextButton;
        private var _diamonds:Array;
        private var _list:EmailListView;
        private var _diamondHBox:HBox;
        private var _levelIcon:LevelIcon;
        private var _tempInfo:PlayerInfo;
        private var _complainBtn:TextButton;
        private var _titleExplain:FilterFrameText;
        private var _titleBmp:Bitmap;
        private var _complainAlert:BaseAlerFrame;
        private var _helpPageBg:Scale9CornerImage;
        private var _helpWord:MovieImage;
        private var _alertFrame:BaseAlerFrame;

        public function ReadingView()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.email.title");
            addToContent(this._titleBmp);
            this._line = ComponentFactory.Instance.creatComponentByStylename("email.readView.TabBtnLine");
            addToContent(this._line);
            this._readViewBgI = ComponentFactory.Instance.creatBitmap("asset.email.readViewBgI");
            addToContent(this._readViewBgI);
            this._readViewBg = ClassUtils.CreatInstance("asset.email.readViewBg");
            PositionUtils.setPos(this._readViewBg, "readingViewBG.pos");
            addToContent(this._readViewBg);
            this._readViewBgII = ComponentFactory.Instance.creatComponentByStylename("email.diamond.bg");
            addToContent(this._readViewBgII);
            this._titleExplain = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.explainTxt.text");
            this._titleExplain.text = LanguageMgr.GetTranslation("auctionHouse.explainTxt.text");
            PositionUtils.setPos(this._titleExplain, "email.titleExplain.pos");
            addToContent(this._titleExplain);
            this.addLeftTopBtnGroup();
            var _local_1:ScaleLeftRightImage = ComponentFactory.Instance.creatComponentByStylename("email.PageCountBg");
            addToContent(_local_1);
            this._leftPageBtn = ComponentFactory.Instance.creat("email.leftPageBtn");
            addToContent(this._leftPageBtn);
            this._leftPageBtn.enable = false;
            this._rightPageBtn = ComponentFactory.Instance.creat("email.rightPageBtn");
            addToContent(this._rightPageBtn);
            this._rightPageBtn.enable = false;
            this._pageTxt = ComponentFactory.Instance.creat("email.pageTxt");
            this._pageTxt.text = "1/1";
            addToContent(this._pageTxt);
            this._selectAllBtn = ComponentFactory.Instance.creat("email.selectAllBtn");
            this._selectAllBtn.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.textBtnFont1");
            addToContent(this._selectAllBtn);
            this._deleteBtn = ComponentFactory.Instance.creat("email.deleteBtn");
            this._deleteBtn.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.textBtnFont2");
            addToContent(this._deleteBtn);
            this._reciveMailBtn = ComponentFactory.Instance.creat("email.reciveMailBtn");
            this._reciveMailBtn.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.textBtnFont3");
            addToContent(this._reciveMailBtn);
            this._senderTip = ComponentFactory.Instance.creatComponentByStylename("email.senderTipTxt");
            this._senderTip.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.senderTip");
            addToContent(this._senderTip);
            this._topicTip = ComponentFactory.Instance.creatComponentByStylename("email.topicTipTxt");
            this._topicTip.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.topicTip");
            addToContent(this._topicTip);
            this._sender = ComponentFactory.Instance.creat("email.senderTxt");
            this._sender.maxChars = 36;
            addToContent(this._sender);
            this._topic = ComponentFactory.Instance.creat("email.topicTxt");
            this._topic.maxChars = 22;
            addToContent(this._topic);
            this._content = ComponentFactory.Instance.creatComponentByStylename("email.content");
            addToContent(this._content);
            this._diamondHBox = ComponentFactory.Instance.creat("emial.diamondHbox");
            addToContent(this._diamondHBox);
            this._diamonds = new Array();
            var _local_2:uint;
            while (_local_2 < 5)
            {
                this._diamonds[_local_2] = new DiamondOfReading();
                this._diamonds[_local_2].index = _local_2;
                this._diamondHBox.addChild(this._diamonds[_local_2]);
                _local_2++;
            };
            this._diamondHBox.refreshChildPos();
            this._help_btn = ComponentFactory.Instance.creat("email.helpPageBtn");
            addToContent(this._help_btn);
            this._list = ComponentFactory.Instance.creat("email.emailListView");
            addToContent(this._list);
            if (PathManager.solveFeedbackEnable())
            {
                this._complainBtn = ComponentFactory.Instance.creatComponentByStylename("email.complainbtn");
                this._complainBtn.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.textBtnFont5");
                addToContent(this._complainBtn);
                this._complainBtn.visible = false;
            };
        }

        private function addLeftTopBtnGroup():void
        {
            this._leftTopBtnGroup = new SelectedButtonGroup();
            this._emailListButton = ComponentFactory.Instance.creat("emailListBtn");
            this._emailListButton.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.selectBtnFont1");
            this._leftTopBtnGroup.addSelectItem(this._emailListButton);
            addToContent(this._emailListButton);
            this._noReadButton = ComponentFactory.Instance.creat("noReadBtn");
            this._noReadButton.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.selectBtnFont2");
            this._leftTopBtnGroup.addSelectItem(this._noReadButton);
            addToContent(this._noReadButton);
            this._sendedButton = ComponentFactory.Instance.creat("sendedBtn");
            this._sendedButton.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.selectBtnFont3");
            this._leftTopBtnGroup.selectIndex = 0;
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._emailListButton.addEventListener(MouseEvent.CLICK, this.__selectMailTypeListener);
            this._noReadButton.addEventListener(MouseEvent.CLICK, this.__selectMailTypeListener);
            this._sendedButton.addEventListener(MouseEvent.CLICK, this.__selectMailTypeListener);
            this._leftPageBtn.addEventListener(MouseEvent.CLICK, this.__lastPage);
            this._rightPageBtn.addEventListener(MouseEvent.CLICK, this.__nextPage);
            this._selectAllBtn.addEventListener(MouseEvent.CLICK, this.__selectAllListener);
            this._deleteBtn.addEventListener(MouseEvent.CLICK, this.__deleteSelectListener);
            this._reciveMailBtn.addEventListener(MouseEvent.CLICK, this.__receiveExListener);
            this._help_btn.addEventListener(MouseEvent.CLICK, this.__help);
            if (PathManager.solveFeedbackEnable())
            {
                this._complainBtn.addEventListener(MouseEvent.CLICK, this.__complainhandler);
            };
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._emailListButton.removeEventListener(MouseEvent.CLICK, this.__selectMailTypeListener);
            this._noReadButton.removeEventListener(MouseEvent.CLICK, this.__selectMailTypeListener);
            this._sendedButton.removeEventListener(MouseEvent.CLICK, this.__selectMailTypeListener);
            this._leftPageBtn.removeEventListener(MouseEvent.CLICK, this.__lastPage);
            this._rightPageBtn.removeEventListener(MouseEvent.MOUSE_DOWN, this.__nextPage);
            this._selectAllBtn.removeEventListener(MouseEvent.CLICK, this.__selectAllListener);
            this._deleteBtn.removeEventListener(MouseEvent.CLICK, this.__deleteSelectListener);
            this._reciveMailBtn.removeEventListener(MouseEvent.CLICK, this.__receiveExListener);
            this._help_btn.removeEventListener(MouseEvent.CLICK, this.__help);
            if (this._helpPageCloseBtn)
            {
                this._helpPageCloseBtn.removeEventListener(MouseEvent.CLICK, this.__helpPageClose);
                this._helpPage.removeEventListener(FrameEvent.RESPONSE, this.__helpResponseHandler);
            };
            if (PathManager.solveFeedbackEnable())
            {
                this._complainBtn.addEventListener(MouseEvent.CLICK, this.__complainhandler);
            };
        }

        private function __complainhandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._complainAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("email.complain.confim"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
            this._complainAlert.addEventListener(FrameEvent.RESPONSE, this.__frameResponse);
        }

        protected function __frameResponse(_arg_1:FrameEvent):void
        {
            var _local_2:FeedbackInfo;
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (FeedbackManager.instance.examineTime())
                    {
                        _local_2 = new FeedbackInfo();
                        _local_2.question_title = LanguageMgr.GetTranslation("email.complain.lan");
                        _local_2.question_content = this._info.Content;
                        _local_2.occurrence_date = DateUtils.dateFormat(new Date());
                        _local_2.question_type = 8;
                        _local_2.report_user_name = this._info.Sender;
                        FeedbackManager.instance.submitFeedbackInfo(_local_2);
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.SystemsAnalysis"));
                    };
                    break;
            };
            this._complainAlert.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse);
            this._complainAlert.dispose();
            this._complainAlert = null;
        }

        public function set info(_arg_1:EmailInfo):void
        {
            this._info = _arg_1;
            if ((this._info is EmailInfoOfSended))
            {
                this.updateSended();
                return;
            };
            this.update();
            if (((this._info) && (((this._info.Type == 1) || (this._info.Type == 101)) || (this._info.Type == 10))))
            {
                IMController.Instance.saveRecentContactsID(this._info.SenderID);
            };
        }

        private function updateSended():void
        {
            var _local_1:EmailInfoOfSended = (this._info as EmailInfoOfSended);
            if (_local_1.Type == EmailType.CONSORTION_EMAIL)
            {
                this._sender.text = LanguageMgr.GetTranslation("tank.view.common.ConsortiaIcon.self");
            }
            else
            {
                this._sender.text = ((_local_1) ? _local_1.Receiver : "");
            };
            this._topic.text = ((_local_1) ? _local_1.Title : "");
            this._content.text = ((_local_1) ? _local_1.Content : "");
            this._content.textField.text = (this._content.textField.text + ("\n" + _local_1.AnnexRemark));
            this._list.updateInfo(this._info);
        }

        private function update():void
        {
            var _local_1:DiamondOfReading;
            if (((this._info) && (((((!(this._info.ReceiverID == this._info.SenderID)) && (this._info.Type == 1)) || (this._info.Type == 59)) || (this._info.Type == 67)) || (this._info.Type == 101))))
            {
                if (PathManager.solveFeedbackEnable())
                {
                    this._complainBtn.visible = true;
                };
            }
            else
            {
                if (PathManager.solveFeedbackEnable())
                {
                    this._complainBtn.visible = false;
                };
            };
            this._sender.text = ((this._info) ? this._info.Sender : "");
            this._topic.text = ((this._info) ? this._info.Title : "");
            this._content.text = ((this._info) ? this._info.Content : "");
            for each (_local_1 in this._diamonds)
            {
                _local_1.info = this._info;
            };
            this._list.updateInfo(this._info);
        }

        public function setListView(_arg_1:Array, _arg_2:int, _arg_3:int, _arg_4:Boolean=false):void
        {
            this._list.update(_arg_1, _arg_4);
            this._pageTxt.text = ((_arg_3.toString() + "/") + _arg_2.toString());
            this._leftPageBtn.enable = (((_arg_3 == 0) || (_arg_3 == 1)) ? false : true);
            this._rightPageBtn.enable = ((_arg_3 == _arg_2) ? false : true);
        }

        public function switchBtnsVisible(_arg_1:Boolean):void
        {
            this._selectAllBtn.visible = _arg_1;
            this._deleteBtn.visible = _arg_1;
            this._reciveMailBtn.visible = _arg_1;
        }

        private function btnSound():void
        {
            SoundManager.instance.play("043");
        }

        public function set readOnly(_arg_1:Boolean):void
        {
            var _local_2:uint;
            while (_local_2 < 5)
            {
                (this._diamonds[_local_2] as DiamondOfReading).readOnly = _arg_1;
                (this._diamonds[_local_2] as DiamondOfReading).visible = (!(_arg_1));
                _local_2++;
            };
        }

        private function closeWin():void
        {
            MailManager.Instance.hide();
        }

        public function personalHide():void
        {
        }

        private function createHelpPage():void
        {
            this._helpPage = ComponentFactory.Instance.creat("email.helpPageFrame");
            this._helpPage.escEnable = true;
            this._helpPage.titleText = LanguageMgr.GetTranslation("tank.view.emailII.ReadingView.useHelp");
            LayerManager.Instance.addToLayer(this._helpPage, LayerManager.GAME_TOP_LAYER, true);
            this._helpPageBg = ComponentFactory.Instance.creatComponentByStylename("email.helpPageFrameBG");
            this._helpPage.addToContent(this._helpPageBg);
            this._helpPageCloseBtn = ComponentFactory.Instance.creat("email.helpPageCloseBtn");
            this._helpPageCloseBtn.text = LanguageMgr.GetTranslation("close");
            this._helpPage.addToContent(this._helpPageCloseBtn);
            this._helpPageCloseBtn.addEventListener(MouseEvent.CLICK, this.__helpPageClose);
            this._helpWord = ComponentFactory.Instance.creat("email.helpPageWord");
            this._helpPage.addToContent(this._helpWord);
            this._helpPage.visible = false;
            this._helpPage.addEventListener(FrameEvent.RESPONSE, this.__helpResponseHandler);
        }

        private function __helpResponseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this._helpPage.visible = false;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            if (this._complainAlert)
            {
                this._complainAlert.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse);
                this._complainAlert.dispose();
            };
            this._complainAlert = null;
            if (this._titleBmp)
            {
                ObjectUtils.disposeObject(this._titleBmp);
            };
            this._titleBmp = null;
            if (this._line)
            {
                ObjectUtils.disposeObject(this._line);
            };
            this._line = null;
            if (this._readViewBg)
            {
                ObjectUtils.disposeObject(this._readViewBg);
            };
            this._readViewBg = null;
            if (this._readViewBgII)
            {
                ObjectUtils.disposeObject(this._readViewBgII);
            };
            this._readViewBgII = null;
            if (this._readViewBgI)
            {
                ObjectUtils.disposeObject(this._readViewBgI);
            };
            this._readViewBgI = null;
            if (this._sender)
            {
                ObjectUtils.disposeObject(this._sender);
            };
            this._sender = null;
            if (this._topic)
            {
                ObjectUtils.disposeObject(this._topic);
            };
            this._topic = null;
            if (this._leftTopBtnGroup)
            {
                ObjectUtils.disposeObject(this._leftTopBtnGroup);
            };
            this._leftTopBtnGroup = null;
            if (this._emailListButton)
            {
                ObjectUtils.disposeObject(this._emailListButton);
            };
            this._emailListButton = null;
            if (this._noReadButton)
            {
                ObjectUtils.disposeObject(this._noReadButton);
            };
            this._noReadButton = null;
            if (this._sendedButton)
            {
                ObjectUtils.disposeObject(this._sendedButton);
            };
            this._sendedButton = null;
            if (this._leftPageBtn)
            {
                ObjectUtils.disposeObject(this._leftPageBtn);
            };
            this._leftPageBtn = null;
            if (this._rightPageBtn)
            {
                ObjectUtils.disposeObject(this._rightPageBtn);
            };
            this._rightPageBtn = null;
            if (this._pageTxt)
            {
                ObjectUtils.disposeObject(this._pageTxt);
            };
            this._pageTxt = null;
            if (this._selectAllBtn)
            {
                ObjectUtils.disposeObject(this._selectAllBtn);
            };
            this._selectAllBtn = null;
            if (this._deleteBtn)
            {
                ObjectUtils.disposeObject(this._deleteBtn);
            };
            this._deleteBtn = null;
            if (this._reciveMailBtn)
            {
                ObjectUtils.disposeObject(this._reciveMailBtn);
            };
            this._reciveMailBtn = null;
            if (this._help_btn)
            {
                ObjectUtils.disposeObject(this._help_btn);
            };
            this._help_btn = null;
            if (this._list)
            {
                ObjectUtils.disposeObject(this._list);
            };
            this._list = null;
            if (this._diamondHBox)
            {
                ObjectUtils.disposeObject(this._diamondHBox);
            };
            this._diamondHBox = null;
            if (this._senderTip)
            {
                ObjectUtils.disposeObject(this._senderTip);
            };
            this._senderTip = null;
            if (this._topicTip)
            {
                ObjectUtils.disposeObject(this._topicTip);
            };
            this._topicTip = null;
            if (this._complainBtn)
            {
                ObjectUtils.disposeObject(this._complainBtn);
            };
            this._complainBtn = null;
            this._info = null;
            this._diamonds = null;
            this.helpPageDispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function helpPageDispose():void
        {
            if (this._helpPage)
            {
                if (this._helpPageCloseBtn)
                {
                    ObjectUtils.disposeObject(this._helpPageCloseBtn);
                };
                this._helpPageCloseBtn = null;
                if (this._helpPageBg)
                {
                    ObjectUtils.disposeObject(this._helpPageBg);
                };
                this._helpPageBg = null;
                if (this._helpWord)
                {
                    ObjectUtils.disposeObject(this._helpWord);
                };
                this._helpWord = null;
                this._helpPage.dispose();
                if (((this._helpPage) && (this._helpPage.parent)))
                {
                    this._helpPage.parent.removeChild(this._helpPage);
                };
                this._helpPage = null;
            };
        }

        private function __selectMailTypeListener(_arg_1:MouseEvent):void
        {
            this.btnSound();
            if (_arg_1.currentTarget == this._emailListButton)
            {
                this._senderTip.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.senderTip");
                MailManager.Instance.changeType(EmailState.ALL);
            }
            else
            {
                if (_arg_1.currentTarget == this._noReadButton)
                {
                    this._senderTip.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.senderTip");
                    MailManager.Instance.changeType(EmailState.NOREAD);
                }
                else
                {
                    this._senderTip.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.geterTip");
                    MailManager.Instance.changeType(EmailState.SENDED);
                };
            };
        }

        private function __lastPage(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("045");
            MailManager.Instance.setPage(true, this._list.canChangePage());
            MailManager.Instance.changeSelected(null);
        }

        private function __nextPage(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("045");
            MailManager.Instance.setPage(false, this._list.canChangePage());
            MailManager.Instance.changeSelected(null);
        }

        private function __selectAllListener(_arg_1:MouseEvent):void
        {
            this.btnSound();
            this._list.switchSeleted();
        }

        private function __deleteSelectListener(_arg_1:MouseEvent):void
        {
            this.btnSound();
            var _local_2:Array = this._list.getSelectedMails();
            if (_local_2.length > 0)
            {
                if (this.hightGoods(_local_2))
                {
                    this.ok();
                };
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.ReadingView.deleteSelectListener"));
            };
        }

        private function hightGoods(_arg_1:Array):Boolean
        {
            var _local_5:EmailInfo;
            var _local_6:int;
            var _local_7:String;
            var _local_8:InventoryItemInfo;
            var _local_2:Boolean;
            var _local_3:Boolean;
            var _local_4:Boolean;
            for each (_local_5 in _arg_1)
            {
                if (((!(_local_5.Money == 0)) || (!(_local_5.BindMoney == 0))))
                {
                    _local_3 = true;
                };
                _local_6 = 1;
                while (_local_6 <= 5)
                {
                    _local_7 = ("Annex" + _local_6);
                    if (_local_5.hasOwnProperty(_local_7))
                    {
                        _local_8 = (_local_5[_local_7] as InventoryItemInfo);
                        if (_local_8)
                        {
                            if ((!(_local_3)))
                            {
                                _local_3 = true;
                            };
                        };
                        if (EquipType.isValuableEquip(_local_8))
                        {
                            _local_2 = false;
                            _local_4 = true;
                            break;
                        };
                    };
                    _local_6++;
                };
            };
            if (_local_4)
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
                    };
                }
                else
                {
                    this.showAlert();
                };
            }
            else
            {
                if (_local_3)
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
                            this.ok();
                        }
                        else
                        {
                            BagLockedController.Instance.addEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
                            BaglockedManager.Instance.show();
                        };
                    }
                    else
                    {
                        this.ok();
                    };
                };
            };
            return (_local_2);
        }

        private function __cancelBtn(_arg_1:SetPassEvent):void
        {
            BagLockedController.Instance.removeEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
            this.disposeAlert();
        }

        private function showAlert():void
        {
            if (this._alertFrame == null)
            {
                this._alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"), LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.delectEmail"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.BLCAK_BLOCKGOUND);
                this._alertFrame.addEventListener(FrameEvent.RESPONSE, this.__simpleAlertResponse);
            };
        }

        private function disposeAlert():void
        {
            if (this._alertFrame)
            {
                this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__simpleAlertResponse);
                this._alertFrame.dispose();
            };
            this._alertFrame = null;
        }

        private function __simpleAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__simpleAlertResponse);
            ObjectUtils.disposeObject(this._alertFrame);
            if (this._alertFrame.parent)
            {
                this._alertFrame.parent.removeChild(this._alertFrame);
            };
            if ((((_arg_1.responseCode == FrameEvent.CANCEL_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.cancel();
            }
            else
            {
                if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
                {
                    this.ok();
                };
            };
        }

        private function cancel():void
        {
            this.btnSound();
            this.disposeAlert();
        }

        private function ok():void
        {
            this.btnSound();
            this.disposeAlert();
            var _local_1:Array = this._list.getSelectedMails();
            var _local_2:uint;
            while (_local_2 < _local_1.length)
            {
                MailManager.Instance.deleteEmail(_local_1[_local_2]);
                _local_2++;
            };
            SocketManager.Instance.out.sendDeleteMail(_local_1);
        }

        private function __receiveExListener(_arg_1:MouseEvent):void
        {
            var _local_3:uint;
            var _local_4:EmailInfo;
            var _local_5:String;
            var _local_6:Date;
            this.btnSound();
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:Array = this._list.getSelectedMails();
            if (((_local_2.length > 0) || (this._info)))
            {
                if (_local_2.length > 0)
                {
                    _local_3 = 0;
                    while (_local_3 < _local_2.length)
                    {
                        if (!(((_local_2[_local_3] as EmailInfo).Type > 100) && ((_local_2[_local_3] as EmailInfo).Money > 0)))
                        {
                            _local_4 = (_local_2[_local_3] as EmailInfo);
                            if ((!(_local_4.IsRead)))
                            {
                                _local_5 = _local_4.SendTime;
                                _local_6 = new Date(Number(_local_5.substr(0, 4)), (Number(_local_5.substr(5, 2)) - 1), Number(_local_5.substr(8, 2)), Number(_local_5.substr(11, 2)), Number(_local_5.substr(14, 2)), Number(_local_5.substr(17, 2)));
                                _local_4.ValidDate = (72 + ((TimeManager.Instance.Now().time - _local_6.time) / ((60 * 60) * 1000)));
                                _local_4.IsRead = true;
                                this._list.updateInfo(_local_4);
                            };
                            MailManager.Instance.getAnnexToBag(_local_2[_local_3], 0);
                        };
                        _local_3++;
                    };
                };
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.ReadingView.deleteSelectListener"));
            };
        }

        private function __help(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            if ((!(this._helpPage)))
            {
                this.createHelpPage();
            };
            StageReferance.stage.focus = this._helpPage;
            this._helpPage.visible = ((this._helpPage.visible) ? false : true);
        }

        private function __helpPageClose(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._helpPage.visible = false;
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)
            {
                this.btnSound();
                this.closeWin();
            };
        }


    }
}//package email.view

