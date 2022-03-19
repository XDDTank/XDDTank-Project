// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.settlement.SettlementViewFightRobot

package game.view.settlement
{
    import flash.display.MovieClip;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.GameInfo;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import ddt.manager.SoundManager;
    import game.GameManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import game.model.Player;
    import flash.display.Sprite;
    import road7th.data.DictionaryData;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.events.MouseEvent;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.text.GradientText;
    import ddt.view.common.LevelIcon;
    import vip.VipController;
    import ddt.data.player.PlayerInfo;
    import ddt.view.character.CharactoryFactory;
    import ddt.view.character.ShowCharacter;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;
    import ddt.view.character.BaseLayer;
    import flash.geom.Rectangle;
    import ddt.display.BitmapLoaderProxy;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.utils.ObjectUtils;

    public class SettlementViewFightRobot extends MovieClip implements Disposeable 
    {

        private const TRMAIN_TIME:uint = 25;

        private var _gameInfo:GameInfo;
        private var _RewardGold:SettlementNumber;
        private var _RewardMagicSoul:SettlementNumber;
        public var leaveBtn:MovieClip;
        public var left_winlose:MovieClip;
        public var right_winlose:MovieClip;
        public var personContent1:MovieClip;
        public var personContent2:MovieClip;
        public var personContent3:MovieClip;
        public var personContent4:MovieClip;
        public var fightPowerShineMc:MovieClip;
        public var stageMask:MovieClip;
        private var _remainTimer:Timer;
        private var _playerList:Array;
        private var _playerInfoList:Array;

        public function SettlementViewFightRobot()
        {
            this.init();
            this.initEvent();
            this._remainTimer = new Timer(1000);
            this._remainTimer.addEventListener(TimerEvent.TIMER, this.__timeUp);
            this._remainTimer.start();
        }

        private function init():void
        {
            SoundManager.instance.play("063");
            this._playerList = new Array();
            this._playerInfoList = new Array();
            this._gameInfo = GameManager.Instance.Current;
            this.initPlayer();
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("fightrobot.rewardGold.pos");
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("fightrobot.rewardMagicSoul.pos");
            this._RewardGold = new SettlementNumber();
            this._RewardGold.type = SettlementNumber.FIGHT_ROBOT;
            this._RewardGold.point = _local_1;
            this._RewardMagicSoul = new SettlementNumber();
            this._RewardMagicSoul.type = SettlementNumber.FIGHT_ROBOT;
            this._RewardMagicSoul.point = _local_2;
        }

        private function initPlayer():void
        {
            var _local_1:int;
            var _local_5:Player;
            var _local_6:Player;
            var _local_7:Sprite;
            var _local_8:Sprite;
            var _local_9:Sprite;
            var _local_10:Sprite;
            var _local_2:DictionaryData = this._gameInfo.findTeam(this._gameInfo.selfGamePlayer.team);
            var _local_3:DictionaryData = this._gameInfo.findTeam((3 - this._gameInfo.selfGamePlayer.team));
            var _local_4:uint = 1;
            for each (_local_5 in _local_2)
            {
                if (_local_5.isSelf)
                {
                    _local_7 = this.createCharacter(PlayerManager.Instance.Self);
                    this._playerList[0] = _local_7;
                    this._playerInfoList[0] = PlayerManager.Instance.Self;
                }
                else
                {
                    if (this.checkNeedChange())
                    {
                        _local_8 = this.createCharacter(_local_5.playerInfo);
                        if (((_local_5.playerInfo.ID == GameManager.Instance.fightRobotChangePlayerID1) || (_local_5.playerInfo.ID == GameManager.Instance.fightRobotChangePlayerID2)))
                        {
                            this._playerList[2] = _local_8;
                            this._playerInfoList[2] = _local_5.playerInfo;
                        }
                        else
                        {
                            this._playerList[1] = _local_8;
                            this._playerInfoList[1] = _local_5.playerInfo;
                        };
                    }
                    else
                    {
                        _local_9 = this.createCharacter(_local_5.playerInfo);
                        this._playerList[_local_4] = _local_9;
                        this._playerInfoList[_local_4] = _local_5.playerInfo;
                        _local_4++;
                    };
                };
            };
            _local_4 = 4;
            for each (_local_6 in _local_3)
            {
                _local_10 = this.createCharacter(_local_6.playerInfo, 1);
                if (((_local_6.playerInfo.ID == GameManager.Instance.fightRobotChangePlayerID1) || (_local_6.playerInfo.ID == GameManager.Instance.fightRobotChangePlayerID2)))
                {
                    this._playerList[3] = _local_10;
                    this._playerInfoList[3] = _local_6.playerInfo;
                }
                else
                {
                    this._playerList[_local_4] = _local_10;
                    this._playerInfoList[_local_4] = _local_6.playerInfo;
                    _local_4++;
                };
            };
        }

        private function initEvent():void
        {
            this.addEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
        }

        private function __timeUp(_arg_1:TimerEvent):void
        {
            SoundManager.instance.play("048");
            if ((_arg_1.target as Timer).currentCount == this.TRMAIN_TIME)
            {
                this.leave();
            };
        }

        private function __onEnterFrame(_arg_1:Event):void
        {
            var _local_2:Sprite;
            var _local_3:Sprite;
            var _local_4:Sprite;
            var _local_5:FilterFrameText;
            var _local_6:FilterFrameText;
            var _local_7:FilterFrameText;
            var _local_8:Sprite;
            var _local_9:Sprite;
            var _local_10:Sprite;
            var _local_11:FilterFrameText;
            var _local_12:FilterFrameText;
            var _local_13:FilterFrameText;
            if (this.currentFrameLabel == "leave")
            {
                this.leaveBtn.buttonMode = true;
                this.leaveBtn.addEventListener(MouseEvent.CLICK, this.__leaveBtnClick);
            }
            else
            {
                if (this.currentFrameLabel == "left_winlose")
                {
                    this.left_winlose.gotoAndStop(((this._gameInfo.selfGamePlayer.isWin == true) ? 1 : 3));
                }
                else
                {
                    if (this.currentFrameLabel == "right_winlose")
                    {
                        this.right_winlose.gotoAndStop(((this._gameInfo.selfGamePlayer.isWin == true) ? 2 : 4));
                    }
                    else
                    {
                        if (this.currentFrameLabel == "leftPerson")
                        {
                            _local_2 = this._playerList[0];
                            _local_2.scaleX = (_local_2.scaleY = 1.2);
                            PositionUtils.setPos(_local_2, "fightrobot.person1.pos");
                            _local_3 = this._playerList[1];
                            _local_3.scaleX = (_local_3.scaleY = 0.8);
                            PositionUtils.setPos(_local_3, "fightrobot.person2.pos");
                            _local_4 = this._playerList[2];
                            _local_4.scaleX = (_local_4.scaleY = 0.8);
                            PositionUtils.setPos(_local_4, "fightrobot.person3.pos");
                            this.personContent1.personMc1.person1.addChild(_local_2);
                            this.personContent1.personMc2.person2.addChild(_local_3);
                            this.personContent3.personMc3.person3.addChild(_local_4);
                            this.personContent1.personMc1.personName1.addChild(this.createLevelAndName(this._playerInfoList[0]));
                            this.personContent1.personMc2.personName2.addChild(this.createLevelAndName(this._playerInfoList[1]));
                            this.personContent3.personName3.addChild(this.createLevelAndName(this._playerInfoList[2]));
                            _local_5 = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower");
                            _local_5.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower", this._playerInfoList[0].FightPower);
                            this.personContent1.fightPower1.addChild(_local_5);
                            _local_6 = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower");
                            _local_6.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower", this._playerInfoList[1].FightPower);
                            this.personContent1.fightPower2.addChild(_local_6);
                            _local_7 = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower");
                            _local_7.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower", this._playerInfoList[2].FightPower);
                            this.personContent3.fightPower3.addChild(_local_7);
                        }
                        else
                        {
                            if (this.currentFrameLabel == "rightPerson")
                            {
                                _local_8 = this._playerList[3];
                                _local_8.scaleX = (_local_8.scaleY = 0.8);
                                PositionUtils.setPos(_local_8, "fightrobot.person4.pos");
                                _local_9 = this._playerList[4];
                                _local_9.scaleX = (_local_9.scaleY = 0.6);
                                PositionUtils.setPos(_local_9, "fightrobot.person5.pos");
                                _local_10 = this._playerList[5];
                                _local_10.scaleX = (_local_10.scaleY = 0.6);
                                PositionUtils.setPos(_local_10, "fightrobot.person6.pos");
                                this.personContent2.personMc5.person5.addChild(_local_9);
                                this.personContent2.personMc6.person6.addChild(_local_10);
                                this.personContent4.personMc4.addChild(_local_8);
                                this.personContent2.personMc5.personName5.addChild(this.createLevelAndName(this._playerInfoList[4]));
                                this.personContent2.personMc6.personName6.addChild(this.createLevelAndName(this._playerInfoList[5]));
                                this.personContent4.personNameMc4.personName4.addChild(this.createLevelAndName(this._playerInfoList[3]));
                                _local_11 = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower2");
                                _local_11.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower", this._playerInfoList[4].FightPower);
                                this.personContent2.fightPower5.addChild(_local_11);
                                _local_12 = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower2");
                                _local_12.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower", this._playerInfoList[5].FightPower);
                                this.personContent2.fightPower6.addChild(_local_12);
                                _local_13 = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower2");
                                _local_13.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower", this._playerInfoList[3].FightPower);
                                this.personContent4.fightPower4.addChild(_local_13);
                            }
                            else
                            {
                                if (this.currentFrameLabel == "playRewardGold")
                                {
                                    this._RewardGold.playAndStopNum(this._gameInfo.selfGamePlayer.fightRobotRewardGold);
                                    this.personContent1.rewardGold.addChild(this._RewardGold);
                                }
                                else
                                {
                                    if (this.currentFrameLabel == "playRewardMagicSoul")
                                    {
                                        this._RewardMagicSoul.playAndStopNum(this._gameInfo.selfGamePlayer.fightRobotRewardMagicSoul);
                                        this.personContent1.rewardMagicSoul.addChild(this._RewardMagicSoul);
                                    }
                                    else
                                    {
                                        if (this.currentFrameLabel == "stageMask")
                                        {
                                            if ((!(this.checkNeedChange())))
                                            {
                                                this.stageMask.visible = false;
                                            };
                                        }
                                        else
                                        {
                                            if (this.currentFrameLabel == "fightPowerShine")
                                            {
                                                if ((!(this.checkNeedChange())))
                                                {
                                                    this.fightPowerShineMc.visible = false;
                                                };
                                            }
                                            else
                                            {
                                                if (this.currentFrameLabel == "changePlayer")
                                                {
                                                    if (this.checkNeedChange())
                                                    {
                                                        this.personContent3.gotoAndPlay(161);
                                                        this.personContent4.gotoAndPlay(158);
                                                    };
                                                }
                                                else
                                                {
                                                    if (this.currentFrame == this.totalFrames)
                                                    {
                                                        stop();
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function tracePlayer(_arg_1:DictionaryData):String
        {
            var _local_3:Player;
            var _local_2:String = "";
            for each (_local_3 in _arg_1)
            {
                _local_2 = (_local_2 + (_local_3.playerInfo.ID + ","));
            };
            return (_local_2);
        }

        private function createLevelAndName(_arg_1:PlayerInfo):Sprite
        {
            var _local_2:Sprite;
            var _local_4:FilterFrameText;
            var _local_5:GradientText;
            _local_2 = new Sprite();
            var _local_3:LevelIcon = new LevelIcon();
            _local_3.setInfo(_arg_1.Grade, 0, 0, 0, 0, 0, false, false);
            _local_2.addChild(_local_3);
            _local_4 = ComponentFactory.Instance.creatComponentByStylename("pvp.CharacterItemNameTxt");
            _local_4.text = _arg_1.NickName;
            _local_4.x = ((_local_3.x + _local_3.width) - 2);
            _local_4.y = (_local_3.y + 2);
            if (_arg_1.IsVIP)
            {
                _local_5 = VipController.instance.getVipNameTxt(_local_4.width, _arg_1.VIPtype);
                _local_5.x = _local_4.x;
                _local_5.y = _local_4.y;
                _local_5.text = _local_4.text;
                _local_2.addChild(_local_5);
            }
            else
            {
                _local_2.addChild(_local_4);
            };
            return (_local_2);
        }

        private function createCharacter(_arg_1:PlayerInfo, _arg_2:int=-1):Sprite
        {
            var _local_3:ShowCharacter = (CharactoryFactory.createCharacter(_arg_1, CharactoryFactory.SHOW, true) as ShowCharacter);
            _local_3.showWing = false;
            _local_3.showGun = false;
            _local_3.setShowLight(false);
            _local_3.show(false, _arg_2, false);
            var _local_4:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_arg_1.WeaponID);
            var _local_5:String = PathManager.solveGoodsPath(_local_4, _local_4.Pic, (PlayerManager.Instance.Self.Sex == 1), BaseLayer.SHOW, "A", "1", _local_4.Level);
            var _local_6:Rectangle = ComponentFactory.Instance.creatCustomObject("settlementViewFightRobot.WeaponSize");
            var _local_7:BitmapLoaderProxy = new BitmapLoaderProxy(_local_5, _local_6);
            _local_7.scaleX = -1;
            _local_7.mouseEnabled = false;
            _local_7.mouseChildren = false;
            if (_arg_2 == -1)
            {
                PositionUtils.setPos(_local_7, "settlementViewFightRobot.wepon.pos");
            }
            else
            {
                PositionUtils.setPos(_local_7, "settlementViewFightRobot.wepon2.pos");
            };
            var _local_8:Sprite = new Sprite();
            _local_8.addChild(_local_3);
            _local_8.addChild(_local_7);
            return (_local_8);
        }

        private function checkNeedChange():Boolean
        {
            if ((((GameManager.Instance.fightRobotChangePlayerID1 >= 0) && (GameManager.Instance.fightRobotChangePlayerID2 >= 0)) && (this._gameInfo.selfGamePlayer.isWin)))
            {
                return (true);
            };
            return (false);
        }

        private function __leaveBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.leave();
        }

        private function leave():void
        {
            SoundManager.instance.stop("063");
            StateManager.setState(StateType.MAIN);
        }

        public function dispose():void
        {
            GameManager.Instance.fightRobotChangePlayerID1 = -1;
            GameManager.Instance.fightRobotChangePlayerID2 = -1;
            this.removeEventListener(Event.ENTER_FRAME, this.__onEnterFrame);
            if (this.leaveBtn)
            {
                this.leaveBtn.removeEventListener(MouseEvent.CLICK, this.__leaveBtnClick);
            };
            this._remainTimer.removeEventListener(TimerEvent.TIMER, this.__timeUp);
            ObjectUtils.disposeObject(this._remainTimer);
            this._remainTimer = null;
            this._gameInfo = null;
            ObjectUtils.disposeObject(this._RewardGold);
            this._RewardGold = null;
            ObjectUtils.disposeObject(this._RewardMagicSoul);
            this._RewardMagicSoul = null;
            var _local_1:uint;
            while (_local_1 < this._playerList.length)
            {
                this._playerList[_local_1] = null;
                _local_1++;
            };
            this._playerList = null;
            this._playerInfoList = null;
        }


    }
}//package game.view.settlement

