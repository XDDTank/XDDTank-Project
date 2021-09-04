package game.view.settlement
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.character.BaseLayer;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import ddt.view.common.LevelIcon;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Player;
   import road7th.data.DictionaryData;
   import vip.VipController;
   
   public class SettlementViewFightRobot extends MovieClip implements Disposeable
   {
       
      
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
      
      private const TRMAIN_TIME:uint = 25;
      
      private var _remainTimer:Timer;
      
      private var _playerList:Array;
      
      private var _playerInfoList:Array;
      
      public function SettlementViewFightRobot()
      {
         super();
         this.init();
         this.initEvent();
         this._remainTimer = new Timer(1000);
         this._remainTimer.addEventListener(TimerEvent.TIMER,this.__timeUp);
         this._remainTimer.start();
      }
      
      private function init() : void
      {
         SoundManager.instance.play("063");
         this._playerList = new Array();
         this._playerInfoList = new Array();
         this._gameInfo = GameManager.Instance.Current;
         this.initPlayer();
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("fightrobot.rewardGold.pos");
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("fightrobot.rewardMagicSoul.pos");
         this._RewardGold = new SettlementNumber();
         this._RewardGold.type = SettlementNumber.FIGHT_ROBOT;
         this._RewardGold.point = _loc1_;
         this._RewardMagicSoul = new SettlementNumber();
         this._RewardMagicSoul.type = SettlementNumber.FIGHT_ROBOT;
         this._RewardMagicSoul.point = _loc2_;
      }
      
      private function initPlayer() : void
      {
         var _loc1_:int = 0;
         var _loc5_:Player = null;
         var _loc6_:Player = null;
         var _loc7_:Sprite = null;
         var _loc8_:Sprite = null;
         var _loc9_:Sprite = null;
         var _loc10_:Sprite = null;
         var _loc2_:DictionaryData = this._gameInfo.findTeam(this._gameInfo.selfGamePlayer.team);
         var _loc3_:DictionaryData = this._gameInfo.findTeam(3 - this._gameInfo.selfGamePlayer.team);
         var _loc4_:uint = 1;
         for each(_loc5_ in _loc2_)
         {
            if(_loc5_.isSelf)
            {
               _loc7_ = this.createCharacter(PlayerManager.Instance.Self);
               this._playerList[0] = _loc7_;
               this._playerInfoList[0] = PlayerManager.Instance.Self;
            }
            else if(this.checkNeedChange())
            {
               _loc8_ = this.createCharacter(_loc5_.playerInfo);
               if(_loc5_.playerInfo.ID == GameManager.Instance.fightRobotChangePlayerID1 || _loc5_.playerInfo.ID == GameManager.Instance.fightRobotChangePlayerID2)
               {
                  this._playerList[2] = _loc8_;
                  this._playerInfoList[2] = _loc5_.playerInfo;
               }
               else
               {
                  this._playerList[1] = _loc8_;
                  this._playerInfoList[1] = _loc5_.playerInfo;
               }
            }
            else
            {
               _loc9_ = this.createCharacter(_loc5_.playerInfo);
               this._playerList[_loc4_] = _loc9_;
               this._playerInfoList[_loc4_] = _loc5_.playerInfo;
               _loc4_++;
            }
         }
         _loc4_ = 4;
         for each(_loc6_ in _loc3_)
         {
            _loc10_ = this.createCharacter(_loc6_.playerInfo,1);
            if(_loc6_.playerInfo.ID == GameManager.Instance.fightRobotChangePlayerID1 || _loc6_.playerInfo.ID == GameManager.Instance.fightRobotChangePlayerID2)
            {
               this._playerList[3] = _loc10_;
               this._playerInfoList[3] = _loc6_.playerInfo;
            }
            else
            {
               this._playerList[_loc4_] = _loc10_;
               this._playerInfoList[_loc4_] = _loc6_.playerInfo;
               _loc4_++;
            }
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      private function __timeUp(param1:TimerEvent) : void
      {
         SoundManager.instance.play("048");
         if((param1.target as Timer).currentCount == this.TRMAIN_TIME)
         {
            this.leave();
         }
      }
      
      private function __onEnterFrame(param1:Event) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         var _loc5_:FilterFrameText = null;
         var _loc6_:FilterFrameText = null;
         var _loc7_:FilterFrameText = null;
         var _loc8_:Sprite = null;
         var _loc9_:Sprite = null;
         var _loc10_:Sprite = null;
         var _loc11_:FilterFrameText = null;
         var _loc12_:FilterFrameText = null;
         var _loc13_:FilterFrameText = null;
         if(this.currentFrameLabel == "leave")
         {
            this.leaveBtn.buttonMode = true;
            this.leaveBtn.addEventListener(MouseEvent.CLICK,this.__leaveBtnClick);
         }
         else if(this.currentFrameLabel == "left_winlose")
         {
            this.left_winlose.gotoAndStop(this._gameInfo.selfGamePlayer.isWin == true ? 1 : 3);
         }
         else if(this.currentFrameLabel == "right_winlose")
         {
            this.right_winlose.gotoAndStop(this._gameInfo.selfGamePlayer.isWin == true ? 2 : 4);
         }
         else if(this.currentFrameLabel == "leftPerson")
         {
            _loc2_ = this._playerList[0];
            _loc2_.scaleX = _loc2_.scaleY = 1.2;
            PositionUtils.setPos(_loc2_,"fightrobot.person1.pos");
            _loc3_ = this._playerList[1];
            _loc3_.scaleX = _loc3_.scaleY = 0.8;
            PositionUtils.setPos(_loc3_,"fightrobot.person2.pos");
            _loc4_ = this._playerList[2];
            _loc4_.scaleX = _loc4_.scaleY = 0.8;
            PositionUtils.setPos(_loc4_,"fightrobot.person3.pos");
            this.personContent1.personMc1.person1.addChild(_loc2_);
            this.personContent1.personMc2.person2.addChild(_loc3_);
            this.personContent3.personMc3.person3.addChild(_loc4_);
            this.personContent1.personMc1.personName1.addChild(this.createLevelAndName(this._playerInfoList[0]));
            this.personContent1.personMc2.personName2.addChild(this.createLevelAndName(this._playerInfoList[1]));
            this.personContent3.personName3.addChild(this.createLevelAndName(this._playerInfoList[2]));
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower");
            _loc5_.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower",this._playerInfoList[0].FightPower);
            this.personContent1.fightPower1.addChild(_loc5_);
            _loc6_ = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower");
            _loc6_.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower",this._playerInfoList[1].FightPower);
            this.personContent1.fightPower2.addChild(_loc6_);
            _loc7_ = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower");
            _loc7_.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower",this._playerInfoList[2].FightPower);
            this.personContent3.fightPower3.addChild(_loc7_);
         }
         else if(this.currentFrameLabel == "rightPerson")
         {
            _loc8_ = this._playerList[3];
            _loc8_.scaleX = _loc8_.scaleY = 0.8;
            PositionUtils.setPos(_loc8_,"fightrobot.person4.pos");
            _loc9_ = this._playerList[4];
            _loc9_.scaleX = _loc9_.scaleY = 0.6;
            PositionUtils.setPos(_loc9_,"fightrobot.person5.pos");
            _loc10_ = this._playerList[5];
            _loc10_.scaleX = _loc10_.scaleY = 0.6;
            PositionUtils.setPos(_loc10_,"fightrobot.person6.pos");
            this.personContent2.personMc5.person5.addChild(_loc9_);
            this.personContent2.personMc6.person6.addChild(_loc10_);
            this.personContent4.personMc4.addChild(_loc8_);
            this.personContent2.personMc5.personName5.addChild(this.createLevelAndName(this._playerInfoList[4]));
            this.personContent2.personMc6.personName6.addChild(this.createLevelAndName(this._playerInfoList[5]));
            this.personContent4.personNameMc4.personName4.addChild(this.createLevelAndName(this._playerInfoList[3]));
            _loc11_ = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower2");
            _loc11_.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower",this._playerInfoList[4].FightPower);
            this.personContent2.fightPower5.addChild(_loc11_);
            _loc12_ = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower2");
            _loc12_.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower",this._playerInfoList[5].FightPower);
            this.personContent2.fightPower6.addChild(_loc12_);
            _loc13_ = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementFightRobot.fightPower2");
            _loc13_.text = LanguageMgr.GetTranslation("ddt.settlementFightrobot.fightPower",this._playerInfoList[3].FightPower);
            this.personContent4.fightPower4.addChild(_loc13_);
         }
         else if(this.currentFrameLabel == "playRewardGold")
         {
            this._RewardGold.playAndStopNum(this._gameInfo.selfGamePlayer.fightRobotRewardGold);
            this.personContent1.rewardGold.addChild(this._RewardGold);
         }
         else if(this.currentFrameLabel == "playRewardMagicSoul")
         {
            this._RewardMagicSoul.playAndStopNum(this._gameInfo.selfGamePlayer.fightRobotRewardMagicSoul);
            this.personContent1.rewardMagicSoul.addChild(this._RewardMagicSoul);
         }
         else if(this.currentFrameLabel == "stageMask")
         {
            if(!this.checkNeedChange())
            {
               this.stageMask.visible = false;
            }
         }
         else if(this.currentFrameLabel == "fightPowerShine")
         {
            if(!this.checkNeedChange())
            {
               this.fightPowerShineMc.visible = false;
            }
         }
         else if(this.currentFrameLabel == "changePlayer")
         {
            if(this.checkNeedChange())
            {
               this.personContent3.gotoAndPlay(161);
               this.personContent4.gotoAndPlay(158);
            }
         }
         else if(this.currentFrame == this.totalFrames)
         {
            stop();
         }
      }
      
      private function tracePlayer(param1:DictionaryData) : String
      {
         var _loc3_:Player = null;
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc2_ += _loc3_.playerInfo.ID + ",";
         }
         return _loc2_;
      }
      
      private function createLevelAndName(param1:PlayerInfo) : Sprite
      {
         var _loc2_:Sprite = null;
         var _loc4_:FilterFrameText = null;
         var _loc5_:GradientText = null;
         _loc2_ = new Sprite();
         var _loc3_:LevelIcon = new LevelIcon();
         _loc3_.setInfo(param1.Grade,0,0,0,0,0,false,false);
         _loc2_.addChild(_loc3_);
         _loc4_ = ComponentFactory.Instance.creatComponentByStylename("pvp.CharacterItemNameTxt");
         _loc4_.text = param1.NickName;
         _loc4_.x = _loc3_.x + _loc3_.width - 2;
         _loc4_.y = _loc3_.y + 2;
         if(param1.IsVIP)
         {
            _loc5_ = VipController.instance.getVipNameTxt(_loc4_.width,param1.VIPtype);
            _loc5_.x = _loc4_.x;
            _loc5_.y = _loc4_.y;
            _loc5_.text = _loc4_.text;
            _loc2_.addChild(_loc5_);
         }
         else
         {
            _loc2_.addChild(_loc4_);
         }
         return _loc2_;
      }
      
      private function createCharacter(param1:PlayerInfo, param2:int = -1) : Sprite
      {
         var _loc3_:ShowCharacter = CharactoryFactory.createCharacter(param1,CharactoryFactory.SHOW,true) as ShowCharacter;
         _loc3_.showWing = false;
         _loc3_.showGun = false;
         _loc3_.setShowLight(false);
         _loc3_.show(false,param2,false);
         var _loc4_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.WeaponID);
         var _loc5_:String = PathManager.solveGoodsPath(_loc4_,_loc4_.Pic,PlayerManager.Instance.Self.Sex == 1,BaseLayer.SHOW,"A","1",_loc4_.Level);
         var _loc6_:Rectangle = ComponentFactory.Instance.creatCustomObject("settlementViewFightRobot.WeaponSize");
         var _loc7_:BitmapLoaderProxy = new BitmapLoaderProxy(_loc5_,_loc6_);
         _loc7_.scaleX = -1;
         _loc7_.mouseEnabled = false;
         _loc7_.mouseChildren = false;
         if(param2 == -1)
         {
            PositionUtils.setPos(_loc7_,"settlementViewFightRobot.wepon.pos");
         }
         else
         {
            PositionUtils.setPos(_loc7_,"settlementViewFightRobot.wepon2.pos");
         }
         var _loc8_:Sprite = new Sprite();
         _loc8_.addChild(_loc3_);
         _loc8_.addChild(_loc7_);
         return _loc8_;
      }
      
      private function checkNeedChange() : Boolean
      {
         if(GameManager.Instance.fightRobotChangePlayerID1 >= 0 && GameManager.Instance.fightRobotChangePlayerID2 >= 0 && this._gameInfo.selfGamePlayer.isWin)
         {
            return true;
         }
         return false;
      }
      
      private function __leaveBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.leave();
      }
      
      private function leave() : void
      {
         SoundManager.instance.stop("063");
         StateManager.setState(StateType.MAIN);
      }
      
      public function dispose() : void
      {
         GameManager.Instance.fightRobotChangePlayerID1 = -1;
         GameManager.Instance.fightRobotChangePlayerID2 = -1;
         this.removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         if(this.leaveBtn)
         {
            this.leaveBtn.removeEventListener(MouseEvent.CLICK,this.__leaveBtnClick);
         }
         this._remainTimer.removeEventListener(TimerEvent.TIMER,this.__timeUp);
         ObjectUtils.disposeObject(this._remainTimer);
         this._remainTimer = null;
         this._gameInfo = null;
         ObjectUtils.disposeObject(this._RewardGold);
         this._RewardGold = null;
         ObjectUtils.disposeObject(this._RewardMagicSoul);
         this._RewardMagicSoul = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this._playerList.length)
         {
            this._playerList[_loc1_] = null;
            _loc1_++;
         }
         this._playerList = null;
         this._playerInfoList = null;
      }
   }
}
