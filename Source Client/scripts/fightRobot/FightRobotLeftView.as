package fightRobot
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import militaryrank.view.MilitaryIcon;
   import vip.VipController;
   
   public class FightRobotLeftView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _nickNameTxt:DisplayObject;
      
      private var _fightPowerTxt:FilterFrameText;
      
      private var _character:RoomCharacter;
      
      private var _levelIcon:LevelIcon;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _militaryIcon:MilitaryIcon;
      
      private var _marriedIcon:MarriedIcon;
      
      private var _teamateList:Vector.<FightRobotTeamateView>;
      
      public function FightRobotLeftView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:SelfInfo = null;
         _loc1_ = PlayerManager.Instance.Self;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.fightrobot.left.bg");
         if(_loc1_.IsVIP)
         {
            this._nickNameTxt = VipController.instance.getVipNameTxt(130,_loc1_.VIPtype);
            (this._nickNameTxt as GradientText).text = _loc1_.NickName;
         }
         else
         {
            this._nickNameTxt = ComponentFactory.Instance.creatComponentByStylename("fightrobot.nickName.text");
            (this._nickNameTxt as FilterFrameText).text = DisplayUtils.subStringByLength(this._nickNameTxt as TextField,_loc1_.NickName,130);
         }
         PositionUtils.setPos(this._nickNameTxt,"fightrobot.nickName.pos");
         this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("fightrobot.fightPower.text");
         this._character = CharactoryFactory.createCharacter(_loc1_,"room") as RoomCharacter;
         this._character.showGun = false;
         this._character.show(true,-1);
         PositionUtils.setPos(this._character,"fightrobot.character.pos");
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("fightrobot.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         this._levelIcon.setInfo(_loc1_.Grade,_loc1_.Repute,_loc1_.WinCount,_loc1_.TotalCount,_loc1_.FightPower,_loc1_.Offer,true,false);
         this._vipIcon = ComponentFactory.Instance.creatCustomObject("fightrobot.vipIcon");
         this._vipIcon.setInfo(_loc1_);
         if(!_loc1_.IsVIP)
         {
            this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._vipIcon.filters = null;
         }
         this._militaryIcon = new MilitaryIcon(_loc1_);
         this._militaryIcon.setMilitary(_loc1_.MilitaryRankTotalScores);
         PositionUtils.setPos(this._militaryIcon,"fightrobot.military.pos");
         this._fightPowerTxt.text = String(_loc1_.FightPower);
         addChild(this._bg);
         addChild(this._character);
         addChild(this._nickNameTxt);
         addChild(this._fightPowerTxt);
         addChild(this._levelIcon);
         addChild(this._vipIcon);
         addChild(this._militaryIcon);
         if(_loc1_.SpouseID > 0)
         {
            this._marriedIcon = ComponentFactory.Instance.creatCustomObject("fightrobot.MarriedIcon");
            this._marriedIcon.tipData = {
               "nickName":_loc1_.SpouseName,
               "gender":_loc1_.Sex
            };
            addChild(this._marriedIcon);
         }
      }
      
      public function set teamateList(param1:Vector.<FightRobotTeamateView>) : void
      {
         this._teamateList = param1;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            addChild(param1[_loc2_]);
            PositionUtils.setPos(param1[_loc2_],"fightrobot.teamate" + (_loc2_ + 1) + ".pos");
            _loc2_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:FightRobotTeamateView = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._nickNameTxt);
         this._nickNameTxt = null;
         ObjectUtils.disposeObject(this._fightPowerTxt);
         this._fightPowerTxt = null;
         ObjectUtils.disposeObject(this._character);
         this._character = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._militaryIcon);
         this._militaryIcon = null;
         ObjectUtils.disposeObject(this._marriedIcon);
         this._marriedIcon = null;
         for each(_loc1_ in this._teamateList)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._teamateList = null;
      }
   }
}
