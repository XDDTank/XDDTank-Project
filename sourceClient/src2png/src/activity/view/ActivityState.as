// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityState

package activity.view
{
    import flash.display.Sprite;
    import calendar.view.ICalendar;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import activity.data.ActivityInfo;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import activity.view.goodsExchange.GoodsExchangeView;
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import activity.ActivityController;
    import activity.ActivityEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.loader.BaseLoader;
    import flash.events.TimerEvent;
    import ddt.manager.MessageTipManager;
    import activity.data.ActivityChildTypes;
    import activity.data.ActivityTypes;
    import com.pickgliss.loader.LoaderEvent;
    import calendar.CalendarEvent;

    public class ActivityState extends Sprite implements ICalendar 
    {

        public static const PICC_PRICE:int = 10000;
        public static const MC_DEFAULT:int = 0;
        public static const MC_OPEN_COMMON_ONCE:int = 1;
        public static const MC_GUILD:int = 2;
        public static const MC_DIVORCE:int = 3;
        public static const MC_POWER:int = 4;
        public static const MC_LEVEL:int = 5;
        public static const MC_CHARGE:int = 6;
        public static const MC_COST:int = 7;
        public static const MC_TUAN:int = 8;

        private var _titleField:FilterFrameText;
        private var _getButton:BaseButton;
        private var _exchangeButton:BaseButton;
        private var _piccBtn:BaseButton;
        private var _activityInfo:ActivityInfo;
        private var _back:Bitmap;
        private var _scrollList:ScrollPanel;
        private var _content:VBox;
        private var _detailview:ActivityDetail;
        private var _goodsExchangeNew:GoodsExchangeView;
        private var _backMC:MovieClip;
        private var _getAwardTimer:Timer;

        public function ActivityState()
        {
            this.configUI();
            this.addEvent();
        }

        private function configUI():void
        {
            this._back = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityStateBg");
            addChild(this._back);
            this._backMC = ComponentFactory.Instance.creat("ddtactivity.activitystate.openBgMC");
            this._backMC.visible = false;
            this._backMC.gotoAndStop(MC_OPEN_COMMON_ONCE);
            PositionUtils.setPos(this._backMC, "ddtactivity.activitystate.openBg.MC.pos");
            addChild(this._backMC);
            this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateTitleField");
            addChild(this._titleField);
            this._detailview = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityDetailNew");
            this._getButton = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.GetButton");
            this._getButton.visible = false;
            addChild(this._getButton);
            this._exchangeButton = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.exchangeButton");
            this._exchangeButton.visible = false;
            addChild(this._exchangeButton);
            this._piccBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.PiccBtn");
            addChild(this._piccBtn);
            this._content = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.Vbox");
            this._content.addChild(this._detailview);
            this._scrollList = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityDetailList");
            this._scrollList.setView(this._content);
            addChild(this._scrollList);
        }

        private function addEvent():void
        {
            this._getButton.addEventListener(MouseEvent.CLICK, this.__getAward);
            this._exchangeButton.addEventListener(MouseEvent.CLICK, this.__exchange);
            this._piccBtn.addEventListener(MouseEvent.CLICK, this.__piccHandler);
            ActivityController.instance.model.addEventListener(ActivityEvent.BUTTON_CHANGE, this.updateBtnState);
            ActivityController.instance.model.addEventListener(ActivityEvent.GET_RAWARD, this.__getReward);
        }

        protected function __piccHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ActivityState.confirm.content", PICC_PRICE), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.moveEnable = false;
            _local_2.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        protected function __responseHandler(_arg_1:FrameEvent):void
        {
            var _local_3:BaseAlerFrame;
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                _local_3 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("poorNote"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                _local_3.moveEnable = false;
                _local_3.addEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __poorManResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                LeavePageManager.leaveToFillPath();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        public function __getReward(_arg_1:ActivityEvent):void
        {
            var _local_2:Object = _arg_1.data;
            if (_local_2["ID"] == this._activityInfo.ActivityId)
            {
                this.sendSocket(_local_2);
            };
        }

        private function __getAward(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.sendSocket();
        }

        private function sendSocket(_arg_1:Object=null):void
        {
            var _local_2:BaseLoader;
            var _local_3:BaseAlerFrame;
            if ((!(this._getAwardTimer)))
            {
                this._getAwardTimer = new Timer(2000, 1);
                this._getAwardTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__getAwardTimerComplete);
                this._getAwardTimer.start();
            }
            else
            {
                if (this._getAwardTimer.running)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activityState.getAward.click"));
                    return;
                };
            };
            if ((!(ActivityController.instance.isInValidOpenDate(this._activityInfo))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.hasnotbegin"));
                return;
            };
            if (this._activityInfo)
            {
                if ((((((ActivityController.instance.checkOpenActivity(this._activityInfo)) || (ActivityController.instance.checkMouthActivity(this._activityInfo))) && (ActivityController.instance.isInValidShowDate(this._activityInfo))) || (ActivityController.instance.checkChargeReward(this._activityInfo))) || (ActivityController.instance.checkCostReward(this._activityInfo))))
                {
                    if (ActivityController.instance.checkMouthActivity(this._activityInfo))
                    {
                        if ((!(ActivityController.instance.checkCondition(this._activityInfo))))
                        {
                            return;
                        };
                    };
                    ActivityController.instance.getActivityAward(this._activityInfo, _arg_1);
                }
                else
                {
                    if (((this._detailview.getInputField().text == "") && ((this._activityInfo.ActivityType == ActivityTypes.RELEASE) && (this._activityInfo.ActivityChildType == ActivityChildTypes.NUMBER_ACTIVE))))
                    {
                        _local_3 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.movement.MovementRightView.pass"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, false, false, 2);
                        _local_3.info.showCancel = false;
                        return;
                    };
                    _local_2 = ActivityController.instance.reciveActivityAward(this._activityInfo, this._detailview.getInputField().text);
                    _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
                    _local_2.addEventListener(LoaderEvent.COMPLETE, this.__activityLoadComplete);
                    this._detailview.getInputField().text = "";
                };
            };
        }

        private function __getAwardTimerComplete(_arg_1:TimerEvent):void
        {
            this._getAwardTimer.stop();
            this._getAwardTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__getAwardTimerComplete);
            this._getAwardTimer = null;
        }

        private function __exchange(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            if ((!(this._getAwardTimer)))
            {
                this._getAwardTimer = new Timer(2000, 1);
                this._getAwardTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__getAwardTimerComplete);
                this._getAwardTimer.start();
            }
            else
            {
                if (this._getAwardTimer.running)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activityState.getAward.click"));
                    return;
                };
            };
            if ((!(ActivityController.instance.isInValidOpenDate(this._activityInfo))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.ActivityDetail.hasnotbegin"));
                return;
            };
            this._goodsExchangeNew.sendGoods();
        }

        private function __activityLoadComplete(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.currentTarget as BaseLoader);
            _local_2.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.removeEventListener(LoaderEvent.COMPLETE, this.__activityLoadComplete);
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:BaseLoader = (_arg_1.currentTarget as BaseLoader);
            _local_2.removeEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            _local_2.removeEventListener(LoaderEvent.COMPLETE, this.__activityLoadComplete);
        }

        public function updataData():void
        {
            this.setData(this._activityInfo);
        }

        public function setData(_arg_1:*=null):void
        {
            this._activityInfo = (_arg_1 as ActivityInfo);
            if (this._activityInfo)
            {
                this.visible = true;
                this._getButton.visible = true;
                this._getButton.enable = true;
                this._piccBtn.visible = false;
                this._titleField.text = this._activityInfo.ActivityName;
                if (this._activityInfo.ActivityType == ActivityTypes.CONVERT)
                {
                    this.hideDetailViewNew();
                    this.showGoodsExchangeViewNew();
                }
                else
                {
                    this.hideGoodsExchangeViewNew();
                    this.showDetailViewNew();
                    if ((((((this._activityInfo.ActivityType == ActivityTypes.CHARGE) || (this._activityInfo.ActivityType == ActivityTypes.COST)) || (this._activityInfo.ActivityType == ActivityTypes.BEAD)) || (this._activityInfo.ActivityType == ActivityTypes.PET)) || ((this._activityInfo.ActivityType == ActivityTypes.MARRIED) && ((this._activityInfo.ActivityChildType == ActivityChildTypes.WEDDINGS) || (this._activityInfo.ActivityChildType == ActivityChildTypes.WEDDING)))))
                    {
                        this._getButton.visible = false;
                    }
                    else
                    {
                        if (ActivityController.instance.checkMouthActivity(this._activityInfo))
                        {
                            if ((!(ActivityController.instance.checkCondition(this._activityInfo))))
                            {
                                this._getButton.enable = false;
                            };
                        };
                    };
                    if (((this._getButton.enable) && (ActivityController.instance.checkFinish(this._activityInfo))))
                    {
                        this._getButton.enable = false;
                    };
                };
                if (ActivityController.instance.checkOpenActivity(this._activityInfo))
                {
                    this._backMC.visible = true;
                    this._back.visible = false;
                    this._titleField.visible = false;
                    this.setMCFrame();
                    this.updateBtnState(null);
                }
                else
                {
                    if (((ActivityController.instance.checkChargeReward(this._activityInfo)) || (ActivityController.instance.checkCostReward(this._activityInfo))))
                    {
                        this._backMC.visible = true;
                        this._back.visible = false;
                        this._titleField.visible = false;
                        this.setMCFrame();
                    }
                    else
                    {
                        if (ActivityController.instance.checkTuan(this._activityInfo))
                        {
                            this._backMC.visible = true;
                            this._back.visible = false;
                            this._titleField.visible = false;
                            this._getButton.visible = false;
                            this.setMCFrame();
                        }
                        else
                        {
                            this._backMC.visible = false;
                            this._back.visible = true;
                            this._titleField.visible = true;
                        };
                    };
                };
                if (((ActivityController.instance.checkCostReward(this._activityInfo)) || (ActivityController.instance.checkChargeReward(this._activityInfo))))
                {
                    this._scrollList.height = 420;
                }
                else
                {
                    this._scrollList.height = 350;
                };
            }
            else
            {
                this._piccBtn.visible = false;
                this._getButton.visible = false;
                this.visible = false;
            };
            this._scrollList.invalidateViewport();
        }

        private function updateBtnState(_arg_1:ActivityEvent):void
        {
            if ((((ActivityController.instance.checkOpenLove(this._activityInfo)) || (this._activityInfo.ActivityType == ActivityTypes.BEAD)) || (this._activityInfo.ActivityType == ActivityTypes.PET)))
            {
                this._getButton.visible = false;
            }
            else
            {
                this._getButton.visible = true;
                if (this._detailview.checkGetEnable())
                {
                    this._getButton.enable = true;
                }
                else
                {
                    this._getButton.enable = false;
                };
            };
        }

        private function showGoodsExchangeViewNew():void
        {
            if ((!(this._goodsExchangeNew)))
            {
                this._goodsExchangeNew = new GoodsExchangeView();
                this._goodsExchangeNew.addEventListener(CalendarEvent.ExchangeGoodsChange, this.__ExchangeGoodsChangeHandler);
                this._content.addChild(this._goodsExchangeNew);
            };
            this._goodsExchangeNew.info = this._activityInfo;
            this._exchangeButton.visible = true;
        }

        private function hideGoodsExchangeViewNew():void
        {
            if (this._goodsExchangeNew)
            {
                this._exchangeButton.visible = false;
                this._goodsExchangeNew.removeEventListener(CalendarEvent.ExchangeGoodsChange, this.__ExchangeGoodsChangeHandler);
                ObjectUtils.disposeObject(this._goodsExchangeNew);
                this._goodsExchangeNew = null;
            };
        }

        private function __ExchangeGoodsChangeHandler(_arg_1:CalendarEvent):void
        {
            if (_arg_1.enable == false)
            {
                this._exchangeButton.enable = false;
            }
            else
            {
                this._exchangeButton.enable = true;
            };
        }

        private function showDetailViewNew():void
        {
            if ((!(this._detailview)))
            {
                this._detailview = new ActivityDetail();
                this._content.addChild(this._detailview);
            };
            this._detailview.setData(this._activityInfo);
            this._getButton.visible = true;
            this._content.height = this._detailview.height;
        }

        private function setMCFrame():void
        {
            var _local_1:int;
            if (ActivityController.instance.checkTotalMoeny(this._activityInfo))
            {
                _local_1 = MC_OPEN_COMMON_ONCE;
            }
            else
            {
                if (ActivityController.instance.checkOpenConsortiaLevel(this._activityInfo))
                {
                    _local_1 = MC_GUILD;
                }
                else
                {
                    if (ActivityController.instance.checkOpenLove(this._activityInfo))
                    {
                        _local_1 = MC_DIVORCE;
                    }
                    else
                    {
                        if (ActivityController.instance.checkOpenLevel(this._activityInfo))
                        {
                            _local_1 = MC_LEVEL;
                        }
                        else
                        {
                            if (ActivityController.instance.checkOpenFight(this._activityInfo))
                            {
                                _local_1 = MC_POWER;
                            }
                            else
                            {
                                if (ActivityController.instance.checkChargeReward(this._activityInfo))
                                {
                                    _local_1 = MC_CHARGE;
                                }
                                else
                                {
                                    if (ActivityController.instance.checkCostReward(this._activityInfo))
                                    {
                                        _local_1 = MC_COST;
                                    }
                                    else
                                    {
                                        if (ActivityController.instance.checkTuan(this._activityInfo))
                                        {
                                            _local_1 = MC_TUAN;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            this._backMC.gotoAndStop(_local_1);
        }

        private function hideDetailViewNew():void
        {
            if (this._detailview)
            {
                ObjectUtils.disposeObject(this._detailview);
                this._detailview = null;
            };
            this._getButton.visible = false;
        }

        private function removeEvent():void
        {
            this._getButton.removeEventListener(MouseEvent.CLICK, this.__getAward);
            this._exchangeButton.removeEventListener(MouseEvent.CLICK, this.__exchange);
            this._piccBtn.removeEventListener(MouseEvent.CLICK, this.__piccHandler);
            ActivityController.instance.model.removeEventListener(ActivityEvent.BUTTON_CHANGE, this.updateBtnState);
            ActivityController.instance.model.removeEventListener(ActivityEvent.GET_RAWARD, this.__getReward);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            ObjectUtils.disposeObject(this._piccBtn);
            this._piccBtn = null;
            ObjectUtils.disposeObject(this._titleField);
            this._titleField = null;
            ObjectUtils.disposeObject(this._getButton);
            this._getButton = null;
            ObjectUtils.disposeObject(this._exchangeButton);
            this._exchangeButton = null;
            ObjectUtils.disposeObject(this._scrollList);
            this._scrollList = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            if (this._goodsExchangeNew)
            {
                ObjectUtils.disposeObject(this._goodsExchangeNew);
                this._goodsExchangeNew = null;
            };
            if (this._getAwardTimer)
            {
                this._getAwardTimer.stop();
                this._getAwardTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__getAwardTimerComplete);
                this._getAwardTimer = null;
            };
        }


    }
}//package activity.view

