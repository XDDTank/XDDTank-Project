// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistLeftInfoView

package tofflist.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import ddt.view.common.LevelIcon;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import tofflist.data.RankInfo;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.player.SelfInfo;
    import road7th.data.DictionaryData;
    import ddt.manager.PlayerManager;
    import ddt.data.club.ClubInfo;
    import ddt.manager.LanguageMgr;
    import tofflist.TofflistModel;
    import ddt.manager.ServerConfigManager;
    import militaryrank.MilitaryRankManager;
    import ddt.utils.PositionUtils;
    import tofflist.TofflistEvent;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;

    public class TofflistLeftInfoView extends Sprite implements Disposeable 
    {

        private var _bgI:Scale9CornerImage;
        private var _levelIcon:LevelIcon;
        private var _RankingLiftImg:ScaleFrameImage;
        private var _rankTitle:FilterFrameText;
        private var _textArr:Array;
        private var _updateTimeTxt:FilterFrameText;
        private var _tempArr:Vector.<RankInfo>;
        private var _bg:MovieClip;

        public function TofflistLeftInfoView()
        {
            this.init();
            this.addEvent();
        }

        public function dispose():void
        {
            var _local_1:FilterFrameText;
            this.removeEvent();
            for each (_local_1 in this._textArr)
            {
                ObjectUtils.disposeObject(_local_1);
            };
            this._textArr = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._bgI);
            this._bgI = null;
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
            ObjectUtils.disposeObject(this._updateTimeTxt);
            this._updateTimeTxt = null;
            if (this._RankingLiftImg)
            {
                ObjectUtils.disposeObject(this._RankingLiftImg);
            };
            this._RankingLiftImg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get updateTimeTxt():FilterFrameText
        {
            return (this._updateTimeTxt);
        }

        private function __tofflistTypeHandler(_arg_1:TofflistEvent):void
        {
            var _local_4:int;
            var _local_5:SelfInfo;
            var _local_6:DictionaryData;
            var _local_2:SelfInfo = PlayerManager.Instance.Self;
            var _local_3:ClubInfo = PlayerManager.Instance.SelfConsortia;
            this._levelIcon.visible = false;
            this._RankingLiftImg.visible = false;
            this._textArr[3].visible = false;
            this._bg.gotoAndStop(2);
            this._textArr[1].visible = false;
            this._rankTitle.text = LanguageMgr.GetTranslation("repute");
            switch (TofflistModel.firstMenuType)
            {
                case TofflistStairMenu.PERSONAL:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.FightPower);
                            if (TofflistModel.Instance.rankInfo != null)
                            {
                                this.onComPare(TofflistModel.Instance.rankInfo.FightPower, TofflistModel.Instance.rankInfo.PrevFightPower);
                            };
                            this._textArr[2].text = _local_2.FightPower;
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._bg.gotoAndStop(1);
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.GP);
                            if (TofflistModel.Instance.rankInfo != null)
                            {
                                this.onComPare(TofflistModel.Instance.rankInfo.GP, TofflistModel.Instance.rankInfo.PrevGP);
                            };
                            this._textArr[2].text = _local_2.GP;
                            this._levelIcon.setInfo(_local_2.Grade, _local_2.Repute, _local_2.WinCount, _local_2.TotalCount, _local_2.FightPower, _local_2.Offer, true, false);
                            this._levelIcon.visible = true;
                            break;
                        case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.AchievementPoint);
                            if (TofflistModel.Instance.rankInfo != null)
                            {
                                this.onComPare(TofflistModel.Instance.rankInfo.AchievementPoint, TofflistModel.Instance.rankInfo.PrevAchievementPoint);
                            };
                            this._textArr[2].text = _local_2.AchievementPoint;
                            break;
                        case TofflistTwoGradeMenu.MATCHES:
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.LeagueAddWeek);
                            if (TofflistModel.Instance.rankInfo != null)
                            {
                                this.onComPare(TofflistModel.Instance.rankInfo.LeagueAddWeek, TofflistModel.Instance.rankInfo.PrevLeagueAddWeek);
                            };
                            this._textArr[2].text = _local_2.matchInfo.weeklyScore;
                            break;
                        case TofflistTwoGradeMenu.MILITARY:
                            this._bg.gotoAndStop(6);
                            this._rankTitle.text = LanguageMgr.GetTranslation("tank.menu.MilitaryScore");
                            _local_5 = PlayerManager.Instance.Self;
                            _local_6 = TofflistModel.Instance.getMilitaryLocalTopN(3);
                            if (((_local_5.MilitaryRankTotalScores < ServerConfigManager.instance.getMilitaryData()[12]) || (!(_local_6.hasKey(_local_5.ID)))))
                            {
                                this._textArr[0].text = MilitaryRankManager.Instance.getMilitaryRankInfo(_local_5.MilitaryRankTotalScores).Name;
                            }
                            else
                            {
                                this._textArr[0].text = MilitaryRankManager.Instance.getOtherMilitaryName(_local_6[_local_5.ID][0])[0];
                            };
                            this._textArr[2].text = _local_2.MilitaryRankTotalScores;
                            break;
                        case TofflistTwoGradeMenu.ARENA:
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ArenaRankLocalDay);
                            this._textArr[2].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ArenaScoreDay);
                            this._bg.gotoAndStop(3);
                            break;
                    };
                    break;
                case TofflistStairMenu.CROSS_SERVER_PERSONAL:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._bg.gotoAndStop(2);
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.FightPower);
                            this._textArr[2].text = _local_2.FightPower;
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._bg.gotoAndStop(1);
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.GP);
                            this._textArr[2].text = _local_2.GP;
                            this._levelIcon.setInfo(_local_2.Grade, _local_2.Repute, _local_2.WinCount, _local_2.TotalCount, _local_2.FightPower, _local_2.Offer, true, false);
                            this._levelIcon.visible = true;
                            break;
                        case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.AchievementPoint);
                            this._textArr[2].text = _local_2.AchievementPoint;
                            break;
                        case TofflistTwoGradeMenu.ARENA:
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ArenaRankCrossDay);
                            this._textArr[2].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ArenaScoreDay);
                            this._bg.gotoAndStop(3);
                            break;
                    };
                    break;
                case TofflistStairMenu.CONSORTIA:
                default:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._bg.gotoAndStop(5);
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ConsortiaFightPower);
                            if (TofflistModel.Instance.rankInfo != null)
                            {
                                this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaFightPower, TofflistModel.Instance.rankInfo.ConsortiaPrevFightPower);
                            };
                            this._textArr[2].text = _local_2.consortiaInfo.FightPower;
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._bg.gotoAndStop(4);
                            this._textArr[1].visible = true;
                            if (((!(_local_3)) || (!(_local_2.consortiaInfo.ChairmanName))))
                            {
                                this.consortiaEmpty();
                            };
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ConsortiaLevel);
                            if (TofflistModel.Instance.rankInfo != null)
                            {
                                this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaLevel, TofflistModel.Instance.rankInfo.ConsortiaPrevLevel);
                            };
                            this._textArr[2].text = _local_2.consortiaInfo.Experience;
                            this._textArr[1].text = _local_2.consortiaInfo.Level;
                            break;
                        case TofflistTwoGradeMenu.ASSETS:
                            if (((!(_local_3)) || (!(_local_2.consortiaInfo.ChairmanName))))
                            {
                                this.consortiaEmpty();
                            }
                            else
                            {
                                this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ConsortiaRiches);
                                if (TofflistModel.Instance.rankInfo != null)
                                {
                                    this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaRiches, TofflistModel.Instance.rankInfo.ConsortiaPrevRiches);
                                };
                                this._textArr[2].text = _local_2.consortiaInfo.Riches;
                            };
                            break;
                    };
                    break;
                case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._bg.gotoAndStop(5);
                            this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ConsortiaFightPower);
                            this._textArr[2].text = _local_2.consortiaInfo.FightPower;
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._textArr[1].visible = true;
                            this._bg.gotoAndStop(4);
                            if (((!(_local_3)) || (!(_local_2.consortiaInfo.ChairmanName))))
                            {
                                this.consortiaEmpty();
                            }
                            else
                            {
                                this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ConsortiaLevel);
                                this._textArr[2].text = _local_2.consortiaInfo.Experience;
                                this._textArr[1].text = _local_2.consortiaInfo.Level;
                            };
                            break;
                        case TofflistTwoGradeMenu.ASSETS:
                            if (((!(_local_3)) || (!(_local_2.consortiaInfo.ChairmanName))))
                            {
                                this.consortiaEmpty();
                            }
                            else
                            {
                                this._textArr[0].text = ((TofflistModel.Instance.rankInfo == null) ? "0" : TofflistModel.Instance.rankInfo.ConsortiaRiches);
                                this._textArr[2].text = _local_2.consortiaInfo.Riches;
                            };
                            break;
                    };
            };
            if (TofflistModel.secondMenuType != TofflistTwoGradeMenu.LEVEL)
            {
                PositionUtils.setPos(this._RankingLiftImg, "tofflist.rankImagePos1");
                PositionUtils.setPos(this._textArr[3], "tofflist.comparePos1");
                PositionUtils.setPos(this._textArr[2], "tofflist.valueTextPos1");
            }
            else
            {
                PositionUtils.setPos(this._RankingLiftImg, "tofflist.rankImagePos2");
                PositionUtils.setPos(this._textArr[3], "tofflist.comparePos2");
                PositionUtils.setPos(this._textArr[2], "tofflist.valueTextPos2");
            };
            this._textArr[3].x = (this._textArr[3].x - (this._textArr[3].textWidth / 2));
            this._textArr[2].x = (this._textArr[2].x - (this._textArr[2].textWidth / 2));
        }

        private function addEvent():void
        {
            TofflistModel.addEventListener(TofflistEvent.RANKINFO_READY, this.__rankInfoHandler);
            TofflistModel.addEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE, this.__tofflistTypeHandler);
        }

        private function __rankInfoHandler(_arg_1:TofflistEvent):void
        {
            this.__tofflistTypeHandler(null);
        }

        private function consortiaEmpty():void
        {
            this._textArr[0].text = (this._textArr[2].text = LanguageMgr.GetTranslation("tank.tofflist.view.TofflistLeftInfo.no"));
        }

        private function onComPare(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:int;
            this._RankingLiftImg.visible = true;
            if (((!(TofflistModel.Instance.rankInfo == null)) && (_arg_1 < _arg_2)))
            {
                this._RankingLiftImg.setFrame(1);
                _local_3 = (_arg_2 - _arg_1);
                this._textArr[3].text = _local_3;
            };
            if (((!(TofflistModel.Instance.rankInfo == null)) && (_arg_1 > _arg_2)))
            {
                this._RankingLiftImg.setFrame(2);
                _local_3 = (_arg_1 - _arg_2);
                this._textArr[3].text = _local_3;
            };
            if (((!(TofflistModel.Instance.rankInfo == null)) && (_arg_1 == _arg_2)))
            {
                this._RankingLiftImg.visible = false;
                this._textArr[3].text = "";
            };
            this._textArr[3].visible = this._RankingLiftImg.visible;
        }

        private function init():void
        {
            this._textArr = [];
            this._bgI = ComponentFactory.Instance.creatComponentByStylename("asset.tofflist.infobgAssetI");
            addChild(this._bgI);
            this._bg = ClassUtils.CreatInstance("asset.tofflist.infobgAsset");
            PositionUtils.setPos(this._bg, "tofflist.infobgAsset.Pos");
            this._bg.gotoAndStop(2);
            addChild(this._bg);
            this._rankTitle = ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoRankTitleText");
            this._rankTitle.text = LanguageMgr.GetTranslation("repute");
            this._textArr.push(addChild(ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoRankText")));
            this._textArr.push(addChild(ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoLevelText")));
            this._textArr.push(addChild(ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoValueText")));
            this._textArr.push(addChild(ComponentFactory.Instance.creatComponentByStylename("toffilist.leftInfoComPareText")));
            this._updateTimeTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.updateTimeTxt");
            addChild(this._updateTimeTxt);
            this._RankingLiftImg = ComponentFactory.Instance.creatComponentByStylename("toffilist.RankingLift");
            addChild(this._RankingLiftImg);
            this._levelIcon = new LevelIcon();
            this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
            PositionUtils.setPos(this._levelIcon, "tofflist.levelIconPos");
            addChild(this._levelIcon);
            this._levelIcon.visible = false;
            this._RankingLiftImg.visible = false;
        }

        private function removeEvent():void
        {
            TofflistModel.removeEventListener(TofflistEvent.RANKINFO_READY, this.__rankInfoHandler);
            TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE, this.__tofflistTypeHandler);
        }


    }
}//package tofflist.view

