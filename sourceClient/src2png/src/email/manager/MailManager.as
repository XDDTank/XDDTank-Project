// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.manager.MailManager

package email.manager
{
    import email.model.EmailModel;
    import email.view.EmailView;
    import flash.net.URLVariables;
    import email.view.WritingView;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.utils.RequestVairableCreater;
    import ddt.manager.PlayerManager;
    import ddt.manager.SelectListManager;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.LanguageMgr;
    import email.analyze.AllEmailAnalyzer;
    import email.analyze.SendedEmailAnalyze;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LeavePageManager;
    import ddt.view.MainToolBar;
    import com.pickgliss.ui.ComponentFactory;
    import email.view.EmailEvent;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import email.data.EmailState;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import email.data.EmailInfo;
    import email.data.EmailType;
    import ddt.manager.SharedManager;
    import ddt.manager.TaskManager;
    import road7th.comm.PackageIn;
    import flash.utils.Dictionary;
    import ddt.manager.MessageTipManager;
    import ddt.data.analyze.ShopItemAnalyzer;
    import ddt.manager.ShopManager;
    import ddt.manager.TimeManager;

    public class MailManager 
    {

        private static var useFirst:Boolean = true;
        private static var loadComplete:Boolean = false;
        private static var _instance:MailManager;

        public const NUM_OF_WRITING_DIAMONDS:uint = 4;

        private var _model:EmailModel;
        private var _view:EmailView;
        private var _isShow:Boolean;
        private var args:URLVariables;
        public var isOpenFromBag:Boolean = false;
        private var _write:WritingView;
        private var _name:String;

        public function MailManager()
        {
            this._model = new EmailModel();
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEND_EMAIL, this.__sendEmail);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DELETE_MAIL, this.__deleteMail);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_MAIL_ATTACHMENT, this.__getMailToBag);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAIL_CANCEL, this.__mailCancel);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAIL_RESPONSE, this.__responseMail);
        }

        public static function get Instance():MailManager
        {
            if (_instance == null)
            {
                _instance = new (MailManager)();
            };
            return (_instance);
        }


        public function get Model():EmailModel
        {
            return (this._model);
        }

        public function getAllEmailLoader():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            if (PlayerManager.Instance.Self.consortiaInfo.ChairmanID)
            {
                _local_1["chairmanID"] = PlayerManager.Instance.Self.consortiaInfo.ChairmanID;
            }
            else
            {
                _local_1["chairmanID"] = SelectListManager.Instance.currentLoginRole.ChairmanID;
            };
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("LoadUserMail.ashx"), BaseLoader.COMPRESS_REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("tank.view.emailII.LoadMailAllInfoError");
            _local_2.analyzer = new AllEmailAnalyzer(this.stepAllEmail);
            return (_local_2);
        }

        public function getSendedEmailLoader():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("MailSenderList.ashx"), BaseLoader.COMPRESS_REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("tank.view.emailII.LoadSendInfoError");
            _local_2.analyzer = new SendedEmailAnalyze(this.stepSendedEmails);
            return (_local_2);
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:String = _arg_1.loader.loadErrorMessage;
            if (_arg_1.loader.analyzer)
            {
                _local_2 = ((_arg_1.loader.loadErrorMessage + "\n") + _arg_1.loader.analyzer.message);
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), _arg_1.loader.loadErrorMessage, LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            LeavePageManager.leaveToLoginPath();
        }

        public function loadMail(_arg_1:uint):void
        {
            switch (_arg_1)
            {
                case 1:
                    LoadResourceManager.instance.startLoad(this.getAllEmailLoader());
                    return;
                case 2:
                    LoadResourceManager.instance.startLoad(this.getSendedEmailLoader());
                    return;
                case 3:
                    LoadResourceManager.instance.startLoad(this.getAllEmailLoader());
                    LoadResourceManager.instance.startLoad(this.getSendedEmailLoader());
                    return;
            };
        }

        public function get isShow():Boolean
        {
            return (this._isShow);
        }

        public function stepAllEmail(_arg_1:AllEmailAnalyzer):void
        {
            this._model.emails = _arg_1.list;
            this.changeSelected(null);
            if (this._model.hasUnReadEmail())
            {
                MainToolBar.Instance.unReadEmail = true;
            };
        }

        private function stepSendedEmails(_arg_1:SendedEmailAnalyze):void
        {
            this._model.sendedMails = _arg_1.list;
        }

        public function show():void
        {
            if (loadComplete)
            {
                this._view = null;
                this._view = ComponentFactory.Instance.creatCustomObject("emailView");
                this._view.setup(this, this._model);
                this._view.addEventListener(EmailEvent.ESCAPE_KEY, this.__escapeKeyDown);
                this._isShow = true;
                this._view.show();
            }
            else
            {
                if (useFirst)
                {
                    UIModuleSmallLoading.Instance.progress = 0;
                    UIModuleSmallLoading.Instance.show();
                    UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIModuleProgress);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.EMAIL);
                    useFirst = false;
                };
            };
        }

        private function __onUIModuleProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.EMAIL)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            useFirst = true;
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
        }

        protected function __onUIModuleComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.EMAIL)
            {
                UIModuleSmallLoading.Instance.hide();
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
                loadComplete = true;
                this.show();
            };
        }

        public function hide():void
        {
            MainToolBar.Instance.unReadEmail = false;
            if (this._view)
            {
                this._model.selectEmail = null;
                this._model.mailType = EmailState.ALL;
                this._view.removeEventListener(EmailEvent.ESCAPE_KEY, this.__escapeKeyDown);
                this._view.dispose();
                this._view = null;
            };
            this._isShow = false;
            this.isOpenFromBag = false;
        }

        private function __escapeKeyDown(_arg_1:EmailEvent):void
        {
            if (((this._write) && (this._write.parent)))
            {
                this._write.removeEventListener(EmailEvent.ESCAPE_KEY, this.__escapeKeyDown);
                this._write.removeEventListener(EmailEvent.CLOSE_WRITING_FRAME, this.__closeWritingFrame);
                ObjectUtils.disposeObject(this._write);
                this._write = null;
            };
            if (this._view)
            {
                if (((this._view.writeView) && (this._view.writeView.parent)))
                {
                    this._view.writeView.closeWin();
                }
                else
                {
                    this.hide();
                };
            };
        }

        public function switchVisible():void
        {
            if (((this._view) && (this._view.parent)))
            {
                this.hide();
            }
            else
            {
                this.show();
            };
        }

        public function changeState(_arg_1:String):void
        {
            this._model.state = _arg_1;
        }

        public function showWriting(_arg_1:String=null):void
        {
            this._name = _arg_1;
            if (loadComplete)
            {
                this.creatWriteView();
            }
            else
            {
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onWriteUIModuleComplete);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.EMAIL);
            };
        }

        private function __onWriteUIModuleComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            loadComplete = true;
            if (_arg_1.module == UIModuleTypes.EMAIL)
            {
                this.creatWriteView();
            };
        }

        private function creatWriteView():void
        {
            if (this._write != null)
            {
                this._write = null;
            };
            this._write = ComponentFactory.Instance.creat("email.writingView");
            this._write.type = 0;
            PositionUtils.setPos(this._write, "EmailView.Pos_2");
            this._write.selectInfo = this._model.selectEmail;
            LayerManager.Instance.addToLayer(this._write, LayerManager.GAME_DYNAMIC_LAYER, false, LayerManager.BLCAK_BLOCKGOUND);
            if (((StageReferance.stage) && (StageReferance.stage.focus)))
            {
                (StageReferance.stage.focus == this._write);
            };
            this._write.reset();
            if (this._name != null)
            {
                this._write.setName(this._name);
            };
            this._write.addEventListener(EmailEvent.CLOSE_WRITING_FRAME, this.__closeWritingFrame);
            this._write.addEventListener(FrameEvent.RESPONSE, this.__closeWriting);
            this._write.addEventListener(EmailEvent.ESCAPE_KEY, this.__escapeKeyDown);
            this._write.addEventListener(EmailEvent.DISPOSED, this.__onDispose);
        }

        private function __closeWriting(_arg_1:FrameEvent):void
        {
            if (this._write)
            {
                this._write.closeWin();
            };
        }

        private function __closeWritingFrame(_arg_1:EmailEvent):void
        {
            if (this._write)
            {
                this._write.removeEventListener(FrameEvent.RESPONSE, this.__closeWriting);
                this._write.removeEventListener(EmailEvent.ESCAPE_KEY, this.__escapeKeyDown);
                this._write.removeEventListener(EmailEvent.CLOSE_WRITING_FRAME, this.__closeWritingFrame);
                ObjectUtils.disposeObject(this._write);
                this._write = null;
            };
        }

        private function __onDispose(_arg_1:EmailEvent):void
        {
            if (this._write)
            {
                try
                {
                    this._write.removeEventListener(FrameEvent.RESPONSE, this.__closeWriting);
                    this._write.removeEventListener(EmailEvent.ESCAPE_KEY, this.__escapeKeyDown);
                    this._write.removeEventListener(EmailEvent.CLOSE_WRITING_FRAME, this.__closeWritingFrame);
                    ObjectUtils.disposeObject(this._write);
                }
                catch(e:Error)
                {
                };
            };
            this._write = null;
        }

        public function changeType(_arg_1:String):void
        {
            if (this._model.mailType == _arg_1)
            {
                return;
            };
            this.updateNoReadMails();
            this._model.mailType = _arg_1;
        }

        public function changeSelected(_arg_1:EmailInfo):void
        {
            this._model.selectEmail = _arg_1;
        }

        public function updateNoReadMails():void
        {
            this._model.getNoReadMails();
        }

        public function getAnnexToBag(_arg_1:EmailInfo, _arg_2:int):void
        {
            if ((!(this.HasAtLeastOneDiamond(_arg_1))))
            {
                return;
            };
            SocketManager.Instance.out.sendGetMail(_arg_1.ID, _arg_2);
        }

        private function HasAtLeastOneDiamond(_arg_1:EmailInfo):Boolean
        {
            if (_arg_1.Gold > 0)
            {
                return (true);
            };
            if (_arg_1.Money > 0)
            {
                return (true);
            };
            if (_arg_1.BindMoney > 0)
            {
                return (true);
            };
            var _local_2:uint = 1;
            while (_local_2 <= 5)
            {
                if (_arg_1[("Annex" + _local_2)])
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        public function deleteEmail(_arg_1:EmailInfo):void
        {
            var _local_2:Array;
            if (_arg_1)
            {
                if (_arg_1.Type == EmailType.CONSORTION_EMAIL)
                {
                    if (SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID])
                    {
                        _local_2 = (SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID] as Array);
                        if (_local_2.indexOf(_arg_1.ID) < 0)
                        {
                            _local_2.push(_arg_1.ID);
                        };
                    }
                    else
                    {
                        SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID] = [_arg_1.ID];
                    };
                    SharedManager.Instance.save();
                };
            };
        }

        public function readEmail(_arg_1:EmailInfo):void
        {
            if (this._model.mailType != EmailState.NOREAD)
            {
                this._model.removeFromNoRead(_arg_1);
            };
            SocketManager.Instance.out.sendUpdateMail(_arg_1.ID);
        }

        public function setPage(_arg_1:Boolean, _arg_2:Boolean=true):void
        {
            if (((!(_arg_1)) && (!(_arg_2))))
            {
                this._model.currentPage = this._model.currentPage;
                return;
            };
            if (_arg_1)
            {
                if ((this._model.currentPage - 1) > 0)
                {
                    this._model.currentPage = (this._model.currentPage - 1);
                };
            }
            else
            {
                if ((this._model.currentPage + 1) <= this._model.totalPage)
                {
                    this._model.currentPage = (this._model.currentPage + 1);
                }
                else
                {
                    if (((this._model.mailType == EmailState.NOREAD) && (this._model.totalPage == 1)))
                    {
                        this._model.currentPage = 1;
                    };
                };
            };
        }

        public function sendEmail(_arg_1:Object):void
        {
            SocketManager.Instance.out.sendEmail(_arg_1);
        }

        public function onSendAnnex(_arg_1:Array):void
        {
            TaskManager.instance.onSendAnnex(_arg_1);
        }

        public function untreadEmail(_arg_1:int):void
        {
            SocketManager.Instance.out.untreadEmail(_arg_1);
        }

        private function __getMailToBag(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_7:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:EmailInfo = this._model.getMailByID(_local_3);
            if ((!(_local_5)))
            {
                return;
            };
            if (((_local_5.Type > 100) && (_local_5.Money > 0)))
            {
                _local_5.ValidDate = 72;
                _local_5.Money = 0;
            };
            var _local_6:uint;
            while (_local_6 < _local_4)
            {
                _local_7 = _local_2.readInt();
                this.deleteMailDiamond(_local_5, _local_7);
                _local_6++;
            };
            this._model.changeEmail(_local_5);
        }

        private function deleteMailDiamond(_arg_1:EmailInfo, _arg_2:int):void
        {
            var _local_3:uint;
            switch (_arg_2)
            {
                case 6:
                    _arg_1.Gold = 0;
                    return;
                case 7:
                    _arg_1.Money = 0;
                    return;
                case 8:
                    _arg_1.BindMoney = 0;
                    return;
                case 9:
                    _arg_1.BindMoney = 0;
                    return;
                default:
                    _local_3 = 1;
                    while (_local_3 <= 5)
                    {
                        if (_arg_2 == _local_3)
                        {
                            _arg_1[("Annex" + _local_3)] = null;
                            break;
                        };
                        _local_3++;
                    };
            };
        }

        private function __deleteMail(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_6:Dictionary;
            var _local_7:int;
            var _local_8:int;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Array = new Array();
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_6 = new Dictionary();
                _local_7 = _arg_1.pkg.readInt();
                _local_8 = _arg_1.pkg.readByte();
                _local_6["id"] = _local_7;
                _local_6["isSuccess"] = ((_local_8 >= 1) ? true : false);
                _local_3[_local_4] = _local_6;
                _local_4++;
            };
            var _local_5:int;
            while (_local_5 < _local_3.length)
            {
                if (_local_3[_local_5]["isSuccess"])
                {
                    this.removeMail(this._model.getMailByID(_local_3[_local_5]["id"]));
                    this.changeSelected(null);
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.MailManager.delete"));
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.MailManager.false"));
                };
                _local_5++;
            };
        }

        public function removeMail(_arg_1:EmailInfo):void
        {
            this._model.removeEmail(_arg_1);
        }

        public function removeMailArray(_arg_1:Array):void
        {
            this._model.removeEmailArray(_arg_1);
        }

        private function __sendEmail(_arg_1:CrazyTankSocketEvent):void
        {
            if (_arg_1.pkg.readBoolean())
            {
                if (this._view)
                {
                    this._view.resetWrite();
                };
                if (this._write)
                {
                    this._write.reset();
                };
            };
        }

        private function __mailCancel(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            if (_arg_1.pkg.readBoolean())
            {
                this._model.removeEmail(this._model.selectEmail);
                this.changeSelected(null);
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.MailManager.back"));
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.MailManager.return"));
            };
        }

        private function __responseMail(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:URLVariables;
            var _local_5:BaseLoader;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int = _arg_1.pkg.readInt();
            this.loadMail(_local_3);
            if (_local_3 != 2)
            {
                MainToolBar.Instance.unReadEmail = true;
            };
            if (_local_3 == 5)
            {
                _local_4 = RequestVairableCreater.creatWidthKey(true);
                _local_4["timeTick"] = Math.random();
                _local_5 = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ShopItemList.xml"), BaseLoader.COMPRESS_TEXT_LOADER, _local_4);
                _local_5.analyzer = new ShopItemAnalyzer(ShopManager.Instance.updateShopGoods);
                LoadResourceManager.instance.startLoad(_local_5);
            };
        }

        public function calculateRemainTime(_arg_1:String, _arg_2:Number):Number
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


    }
}//package email.manager

