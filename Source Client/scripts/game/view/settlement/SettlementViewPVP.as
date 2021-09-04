package game.view.settlement
{
   import arena.ArenaManager;
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Player;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   import vip.VipController;
   
   public class SettlementViewPVP extends MovieClip implements Disposeable
   {
       
      
      private var _roomInfo:RoomInfo;
      
      private var _gameInfo:GameInfo;
      
      public var totalExp:MovieClip;
      
      public var totalMilitary:MovieClip;
      
      public var totalExploit:MovieClip;
      
      private var _pvpNumTotalExp:SettlementNumber;
      
      private var _pvpNumTotalMili:SettlementNumber;
      
      private var _pvpNumTotalExploit:SettlementNumber;
      
      public var addorReleaseLight:MovieClip;
      
      public var explotReleaseLight:MovieClip;
      
      public var leaveBtn:MovieClip;
      
      public var left_winlose:MovieClip;
      
      public var right_winlose:MovieClip;
      
      public var win_character:MovieClip;
      
      public var lose_character:MovieClip;
      
      private var _leftcharacter:ShowCharacter;
      
      private var _rightcharacter:ShowCharacter;
      
      public var lose_info:MovieClip;
      
      public var win_info:MovieClip;
      
      public var fight_left:MovieClip;
      
      public var fight_right:MovieClip;
      
      private var _numFightLeft:SettlementNumber;
      
      private var _numFightRight:SettlementNumber;
      
      public var damage_left:MovieClip;
      
      public var armor_left:MovieClip;
      
      public var agility_left:MovieClip;
      
      public var lucy_left:MovieClip;
      
      public var hp_left:MovieClip;
      
      private var _nameDamageLeft:PropertyName;
      
      private var _nameArmorLeft:PropertyName;
      
      private var _nameAgilityLeft:PropertyName;
      
      private var _nameLucyLeft:PropertyName;
      
      private var _nameHpLeft:PropertyName;
      
      public var damage_right:MovieClip;
      
      public var armor_right:MovieClip;
      
      public var agility_right:MovieClip;
      
      public var lucy_right:MovieClip;
      
      public var hp_right:MovieClip;
      
      private var _nameDamageRight:PropertyName;
      
      private var _nameArmorRight:PropertyName;
      
      private var _nameAgilityRight:PropertyName;
      
      private var _nameLucyRight:PropertyName;
      
      private var _nameHpRight:PropertyName;
      
      private var _numDamageLeft:SettlementNumber;
      
      private var _numArmorLeft:SettlementNumber;
      
      private var _numAgilityLeft:SettlementNumber;
      
      private var _numLucyLeft:SettlementNumber;
      
      private var _numHpLeft:SettlementNumber;
      
      private var _numDamageRight:SettlementNumber;
      
      private var _numArmorRight:SettlementNumber;
      
      private var _numAgilityRight:SettlementNumber;
      
      private var _numLucyRight:SettlementNumber;
      
      private var _numHpRight:SettlementNumber;
      
      private var _leftObj:Object;
      
      private var _rightObj:Object;
      
      public var appraise:MovieClip;
      
      private var _appraiseTxt:FilterFrameText;
      
      private var _appraiseArr:Array;
      
      private var _noPlayer:Boolean = false;
      
      private var _otherPlayer:PlayerInfo;
      
      private var _expObjec:Object;
      
      private var _pos1:Point;
      
      private var _pos2:Point;
      
      private var _pos3:Point;
      
      private var _outLine:Bitmap;
      
      private var _countDown:uint;
      
      private var _remainTime:int = 25;
      
      public function SettlementViewPVP()
      {
         super();
         this.init();
         this.initEvent();
         this._countDown = setInterval(this.countDownBySec,1000);
      }
      
      private function init() : void
      {
         SoundManager.instance.play("063");
         this._roomInfo = RoomManager.Instance.current;
         this._gameInfo = GameManager.Instance.Current;
         if(this._roomInfo.selfRoomPlayer.isViewer)
         {
            this.leave();
            return;
         }
         this._appraiseArr = new Array();
         this._pos1 = ComponentFactory.Instance.creatCustomObject("settlementViewPVP.pos1");
         this._pos2 = ComponentFactory.Instance.creatCustomObject("settlementViewPVP.pos2");
         this._pos3 = ComponentFactory.Instance.creatCustomObject("settlementViewPVP.pos3");
         this.initPlayer();
         this._expObjec = this._gameInfo.selfGamePlayer.expObj;
         this._pvpNumTotalExp = new SettlementNumber();
         this._pvpNumTotalExp.type = SettlementNumber.T_RED;
         this._pvpNumTotalMili = new SettlementNumber();
         this._pvpNumTotalMili.type = SettlementNumber.T_GREEN;
         this._pvpNumTotalExploit = new SettlementNumber();
         this._pvpNumTotalExploit.type = SettlementNumber.T_BLUE;
         this._numFightLeft = new SettlementNumber();
         this._numFightLeft.type = SettlementNumber.FIGHT;
         this._numFightRight = new SettlementNumber();
         this._numFightRight.type = SettlementNumber.FIGHT;
         this._nameDamageRight = new PropertyName();
         this._nameArmorRight = new PropertyName();
         this._nameAgilityRight = new PropertyName();
         this._nameLucyRight = new PropertyName();
         this._nameHpRight = new PropertyName();
         this._leftObj = new Object();
         this._leftObj["fight"] = this._gameInfo.selfGamePlayer.playerInfo.FightPower;
         this._leftObj["damage"] = this._gameInfo.selfGamePlayer.playerInfo.Damage;
         this._leftObj["armor"] = this._gameInfo.selfGamePlayer.playerInfo.Guard;
         this._leftObj["agility"] = this._gameInfo.selfGamePlayer.playerInfo.Agility;
         this._leftObj["lucy"] = this._gameInfo.selfGamePlayer.playerInfo.Luck;
         this._leftObj["hp"] = this._gameInfo.selfGamePlayer.playerInfo.hp;
         this._rightObj = new Object();
         if(!this._noPlayer)
         {
            this._rightObj["fight"] = this._otherPlayer.FightPower;
            this._rightObj["damage"] = this._otherPlayer.Damage;
            this._rightObj["armor"] = this._otherPlayer.Guard;
            this._rightObj["agility"] = this._otherPlayer.Agility;
            this._rightObj["lucy"] = this._otherPlayer.Luck;
            this._rightObj["hp"] = this._otherPlayer.hp;
         }
         else
         {
            this._rightObj["fight"] = 0;
            this._rightObj["damage"] = 0;
            this._rightObj["armor"] = 0;
            this._rightObj["agility"] = 0;
            this._rightObj["lucy"] = 0;
            this._rightObj["hp"] = 0;
         }
      }
      
      private function initPlayer() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Player = null;
         var _loc2_:DictionaryData = this._gameInfo.findTeam(this._gameInfo.selfGamePlayer.team == 1 ? int(2) : int(1));
         for each(_loc3_ in _loc2_)
         {
            if(_loc1_ < _loc3_.playerInfo.FightPower)
            {
               _loc1_ = _loc3_.playerInfo.FightPower;
               this._otherPlayer = _loc3_.playerInfo;
            }
         }
         if(this._otherPlayer == null)
         {
            this._otherPlayer = this._gameInfo.tempPlayer.playerInfo;
            this._noPlayer = true;
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      private function countDownBySec() : void
      {
         --this._remainTime;
         SoundManager.instance.play("048");
         if(this._remainTime < 0)
         {
            clearInterval(this._countDown);
            this.leave();
         }
      }
      
      private function appraiseTxt() : String
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(0 < this._leftObj["fight"] && this._leftObj["fight"] < 500)
         {
            _loc1_ = 20;
         }
         else if(501 <= this._leftObj["fight"] && this._leftObj["fight"] < 8000)
         {
            _loc1_ = 15;
         }
         else if(8001 <= this._leftObj["fight"])
         {
            _loc1_ = 10;
         }
         if(this._leftObj["fight"] >= this._rightObj["fight"])
         {
            if(Number(_loc1_ / 100) > Number((this._leftObj["fight"] - this._rightObj["fight"]) / this._leftObj["fight"]))
            {
               if(this._gameInfo.selfGamePlayer.isWin)
               {
                  this._appraiseTxt.y += 12;
                  return LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp.appraise1");
               }
               this._appraiseTxt.y += 12;
               return LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp.appraise2");
            }
            if(this._gameInfo.selfGamePlayer.isWin)
            {
               return LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp.appraise3");
            }
            return LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp.appraise4");
         }
         if(this._leftObj["fight"] < this._rightObj["fight"])
         {
            if(Number(_loc1_ / 100) > Number((this._rightObj["fight"] - this._leftObj["fight"]) / this._leftObj["fight"]))
            {
               if(this._gameInfo.selfGamePlayer.isWin)
               {
                  this._appraiseTxt.y += 12;
                  return LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp.appraise1");
               }
               this._appraiseTxt.y += 12;
               return LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp.appraise2");
            }
            if(this._gameInfo.selfGamePlayer.isWin)
            {
               this._appraiseTxt.y += 12;
               return LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp.appraise5");
            }
            _loc2_ = this.getLowerStr();
            return LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp.appraise6",_loc2_);
         }
         return "";
      }
      
      private function getLowerStr() : String
      {
         var _loc1_:String = "";
         if(this._appraiseArr.length >= 3)
         {
            this._appraiseArr.sort(this.sortFunction);
            _loc1_ = LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp." + this._appraiseArr[0]["name"]) + "," + LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp." + this._appraiseArr[1]["name"]) + "," + LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp." + this._appraiseArr[2]["name"]);
         }
         else
         {
            _loc1_ = LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp." + this._appraiseArr[0]["name"]);
            if(this._appraiseArr.length > 1)
            {
               _loc1_ += "," + LanguageMgr.GetTranslation("ddt.game.SettlementView.pvp." + this._appraiseArr[1]["name"]);
            }
         }
         return _loc1_;
      }
      
      private function sortFunction(param1:Object, param2:Object) : Number
      {
         if(param1["value"] < param2["value"])
         {
            return 1;
         }
         if(param1["value"] == param2["value"])
         {
            return 0;
         }
         return -1;
      }
      
      public function getProNameColorType(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(this._noPlayer)
         {
            return PropertyName.BROWN;
         }
         if(0 < this._leftObj[param1] && this._leftObj[param1] < 500)
         {
            _loc2_ = 20;
         }
         else if(501 <= this._leftObj[param1] && this._leftObj[param1] < 8000)
         {
            _loc2_ = 15;
         }
         else if(8001 <= this._leftObj[param1])
         {
            _loc2_ = 10;
         }
         if(this._leftObj[param1] > this._rightObj[param1])
         {
            if(Number(_loc2_ / 100) < Number((this._leftObj[param1] - this._rightObj[param1]) / this._leftObj[param1]))
            {
               return PropertyName.GREEN;
            }
            return PropertyName.BROWN;
         }
         if(this._leftObj[param1] < this._rightObj[param1])
         {
            _loc3_ = new Object();
            _loc3_["name"] = param1;
            _loc3_["value"] = this._rightObj[param1] - this._leftObj[param1];
            this._appraiseArr.push(_loc3_);
            if(Number(_loc2_ / 100) < Number((this._rightObj[param1] - this._leftObj[param1]) / this._leftObj[param1]))
            {
               return PropertyName.RED;
            }
            return PropertyName.BROWN;
         }
         return PropertyName.BROWN;
      }
      
      public function getProColorType(param1:String) : int
      {
         var _loc2_:int = 0;
         if(this._noPlayer)
         {
            return SettlementNumber.P_BROWN;
         }
         if(0 < this._leftObj[param1] && this._leftObj[param1] < 500)
         {
            _loc2_ = 20;
         }
         else if(501 < this._leftObj[param1] && this._leftObj[param1] < 8000)
         {
            _loc2_ = 15;
         }
         else if(8001 <= this._leftObj[param1])
         {
            _loc2_ = 10;
         }
         if(this._leftObj[param1] > this._rightObj[param1])
         {
            if(Number(_loc2_ / 100) < Number((this._leftObj[param1] - this._rightObj[param1]) / this._leftObj[param1]))
            {
               return SettlementNumber.P_GREEN;
            }
            return SettlementNumber.P_BROWN;
         }
         if(this._leftObj[param1] < this._rightObj[param1])
         {
            if(Number(_loc2_ / 100) < Number((this._rightObj[param1] - this._leftObj[param1]) / this._leftObj[param1]))
            {
               return SettlementNumber.P_RED;
            }
            return SettlementNumber.P_BROWN;
         }
         return SettlementNumber.P_BROWN;
      }
      
      private function __onEnterFrame(param1:Event) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:BaseCell = null;
         var _loc4_:LevelIcon = null;
         var _loc5_:FilterFrameText = null;
         var _loc6_:GradientText = null;
         var _loc7_:ItemTemplateInfo = null;
         var _loc8_:BaseCell = null;
         var _loc9_:LevelIcon = null;
         var _loc10_:FilterFrameText = null;
         var _loc11_:GradientText = null;
         if(this.currentFrameLabel == "leave")
         {
            this.leaveBtn.buttonMode = true;
            this.leaveBtn.addEventListener(MouseEvent.CLICK,this.__leaveBtnClick);
         }
         else if(this.currentFrameLabel == "left_winlose")
         {
            this.left_winlose.gotoAndStop(this._gameInfo.selfGamePlayer.isWin == true ? 1 : 3);
            this._leftcharacter = CharactoryFactory.createCharacter(this._gameInfo.selfGamePlayer.playerInfo,CharactoryFactory.SHOW,true) as ShowCharacter;
            this._leftcharacter.showWing = false;
            this._leftcharacter.showGun = false;
            this._leftcharacter.setShowLight(false);
            this._leftcharacter.show(false,-1,false);
            this.lose_character.addChild(this._leftcharacter);
         }
         else if(this.currentFrameLabel == "lose_info")
         {
            _loc2_ = ItemManager.Instance.getTemplateById(this._gameInfo.selfGamePlayer.playerInfo.WeaponID);
            _loc3_ = new BaseCell(new Sprite(),_loc2_);
            _loc3_.setContentSize(58,58);
            _loc3_.mouseChildren = false;
            _loc3_.mouseEnabled = false;
            this.lose_info.lose_weapon.addChild(_loc3_);
            _loc4_ = new LevelIcon();
            _loc4_.setInfo(this._gameInfo.selfGamePlayer.playerInfo.Grade,0,0,0,0,0,false,false);
            this.lose_info.lose_name.addChild(_loc4_);
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("pvp.CharacterItemNameTxt");
            _loc5_.text = this._gameInfo.selfGamePlayer.playerInfo.NickName;
            _loc5_.x = _loc4_.x + _loc4_.width + 5;
            _loc5_.y = _loc4_.y + 2;
            if(this._gameInfo.selfGamePlayer.playerInfo.IsVIP)
            {
               _loc6_ = VipController.instance.getVipNameTxt(_loc5_.width,this._gameInfo.selfGamePlayer.playerInfo.VIPtype);
               _loc6_.x = _loc5_.x;
               _loc6_.y = _loc5_.y;
               _loc6_.text = _loc5_.text;
               this.lose_info.lose_name.addChild(_loc6_);
            }
            else
            {
               this.lose_info.lose_name.addChild(_loc5_);
            }
         }
         else if(this.currentFrameLabel == "win_info")
         {
            _loc7_ = ItemManager.Instance.getTemplateById(this._otherPlayer.WeaponID);
            _loc8_ = new BaseCell(new Sprite(),_loc7_);
            _loc8_.setContentSize(58,58);
            _loc8_.mouseChildren = false;
            _loc8_.mouseEnabled = false;
            this.win_info.win_weapon.addChild(_loc8_);
            _loc9_ = new LevelIcon();
            _loc9_.setInfo(this._otherPlayer.Grade,0,0,0,0,0,false,false);
            _loc9_.x = 10;
            _loc9_.y = 1;
            this.win_info.win_name.addChild(_loc9_);
            _loc10_ = ComponentFactory.Instance.creatComponentByStylename("pvp.CharacterItemNameTxt");
            _loc10_.text = this._otherPlayer.NickName;
            _loc10_.x = _loc9_.x + _loc9_.width + 5;
            _loc10_.y = _loc9_.y + 6;
            if(this._otherPlayer.IsVIP)
            {
               _loc11_ = VipController.instance.getVipNameTxt(_loc10_.width,this._otherPlayer.VIPtype);
               _loc11_.x = _loc10_.x;
               _loc11_.y = _loc10_.y;
               _loc11_.text = _loc10_.text;
               this.win_info.win_name.addChild(_loc11_);
            }
            else
            {
               this.win_info.win_name.addChild(_loc10_);
            }
         }
         else if(this.currentFrameLabel == "right_winlose")
         {
            this.right_winlose.gotoAndStop(this._gameInfo.selfGamePlayer.isWin == true ? 2 : 4);
         }
         else if(this.currentFrameLabel == "win_character")
         {
            this._rightcharacter = CharactoryFactory.createCharacter(this._otherPlayer,CharactoryFactory.SHOW,true) as ShowCharacter;
            this._rightcharacter.showWing = false;
            this._rightcharacter.showGun = false;
            this._rightcharacter.setShowLight(false);
            this._rightcharacter.show(false,1,false);
            if(this._noPlayer)
            {
               this._rightcharacter.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._outLine = ComponentFactory.Instance.creatBitmap("game.view.settlement.outlineBitmap");
               addChild(this._outLine);
            }
            this.win_character.addChild(this._rightcharacter);
         }
         else if(this.currentFrameLabel == "fight_left")
         {
            this._numFightLeft.playAndStopNum(this._gameInfo.selfGamePlayer.playerInfo.FightPower);
            this._numFightLeft.point = this._pos1;
            this.fight_left.addChild(this._numFightLeft);
         }
         else if(this.currentFrameLabel == "fight_right")
         {
            if(this._rightObj["fight"] == 0)
            {
               this._pos2.x = -30;
            }
            this._numFightRight.point = this._pos2;
            this._numFightRight.playAndStopNum(this._rightObj["fight"]);
            this.fight_right.addChild(this._numFightRight);
         }
         else if(this.currentFrameLabel == "damage_left")
         {
            this._nameDamageLeft = new PropertyName();
            this._nameDamageLeft.setType(PropertyName.DAMAGE,this.getProNameColorType("damage"));
            this.damage_left.addChild(this._nameDamageLeft);
            this._numDamageLeft = new SettlementNumber();
            this._numDamageLeft.type = this.getProColorType("damage");
            this._numDamageLeft.point = this._pos3;
            this._numDamageLeft.playAndStopNum(this._gameInfo.selfGamePlayer.playerInfo.Damage);
            this.damage_left.addChild(this._numDamageLeft);
         }
         else if(this.currentFrameLabel == "armor_left")
         {
            this._nameArmorLeft = new PropertyName();
            this._nameArmorLeft.setType(PropertyName.ARMOR,this.getProNameColorType("armor"));
            this.armor_left.addChild(this._nameArmorLeft);
            this._numArmorLeft = new SettlementNumber();
            this._numArmorLeft.type = this.getProColorType("armor");
            this._numArmorLeft.point = this._pos3;
            this._numArmorLeft.playAndStopNum(this._gameInfo.selfGamePlayer.playerInfo.Guard);
            this.armor_left.addChild(this._numArmorLeft);
         }
         else if(this.currentFrameLabel == "agility_left")
         {
            this._nameAgilityLeft = new PropertyName();
            this._nameAgilityLeft.setType(PropertyName.AGILITY,this.getProNameColorType("agility"));
            this.agility_left.addChild(this._nameAgilityLeft);
            this._numAgilityLeft = new SettlementNumber();
            this._numAgilityLeft.type = this.getProColorType("agility");
            this._numAgilityLeft.point = this._pos3;
            this._numAgilityLeft.playAndStopNum(this._gameInfo.selfGamePlayer.playerInfo.Agility);
            this.agility_left.addChild(this._numAgilityLeft);
         }
         else if(this.currentFrameLabel == "lucy_left")
         {
            this._nameLucyLeft = new PropertyName();
            this._nameLucyLeft.setType(PropertyName.LUCY,this.getProNameColorType("lucy"));
            this.lucy_left.addChild(this._nameLucyLeft);
            this._numLucyLeft = new SettlementNumber();
            this._numLucyLeft.type = this.getProColorType("lucy");
            this._numLucyLeft.point = this._pos3;
            this._numLucyLeft.playAndStopNum(this._gameInfo.selfGamePlayer.playerInfo.Luck);
            this.lucy_left.addChild(this._numLucyLeft);
         }
         else if(this.currentFrameLabel == "hp_left")
         {
            this._nameHpLeft = new PropertyName();
            this._nameHpLeft.setType(PropertyName.HP,this.getProNameColorType("hp"));
            this.hp_left.addChild(this._nameHpLeft);
            this._numHpLeft = new SettlementNumber();
            this._numHpLeft.type = this.getProColorType("hp");
            this._numHpLeft.point = this._pos3;
            this._numHpLeft.playAndStopNum(this._gameInfo.selfGamePlayer.playerInfo.hp);
            this.hp_left.addChild(this._numHpLeft);
         }
         else if(this.currentFrameLabel == "damage_right")
         {
            if(this._nameDamageLeft.type != PropertyName.BROWN)
            {
               this._nameDamageRight.setType(PropertyName.DAMAGE,PropertyName.BLUE_BUTTON);
            }
            else
            {
               this._nameDamageRight.setType(PropertyName.DAMAGE,PropertyName.BLUE);
            }
            this.damage_right.addChild(this._nameDamageRight);
            this._numDamageRight = new SettlementNumber();
            this._numDamageRight.type = SettlementNumber.P_BLUE;
            this._numDamageRight.point = this._pos3;
            this._numDamageRight.playAndStopNum(this._rightObj["damage"]);
            this.damage_right.addChild(this._numDamageRight);
         }
         else if(this.currentFrameLabel == "armor_right")
         {
            if(this._nameArmorLeft.type != PropertyName.BROWN)
            {
               this._nameArmorRight.setType(PropertyName.ARMOR,PropertyName.BLUE_BUTTON);
            }
            else
            {
               this._nameArmorRight.setType(PropertyName.ARMOR,PropertyName.BLUE);
            }
            this.armor_right.addChild(this._nameArmorRight);
            this._numArmorRight = new SettlementNumber();
            this._numArmorRight.type = SettlementNumber.P_BLUE;
            this._numArmorRight.point = this._pos3;
            this._numArmorRight.playAndStopNum(this._rightObj["armor"]);
            this.armor_right.addChild(this._numArmorRight);
         }
         else if(this.currentFrameLabel == "agility_right")
         {
            if(this._nameAgilityLeft.type != PropertyName.BROWN)
            {
               this._nameAgilityRight.setType(PropertyName.AGILITY,PropertyName.BLUE_BUTTON);
            }
            else
            {
               this._nameAgilityRight.setType(PropertyName.AGILITY,PropertyName.BLUE);
            }
            this.agility_right.addChild(this._nameAgilityRight);
            this._numAgilityRight = new SettlementNumber();
            this._numAgilityRight.type = SettlementNumber.P_BLUE;
            this._numAgilityRight.point = this._pos3;
            this._numAgilityRight.playAndStopNum(this._rightObj["agility"]);
            this.agility_right.addChild(this._numAgilityRight);
         }
         else if(this.currentFrameLabel == "lucy_right")
         {
            if(this._nameLucyLeft.type != PropertyName.BROWN)
            {
               this._nameLucyRight.setType(PropertyName.LUCY,PropertyName.BLUE_BUTTON);
            }
            else
            {
               this._nameLucyRight.setType(PropertyName.LUCY,PropertyName.BLUE);
            }
            this.lucy_right.addChild(this._nameLucyRight);
            this._numLucyRight = new SettlementNumber();
            this._numLucyRight.type = SettlementNumber.P_BLUE;
            this._numLucyRight.point = this._pos3;
            this._numLucyRight.playAndStopNum(this._rightObj["lucy"]);
            this.lucy_right.addChild(this._numLucyRight);
         }
         else if(this.currentFrameLabel == "hp_right")
         {
            if(this._nameHpLeft.type != PropertyName.BROWN)
            {
               this._nameHpRight.setType(PropertyName.HP,PropertyName.BLUE_BUTTON);
            }
            else
            {
               this._nameHpRight.setType(PropertyName.HP,PropertyName.BLUE);
            }
            this.hp_right.addChild(this._nameHpRight);
            this._numHpRight = new SettlementNumber();
            this._numHpRight.type = SettlementNumber.P_BLUE;
            this._numHpRight.point = this._pos3;
            this._numHpRight.playAndStopNum(this._rightObj["hp"]);
            this.hp_right.addChild(this._numHpRight);
         }
         else if(this.currentFrameLabel == "appraise")
         {
            this._appraiseTxt = ComponentFactory.Instance.creatComponentByStylename("gameIII.settlementviewpvp.appraiseTxt");
            this._appraiseTxt.htmlText = this.appraiseTxt();
            this.appraise.appraiseTxt.addChild(this._appraiseTxt);
            if(this._noPlayer)
            {
               this.appraise.visible = false;
            }
         }
         else if(this.currentFrameLabel == "showTotalExp")
         {
            this._pvpNumTotalExp.playAndStopNum(this._expObjec.gpForVIP + this._expObjec.gpForServer + this._expObjec.gpForSpouse + this._expObjec.baseExp);
            this.totalExp.addChild(this._pvpNumTotalExp);
         }
         else if(this.currentFrameLabel == "showTotalMilitary")
         {
            this._pvpNumTotalMili.playAndStopNum(this._expObjec.militaryScore);
            this.addorReleaseLight.gotoAndStop(this._expObjec.militaryScore < 0 ? 2 : 1);
            this.totalMilitary.addChild(this._pvpNumTotalMili);
         }
         else if(this.currentFrameLabel == "showTotalExploit")
         {
            this._pvpNumTotalExploit.playAndStopNum(this._expObjec.exploit);
            this.explotReleaseLight.gotoAndStop(this._expObjec.exploit < 0 ? 2 : 1);
            this.totalExploit.addChild(this._pvpNumTotalExploit);
         }
         else if(this.currentFrame == this.totalFrames)
         {
            stop();
         }
      }
      
      private function __leaveBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.leave();
      }
      
      private function leave() : void
      {
         SoundManager.instance.stop("063");
         var _loc1_:String = StateType.MAIN;
         if(this._roomInfo.type == RoomInfo.MATCH_ROOM || this._roomInfo.type == RoomInfo.MULTI_MATCH)
         {
            _loc1_ = StateType.MATCH_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.SINGLE_ROOM)
         {
            _loc1_ = StateType.ROOM_LIST;
         }
         else if(this._roomInfo.type == RoomInfo.CHALLENGE_ROOM)
         {
            _loc1_ = StateType.CHALLENGE_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.HIJACK_CAR)
         {
            _loc1_ = StateType.MAIN;
         }
         else if(this._roomInfo.type == RoomInfo.ARENA)
         {
            _loc1_ = StateType.ARENA;
            ArenaManager.instance.enter(1);
            return;
         }
         this.dispose();
         StateManager.setState(_loc1_);
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         this._gameInfo.tempPlayer = null;
         this.removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         if(this.leaveBtn)
         {
            this.leaveBtn.removeEventListener(MouseEvent.CLICK,this.__leaveBtnClick);
         }
         clearInterval(this._countDown);
         ObjectUtils.disposeObject(this._pvpNumTotalExp);
         this._pvpNumTotalExp = null;
         ObjectUtils.disposeObject(this._pvpNumTotalExploit);
         this._pvpNumTotalExploit = null;
         ObjectUtils.disposeObject(this._pvpNumTotalMili);
         this._pvpNumTotalMili = null;
         ObjectUtils.disposeObject(this._nameAgilityLeft);
         this._nameAgilityLeft = null;
         ObjectUtils.disposeObject(this._nameAgilityRight);
         this._nameAgilityRight = null;
         ObjectUtils.disposeObject(this._nameArmorLeft);
         this._nameArmorLeft = null;
         ObjectUtils.disposeObject(this._nameArmorRight);
         this._nameArmorRight = null;
         ObjectUtils.disposeObject(this._nameDamageLeft);
         this._nameDamageLeft = null;
         ObjectUtils.disposeObject(this._nameDamageRight);
         this._nameDamageRight = null;
         ObjectUtils.disposeObject(this._nameHpLeft);
         this._nameHpLeft = null;
         ObjectUtils.disposeObject(this._nameHpRight);
         this._nameHpRight = null;
         ObjectUtils.disposeObject(this._nameLucyLeft);
         this._nameLucyLeft = null;
         ObjectUtils.disposeObject(this._nameLucyRight);
         this._nameLucyRight = null;
         ObjectUtils.disposeObject(this._appraiseTxt);
         this._appraiseTxt = null;
         ObjectUtils.disposeObject(this._outLine);
         this._outLine = null;
         ObjectUtils.disposeObject(this._leftcharacter);
         this._leftcharacter = null;
         ObjectUtils.disposeObject(this._rightcharacter);
         this._rightcharacter = null;
         if(this.win_info && this.win_info.win_name)
         {
            _loc1_ = 0;
            while(_loc1_ < this.win_info.win_name.numChildren)
            {
               _loc2_ = this.win_info.win_name.getChildAt(_loc1_);
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
               _loc1_++;
            }
         }
         if(this.win_info && this.win_info.win_weapon)
         {
            _loc1_ = 0;
            while(_loc1_ < this.win_info.win_weapon.numChildren)
            {
               _loc2_ = this.win_info.win_weapon.getChildAt(_loc1_);
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
               _loc1_++;
            }
         }
         if(this.lose_info && this.lose_info.lose_name)
         {
            _loc1_ = 0;
            while(_loc1_ < this.lose_info.lose_name.numChildren)
            {
               _loc2_ = this.lose_info.lose_name.getChildAt(_loc1_);
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
               _loc1_++;
            }
         }
         if(this.lose_info && this.lose_info.lose_weapon)
         {
            _loc1_ = 0;
            while(_loc1_ < this.lose_info.lose_weapon.numChildren)
            {
               _loc2_ = this.lose_info.lose_weapon.getChildAt(_loc1_);
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
               _loc1_++;
            }
         }
      }
   }
}
