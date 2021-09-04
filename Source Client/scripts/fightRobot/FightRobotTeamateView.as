package fightRobot
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.utils.PositionUtils;
   import ddt.view.PlayerPortraitView;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import vip.VipController;
   
   public class FightRobotTeamateView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _portrait:PlayerPortraitView;
      
      private var _nickNameTxt:DisplayObject;
      
      private var _isVIP:Boolean;
      
      private var _fightPowerTxt:FilterFrameText;
      
      public function FightRobotTeamateView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.fightrobot.teamate.bg");
         addChild(this._bg);
      }
      
      public function setStyle(param1:String, param2:String, param3:String, param4:int, param5:Boolean) : void
      {
         var _loc6_:PlayerInfo = new PlayerInfo();
         _loc6_.Sex = param5;
         _loc6_.Style = param1;
         _loc6_.Skin = param2;
         _loc6_.Colors = param3;
         _loc6_.Hide = param4;
         this._portrait = ComponentFactory.Instance.creatCustomObject("hall.fightPowerAndFatigue.selfPortrait",["right"]);
         this._portrait.info = _loc6_;
         this._portrait.isShowFrame = false;
         this._portrait.scaleX = this._portrait.scaleY = 0.9;
         PositionUtils.setPos(this._portrait,"fightrobot.teamatePortrait.pos");
         addChild(this._portrait);
      }
      
      public function set nickName(param1:String) : void
      {
         var _loc2_:String = null;
         if(this._isVIP)
         {
            this._nickNameTxt = VipController.instance.getVipNameTxt(130);
            (this._nickNameTxt as GradientText).text = param1;
         }
         else
         {
            this._nickNameTxt = ComponentFactory.Instance.creatComponentByStylename("fightrobot.nickName.text");
            _loc2_ = DisplayUtils.subStringByLength(this._nickNameTxt as TextField,param1,130);
            (this._nickNameTxt as FilterFrameText).text = _loc2_;
         }
         PositionUtils.setPos(this._nickNameTxt,"fightrobot.teamateName.pos");
         addChild(this._nickNameTxt);
      }
      
      public function set fightPower(param1:int) : void
      {
         this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("fightrobot.fightPower.text");
         this._fightPowerTxt.text = String(param1);
         PositionUtils.setPos(this._fightPowerTxt,"fightrobot.teamateFightPower.pos");
         addChild(this._fightPowerTxt);
      }
      
      public function set isVIP(param1:Boolean) : void
      {
         this._isVIP = param1;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._portrait);
         this._portrait = null;
         ObjectUtils.disposeObject(this._nickNameTxt);
         this._nickNameTxt = null;
         ObjectUtils.disposeObject(this._fightPowerTxt);
         this._fightPowerTxt = null;
      }
   }
}
