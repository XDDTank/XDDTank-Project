// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistRightView

package tofflist.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import tofflist.TofflistController;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;
    import tofflist.TofflistModel;
    import tofflist.TofflistEvent;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;

    public class TofflistRightView extends Sprite implements Disposeable 
    {

        private var _contro:TofflistController;
        private var _currentData:Array;
        private var _currentPage:int;
        private var _gridBox:TofflistGridBox;
        private var _pageTxt:FilterFrameText;
        private var _pgdn:BaseButton;
        private var _pgup:BaseButton;
        private var _stairMenu:TofflistStairMenu;
        private var _thirdClassMenu:TofflistThirdClassMenu;
        private var _totalPage:int;
        private var _twoGradeMenu:TofflistTwoGradeMenu;
        private var _leftInfo:TofflistLeftInfoView;
        private var _upDownBg:ScaleLeftRightImage;
        private var _upDownTextBg:ScaleLeftRightImage;

        public function TofflistRightView(_arg_1:TofflistController)
        {
            this._contro = _arg_1;
            super();
            this.init();
            this.addEvent();
        }

        public function get gridBox():TofflistGridBox
        {
            return (this._gridBox);
        }

        public function dispose():void
        {
            this._contro = null;
            this._currentData = null;
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            if (this.gridBox)
            {
                ObjectUtils.disposeObject(this.gridBox);
            };
            if (this._pageTxt)
            {
                ObjectUtils.disposeObject(this._pageTxt);
            };
            if (this._pgdn)
            {
                ObjectUtils.disposeObject(this._pgdn);
            };
            if (this._pgup)
            {
                ObjectUtils.disposeObject(this._pgup);
            };
            if (this._upDownTextBg)
            {
                ObjectUtils.disposeObject(this._upDownTextBg);
            };
            if (this._upDownBg)
            {
                ObjectUtils.disposeObject(this._upDownBg);
            };
            if (this._stairMenu)
            {
                ObjectUtils.disposeObject(this._stairMenu);
            };
            if (this._twoGradeMenu)
            {
                ObjectUtils.disposeObject(this._twoGradeMenu);
            };
            if (this._thirdClassMenu)
            {
                ObjectUtils.disposeObject(this._thirdClassMenu);
            };
            this._gridBox = null;
            this._pageTxt = null;
            this._pgdn = null;
            this._pgup = null;
            this._upDownBg = null;
            this._upDownTextBg = null;
            this._stairMenu = null;
            this._twoGradeMenu = null;
            this._thirdClassMenu = null;
        }

        public function updateTime(_arg_1:String):void
        {
            if (_arg_1)
            {
                this._leftInfo.updateTimeTxt.text = (LanguageMgr.GetTranslation("tank.tofflist.view.lastUpdateTime") + _arg_1);
            }
            else
            {
                this._leftInfo.updateTimeTxt.text = "";
            };
        }

        public function get firstType():String
        {
            return (this._stairMenu.type);
        }

        public function orderList(_arg_1:Array):void
        {
            if ((!(_arg_1)))
            {
                return;
            };
            this._currentData = _arg_1;
            this._gridBox.updateList(_arg_1);
            this._totalPage = Math.ceil((((_arg_1 == null) ? 0 : _arg_1.length) / 8));
            if (((this._currentData) && (this._currentData.length > 0)))
            {
                this._currentPage = 1;
            }
            else
            {
                this._currentPage = 1;
            };
            this.checkPageBtn();
        }

        public function get twoGradeType():String
        {
            return (this._twoGradeMenu.type);
        }

        private function __addToStageHandler(_arg_1:Event):void
        {
            this._stairMenu.type = TofflistStairMenu.PERSONAL;
            this._twoGradeMenu.setParentType(this._stairMenu.type);
        }

        private function __menuTypeHandler(_arg_1:TofflistEvent):void
        {
            switch (TofflistModel.firstMenuType)
            {
                case TofflistStairMenu.PERSONAL:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_BATTLE);
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_LEVEL);
                            break;
                        case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_ACHIVE);
                            break;
                        case TofflistTwoGradeMenu.MATCHES:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_MATCH);
                            break;
                        case TofflistTwoGradeMenu.MILITARY:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_LOCAL_MILITARY);
                            break;
                        case TofflistTwoGradeMenu.ARENA:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.LOCAL_ARENA_SCORE_DAY);
                            break;
                    };
                    return;
                case TofflistStairMenu.CONSORTIA:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_LOCAL_BATTLE);
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_LOCAL_LEVEL);
                            break;
                        case TofflistTwoGradeMenu.ASSETS:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_LOCAL_ASSET);
                            break;
                    };
                    return;
                case TofflistStairMenu.CROSS_SERVER_PERSONAL:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_CROSS_BATTLE);
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_CROSS_LEVEL);
                            break;
                        case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.PERSON_CROSS_ACHIVE);
                            break;
                        case TofflistTwoGradeMenu.ARENA:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.CROSS_ARENA_SCORE_DAY);
                            break;
                    };
                    return;
                case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_CROSS_BATTLE);
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_CROSS_LEVEL);
                            break;
                        case TofflistTwoGradeMenu.ASSETS:
                            this._gridBox.updateStyleXY(TofflistThirdClassMenu.CONSORTIA_CROSS_ASSET);
                            break;
                    };
                    return;
            };
        }

        private function __pgdnHandler(_arg_1:MouseEvent):void
        {
            if ((!(this._currentData)))
            {
                return;
            };
            SoundManager.instance.play("008");
            this._currentPage++;
            this._gridBox.updateList(this._currentData, this._currentPage);
            this.checkPageBtn();
        }

        private function __pgupHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._currentPage--;
            this._gridBox.updateList(this._currentData, this._currentPage);
            this.checkPageBtn();
        }

        private function __searchOrderHandler(_arg_1:TofflistEvent):void
        {
            var _local_2:String;
            this._contro.clearDisplayContent();
            if (TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL)
            {
                _local_2 = "personal";
                if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
                {
                    if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                    {
                        this._contro.loadFormData("personalBattleAccumulate");
                    };
                }
                else
                {
                    if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
                    {
                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
                        {
                            this._contro.loadFormData("individualGradeDay");
                        }
                        else
                        {
                            if (this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
                            {
                                this._contro.loadFormData("individualGradeWeek");
                            }
                            else
                            {
                                if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                                {
                                    this._contro.loadFormData("individualGradeAccumulate");
                                };
                            };
                        };
                    }
                    else
                    {
                        if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.ACHIEVEMENTPOINT)
                        {
                            if (this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
                            {
                                this._contro.loadFormData("PersonalAchievementPointDay");
                            }
                            else
                            {
                                if (this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
                                {
                                    this._contro.loadFormData("PersonalAchievementPointWeek");
                                }
                                else
                                {
                                    if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                                    {
                                        this._contro.loadFormData("PersonalAchievementPoint");
                                    };
                                };
                            };
                        }
                        else
                        {
                            if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.MATCHES)
                            {
                                if (this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
                                {
                                    this._contro.loadFormData("personalMatchesWeek");
                                };
                            }
                            else
                            {
                                if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.MILITARY)
                                {
                                    if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                                    {
                                        this._contro.loadFormData("Person_local_military");
                                    };
                                }
                                else
                                {
                                    if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.ARENA)
                                    {
                                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
                                        {
                                            this._contro.loadFormData(TofflistThirdClassMenu.LOCAL_ARENA_SCORE_DAY);
                                        };
                                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
                                        {
                                            this._contro.loadFormData(TofflistThirdClassMenu.LOCAL_ARENA_SCORE_WEEK);
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
                if (TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA)
                {
                    _local_2 = "sociaty";
                    if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
                    {
                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                        {
                            this._contro.loadFormData("consortiaBattleAccumulate");
                        };
                    }
                    else
                    {
                        if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
                        {
                            if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                            {
                                this._contro.loadFormData("consortiaGradeAccumulate");
                            };
                        }
                        else
                        {
                            if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.ASSETS)
                            {
                                if (this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
                                {
                                    this._contro.loadFormData("consortiaAssetDay");
                                }
                                else
                                {
                                    if (this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
                                    {
                                        this._contro.loadFormData("consortiaAssetWeek");
                                    }
                                    else
                                    {
                                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                                        {
                                            this._contro.loadFormData("consortiaAssetAccumulate");
                                        };
                                    };
                                };
                            };
                        };
                    };
                }
                else
                {
                    if (TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
                    {
                        _local_2 = "personal";
                        if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
                        {
                            if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                            {
                                this._contro.loadFormData("crossServerPersonalBattleAccumulate");
                            };
                        }
                        else
                        {
                            if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
                            {
                                if (this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
                                {
                                    this._contro.loadFormData("crossServerIndividualGradeDay");
                                }
                                else
                                {
                                    if (this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
                                    {
                                        this._contro.loadFormData("crossServerIndividualGradeWeek");
                                    }
                                    else
                                    {
                                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                                        {
                                            this._contro.loadFormData("crossServerIndividualGradeAccumulate");
                                        };
                                    };
                                };
                            }
                            else
                            {
                                if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.ACHIEVEMENTPOINT)
                                {
                                    if (this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
                                    {
                                        this._contro.loadFormData("crossServerPersonalAchievementPointDay");
                                    }
                                    else
                                    {
                                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
                                        {
                                            this._contro.loadFormData("crossServerPersonalAchievementPointWeek");
                                        }
                                        else
                                        {
                                            if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                                            {
                                                this._contro.loadFormData("crossServerPersonalAchievementPoint");
                                            };
                                        };
                                    };
                                }
                                else
                                {
                                    if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.ARENA)
                                    {
                                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
                                        {
                                            this._contro.loadFormData(TofflistThirdClassMenu.CROSS_ARENA_SCORE_DAY);
                                        };
                                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
                                        {
                                            this._contro.loadFormData(TofflistThirdClassMenu.CROSS_ARENA_SCORE_WEEK);
                                        };
                                    };
                                };
                            };
                        };
                    }
                    else
                    {
                        if (TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_CONSORTIA)
                        {
                            _local_2 = "sociaty";
                            if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
                            {
                                if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                                {
                                    this._contro.loadFormData("crossServerConsortiaGradeAccumulate");
                                };
                            }
                            else
                            {
                                if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.ASSETS)
                                {
                                    if (this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
                                    {
                                        this._contro.loadFormData("crossServerConsortiaAssetDay");
                                    }
                                    else
                                    {
                                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
                                        {
                                            this._contro.loadFormData("crossServerConsortiaAssetWeek");
                                        }
                                        else
                                        {
                                            if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                                            {
                                                this._contro.loadFormData("crossServerConsortiaAssetAccumulate");
                                            };
                                        };
                                    };
                                }
                                else
                                {
                                    if (TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
                                    {
                                        if (this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
                                        {
                                            this._contro.loadFormData("crossServerConsortiaBattleAccumulate");
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function __selectChildBarHandler(_arg_1:TofflistEvent):void
        {
            this._contro.clearDisplayContent();
            this._thirdClassMenu.selectType(this._stairMenu.type, TofflistModel.secondMenuType);
        }

        private function __selectStairMenuHandler(_arg_1:TofflistEvent):void
        {
            this._contro.clearDisplayContent();
            this._twoGradeMenu.setParentType(TofflistModel.firstMenuType);
        }

        private function addEvent():void
        {
            this._thirdClassMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT, this.__searchOrderHandler);
            this._twoGradeMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT, this.__selectChildBarHandler);
            this._stairMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT, this.__selectStairMenuHandler);
            TofflistModel.addEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE, this.__menuTypeHandler);
            this._pgup.addEventListener(MouseEvent.CLICK, this.__pgupHandler);
            this._pgdn.addEventListener(MouseEvent.CLICK, this.__pgdnHandler);
            this.addEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
        }

        private function checkPageBtn():void
        {
            if (this._currentPage <= 1)
            {
                this._pgup.enable = false;
            }
            else
            {
                this._pgup.enable = true;
            };
            if (this._currentPage < this._totalPage)
            {
                this._pgdn.enable = true;
            }
            else
            {
                this._pgdn.enable = false;
            };
            this._pageTxt.text = ((this._currentPage + "/") + this._totalPage);
        }

        private function init():void
        {
            this._gridBox = ComponentFactory.Instance.creatCustomObject("tofflist.gridBox");
            addChild(this._gridBox);
            this._stairMenu = ComponentFactory.Instance.creatCustomObject("tofflist.stairMenu");
            addChild(this._stairMenu);
            this._twoGradeMenu = ComponentFactory.Instance.creatCustomObject("tofflist.twoGradeMenu");
            addChild(this._twoGradeMenu);
            this._thirdClassMenu = ComponentFactory.Instance.creatCustomObject("tofflist.hirdClassMenu");
            addChild(this._thirdClassMenu);
            this._upDownBg = ComponentFactory.Instance.creatComponentByStylename("asset.Toffilist.upDownBgImgAsset");
            addChild(this._upDownBg);
            this._pgup = ComponentFactory.Instance.creatComponentByStylename("toffilist.prePageBtn");
            addChild(this._pgup);
            this._pgdn = ComponentFactory.Instance.creatComponentByStylename("toffilist.nextPageBtn");
            addChild(this._pgdn);
            this._upDownTextBg = ComponentFactory.Instance.creatComponentByStylename("asset.Toffilist.upDownTextBgImgAsset");
            addChild(this._upDownTextBg);
            this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.pageTxt");
            addChild(this._pageTxt);
            this._leftInfo = ComponentFactory.Instance.creatCustomObject("tofflist.leftInfoView");
            addChild(this._leftInfo);
        }

        private function removeEvent():void
        {
            this._stairMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT, this.__selectStairMenuHandler);
            this._twoGradeMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT, this.__selectChildBarHandler);
            this._thirdClassMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT, this.__searchOrderHandler);
            TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE, this.__menuTypeHandler);
            this._pgup.removeEventListener(MouseEvent.CLICK, this.__pgupHandler);
            this._pgdn.removeEventListener(MouseEvent.CLICK, this.__pgdnHandler);
            this.removeEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
        }


    }
}//package tofflist.view

