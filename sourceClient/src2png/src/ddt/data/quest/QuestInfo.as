// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.quest.QuestInfo

package ddt.data.quest
{
    import road7th.utils.DateUtils;
    import com.pickgliss.utils.StringUtils;
    import ddt.manager.TaskManager;
    import ddt.manager.ItemManager;
    import ddt.manager.PathManager;
    import ddt.manager.TimeManager;
    import ddt.data.player.SelfInfo;
    import ddt.data.goods.InventoryItemInfo;
    import __AS3__.vec.Vector;
    import pet.date.PetInfo;
    import ddt.manager.PlayerManager;
    import ddt.data.BagInfo;
    import consortion.ConsortionModelControl;
    import ddt.manager.PetBagManager;
    import bead.BeadManager;
    import ddt.manager.LanguageMgr;
    import liveness.LivenessModel;

    public class QuestInfo 
    {

        public static const PET:int = 0;

        public var QuestID:int;
        public var GuideType:int;
        public var GuideSceneID:int;
        public var data:QuestDataInfo;
        public var Detail:String;
        public var Objective:String;
        public var otherCondition:int;
        public var Level:int;
        public var NeedMinLevel:int;
        public var NeedMaxLevel:int;
        public var required:Boolean = false;
        public var Type:int;
        public var PreQuestID:String;
        public var NextQuestID:String;
        public var CanRepeat:Boolean;
        public var RepeatInterval:int;
        public var RepeatMax:int;
        public var Title:String;
        public var disabled:Boolean = false;
        public var optionalConditionNeed:uint = 0;
        public var _conditions:Array;
        private var _itemRewards:Array;
        public var StrengthenLevel:int;
        public var FinishCount:int;
        public var ReqItemID:int;
        public var ReqKillLevel:int;
        public var ReqBeCaption:Boolean;
        public var ReqMap:int;
        public var ReqFightMode:int;
        public var ReqTimeMode:int;
        public var RewardGold:int;
        public var RewardMoney:int;
        public var RewardGP:int;
        public var OneKeyFinishNeedMoney:int;
        public var RewardOffer:int;
        public var RewardDailyActivity:int;
        public var RewardBindMoney:int;
        public var RewardBuffID:int;
        public var RewardBuffDate:int;
        public var RewardHonor:int;
        public var RewardMagicSoul:int;
        public var Rank:String;
        public var Level2NeedMoney:int;
        public var Level3NeedMoney:int;
        public var Level4NeedMoney:int;
        public var Level5NeedMoney:int;
        public var RewardConsortiaGP:int;
        public var RewardConsortiaRiches:int;
        public var MapID:int;
        public var AutoEquip:Boolean;
        public var StarLev:int;
        public var LimitNodes:int;
        public var SortLevel:int;
        private var _questLevel:int;
        public var TimeLimit:Boolean;
        public var StartDate:Date;
        public var EndDate:Date;
        public var BuffID:int;
        public var BuffValidDate:int;


        public static function createFromXML(_arg_1:XML):QuestInfo
        {
            var _local_7:XML;
            var _local_8:QuestCondition;
            var _local_9:XML;
            var _local_10:Array;
            var _local_11:QuestItemReward;
            var _local_2:QuestInfo = new (QuestInfo)();
            _local_2.QuestID = _arg_1.@ID;
            _local_2.Type = _arg_1.@QuestID;
            _local_2.Detail = _arg_1.@Detail;
            _local_2.Title = _arg_1.@Title;
            _local_2.Objective = _arg_1.@Objective;
            _local_2.SortLevel = _arg_1.@SortLevel;
            _local_2.QuestLevel = _arg_1.@QuestLevel;
            _local_2.NeedMinLevel = _arg_1.@NeedMinLevel;
            _local_2.NeedMaxLevel = _arg_1.@NeedMaxLevel;
            _local_2.PreQuestID = _arg_1.@PreQuestID;
            _local_2.NextQuestID = _arg_1.@NextQuestID;
            _local_2.CanRepeat = ((_arg_1.@CanRepeat == "true") ? true : false);
            _local_2.RepeatInterval = _arg_1.@RepeatInterval;
            _local_2.RepeatMax = _arg_1.@RepeatMax;
            _local_2.RewardHonor = _arg_1.@RewardHonor;
            _local_2.RewardGold = _arg_1.@RewardGold;
            _local_2.RewardMagicSoul = _arg_1.@RewardMagicSoul;
            _local_2.RewardGP = _arg_1.@RewardGP;
            _local_2.RewardMoney = _arg_1.@RewardMoney;
            _local_2.OneKeyFinishNeedMoney = _arg_1.@OneKeyFinishNeedMoney;
            _local_2.Rank = _arg_1.@Rank;
            _local_2.RewardOffer = _arg_1.@RewardOffer;
            _local_2.RewardDailyActivity = _arg_1.@RewardDailyActivity;
            _local_2.RewardBindMoney = _arg_1.@RewardBindMoney;
            _local_2.TimeLimit = _arg_1.@TimeMode;
            _local_2.RewardBuffID = _arg_1.@RewardBuffID;
            _local_2.RewardBuffDate = _arg_1.@RewardBuffDate;
            _local_2.Level2NeedMoney = _arg_1.@Level2NeedMoney;
            _local_2.Level3NeedMoney = _arg_1.@Level3NeedMoney;
            _local_2.Level4NeedMoney = _arg_1.@Level4NeedMoney;
            _local_2.Level5NeedMoney = _arg_1.@Level5NeedMoney;
            _local_2.otherCondition = _arg_1.@IsOther;
            _local_2.StartDate = DateUtils.dealWithStringDate(String(_arg_1.@StartDate).replace("T", " "));
            _local_2.EndDate = DateUtils.dealWithStringDate(String(_arg_1.@EndDate).replace("T", " "));
            _local_2.MapID = _arg_1.@MapID;
            _local_2.AutoEquip = StringUtils.converBoolean(_arg_1.@AutoEquip);
            _local_2.optionalConditionNeed = _arg_1.@NotMustCount;
            _local_2.LimitNodes = _arg_1.@LimitNodes;
            _local_2.GuideType = _arg_1.@GuideType;
            _local_2.GuideSceneID = _arg_1.@GuideSceneID;
            _local_2.RewardOffer = _arg_1.@RewardOffer;
            _local_2.RewardConsortiaGP = _arg_1.@RewardConsortiaGP;
            _local_2.RewardConsortiaRiches = _arg_1.@RewardConsortiaRiches;
            var _local_3:XMLList = _arg_1..Item_Condiction;
            var _local_4:int;
            while (_local_4 < _local_3.length())
            {
                _local_7 = _local_3[_local_4];
                _local_8 = new QuestCondition(_local_2.QuestID, _local_7.@CondictionID, _local_7.@CondictionType, _local_7.@CondictionTitle, _local_7.@Para1, _local_7.@Para2);
                if (_local_7.@isOpitional == "true")
                {
                    _local_8.isOpitional = true;
                }
                else
                {
                    _local_8.isOpitional = false;
                };
                switch (_local_8.type)
                {
                    case 1:
                        TaskManager.instance.addGradeListener();
                        break;
                    case 2:
                    case 14:
                    case 15:
                        TaskManager.instance.addItemListener(_local_8.param);
                        break;
                    case 18:
                        break;
                    case 20:
                        switch (_local_8.param)
                        {
                            case 1:
                                if ((!(_local_2.isTimeOut())))
                                {
                                    TaskManager.instance.addDesktopListener(_local_8);
                                };
                                break;
                            case 2:
                                TaskManager.instance.addAnnexListener(_local_8);
                                break;
                            case 3:
                                TaskManager.instance.addFriendListener(_local_8);
                                break;
                            case 4:
                                break;
                        };
                        break;
                };
                _local_2.addCondition(_local_8);
                _local_4++;
            };
            var _local_5:XMLList = _arg_1..Item_Good;
            var _local_6:int;
            while (_local_6 < _local_5.length())
            {
                _local_9 = _local_5[_local_6];
                _local_10 = new Array(int(_local_9.@RewardItemCount1), int(_local_9.@RewardItemCount2), int(_local_9.@RewardItemCount3), int(_local_9.@RewardItemCount4), int(_local_9.@RewardItemCount5));
                _local_11 = new QuestItemReward(_local_9.@RewardItemID, _local_10, _local_9.@IsSelect, _local_9.@IsBind);
                _local_11.time = _local_9.@RewardItemValid;
                _local_11.AttackCompose = _local_9.@AttackCompose;
                _local_11.DefendCompose = _local_9.@DefendCompose;
                _local_11.AgilityCompose = _local_9.@AgilityCompose;
                _local_11.LuckCompose = _local_9.@LuckCompose;
                _local_11.StrengthenLevel = _local_9.@StrengthenLevel;
                _local_11.IsCount = _local_9.@IsCount;
                _local_2.addReward(_local_11);
                _local_6++;
            };
            return (_local_2);
        }


        public function get QuestLevel():int
        {
            return (this._questLevel);
        }

        public function set QuestLevel(_arg_1:int):void
        {
            if (_arg_1 < 1)
            {
                _arg_1 = 1;
            };
            if (_arg_1 > 5)
            {
                _arg_1 = 5;
            };
            this._questLevel = _arg_1;
        }

        public function get RewardItemCount():int
        {
            return (this._itemRewards[0].count);
        }

        public function get RewardItemValidate():int
        {
            return (this._itemRewards[0].count);
        }

        public function get itemRewards():Array
        {
            return (this._itemRewards);
        }

        public function get Id():int
        {
            return (this.QuestID);
        }

        public function get hadChecked():Boolean
        {
            if (((this.data) && (this.data.hadChecked)))
            {
                return (true);
            };
            return (false);
        }

        public function set hadChecked(_arg_1:Boolean):void
        {
            if (this.data)
            {
                this.data.hadChecked = _arg_1;
            };
        }

        public function BuffName():String
        {
            return (ItemManager.Instance.getTemplateById(this.BuffID).Name);
        }

        public function addCondition(_arg_1:QuestCondition):void
        {
            if ((!(this._conditions)))
            {
                this._conditions = new Array();
            };
            this._conditions.push(_arg_1);
        }

        public function addReward(_arg_1:QuestItemReward):void
        {
            if ((!(this._itemRewards)))
            {
                this._itemRewards = new Array();
            };
            this._itemRewards.push(_arg_1);
        }

        public function isTimeOut():Boolean
        {
            if (((this.Id == 500) && (PathManager.solveClientDownloadPath() == "")))
            {
                return (true);
            };
            var _local_1:Date = TimeManager.Instance.Now();
            var _local_2:Date = new Date(1990, 1, 1, _local_1.getHours(), _local_1.getMinutes(), _local_1.getSeconds());
            var _local_3:Date = new Date(1990, 1, 1, this.StartDate.getHours(), this.StartDate.getMinutes(), this.StartDate.getSeconds());
            var _local_4:Date = new Date(1990, 1, 1, this.EndDate.getHours(), this.EndDate.getMinutes(), this.EndDate.getSeconds());
            if (((_local_1.time > this.EndDate.time) || (_local_1.time < this.StartDate.time)))
            {
                return (true);
            };
            return (false);
        }

        public function get id():int
        {
            return (this.QuestID);
        }

        public function get Condition():int
        {
            return (this._conditions[0].type);
        }

        public function get RewardItemID():int
        {
            return (this._itemRewards[0].itemID);
        }

        public function get RewardItemValidateTime():int
        {
            return (this._itemRewards[0].time);
        }

        public function isAvailableFor(_arg_1:SelfInfo):Boolean
        {
            return (false);
        }

        public function get isAvailable():Boolean
        {
            if ((!(this.isAchieved)))
            {
                return (true);
            };
            if ((!(this.CanRepeat)))
            {
                return (false);
            };
            if (TimeManager.Instance.TotalDaysToNow2(this.data.CompleteDate) < this.RepeatInterval)
            {
                if (((this.data.repeatLeft < 1) && (!(this.data.isExist))))
                {
                    return (false);
                };
            };
            return (true);
        }

        public function get isAchieved():Boolean
        {
            if (((!(this.data)) || (!(this.data.isAchieved))))
            {
                return (false);
            };
            return (true);
        }

        private function getProgressById(_arg_1:uint):uint
        {
            var _local_2:SelfInfo;
            var _local_3:QuestCondition;
            var _local_5:InventoryItemInfo;
            var _local_6:Array;
            var _local_7:Array;
            var _local_8:int;
            var _local_9:int;
            var _local_10:Vector.<PetInfo>;
            var _local_11:uint;
            var _local_12:uint;
            var _local_13:Array;
            var _local_14:Array;
            var _local_15:uint;
            var _local_16:InventoryItemInfo;
            var _local_17:InventoryItemInfo;
            var _local_18:PetInfo;
            var _local_19:InventoryItemInfo;
            var _local_20:int;
            var _local_21:uint;
            _local_2 = PlayerManager.Instance.Self;
            _local_3 = this.getConditionById(_arg_1);
            var _local_4:int;
            if (((this.data == null) || (this.data.progress[_arg_1] == null)))
            {
                _local_4 = 0;
            }
            else
            {
                _local_4 = (_local_3.target - this.data.progress[_arg_1]);
            };
            switch (_local_3.type)
            {
                case 1:
                    _local_4 = _local_2.Grade;
                    break;
                case 2:
                    _local_4 = 0;
                    _local_5 = _local_2.getBag(BagInfo.EQUIPBAG).findEquipedItemByTemplateId(_local_3.param, false);
                    if (((_local_5) && (_local_5.Place <= 30)))
                    {
                        _local_4 = 1;
                    };
                    break;
                case 9:
                    _local_4 = 0;
                    _local_6 = _local_2.getBag(BagInfo.EQUIPBAG).findItemsForEach(_local_3.param);
                    _local_7 = _local_2.getBag(BagInfo.STOREBAG).findItemsForEach(_local_3.param);
                    for each (_local_16 in _local_6)
                    {
                        if (_local_16.StrengthenLevel >= _local_3.target)
                        {
                            _local_4 = _local_3.target;
                            break;
                        };
                    };
                    for each (_local_17 in _local_7)
                    {
                        if (_local_17.StrengthenLevel >= _local_3.target)
                        {
                            _local_4 = _local_3.target;
                            break;
                        };
                    };
                    break;
                case 14:
                case 15:
                    _local_8 = _local_2.getBag(BagInfo.EQUIPBAG).getItemCountByTemplateId(_local_3.param, false);
                    _local_9 = _local_2.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(_local_3.param, false);
                    _local_4 = (_local_8 + _local_9);
                    break;
                case 16:
                    _local_4 = 1;
                    break;
                case 17:
                    _local_4 = ((_local_2.IsMarried) ? 1 : 0);
                    break;
                case 18:
                    switch (_local_3.param)
                    {
                        case 0:
                            if (ConsortionModelControl.Instance.model.memberList.length > 0)
                            {
                                _local_4 = ConsortionModelControl.Instance.model.memberList.length;
                            };
                            break;
                        case 1:
                            if (PlayerManager.Instance.Self.UseOffer)
                            {
                                _local_4 = PlayerManager.Instance.Self.UseOffer;
                            };
                            break;
                        case 2:
                            if (PlayerManager.Instance.Self.consortiaInfo.SmithLevel)
                            {
                                _local_4 = PlayerManager.Instance.Self.consortiaInfo.SmithLevel;
                            };
                            break;
                        case 3:
                            if (PlayerManager.Instance.Self.consortiaInfo.ShopLevel)
                            {
                                _local_4 = PlayerManager.Instance.Self.consortiaInfo.ShopLevel;
                            };
                            break;
                        case 4:
                            if (PlayerManager.Instance.Self.consortiaInfo.StoreLevel)
                            {
                                _local_4 = PlayerManager.Instance.Self.consortiaInfo.StoreLevel;
                            };
                            break;
                    };
                    break;
                case 20:
                    if (_local_3.param == 3)
                    {
                        _local_4 = PlayerManager.Instance.friendList.length;
                        break;
                    };
                    break;
                case 56:
                    if (PlayerManager.Instance.Self.totemId <= 10000)
                    {
                        _local_4 = 0;
                    }
                    else
                    {
                        _local_4 = int(Math.floor(((PlayerManager.Instance.Self.totemId - 10000) / 7)));
                    };
                    break;
                case 58:
                    _local_4 = PetBagManager.instance().petModel.spaceLevel;
                    break;
                case 61:
                    _local_4 = PlayerManager.Instance.Self.getStrengthCompleteCount(_local_3.param2);
                    break;
                case 50:
                    _local_10 = PetBagManager.instance().petModel.getpetListSorted();
                    _local_11 = 0;
                    for each (_local_18 in _local_10)
                    {
                        if (_local_18.Level >= _local_3.param2)
                        {
                            _local_11++;
                        };
                    };
                    if (_local_11 > _local_3.param)
                    {
                        _local_4 = _local_3.param2;
                    }
                    else
                    {
                        _local_4 = 0;
                    };
                    break;
                case 57:
                    _local_12 = 0;
                    for each (_local_19 in BeadManager.instance.beadBag.items)
                    {
                        if (_local_19.beadLevel >= _local_3.param2)
                        {
                            _local_12++;
                        };
                    };
                    if (_local_12 > _local_3.param)
                    {
                        _local_4 = _local_3.param2;
                    }
                    else
                    {
                        _local_4 = 0;
                    };
                    break;
                case 62:
                    _local_13 = new Array(0, 0, 0, 0, 0, 0);
                    _local_14 = _local_2.getBag(BagInfo.EQUIPBAG).findSuitsForEach(_local_3.param);
                    _local_20 = 0;
                    while (_local_20 < _local_14.length)
                    {
                        if (_local_14[_local_20].TemplateType < 7)
                        {
                            _local_13[(_local_14[_local_20].TemplateType - 1)] = 1;
                        };
                        _local_20++;
                    };
                    _local_15 = 0;
                    _local_21 = 0;
                    while (_local_21 < 6)
                    {
                        _local_15 = (_local_15 + _local_13[_local_21]);
                        _local_21++;
                    };
                    if (_local_15 < 6)
                    {
                        _local_4 = 0;
                    }
                    else
                    {
                        _local_4 = _local_3.param2;
                    };
                    break;
                default:
                    if (((this.data == null) || (this.data.progress[_arg_1] == null)))
                    {
                        _local_4 = 0;
                    }
                    else
                    {
                        _local_4 = (_local_3.target - this.data.progress[_arg_1]);
                    };
            };
            if (_local_4 > _local_3.target)
            {
                return (0);
            };
            return (_local_3.target - _local_4);
        }

        public function get progress():Array
        {
            var _local_1:SelfInfo = PlayerManager.Instance.Self;
            if ((!(this._conditions)))
            {
                this._conditions = new Array();
            };
            var _local_2:Array = new Array();
            var _local_3:int;
            while (this._conditions[_local_3])
            {
                _local_2[_local_3] = this.getProgressById(_local_3);
                _local_3++;
            };
            return (_local_2);
        }

        public function get conditionStatus():Array
        {
            var _local_3:int;
            if ((!(this._conditions)))
            {
                this._conditions = new Array();
            };
            var _local_1:Array = new Array();
            var _local_2:int;
            while (this._conditions[_local_2])
            {
                _local_3 = this.progress[_local_2];
                if (_local_3 <= 0)
                {
                    _local_1[_local_2] = LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.over");
                }
                else
                {
                    if ((((((((((this._conditions[_local_2].type == 9) || (this._conditions[_local_2].type == 12)) || (this._conditions[_local_2].type == 17)) || (this._conditions[_local_2].type == 21)) || (this._conditions[_local_2].type == 50)) || (this._conditions[_local_2].type == 57)) || (this._conditions[_local_2].type == 61)) || (this._conditions[_local_2].type == 62)) || (this._conditions[_local_2].type == LivenessModel.RANDOM_PVE)))
                    {
                        _local_1[_local_2] = LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
                    }
                    else
                    {
                        if (((this._conditions[_local_2].type == 20) && (this._conditions[_local_2].param == 2)))
                        {
                            _local_1[_local_2] = LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress");
                        }
                        else
                        {
                            _local_1[_local_2] = (((("(" + String((this._conditions[_local_2].target - _local_3))) + "/") + String(this._conditions[_local_2].target)) + ")");
                        };
                    };
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function get conditionDescription():Array
        {
            var _local_3:int;
            if ((!(this._conditions)))
            {
                this._conditions = new Array();
            };
            var _local_1:Array = new Array();
            var _local_2:int;
            while (this._conditions[_local_2])
            {
                _local_3 = this.progress[_local_2];
                if (_local_3 <= 0)
                {
                    _local_1[_local_2] = (this._conditions[_local_2].description + LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.over"));
                }
                else
                {
                    if ((((this._conditions[_local_2].type == 9) || (this._conditions[_local_2].type == 12)) || (this._conditions[_local_2].type == 21)))
                    {
                        _local_1[_local_2] = (this._conditions[_local_2].description + LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress"));
                    }
                    else
                    {
                        if (((this._conditions[_local_2].type == 20) && (this._conditions[_local_2].param == 2)))
                        {
                            _local_1[_local_2] = (this._conditions[_local_2].description + LanguageMgr.GetTranslation("tank.view.task.Taskstatus.onProgress"));
                        }
                        else
                        {
                            _local_1[_local_2] = (((((this._conditions[_local_2].description + "(") + String((this._conditions[_local_2].target - _local_3))) + "/") + String(this._conditions[_local_2].target)) + ")");
                        };
                    };
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function get isCompleted():Boolean
        {
            var _local_1:QuestCondition;
            if (this.Type == 4)
            {
                if ((!(PlayerManager.Instance.Self.IsVIP)))
                {
                    return (false);
                };
                if (((this.id == 306) && (PlayerManager.Instance.Self.VIPtype < 2)))
                {
                    return (false);
                };
            };
            if (((!(this.CanRepeat)) && (this.isAchieved)))
            {
                return (false);
            };
            var _local_2:int = this.optionalConditionNeed;
            var _local_3:int;
            while ((_local_1 = this.getConditionById(_local_3)))
            {
                if ((!(_local_1))) break;
                if (this.progress[_local_3] > 0)
                {
                    if ((!(_local_1.isOpitional)))
                    {
                        return (false);
                    };
                }
                else
                {
                    _local_2--;
                };
                _local_3++;
            };
            if (_local_2 > 0)
            {
                return (false);
            };
            return (true);
        }

        private function getConditionById(_arg_1:uint):QuestCondition
        {
            if ((!(this._conditions)))
            {
                this._conditions = new Array();
            };
            return (this._conditions[_arg_1] as QuestCondition);
        }

        public function get questProgressNum():Number
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            while (this._conditions[_local_3])
            {
                _local_1 = (_local_1 + this.progress[_local_3]);
                _local_2 = (_local_2 + this._conditions[_local_3].target);
                _local_3++;
            };
            return (_local_1 / _local_2);
        }

        public function get canViewWithProgress():Boolean
        {
            var _local_2:int;
            var _local_3:int;
            if ((!(this._conditions)))
            {
                this._conditions = new Array();
            };
            var _local_1:Boolean = true;
            var _local_4:int;
            while (this._conditions[_local_4])
            {
                _local_2 = (_local_2 + this.progress[_local_4]);
                _local_3 = (_local_3 + this._conditions[_local_4].target);
                _local_4++;
            };
            if (_local_2 == _local_3)
            {
                _local_1 = false;
            };
            if ((!(this.isCompleted)))
            {
                _local_4 = 0;
                while (this._conditions[_local_4])
                {
                    if (((((this._conditions[_local_4].type == 9) || (this._conditions[_local_4].type == 12)) || (this._conditions[_local_4].type == 17)) || (this._conditions[_local_4].type == 21)))
                    {
                        _local_1 = false;
                    };
                    if (((this._conditions[_local_4].type == 20) && (this._conditions[_local_4].param == 2)))
                    {
                        _local_1 = false;
                    };
                    _local_4++;
                };
            };
            return (_local_1);
        }

        public function hasOtherAward():Boolean
        {
            if (this.RewardGP > 0)
            {
                return (true);
            };
            if (this.RewardGold > 0)
            {
                return (true);
            };
            if (this.RewardMoney > 0)
            {
                return (true);
            };
            if (this.RewardOffer > 0)
            {
                return (true);
            };
            if (this.RewardDailyActivity > 0)
            {
                return (true);
            };
            if (this.RewardBindMoney > 0)
            {
                return (true);
            };
            if (this.Rank != "")
            {
                return (true);
            };
            if (this.RewardBuffID != 0)
            {
                return (true);
            };
            if (this.RewardHonor != 0)
            {
                return (true);
            };
            if (this.RewardMagicSoul > 0)
            {
                return (true);
            };
            if (this.RewardConsortiaGP > 0)
            {
                return (true);
            };
            if (this.RewardConsortiaRiches > 0)
            {
                return (true);
            };
            return (false);
        }


    }
}//package ddt.data.quest

