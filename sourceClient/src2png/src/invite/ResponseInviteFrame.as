// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//invite.ResponseInviteFrame

package invite
{
    import com.pickgliss.ui.controls.Frame;
    import road7th.data.DictionaryData;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.LanguageMgr;
    import ddt.data.InviteInfo;
    import flash.utils.Timer;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.DisplayUtils;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import turnplate.TurnPlateController;
    import ddt.manager.SocketManager;
    import game.GameManager;
    import ddt.manager.MapManager;
    import room.model.RoomInfo;
    import flash.events.TimerEvent;

    public class ResponseInviteFrame extends Frame 
    {

        private static const InvitePool:DictionaryData = new DictionaryData(true);

        private var _titleBackground:Bitmap;
        private var _responseTitle:FilterFrameText;
        private var _modeLabel:Bitmap;
        private var _mode:ScaleFrameImage;
        private var _leftLabel:FilterFrameText;
        private var _leftField:FilterFrameText;
        private var _rightLabel:FilterFrameText;
        private var _rightField:FilterFrameText;
        private var _levelField:FilterFrameText;
        private var _levelLabel:FilterFrameText;
        private var _tipField:FilterFrameText;
        private var _doButton:TextButton;
        private var _cancelButton:TextButton;
        private var _startTime:int = 0;
        private var _elapsed:int = 0;
        private var _titleString:String = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.yaoqingni");
        private var _timeUnit:String = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
        private var _startupMark:Boolean = false;
        private var _markTime:int = 15;
        private var _visible:Boolean = true;
        private var _inviteInfo:InviteInfo;
        private var _resState:String;
        private var _timer:Timer;
        private var _uiReady:Boolean = false;
        private var _expeditionAlert:BaseAlerFrame;
        private var _turnplateAlert:BaseAlerFrame;

        public function ResponseInviteFrame()
        {
            this.escEnable = true;
            this.configUi();
            this.addEvent();
            if (this._inviteInfo)
            {
                this.onUpdateData();
            };
            this._timer = new Timer(1000, this._markTime);
        }

        private static function removeInvite(_arg_1:ResponseInviteFrame):void
        {
            InvitePool.remove(String(_arg_1.inviteInfo.playerid));
        }

        public static function clearInviteFrame():void
        {
            var _local_2:ResponseInviteFrame;
            var _local_1:Array = InvitePool.list;
            while (_local_1.length > 0)
            {
                _local_2 = _local_1[0];
                if (_local_2)
                {
                    ObjectUtils.disposeObject(_local_2);
                };
            };
        }

        public static function newInvite(_arg_1:InviteInfo):ResponseInviteFrame
        {
            var _local_2:ResponseInviteFrame;
            if (InvitePool[String(_arg_1.playerid)] != null)
            {
                _local_2 = InvitePool[String(_arg_1.playerid)];
                _local_2.inviteInfo = _arg_1;
            }
            else
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("ResponseInviteFrame");
                InvitePool.add(String(_arg_1.playerid), _local_2);
                _local_2.inviteInfo = _arg_1;
            };
            return (_local_2);
        }


        private function configUi():void
        {
            titleText = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
            this._titleBackground = ComponentFactory.Instance.creatBitmap("asset.core.newFrame.titleBg");
            PositionUtils.setPos(this._titleBackground, "asset.core.ResponeseInviteFrame.titleBg");
            addToContent(this._titleBackground);
            this._responseTitle = ComponentFactory.Instance.creatComponentByStylename("invite.response.TitleField");
            this._responseTitle.text = this._titleString;
            addToContent(this._responseTitle);
            this._modeLabel = ComponentFactory.Instance.creatBitmap("invite.response.ModeLabel");
            addToContent(this._modeLabel);
            this._mode = ComponentFactory.Instance.creatComponentByStylename("invite.response.GameMode");
            DisplayUtils.setFrame(this._mode, 1);
            addToContent(this._mode);
            this._leftLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.MapLabel");
            this._leftLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.map");
            addToContent(this._leftLabel);
            this._leftField = ComponentFactory.Instance.creatComponentByStylename("invite.response.MapField");
            addToContent(this._leftField);
            this._rightLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.TimeLabel");
            this._rightLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.huihetime");
            addToContent(this._rightLabel);
            this._rightField = ComponentFactory.Instance.creatComponentByStylename("invite.response.TimeField");
            addToContent(this._rightField);
            this._levelLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.LevelLabel");
            addToContent(this._levelLabel);
            this._levelField = ComponentFactory.Instance.creatComponentByStylename("invite.response.LevelField");
            addToContent(this._levelField);
            this._tipField = ComponentFactory.Instance.creatComponentByStylename("invite.response.TipField");
            this._tipField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.meifanying");
            addToContent(this._tipField);
            this._doButton = ComponentFactory.Instance.creatComponentByStylename("invite.response.DoButton");
            this._doButton.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
            addToContent(this._doButton);
            this._cancelButton = ComponentFactory.Instance.creatComponentByStylename("invite.response.CancelButton");
            this._cancelButton.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
            addToContent(this._cancelButton);
            this._uiReady = true;
        }

        private function addEvent():void
        {
            this._doButton.addEventListener(MouseEvent.CLICK, this.__onInviteAccept);
            this._cancelButton.addEventListener(MouseEvent.CLICK, this.__onCloseClick);
            addEventListener(Event.ADDED_TO_STAGE, this.__toStage);
            addEventListener(FocusEvent.FOCUS_IN, this.__focusIn);
            addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
        }

        private function removeEvent():void
        {
            this._doButton.removeEventListener(MouseEvent.CLICK, this.__onInviteAccept);
            this._cancelButton.removeEventListener(MouseEvent.CLICK, this.__onCloseClick);
            removeEventListener(Event.ADDED_TO_STAGE, this.__toStage);
            removeEventListener(FocusEvent.FOCUS_IN, this.__focusIn);
            removeEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            removeEventListener(MouseEvent.CLICK, this.__bodyClick, true);
        }

        public function show():void
        {
            if ((!(stage)))
            {
                LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, false, LayerManager.BLCAK_BLOCKGOUND);
            };
        }

        private function __focusOut(_arg_1:FocusEvent):void
        {
            addEventListener(MouseEvent.CLICK, this.__bodyClick, true);
        }

        private function __bodyClick(_arg_1:MouseEvent):void
        {
            StageReferance.stage.focus = this;
        }

        private function __toStage(_arg_1:Event):void
        {
            var _local_2:ResponseInviteFrame;
            var _local_3:Rectangle;
            var _local_4:Rectangle;
            var _local_5:Point;
            var _local_6:Point;
            var _local_7:Point;
            if (InvitePool.length > 1)
            {
                _local_2 = InvitePool.list[(InvitePool.length - 2)];
                _local_3 = _local_2.getBounds(stage);
                _local_4 = ComponentFactory.Instance.creatCustomObject("invite.response.DispalyRect");
                _local_7 = ComponentFactory.Instance.creatCustomObject("invite.response.FrameOffset");
                if ((((_local_3.right + _local_7.x) >= _local_4.right) || ((_local_3.bottom + _local_7.y) >= _local_4.bottom)))
                {
                    x = _local_4.x;
                    y = _local_4.y;
                }
                else
                {
                    x = (_local_3.x + _local_7.x);
                    y = (_local_3.y + _local_7.y);
                };
            }
            else
            {
                _local_3 = getBounds(this);
                x = ((StageReferance.stageWidth - _local_3.width) >> 1);
                y = ((StageReferance.stageHeight - _local_3.height) >> 1);
            };
        }

        private function __focusIn(_arg_1:FocusEvent):void
        {
            removeEventListener(MouseEvent.CLICK, this.__bodyClick, true);
            this.bringToTop();
        }

        private function bringToTop():void
        {
            if (parent)
            {
                parent.setChildIndex(this, (parent.numChildren - 1));
            };
        }

        private function __onInviteAccept(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.checkExpedition())
            {
                this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                this._expeditionAlert.moveEnable = false;
                this._expeditionAlert.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            }
            else
            {
                if (TurnPlateController.Instance.isShow)
                {
                    this._turnplateAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.turnplate.inviteStop.txt"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                    this._turnplateAlert.moveEnable = false;
                    this._turnplateAlert.addEventListener(FrameEvent.RESPONSE, this.__turnplateConfirmResponse);
                }
                else
                {
                    this.sendAnswer();
                };
            };
        }

        private function __turnplateConfirmResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__turnplateConfirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                TurnPlateController.Instance.forcibleClose();
                this.sendAnswer();
            };
            if ((((_arg_1.responseCode == FrameEvent.CANCEL_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.close();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                this.sendAnswer();
            };
            if ((((_arg_1.responseCode == FrameEvent.CANCEL_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.close();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function sendAnswer():void
        {
            GameManager.Instance.setup();
            if (this._inviteInfo.gameMode == 0)
            {
                SocketManager.Instance.out.sendGameLogin(1, -1, this._inviteInfo.roomid, this._inviteInfo.password, true);
            }
            else
            {
                if (this._inviteInfo.gameMode == 4)
                {
                    SocketManager.Instance.out.sendGameLogin(2, -1, this._inviteInfo.roomid, this._inviteInfo.password, true);
                }
                else
                {
                    if (this._inviteInfo.gameMode == 20)
                    {
                        SocketManager.Instance.out.sendGameLogin(2, -1, this._inviteInfo.roomid, this._inviteInfo.password, true);
                    }
                    else
                    {
                        SocketManager.Instance.out.sendGameLogin(4, -1, this._inviteInfo.roomid, this._inviteInfo.password, true);
                    };
                };
            };
            this.close();
            clearInviteFrame();
        }

        private function onUpdateData():void
        {
            var _local_1:InviteInfo = this._inviteInfo;
            var _local_2:int = 1;
            if (_local_1.secondType == 1)
            {
                _local_2 = 5;
            };
            if (_local_1.secondType == 2)
            {
                _local_2 = 7;
            };
            if (_local_1.secondType == 3)
            {
                _local_2 = 10;
            };
            if (_local_1.secondType == 4)
            {
                _local_2 = 15;
            };
            titleText = LanguageMgr.GetTranslation("tank.invite.response.title", _local_1.nickname);
            if (_local_1.isOpenBoss)
            {
                this._titleString = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.yaoqingniboss");
            };
            this._responseTitle.text = ((("“" + _local_1.nickname) + "”") + this._titleString);
            if (_local_1.gameMode < 2)
            {
                DisplayUtils.setFrame(this._mode, (_local_1.gameMode + 1));
                this._rightLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.huihetime");
                this._rightField.text = (_local_2 + LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second"));
                this._leftLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.map");
                this._leftField.text = String(MapManager.getMapName(_local_1.mapid));
            }
            else
            {
                if (_local_1.gameMode == 2)
                {
                    DisplayUtils.setFrame(this._mode, (_local_1.gameMode + 1));
                    this._rightLabel.text = LanguageMgr.GetTranslation("tank.view.common.levelRange");
                    this._rightField.text = this.getLevelLimits(_local_1.levelLimits);
                    this._leftLabel.text = LanguageMgr.GetTranslation("tank.view.common.roomLevel");
                    this._leftField.text = MapManager.getRoomHardLevel(_local_1.hardLevel);
                }
                else
                {
                    if (_local_1.gameMode > 2)
                    {
                        if (_local_1.gameMode == 7)
                        {
                            DisplayUtils.setFrame(this._mode, 5);
                        }
                        else
                        {
                            if (_local_1.gameMode == RoomInfo.MULTI_DUNGEON)
                            {
                                DisplayUtils.setFrame(this._mode, 5);
                            }
                            else
                            {
                                DisplayUtils.setFrame(this._mode, (_local_1.gameMode + 1));
                            };
                        };
                        if (_local_1.gameMode == 11)
                        {
                            DisplayUtils.setFrame(this._mode, 5);
                        };
                        this._leftLabel.text = LanguageMgr.GetTranslation("tank.view.common.duplicateName");
                        this._leftLabel.x = PositionUtils.creatPoint("duplicatePos").x;
                        this._leftField.text = String(MapManager.getMapName(_local_1.mapid));
                        this._leftField.x = PositionUtils.creatPoint("duplicateNamePos").x;
                        this._rightLabel.text = LanguageMgr.GetTranslation("tank.view.common.gameLevel");
                        this._rightLabel.x = ((this._leftField.x + this._leftField.width) + 2);
                        this._rightField.x = (this._rightLabel.x + this._rightLabel.width);
                        this._rightField.text = MapManager.getRoomHardLevel(_local_1.hardLevel);
                    };
                };
            };
            if (((_local_1.barrierNum == -1) || (_local_1.gameMode < 2)))
            {
                this._levelLabel.visible = (this._levelField.visible = false);
            }
            else
            {
                this._levelLabel.visible = (this._levelField.visible = true);
                this._levelLabel.text = LanguageMgr.GetTranslation("tank.view.common.InviteAlertPanel.pass");
                this._levelField.text = String(_local_1.barrierNum);
            };
            if (((_local_1.gameMode > 2) && ((_local_1.mapid <= 0) || (_local_1.mapid >= 10000))))
            {
                this._leftField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.nochoice");
                this._rightField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.nochoice");
                this._levelField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.nochoice");
            };
            this.restartMark();
        }

        private function __onMark(_arg_1:TimerEvent):void
        {
            this._tipField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.ruguo", (this._markTime - this._timer.currentCount));
        }

        private function __onMarkComplete(_arg_1:TimerEvent):void
        {
            this.markComplete();
        }

        override protected function __onCloseClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.close();
        }

        private function getLevelLimits(_arg_1:int):String
        {
            var _local_2:String = "";
            switch (_arg_1)
            {
                case 1:
                    _local_2 = "1-10";
                    break;
                case 2:
                    _local_2 = "11-20";
                    break;
                case 3:
                    _local_2 = "20-30";
                    break;
                case 4:
                    _local_2 = "30-40";
                    break;
                default:
                    _local_2 = "";
            };
            return (_local_2 + LanguageMgr.GetTranslation("grade"));
        }

        private function restartMark():void
        {
            if (this._startupMark)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.__onMark);
                this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__onMarkComplete);
                this._timer.stop();
            };
            this._startupMark = true;
            this._timer.addEventListener(TimerEvent.TIMER, this.__onMark);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__onMarkComplete);
            this._timer.reset();
            this._timer.start();
        }

        private function markComplete():void
        {
            this._startupMark = false;
            this._timer.removeEventListener(TimerEvent.TIMER, this.__onMark);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__onMarkComplete);
            this.close();
        }

        public function close():void
        {
            ObjectUtils.disposeObject(this);
        }

        public function get inviteInfo():InviteInfo
        {
            return (this._inviteInfo);
        }

        public function set inviteInfo(_arg_1:InviteInfo):void
        {
            this._inviteInfo = _arg_1;
            if (this._uiReady)
            {
                this.onUpdateData();
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            this._timer.removeEventListener(TimerEvent.TIMER, this.__onMark);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__onMarkComplete);
            this._timer = null;
            if (this._titleBackground)
            {
                ObjectUtils.disposeObject(this._titleBackground);
                this._titleBackground = null;
            };
            if (this._responseTitle)
            {
                ObjectUtils.disposeObject(this._responseTitle);
                this._responseTitle = null;
            };
            if (this._modeLabel)
            {
                ObjectUtils.disposeObject(this._modeLabel);
                this._modeLabel = null;
            };
            if (this._mode)
            {
                ObjectUtils.disposeObject(this._mode);
                this._mode = null;
            };
            if (this._leftLabel)
            {
                ObjectUtils.disposeObject(this._leftLabel);
                this._leftLabel = null;
            };
            if (this._leftField)
            {
                ObjectUtils.disposeObject(this._leftField);
                this._leftField = null;
            };
            if (this._rightLabel)
            {
                ObjectUtils.disposeObject(this._rightLabel);
                this._rightLabel = null;
            };
            if (this._rightField)
            {
                ObjectUtils.disposeObject(this._rightField);
                this._rightField = null;
            };
            if (this._tipField)
            {
                ObjectUtils.disposeObject(this._tipField);
                this._tipField = null;
            };
            if (this._doButton)
            {
                ObjectUtils.disposeObject(this._doButton);
                this._doButton = null;
            };
            if (this._cancelButton)
            {
                ObjectUtils.disposeObject(this._cancelButton);
                this._cancelButton = null;
            };
            if (this._levelLabel)
            {
                ObjectUtils.disposeObject(this._levelLabel);
                this._levelLabel = null;
            };
            if (this._levelField)
            {
                ObjectUtils.disposeObject(this._levelLabel);
                this._levelField = null;
            };
            if (this._expeditionAlert)
            {
                this._expeditionAlert.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
                ObjectUtils.disposeObject(this._expeditionAlert);
                this._expeditionAlert = null;
            };
            if (this._turnplateAlert)
            {
                this._turnplateAlert.removeEventListener(FrameEvent.RESPONSE, this.__turnplateConfirmResponse);
                ObjectUtils.disposeObject(this._turnplateAlert);
                this._turnplateAlert = null;
            };
            removeInvite(this);
            super.dispose();
        }


    }
}//package invite

