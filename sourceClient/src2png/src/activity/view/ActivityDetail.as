// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityDetail

package activity.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ScrollPanel;
    import flash.display.DisplayObject;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.TextInput;
    import flash.utils.Timer;
    import activity.data.ActivityInfo;
    import activity.view.viewInDetail.open.ActivityOpenTotalMoney;
    import activity.view.viewInDetail.open.ActivityOpenLevel;
    import activity.view.viewInDetail.open.ActivityOpenFight;
    import activity.view.viewInDetail.open.ActivityOpenConsortiaLevel;
    import activity.view.viewInDetail.open.ActivityOpenDivoce;
    import activity.view.viewInDetail.reward.ActivityRewardView;
    import activity.view.viewInDetail.tuan.ActivityTuanView;
    import ddt.manager.TimeManager;
    import ddt.manager.LanguageMgr;
    import activity.data.ActivityTypes;
    import activity.ActivityController;
    import activity.data.ActivityChildTypes;
    import activity.data.ActivityGiftbagInfo;
    import activity.data.ConditionRecord;
    import road7th.data.DictionaryData;
    import ddt.manager.ItemManager;
    import ddt.manager.PlayerManager;
    import activity.data.ActivityRewardInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ActivityDetail extends Sprite implements Disposeable 
    {

        private var _discriptionField:FilterFrameText;
        private var _timeField:FilterFrameText;
        private var _awardField:FilterFrameText;
        private var _contentField:FilterFrameText;
        private var _countField:FilterFrameText;
        private var _timeTitle:Bitmap;
        private var _awardTitle:Bitmap;
        private var _contentTitle:Bitmap;
        private var _countTitle:Bitmap;
        private var _awardList:SimpleTileList;
        private var _awardPanel:ScrollPanel;
        private var _timeWidth:int;
        private var _awardWidth:int;
        private var _contentWidth:int;
        private var _countWidth:int;
        private var _time:DisplayObject;
        private var _award:DisplayObject;
        private var _content:DisplayObject;
        private var _input:DisplayObject;
        private var _count:DisplayObject;
        private var _lines:Vector.<DisplayObject> = new Vector.<DisplayObject>();
        private var _bg:Vector.<Scale9CornerImage> = new Vector.<Scale9CornerImage>();
        private var _inputField:TextInput;
        private var _timer:Timer;
        private var _info:ActivityInfo;
        private var _openTotalMoney:ActivityOpenTotalMoney;
        private var _openLevel:ActivityOpenLevel;
        private var _openFight:ActivityOpenFight;
        private var _openConsrotialLevel:ActivityOpenConsortiaLevel;
        private var _openActivityDivorce:ActivityOpenDivoce;
        private var _rewardActivity:ActivityRewardView;
        private var _tuanActivity:ActivityTuanView;

        public function ActivityDetail()
        {
            this.initView();
            this.initEvent();
        }

        private static function calculateLast(_arg_1:Date, _arg_2:Date):String
        {
            var _local_3:int = (_arg_1.time - _arg_2.time);
            var _local_4:String = "";
            if (_local_3 >= TimeManager.DAY_TICKS)
            {
                _local_4 = (_local_4 + (Math.floor((_local_3 / TimeManager.DAY_TICKS)) + LanguageMgr.GetTranslation("day")));
                _local_3 = (_local_3 % TimeManager.DAY_TICKS);
            };
            if (_local_3 >= TimeManager.HOUR_TICKS)
            {
                _local_4 = (_local_4 + (Math.floor((_local_3 / TimeManager.HOUR_TICKS)) + LanguageMgr.GetTranslation("hour")));
                _local_3 = (_local_3 % TimeManager.HOUR_TICKS);
            }
            else
            {
                if (_local_4.length > 0)
                {
                    _local_4 = (_local_4 + ("00" + LanguageMgr.GetTranslation("hour")));
                };
            };
            if (_local_3 >= TimeManager.Minute_TICKS)
            {
                _local_4 = (_local_4 + (Math.floor((_local_3 / TimeManager.Minute_TICKS)) + LanguageMgr.GetTranslation("minute")));
                _local_3 = (_local_3 % TimeManager.Minute_TICKS);
            }
            else
            {
                if (_local_4.length > 0)
                {
                    _local_4 = (_local_4 + ("00" + LanguageMgr.GetTranslation("minute")));
                };
            };
            if (_local_3 >= TimeManager.Second_TICKS)
            {
                _local_4 = (_local_4 + (Math.floor((_local_3 / TimeManager.Second_TICKS)) + LanguageMgr.GetTranslation("second")));
            }
            else
            {
                if (_local_4.length > 0)
                {
                    _local_4 = (_local_4 + ("00" + LanguageMgr.GetTranslation("second")));
                };
            };
            return (_local_4);
        }


        public function setData(_arg_1:ActivityInfo):void
        {
            this.visible = true;
            this._info = _arg_1;
            this._awardTitle.x = (this._award.x + 44);
            this._awardTitle.y = (this._award.y + 12);
            this._awardField.y = ((this._award.y + this._award.height) - 4);
            this._awardField.autoSize = "none";
            this._awardField.width = this._awardWidth;
            this._awardField.text = _arg_1.RewardDesc;
            this._awardField.autoSize = "left";
            if (_arg_1.ActivityType == ActivityTypes.MONTH)
            {
                this.setAwardPanel();
                this._lines[0].y = ((this._awardPanel.y + this._awardPanel.height) + 8);
                this._bg[0].y = (this._award.y - 5);
                this._bg[0].height = (this._awardPanel.height + 48);
                this._awardField.visible = false;
            }
            else
            {
                this._lines[0].y = ((this._awardField.y + this._awardField.height) + 8);
                this._bg[0].y = (this._award.y - 5);
                this._bg[0].height = (this._awardField.height + 48);
            };
            this._content.y = ((this._lines[0].y + this._lines[0].height) + 4);
            this._contentField.y = ((this._content.y + this._content.height) - 2);
            this._contentField.autoSize = "none";
            this._contentField.width = this._contentWidth;
            if (ActivityController.instance.checkMouthActivity(this._info))
            {
                this._contentField.htmlText = this.getDesripe();
            }
            else
            {
                this._contentField.htmlText = this._info.Desc;
            };
            this._contentField.autoSize = "left";
            this._contentTitle.x = (this._content.x + 44);
            this._contentTitle.y = (this._content.y + 12);
            if (((this._info.ActivityType == ActivityTypes.RELEASE) && (this._info.ActivityChildType == ActivityChildTypes.NUMBER_ACTIVE)))
            {
                this._input.visible = (this._inputField.visible = true);
                this._inputField.y = ((this._contentField.y + this._contentField.height) + 20);
                this._input.y = (this._inputField.y + 4);
                this._lines[1].y = ((this._input.y + this._input.height) + 14);
                this._bg[1].y = (this._contentTitle.y - 17);
                this._bg[1].height = (this._input.y - 86);
            }
            else
            {
                this._input.visible = (this._inputField.visible = false);
                this._lines[1].y = ((this._contentField.y + this._contentField.height) + 8);
                this._bg[1].y = (this._contentTitle.y - 17);
                this._bg[1].height = (this._contentField.height + 51);
            };
            this._time.y = ((this._lines[1].y + this._lines[1].height) + 14);
            this._timeField.y = (this._time.y + 12);
            this._timeField.width = this._timeWidth;
            this._timeField.text = _arg_1.activeTime();
            this._timeField.autoSize = "left";
            this._timeTitle.x = (this._time.x + 44);
            this._timeTitle.y = (this._time.y + 12);
            if (((ActivityController.instance.checkMouthActivity(this._info)) && (!(this._info.GetWay == 0))))
            {
                this._lines[2].visible = true;
                this._count.visible = true;
                this._countField.visible = true;
                this._countTitle.visible = true;
                this._lines[2].y = ((this._time.y + this._time.height) + 10);
                this._count.x = this._time.x;
                this._count.y = ((this._time.y + this._time.height) + 20);
                this._countTitle.x = (this._count.x + 44);
                this._countTitle.y = (this._count.y + 12);
                this._countField.x = ((this._countTitle.x + this._countTitle.width) + 6);
                this._countField.y = (this._countTitle.y + 1);
                this._countField.text = ((this._info.GetWay - this._info.receiveNum) + LanguageMgr.GetTranslation("tank.calendar.award.NagivCount"));
            }
            else
            {
                this._lines[2].visible = false;
                this._count.visible = false;
                this._countField.visible = false;
                this._countTitle.visible = false;
            };
            this.adaptByActivity();
        }

        private function getDesripe():String
        {
            var _local_3:Array;
            var _local_6:Object;
            var _local_7:ActivityGiftbagInfo;
            var _local_8:int;
            var _local_9:Array;
            var _local_10:ConditionRecord;
            var _local_11:int;
            var _local_12:int;
            var _local_13:String;
            var _local_1:RegExp = new RegExp("\\{(\\d+)\\}");
            var _local_2:Array = ActivityController.instance.getAcitivityGiftBagByActID(this._info.ActivityId);
            var _local_4:DictionaryData = new DictionaryData();
            var _local_5:String = "";
            for each (_local_7 in _local_2)
            {
                _local_3 = ActivityController.instance.getActivityConditionByGiftbagID(_local_7.GiftbagId);
                _local_8 = 0;
                while (_local_8 < _local_3.length)
                {
                    _local_9 = _local_3[_local_8].Remain2.split("|");
                    if (_local_9[0] == "show")
                    {
                        _local_10 = ActivityController.instance.model.getConditionRecord(this._info.ActivityId, _local_3[(_local_8 - 1)].ConditionIndex);
                        if (((((_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.CHALLENGE) || (_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.FREEDOM)) || (_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.SPORTS)) || (_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.GUILD)))
                        {
                            if (_local_3[(_local_8 - 1)].Remain1 == -3)
                            {
                                _local_9[1] = _local_9[1].replace(_local_1, _local_3[(_local_8 - 1)].ConditionValue);
                            }
                            else
                            {
                                if (_local_3[(_local_8 - 1)].Remain1 > 0)
                                {
                                    _local_9[1] = _local_9[1].replace(_local_1, _local_3[(_local_8 - 1)].ConditionValue);
                                    _local_9[1] = _local_9[1].replace(_local_1, _local_3[(_local_8 - 1)].Remain1);
                                    _local_9[1] = _local_9[1].replace(_local_1, _local_3[(_local_8 - 1)].Remain1);
                                };
                            };
                            _local_9[1] = _local_9[1].replace(_local_1, _local_3[(_local_8 - 1)].ConditionValue);
                        }
                        else
                        {
                            if (_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.NPC)
                            {
                                if (_local_3[(_local_8 - 1)].Remain1 == -1)
                                {
                                    _local_9[1] = _local_9[1].replace(_local_1, _local_9[2]);
                                };
                            }
                            else
                            {
                                if (((_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.COLLECTITEM) || (_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.USEITEM)))
                                {
                                    _local_9[1] = _local_9[1].replace(_local_1, _local_3[(_local_8 - 1)].ConditionValue);
                                    _local_12 = _local_3[(_local_8 - 1)].Remain1;
                                    _local_13 = ItemManager.Instance.getTemplateById(_local_12).Name;
                                    _local_9[1] = _local_9[1].replace(_local_1, _local_13);
                                }
                                else
                                {
                                    if (_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.NUMBER)
                                    {
                                        _local_9[1] = _local_9[1].replace(_local_1, _local_3[(_local_8 - 1)].ConditionValue);
                                    };
                                };
                            };
                        };
                        if (_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.NPC)
                        {
                            if (((_local_10) && (_local_10.record == int(_local_3[(_local_8 - 1)].ConditionValue))))
                            {
                                _local_11 = 1;
                            }
                            else
                            {
                                _local_11 = 0;
                            };
                            _local_5 = (_local_5 + (((_local_9[1] + "  (") + _local_11) + "/1)\n"));
                        }
                        else
                        {
                            if (_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.NUMBER)
                            {
                                if (_local_3[(_local_8 - 1)].Remain1 == -2)
                                {
                                    _local_11 = PlayerManager.Instance.Self.Grade;
                                }
                                else
                                {
                                    if (_local_3[(_local_8 - 1)].Remain1 == -1)
                                    {
                                        _local_11 = ((_local_10) ? _local_10.record : 0);
                                    };
                                };
                                _local_11 = ((_local_11 > _local_3[(_local_8 - 1)].ConditionValue) ? _local_3[(_local_8 - 1)].ConditionValue : _local_11);
                                _local_5 = (_local_5 + (((((_local_9[1] + "  (") + _local_11) + "/") + _local_3[(_local_8 - 1)].ConditionValue) + ")\n"));
                            }
                            else
                            {
                                if (_local_3[(_local_8 - 1)].Remain2 == ActivityConditionType.COLLECTITEM)
                                {
                                    _local_11 = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(_local_3[(_local_8 - 1)].Remain1);
                                    _local_11 = ((_local_11 > _local_3[(_local_8 - 1)].ConditionValue) ? _local_3[(_local_8 - 1)].ConditionValue : _local_11);
                                    _local_5 = (_local_5 + (((((_local_9[1] + "  (") + _local_11) + "/") + _local_3[(_local_8 - 1)].ConditionValue) + ")\n"));
                                }
                                else
                                {
                                    if (_local_10)
                                    {
                                        if (_local_10.record <= int(_local_3[(_local_8 - 1)].ConditionValue))
                                        {
                                            _local_5 = (_local_5 + (((((_local_9[1] + "  (") + _local_10.record) + "/") + _local_3[(_local_8 - 1)].ConditionValue) + ")\n"));
                                        }
                                        else
                                        {
                                            _local_5 = (_local_5 + (((((_local_9[1] + "  (") + _local_3[(_local_8 - 1)].ConditionValue) + "/") + _local_3[(_local_8 - 1)].ConditionValue) + ")\n"));
                                        };
                                    }
                                    else
                                    {
                                        _local_5 = (_local_5 + (((((_local_9[1] + "  (") + "0") + "/") + _local_3[(_local_8 - 1)].ConditionValue) + ")\n"));
                                    };
                                };
                            };
                        };
                        _local_10 = null;
                    };
                    _local_8++;
                };
            };
            return (_local_5);
        }

        private function setAwardPanel():void
        {
            var _local_2:DictionaryData;
            var _local_3:ActivityCell;
            var _local_4:ActivityGiftbagInfo;
            var _local_5:ActivityRewardInfo;
            this._awardList.disposeAllChildren();
            var _local_1:Array = ActivityController.instance.getAcitivityGiftBagByActID(this._info.ActivityId);
            for each (_local_4 in _local_1)
            {
                _local_2 = ActivityController.instance.getRewardsByGiftbagID(_local_4.GiftbagId);
                for each (_local_5 in _local_2)
                {
                    _local_3 = new ActivityCell(_local_5);
                    _local_3.count = _local_5.Count;
                    this._awardList.addChild(_local_3);
                };
            };
            this._awardPanel.vScrollProxy = ((this._awardList.numChildren > 6) ? 0 : 2);
        }

        private function adaptByActivity():void
        {
            var _local_1:DisplayObject;
            var _local_2:Scale9CornerImage;
            this._openTotalMoney.visible = false;
            this._openLevel.visible = false;
            this._openFight.visible = false;
            this._openConsrotialLevel.visible = false;
            this._openActivityDivorce.visible = false;
            this._rewardActivity.visible = false;
            this._tuanActivity.visible = false;
            if (((((ActivityController.instance.checkOpenActivity(this._info)) || (ActivityController.instance.checkChargeReward(this._info))) || (ActivityController.instance.checkCostReward(this._info))) || (ActivityController.instance.checkTuan(this._info))))
            {
                this._award.visible = (this._awardTitle.visible = (this._awardField.visible = (this._awardPanel.visible = false)));
                this._time.visible = (this._timeTitle.visible = false);
                this._timeField.visible = true;
                this._content.visible = (this._contentTitle.visible = (this._contentField.visible = false));
                if (((ActivityController.instance.checkChargeReward(this._info)) || (ActivityController.instance.checkCostReward(this._info))))
                {
                    this._contentField.visible = true;
                };
                for each (_local_1 in this._lines)
                {
                    _local_1.visible = false;
                };
                for each (_local_2 in this._bg)
                {
                    _local_2.visible = false;
                };
                if (ActivityController.instance.checkTotalMoeny(this._info))
                {
                    this._openTotalMoney.visible = true;
                    this._openTotalMoney.info = this._info;
                }
                else
                {
                    if (ActivityController.instance.checkOpenLevel(this._info))
                    {
                        this._openLevel.visible = true;
                        this._openLevel.info = this._info;
                    }
                    else
                    {
                        if (ActivityController.instance.checkOpenFight(this._info))
                        {
                            this._openFight.visible = true;
                            this._openFight.info = this._info;
                            this._contentField.visible = true;
                        }
                        else
                        {
                            if (ActivityController.instance.checkOpenConsortiaLevel(this._info))
                            {
                                this._openConsrotialLevel.visible = true;
                                this._openConsrotialLevel.info = this._info;
                                this._contentField.visible = true;
                            }
                            else
                            {
                                if (ActivityController.instance.checkOpenLove(this._info))
                                {
                                    this._openActivityDivorce.visible = true;
                                    this._openActivityDivorce.info = this._info;
                                }
                                else
                                {
                                    if (((ActivityController.instance.checkCostReward(this._info)) || (ActivityController.instance.checkChargeReward(this._info))))
                                    {
                                        this._rewardActivity.visible = true;
                                        this._rewardActivity.info = this._info;
                                    }
                                    else
                                    {
                                        if (ActivityController.instance.checkTuan(this._info))
                                        {
                                            this._tuanActivity.visible = true;
                                            this._tuanActivity.info = this._info;
                                            this._timeField.visible = false;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            }
            else
            {
                if (this._info.ActivityType == ActivityTypes.MONTH)
                {
                    this._awardField.visible = false;
                    this._award.visible = (this._awardTitle.visible = (this._awardPanel.visible = true));
                }
                else
                {
                    this._award.visible = (this._awardTitle.visible = (this._awardField.visible = (((this._info.RewardDesc == "") || (this._info.RewardDesc == null)) ? false : true)));
                    this._awardPanel.visible = false;
                };
                this._time.visible = (this._timeTitle.visible = true);
                this._content.visible = (this._contentTitle.visible = (this._contentField.visible = true));
                this._lines[0].visible = true;
                this._lines[1].visible = true;
                this._bg[0].visible = true;
                this._bg[1].visible = true;
            };
            this.setTimeAndContentPos();
        }

        private function setTimeAndContentPos():void
        {
            var _local_1:String = "ddtcalendar.ActivityState.TimeFieldPos";
            var _local_2:String = "ddtcalendar.ActivityState.ContentFieldPos";
            if (ActivityController.instance.checkTotalMoeny(this._info))
            {
                _local_1 = (_local_1 + ActivityState.MC_OPEN_COMMON_ONCE);
                _local_2 = (_local_2 + ActivityState.MC_OPEN_COMMON_ONCE);
            }
            else
            {
                if (ActivityController.instance.checkOpenConsortiaLevel(this._info))
                {
                    _local_1 = (_local_1 + ActivityState.MC_GUILD);
                    _local_2 = (_local_2 + ActivityState.MC_GUILD);
                }
                else
                {
                    if (ActivityController.instance.checkOpenLove(this._info))
                    {
                        _local_1 = (_local_1 + ActivityState.MC_DIVORCE);
                        _local_2 = (_local_2 + ActivityState.MC_DIVORCE);
                    }
                    else
                    {
                        if (ActivityController.instance.checkOpenLevel(this._info))
                        {
                            _local_1 = (_local_1 + ActivityState.MC_LEVEL);
                            _local_2 = (_local_2 + ActivityState.MC_LEVEL);
                        }
                        else
                        {
                            if (ActivityController.instance.checkOpenFight(this._info))
                            {
                                _local_1 = (_local_1 + ActivityState.MC_POWER);
                                _local_2 = (_local_2 + ActivityState.MC_POWER);
                            }
                            else
                            {
                                if (ActivityController.instance.checkCostReward(this._info))
                                {
                                    _local_1 = (_local_1 + ActivityState.MC_COST);
                                    _local_2 = (_local_2 + ActivityState.MC_COST);
                                }
                                else
                                {
                                    if (ActivityController.instance.checkChargeReward(this._info))
                                    {
                                        _local_1 = (_local_1 + ActivityState.MC_CHARGE);
                                        _local_2 = (_local_2 + ActivityState.MC_CHARGE);
                                    }
                                    else
                                    {
                                        _local_1 = (_local_1 + ActivityState.MC_DEFAULT);
                                        _local_2 = (_local_2 + ActivityState.MC_DEFAULT);
                                        this._timeField.x = ComponentFactory.Instance.creatCustomObject(_local_1).x;
                                        this._contentField.x = ComponentFactory.Instance.creatCustomObject(_local_2).x;
                                        return;
                                    };
                                };
                            };
                        };
                    };
                };
            };
            PositionUtils.setPos(this._timeField, _local_1);
            PositionUtils.setPos(this._contentField, _local_2);
        }

        private function initView():void
        {
            var _local_1:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.ActivityDetail.Bg");
            PositionUtils.setPos(_local_1, ("ddtcalendar.ActivityState.BgPos" + this._bg.length));
            this._bg.push(_local_1);
            addChild(_local_1);
            _local_1 = ComponentFactory.Instance.creatComponentByStylename("asset.ActivityDetail.Bg");
            PositionUtils.setPos(_local_1, ("ddtcalendar.ActivityState.BgPos" + this._bg.length));
            this._bg.push(_local_1);
            addChild(_local_1);
            this._time = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.TimeIcon");
            addChild(this._time);
            this._award = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.AwardIcon");
            addChild(this._award);
            this._content = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.ContentIcon");
            addChild(this._content);
            this._count = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.timesBitmap");
            addChild(this._count);
            this._timeField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.TimeField");
            this._timeWidth = this._timeField.width;
            addChild(this._timeField);
            this._awardField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.AwardField");
            this._awardWidth = this._awardField.width;
            addChild(this._awardField);
            this._awardList = ComponentFactory.Instance.creatCustomObject("ddtactivity.activitydetail.awardList", [6]);
            addChild(this._awardList);
            this._awardPanel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.activitydetail.awardPanel");
            addChild(this._awardPanel);
            this._awardPanel.setView(this._awardList);
            this._contentField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.StateContentField");
            this._contentField.mouseEnabled = true;
            this._contentField.selectable = false;
            this._contentWidth = this._contentField.width;
            addChild(this._contentField);
            this._countField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.StateCountField");
            this._countWidth = this._countField.width;
            addChild(this._countField);
            var _local_2:DisplayObject = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
            PositionUtils.setPos(_local_2, ("ddtcalendar.ActivityState.LinePos" + this._lines.length));
            this._lines.push(_local_2);
            _local_2 = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
            PositionUtils.setPos(_local_2, ("ddtcalendar.ActivityState.LinePos" + this._lines.length));
            this._lines.push(_local_2);
            _local_2 = ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.ActivityState.SeparatorLine");
            PositionUtils.setPos(_local_2, ("ddtcalendar.ActivityState.LinePos" + this._lines.length));
            this._lines.push(_local_2);
            this._input = ComponentFactory.Instance.creatBitmap("aaset.ddtcalendar.ActivityState.Pwd");
            addChild(this._input);
            this._inputField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.InputField");
            addChild(this._inputField);
            this._openTotalMoney = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenTotalMoney");
            addChild(this._openTotalMoney);
            this._openLevel = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenLevel");
            addChild(this._openLevel);
            this._openFight = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenFight");
            addChild(this._openFight);
            this._openConsrotialLevel = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenConsortiaLevel");
            addChild(this._openConsrotialLevel);
            this._openActivityDivorce = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenDivoce");
            addChild(this._openActivityDivorce);
            this._rewardActivity = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityReward");
            addChild(this._rewardActivity);
            this._tuanActivity = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityTuanView");
            addChild(this._tuanActivity);
            this._awardTitle = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.AwardFieldTitle");
            addChild(this._awardTitle);
            this._contentTitle = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.ContentFieldTitle");
            addChild(this._contentTitle);
            this._timeTitle = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.TimeFieldTitle");
            addChild(this._timeTitle);
            this._countTitle = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityState.CountFieldTitle");
            addChild(this._countTitle);
            this.visible = false;
        }

        private function initEvent():void
        {
        }

        public function checkGetEnable():Boolean
        {
            if (ActivityController.instance.checkTotalMoeny(this._info))
            {
                if (this._openTotalMoney.enable)
                {
                    return (true);
                };
            }
            else
            {
                if (ActivityController.instance.checkOpenFight(this._info))
                {
                    if (this._openFight.enable)
                    {
                        return (true);
                    };
                }
                else
                {
                    if (ActivityController.instance.checkOpenLevel(this._info))
                    {
                        if (this._openLevel.enable)
                        {
                            return (true);
                        };
                    }
                    else
                    {
                        if (ActivityController.instance.checkOpenConsortiaLevel(this._info))
                        {
                            if (this._openConsrotialLevel.enable)
                            {
                                return (true);
                            };
                        }
                        else
                        {
                            if (ActivityController.instance.checkOpenLove(this._info))
                            {
                                if (this._openActivityDivorce.enable)
                                {
                                    return (true);
                                };
                            };
                        };
                    };
                };
            };
            return (false);
        }

        public function update():void
        {
            if (ActivityController.instance.checkTotalMoeny(this._info))
            {
                this._openTotalMoney.update();
            };
        }

        override public function get height():Number
        {
            var _local_1:int;
            return ((this._timeField.y + this._timeField.height) + 10);
        }

        public function getInputField():TextInput
        {
            return (this._inputField);
        }

        public function removeEvent():void
        {
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._timer)
            {
                this._timer.stop();
            };
            this._time = null;
            ObjectUtils.disposeObject(this._timeField);
            this._timeField = null;
            ObjectUtils.disposeObject(this._awardField);
            this._awardField = null;
            ObjectUtils.disposeObject(this._contentField);
            this._contentField = null;
            ObjectUtils.disposeObject(this._time);
            this._time = null;
            ObjectUtils.disposeObject(this._award);
            this._award = null;
            ObjectUtils.disposeObject(this._content);
            this._content = null;
            ObjectUtils.disposeObject(this._input);
            this._input = null;
            ObjectUtils.disposeObject(this._inputField);
            this._inputField = null;
            ObjectUtils.disposeObject(this._timeTitle);
            this._timeTitle = null;
            ObjectUtils.disposeObject(this._awardTitle);
            this._awardTitle = null;
            ObjectUtils.disposeObject(this._contentTitle);
            this._contentTitle = null;
            if (this._awardList)
            {
                this._awardList.disposeAllChildren();
            };
            ObjectUtils.disposeObject(this._awardList);
            this._awardList = null;
            ObjectUtils.disposeObject(this._awardPanel);
            this._awardPanel = null;
            var _local_1:DisplayObject = this._lines.shift();
            while (_local_1 != null)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
                _local_1 = this._lines.shift();
            };
            var _local_2:DisplayObject = this._bg.shift();
            while (_local_2 != null)
            {
                ObjectUtils.disposeObject(_local_2);
                _local_2 = null;
                _local_2 = this._bg.shift();
            };
            ObjectUtils.disposeObject(this._openTotalMoney);
            this._openTotalMoney = null;
            ObjectUtils.disposeObject(this._openFight);
            this._openFight = null;
            ObjectUtils.disposeObject(this._openLevel);
            this._openLevel = null;
            ObjectUtils.disposeObject(this._openConsrotialLevel);
            this._openConsrotialLevel = null;
            ObjectUtils.disposeObject(this._openActivityDivorce);
            this._openActivityDivorce = null;
            ObjectUtils.disposeObject(this._count);
            this._count = null;
            ObjectUtils.disposeObject(this._countField);
            this._countField = null;
            ObjectUtils.disposeObject(this._countTitle);
            this._countTitle = null;
            ObjectUtils.disposeObject(this._rewardActivity);
            this._rewardActivity = null;
            ObjectUtils.disposeObject(this._tuanActivity);
            this._tuanActivity = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package activity.view

