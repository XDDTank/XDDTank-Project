// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.view.TofflistLeftCurrentCharcter

package tofflist.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.display.MovieClip;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.player.PlayerInfo;
    import ddt.view.common.LevelIcon;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.view.character.ICharacter;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.utils.ObjectUtils;
    import tofflist.TofflistModel;
    import ddt.manager.SoundManager;
    import bagAndInfo.info.PlayerInfoViewControl;
    import flash.events.Event;
    import ddt.manager.SocketManager;
    import tofflist.TofflistEvent;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.character.CharactoryFactory;
    import ddt.utils.PositionUtils;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.DisplayUtils;
    import vip.VipController;
    import consortion.data.ConsortiaApplyInfo;
    import __AS3__.vec.Vector;

    public class TofflistLeftCurrentCharcter extends Sprite implements Disposeable 
    {

        private var _AchievementImg:Bitmap;
        private var _EXPImg:MutipleImage;
        private var _MilitaryBmp:MutipleImage;
        private var _LnTAImg:Bitmap;
        private var _NO1Mc:MovieClip;
        private var _chairmanNameTxt:FilterFrameText;
        private var _chairmanNameTxt2:FilterFrameText;
        private var _consortiaName:FilterFrameText;
        private var _exploitImg:Bitmap;
        private var _fightingImg:MutipleImage;
        private var _ArenaImage:MutipleImage;
        private var _guildImg:MutipleImage;
        private var _info:PlayerInfo;
        private var _levelIcon:LevelIcon;
        private var _lookEquip_btn:TextButton;
        private var _applyJoinBtn:TextButton;
        private var _nameTxt:FilterFrameText;
        private var _player:ICharacter;
        private var _rankNumber:Sprite;
        private var _text1:FilterFrameText;
        private var _textBg:Scale9CornerImage;
        private var _wealthImg:Bitmap;
        private var _vipName:GradientText;
        private var _chairmanVipName:GradientText;
        private var _scoreImg:Bitmap;
        private var _charmvalueImg:Bitmap;

        public function TofflistLeftCurrentCharcter()
        {
            this.init();
            this.addEvent();
        }

        public function dispose():void
        {
            if (this._player)
            {
                this._player.dispose();
            };
            this._player = null;
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._AchievementImg = null;
            this._EXPImg = null;
            this._MilitaryBmp = null;
            this._LnTAImg = null;
            this._NO1Mc = null;
            this._chairmanNameTxt2 = null;
            this._exploitImg = null;
            this._fightingImg = null;
            this._ArenaImage = null;
            this._guildImg = null;
            this._levelIcon = null;
            this._lookEquip_btn = null;
            this._applyJoinBtn = null;
            this._nameTxt = null;
            this._rankNumber = null;
            this._text1 = null;
            this._textBg = null;
            this._wealthImg = null;
            this._vipName = null;
            this._chairmanVipName = null;
            this._charmvalueImg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function NO1Effect():void
        {
            if (TofflistModel.currentIndex == 1)
            {
                this._NO1Mc.visible = true;
                this._NO1Mc.gotoAndPlay(1);
            }
            else
            {
                this._NO1Mc.visible = false;
                this._NO1Mc.gotoAndStop(1);
            };
        }

        private function __lookBtnClick(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            if ((((TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL) || (TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA)) && (this._info)))
            {
                PlayerInfoViewControl.viewByID(this._info.ID);
            };
        }

        private function __upCurrentPlayerHandler(_arg_1:TofflistEvent):void
        {
            this._info = TofflistModel.currentPlayerInfo;
            if (this._info)
            {
                SocketManager.Instance.out.sendItemEquip(this._info.ID);
            };
            this.upView();
        }

        private function addEvent():void
        {
            TofflistModel.addEventListener(TofflistEvent.TOFFLIST_CURRENT_PLAYER, this.__upCurrentPlayerHandler);
            this._lookEquip_btn.addEventListener(MouseEvent.CLICK, this.__lookBtnClick);
            this._applyJoinBtn.addEventListener(MouseEvent.CLICK, this.onApplyJoinClubBtnClick);
        }

        private function onApplyJoinClubBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (TofflistModel.currentConsortiaInfo)
            {
                if (PlayerManager.Instance.Self.Grade < 7)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.notInvite"));
                    return;
                };
                if ((!(TofflistModel.currentConsortiaInfo.OpenApply)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.applyJoinClickHandler"));
                    return;
                };
                this._applyJoinBtn.enable = false;
                SocketManager.Instance.out.sendConsortiaTryIn(TofflistModel.currentConsortiaInfo.ConsortiaID);
            };
        }

        private function getRank(_arg_1:int):void
        {
            var _local_2:Bitmap;
            var _local_6:Point;
            if ((!(this._rankNumber)))
            {
                this._rankNumber = new Sprite();
            };
            while (this._rankNumber.numChildren != 0)
            {
                this._rankNumber.removeChildAt(0);
            };
            var _local_3:String = _arg_1.toString();
            var _local_4:int = _local_3.length;
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_2 = this.getRankBitmap(int(_local_3.substr(_local_5, 1)));
                _local_2.x = (_local_5 * 30);
                this._rankNumber.addChild(_local_2);
                _local_5++;
            };
            switch (_arg_1)
            {
                case 1:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankSt");
                    _local_2.x = 25;
                    _local_2.y = 8;
                    this._rankNumber.addChild(_local_2);
                    break;
                case 2:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNd");
                    _local_2.x = 34;
                    _local_2.y = 8;
                    this._rankNumber.addChild(_local_2);
                    break;
                case 3:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankRd");
                    _local_2.x = 30;
                    _local_2.y = 8;
                    this._rankNumber.addChild(_local_2);
                    break;
                default:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankTh");
                    _local_2.x = (_local_4 * 30);
                    _local_2.y = 8;
                    this._rankNumber.addChild(_local_2);
            };
            addChild(this._rankNumber);
            _local_6 = ComponentFactory.Instance.creat("tofflist.rankPos");
            this._rankNumber.x = _local_6.x;
            this._rankNumber.y = _local_6.y;
        }

        private function getRankBitmap(_arg_1:int):Bitmap
        {
            var _local_2:Bitmap;
            switch (_arg_1)
            {
                case 0:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum0");
                    break;
                case 1:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum1");
                    break;
                case 2:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum2");
                    break;
                case 3:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum3");
                    break;
                case 4:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum4");
                    break;
                case 5:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum5");
                    break;
                case 6:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum6");
                    break;
                case 7:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum7");
                    break;
                case 8:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum8");
                    break;
                case 9:
                    _local_2 = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum9");
                    break;
            };
            return (_local_2);
        }

        private function init():void
        {
            this._textBg = ComponentFactory.Instance.creatComponentByStylename("toffilist.textBg");
            addChild(this._textBg);
            this._fightingImg = ComponentFactory.Instance.creatComponentByStylename("asset.Toffilist.fightingImgAsset1_1");
            addChild(this._fightingImg);
            this._ArenaImage = ComponentFactory.Instance.creatComponentByStylename("asset.Toffilist.arenaImgAsset1_1");
            addChild(this._ArenaImage);
            this._exploitImg = ComponentFactory.Instance.creat("asset.Toffilist.exploitImgAsset1_1");
            addChild(this._exploitImg);
            this._EXPImg = ComponentFactory.Instance.creat("asset.Toffilist.EXPImgAsset1_1");
            addChild(this._EXPImg);
            this._MilitaryBmp = ComponentFactory.Instance.creat("asset.Toffilist.MilitaryImgAsset1_1");
            addChild(this._MilitaryBmp);
            this._wealthImg = ComponentFactory.Instance.creat("asset.Toffilist.wealthImgAsset1_1");
            addChild(this._wealthImg);
            this._LnTAImg = ComponentFactory.Instance.creat("asset.Toffilist.LnTAImgAsset1_1");
            addChild(this._LnTAImg);
            this._AchievementImg = ComponentFactory.Instance.creat("asset.Toffilist.AchievementImgAsset1_1");
            addChild(this._AchievementImg);
            this._charmvalueImg = ComponentFactory.Instance.creat("asset.Toffilist.charmvalueImgAsset1_1");
            addChild(this._charmvalueImg);
            this._guildImg = ComponentFactory.Instance.creatComponentByStylename("asset.Toffilist.guildImgAsset");
            addChild(this._guildImg);
            this._scoreImg = ComponentFactory.Instance.creatBitmap("asset.Toffilist.scoreAsset1");
            addChild(this._scoreImg);
            this._text1 = ComponentFactory.Instance.creatComponentByStylename("toffilist.text1");
            addChild(this._text1);
            this._consortiaName = ComponentFactory.Instance.creatComponentByStylename("toffilist.consortiaName");
            addChild(this._consortiaName);
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.nameTxt");
            this._chairmanNameTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.chairmanNameTxt");
            addChild(this._chairmanNameTxt);
            this._chairmanNameTxt2 = ComponentFactory.Instance.creatComponentByStylename("toffilist.chairmanNameTxt2");
            this._lookEquip_btn = ComponentFactory.Instance.creatComponentByStylename("toffilist.lookEquip_btn");
            this._lookEquip_btn.text = LanguageMgr.GetTranslation("civil.leftview.equipName");
            addChild(this._lookEquip_btn);
            this._applyJoinBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.applyJoinClub_btn");
            this._applyJoinBtn.text = LanguageMgr.GetTranslation("tofflist.joinconsortia");
            addChild(this._applyJoinBtn);
            this._applyJoinBtn.visible = false;
            this._NO1Mc = ComponentFactory.Instance.creat("asset.NO1McAsset");
            this._NO1Mc.gotoAndStop(1);
            this._NO1Mc.x = 24;
            this._NO1Mc.y = 64;
            this._NO1Mc.visible = false;
            addChild(this._NO1Mc);
        }

        private function refreshCharater():void
        {
            if (this._player)
            {
                this._player.dispose();
                this._player = null;
            };
            if (this._info)
            {
                this._player = CharactoryFactory.createCharacter(this._info, "room");
                this._player.show(false, -1);
                this._player.showGun = false;
                this._player.setShowLight(true);
                PositionUtils.setPos(this._player, "tofflist.playerPos");
                addChild((this._player as DisplayObject));
            };
        }

        private function removeEvent():void
        {
            TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_CURRENT_PLAYER, this.__upCurrentPlayerHandler);
            this._lookEquip_btn.removeEventListener(MouseEvent.CLICK, this.__lookBtnClick);
            this._applyJoinBtn.removeEventListener(MouseEvent.CLICK, this.onApplyJoinClubBtnClick);
        }

        private function upLevelIcon():void
        {
            if (this._levelIcon)
            {
                ObjectUtils.disposeObject(this._levelIcon);
                this._levelIcon = null;
            };
            if (this._info)
            {
                this._levelIcon = new LevelIcon();
                this._levelIcon.setInfo(this._info.Grade, this._info.Repute, this._info.WinCount, this._info.TotalCount, this._info.FightPower, this._info.Offer, true, false);
                addChild(this._levelIcon);
            };
        }

        private function upStyle():void
        {
            this._text1.text = "";
            this._consortiaName.text = "";
            this._nameTxt.text = "";
            this._chairmanNameTxt.text = "";
            this._chairmanNameTxt2.text = "";
            DisplayUtils.removeDisplay(this._vipName);
            DisplayUtils.removeDisplay(this._chairmanVipName);
            if ((!(this._info)))
            {
                if (this._rankNumber)
                {
                    ObjectUtils.disposeObject(this._rankNumber);
                    this._rankNumber = null;
                };
                if (this._levelIcon)
                {
                    ObjectUtils.disposeObject(this._levelIcon);
                    this._levelIcon = null;
                };
                return;
            };
            if (((TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL) || (TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)))
            {
                this.upLevelIcon();
                this._nameTxt.text = this._info.NickName;
                this._nameTxt.x = ((500 - this._nameTxt.textWidth) / 2);
                if (this._info.IsVIP)
                {
                    if (this._vipName)
                    {
                        ObjectUtils.disposeObject(this._vipName);
                    };
                    this._vipName = VipController.instance.getVipNameTxt((390 - this._nameTxt.x), this._info.VIPtype);
                    this._vipName.textSize = 18;
                    this._vipName.x = this._nameTxt.x;
                    this._vipName.y = this._nameTxt.y;
                    this._vipName.text = this._nameTxt.text;
                    addChild(this._vipName);
                    DisplayUtils.removeDisplay(this._nameTxt);
                    addChild(this._applyJoinBtn);
                }
                else
                {
                    addChild(this._nameTxt);
                    DisplayUtils.removeDisplay(this._vipName);
                };
                this._levelIcon.x = (this._nameTxt.x - (this._levelIcon.width + 5));
                this._levelIcon.y = (this._nameTxt.y - 5);
            }
            else
            {
                if (this._levelIcon)
                {
                    this._levelIcon.visible = false;
                };
                this._chairmanNameTxt.text = LanguageMgr.GetTranslation("tank.tofflist.view.TofflistLeftCurrentCharcter.cdr");
                this._chairmanNameTxt2.text = this._info.NickName;
                this._chairmanNameTxt2.x = ((500 - this._chairmanNameTxt2.textWidth) / 2);
                this._chairmanNameTxt.x = (this._chairmanNameTxt2.x - (this._chairmanNameTxt.textWidth + 5));
                if (this._info.IsVIP)
                {
                    if (this._chairmanVipName)
                    {
                        ObjectUtils.disposeObject(this._chairmanVipName);
                    };
                    this._chairmanVipName = VipController.instance.getVipNameTxt(165, this._info.VIPtype);
                    this._chairmanVipName.textSize = 18;
                    this._chairmanVipName.x = this._chairmanNameTxt2.x;
                    this._chairmanVipName.y = this._chairmanNameTxt2.y;
                    this._chairmanVipName.text = this._chairmanNameTxt2.text;
                    addChild(this._chairmanVipName);
                    DisplayUtils.removeDisplay(this._chairmanNameTxt2);
                    addChild(this._applyJoinBtn);
                }
                else
                {
                    addChild(this._chairmanNameTxt2);
                    DisplayUtils.removeDisplay(this._chairmanVipName);
                };
            };
            this._text1.text = String(TofflistModel.currentText);
            this._consortiaName.text = String(TofflistModel.currentPlayerInfo.ConsortiaName);
            this.getRank(TofflistModel.currentIndex);
        }

        private function upView():void
        {
            this._fightingImg.visible = false;
            this._ArenaImage.visible = false;
            this._AchievementImg.visible = false;
            this._LnTAImg.visible = false;
            this._wealthImg.visible = false;
            this._EXPImg.visible = false;
            this._MilitaryBmp.visible = false;
            this._exploitImg.visible = false;
            this._charmvalueImg.visible = false;
            this._scoreImg.visible = false;
            this.refreshCharater();
            this.upStyle();
            this.NO1Effect();
            if (((this._info) && ((TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL) || (TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA))))
            {
                this._lookEquip_btn.enable = true;
            }
            else
            {
                this._lookEquip_btn.enable = false;
            };
            this.refreshApplyJoinClubBtn();
            switch (TofflistModel.firstMenuType)
            {
                case TofflistStairMenu.PERSONAL:
                case TofflistStairMenu.CROSS_SERVER_PERSONAL:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._fightingImg.visible = true;
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._EXPImg.visible = true;
                            break;
                        case TofflistTwoGradeMenu.GESTE:
                            this._exploitImg.visible = true;
                            break;
                        case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                            this._AchievementImg.visible = true;
                            break;
                        case TofflistTwoGradeMenu.MATCHES:
                            this._scoreImg.visible = true;
                            break;
                        case TofflistTwoGradeMenu.MILITARY:
                            this._MilitaryBmp.visible = true;
                            break;
                        case TofflistTwoGradeMenu.ARENA:
                            this._ArenaImage.visible = true;
                    };
                    return;
                case TofflistStairMenu.CONSORTIA:
                case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
                    switch (TofflistModel.secondMenuType)
                    {
                        case TofflistTwoGradeMenu.BATTLE:
                            this._fightingImg.visible = true;
                            break;
                        case TofflistTwoGradeMenu.LEVEL:
                            this._EXPImg.visible = true;
                            break;
                        case TofflistTwoGradeMenu.ASSETS:
                            this._LnTAImg.visible = true;
                            break;
                        case TofflistTwoGradeMenu.GESTE:
                            this._exploitImg.visible = true;
                            break;
                        case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                            this._AchievementImg.visible = true;
                            break;
                    };
                    return;
            };
        }

        private function refreshApplyJoinClubBtn():void
        {
            var _local_1:int;
            if (TofflistModel.currentConsortiaInfo)
            {
                _local_1 = TofflistModel.currentConsortiaInfo.ConsortiaID;
            };
            if ((((this._info) && (TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA)) && (PlayerManager.Instance.Self.ConsortiaID == 0)))
            {
                this._applyJoinBtn.visible = true;
            }
            else
            {
                this._applyJoinBtn.visible = false;
            };
            if (((_local_1 == 0) || (!(this.hasApplyJoinClub(_local_1)))))
            {
                this._applyJoinBtn.enable = true;
            }
            else
            {
                this._applyJoinBtn.enable = false;
            };
        }

        private function hasApplyJoinClub(_arg_1:int=0):Boolean
        {
            var _local_3:ConsortiaApplyInfo;
            var _local_4:int;
            var _local_2:Vector.<ConsortiaApplyInfo> = TofflistModel.Instance.myConsortiaAuditingApplyData;
            if (_local_2)
            {
                _local_4 = 0;
                while (_local_4 < _local_2.length)
                {
                    _local_3 = _local_2[_local_4];
                    if (_local_3.ConsortiaID == _arg_1)
                    {
                        return (true);
                    };
                    _local_4++;
                };
            };
            return (false);
        }


    }
}//package tofflist.view

