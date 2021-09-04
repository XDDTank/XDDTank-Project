package civil.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import civil.CivilController;
   import civil.CivilEvent;
   import civil.CivilModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import im.IMController;
   import vip.VipController;
   
   public class CivilLeftView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _player:ICharacter;
      
      private var _vipName:GradientText;
      
      private var _introductionTxt:TextArea;
      
      private var _selfInfo:SelfInfo;
      
      private var _info:CivilPlayerInfo;
      
      private var _controller:CivilController;
      
      private var _levelIcon:LevelIcon;
      
      private var _model:CivilModel;
      
      private var _courtshipBtn:TextButton;
      
      private var _talkBtn:TextButton;
      
      private var _equipBtn:TextButton;
      
      private var _addBtn:BaseButton;
      
      private var _playerNameTxt:FilterFrameText;
      
      private var _guildNameTxt:FilterFrameText;
      
      private var _reputeTxt:FilterFrameText;
      
      private var _marriedTxt:FilterFrameText;
      
      public function CivilLeftView(param1:CivilController, param2:CivilModel)
      {
         this._controller = param1;
         this._model = param2;
         super();
         this.init();
         this.initContent();
         this.initEvent();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._addBtn)
         {
            ObjectUtils.disposeObject(this._addBtn);
            this._addBtn = null;
         }
         if(this._courtshipBtn)
         {
            this._courtshipBtn.dispose();
         }
         this._courtshipBtn = null;
         if(this._equipBtn)
         {
            this._equipBtn.dispose();
         }
         this._equipBtn = null;
         if(this._player)
         {
            this._player.dispose();
         }
         this._player = null;
         if(this._levelIcon)
         {
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._introductionTxt)
         {
            ObjectUtils.disposeObject(this._introductionTxt);
            this._introductionTxt = null;
         }
         if(this._talkBtn)
         {
            ObjectUtils.disposeObject(this._talkBtn);
            this._talkBtn = null;
         }
         if(this._playerNameTxt)
         {
            ObjectUtils.disposeObject(this._playerNameTxt);
            this._playerNameTxt = null;
         }
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(this._guildNameTxt)
         {
            ObjectUtils.disposeObject(this._guildNameTxt);
            this._guildNameTxt = null;
         }
         if(this._reputeTxt)
         {
            ObjectUtils.disposeObject(this._reputeTxt);
            this._reputeTxt = null;
         }
         if(this._marriedTxt)
         {
            ObjectUtils.disposeObject(this._marriedTxt);
            this._marriedTxt = null;
         }
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.leftView.bg");
         addChild(this._bg);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("ddtcivil.levelIcon");
         addChild(this._levelIcon);
         this._introductionTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.IntroductionText");
         addChild(this._introductionTxt);
      }
      
      private function initContent() : void
      {
         this._courtshipBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.courtshipTxtBtn");
         this._talkBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.talkTxtBtn");
         this._equipBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.equipTxtBtn");
         this._addBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.addTxtBtn");
         this._playerNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.playerName");
         this._guildNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.guildName");
         this._reputeTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.reputeTxt");
         this._marriedTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.marriedTxt");
         this._equipBtn.text = LanguageMgr.GetTranslation("civil.leftview.equipName");
         this._talkBtn.text = LanguageMgr.GetTranslation("civil.leftview.talkName");
         this._courtshipBtn.text = LanguageMgr.GetTranslation("civil.leftview.courtshipName");
         addChild(this._courtshipBtn);
         addChild(this._talkBtn);
         addChild(this._equipBtn);
         addChild(this._addBtn);
         addChild(this._playerNameTxt);
         addChild(this._guildNameTxt);
         addChild(this._reputeTxt);
         addChild(this._marriedTxt);
      }
      
      private function initEvent() : void
      {
         this._courtshipBtn.addEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._talkBtn.addEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._equipBtn.addEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._addBtn.addEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._model.addEventListener(CivilEvent.SELECTED_CHANGE,this.__updateView);
      }
      
      private function removeEvent() : void
      {
         this._courtshipBtn.removeEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._talkBtn.removeEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._equipBtn.removeEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.__onButtonClick);
         this._model.removeEventListener(CivilEvent.SELECTED_CHANGE,this.__updateView);
      }
      
      private function __onButtonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:CivilPlayerInfo = this._controller.currentcivilInfo;
         if(_loc2_ && _loc2_.info)
         {
            switch(param1.currentTarget)
            {
               case this._talkBtn:
                  IMController.Instance.alertPrivateFrame(_loc2_.info.ID);
                  break;
               case this._equipBtn:
                  if(_loc2_.IsPublishEquip)
                  {
                     PlayerInfoViewControl.viewByID(_loc2_.info.ID,PlayerManager.Instance.Self.ZoneID);
                  }
                  else if(_loc2_.MarryInfoID == PlayerManager.Instance.Self.MarryInfoID && PlayerManager.Instance.Self.IsPublishEquit)
                  {
                     PlayerInfoViewControl.viewByID(_loc2_.info.ID,PlayerManager.Instance.Self.ZoneID);
                  }
                  break;
               case this._addBtn:
                  IMController.Instance.addFriend(_loc2_.info.NickName);
                  break;
               case this._courtshipBtn:
                  ChurchManager.instance.sendValidateMarry(_loc2_.info);
            }
         }
      }
      
      private function __updateView(param1:CivilEvent) : void
      {
         if(this._model.currentcivilItemInfo)
         {
            this.updatePlayerView();
         }
         else
         {
            this._levelIcon.visible = false;
            this._equipBtn.enable = false;
            this._talkBtn.enable = false;
            this._courtshipBtn.enable = false;
            this._addBtn.enable = false;
            this._playerNameTxt.text = "";
            if(this._vipName)
            {
               this._vipName.text = "";
               DisplayUtils.removeDisplay(this._vipName);
            }
            this._guildNameTxt.text = "";
            this._reputeTxt.text = "";
            this._marriedTxt.text = "";
            this._introductionTxt.text = "";
         }
         this.refreshCharater();
      }
      
      private function updatePlayerView() : void
      {
         var _loc1_:CivilPlayerInfo = this._model.currentcivilItemInfo;
         var _loc2_:PlayerInfo = _loc1_.info;
         this._playerNameTxt.text = _loc2_.NickName;
         if(_loc2_.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(192,_loc2_.VIPtype);
            this._vipName.textSize = 16;
            this._vipName.x = this._playerNameTxt.x;
            this._vipName.y = this._playerNameTxt.y;
            this._vipName.text = this._playerNameTxt.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._playerNameTxt);
         }
         else
         {
            addChild(this._playerNameTxt);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._guildNameTxt.text = Boolean(_loc2_.ConsortiaName) ? _loc2_.ConsortiaName : "";
         this._reputeTxt.text = String(_loc2_.Repute);
         this._marriedTxt.text = !!_loc2_.IsMarried ? LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.married") : LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.marry");
         this._levelIcon.setInfo(_loc2_.Grade,_loc2_.Repute,_loc2_.WinCount,_loc2_.TotalCount,_loc2_.FightPower,_loc2_.Offer,true,false);
         this._levelIcon.visible = true;
         if(this._model.currentcivilItemInfo.MarryInfoID == PlayerManager.Instance.Self.MarryInfoID && PlayerManager.Instance.Self.Introduction != null)
         {
            this._introductionTxt.text = PlayerManager.Instance.Self.Introduction;
            this._equipBtn.enable = PlayerManager.Instance.Self.IsPublishEquit;
         }
         else
         {
            this._introductionTxt.text = _loc1_.Introduction;
         }
         if(this._model.currentcivilItemInfo.MarryInfoID == PlayerManager.Instance.Self.MarryInfoID || this._model.currentcivilItemInfo.info.playerState.StateID == PlayerState.OFFLINE)
         {
            this._talkBtn.enable = false;
         }
         else
         {
            this._talkBtn.enable = true;
         }
         if(_loc1_.info.ID == PlayerManager.Instance.Self.ID)
         {
            this._addBtn.enable = false;
            this._equipBtn.enable = this._model.currentcivilItemInfo.IsPublishEquip;
         }
         else
         {
            this._addBtn.enable = true;
            this._equipBtn.enable = this._model.currentcivilItemInfo.IsPublishEquip;
         }
         this._courtshipBtn.enable = this.getCourtshipBtnEnable();
      }
      
      private function getCourtshipBtnEnable() : Boolean
      {
         if(PlayerManager.Instance.Self.Sex == this._model.currentcivilItemInfo.info.Sex || PlayerManager.Instance.Self.IsMarried || this._model.currentcivilItemInfo.info.IsMarried || this._model.currentcivilItemInfo.info.playerState.StateID == PlayerState.OFFLINE)
         {
            return false;
         }
         return true;
      }
      
      private function refreshCharater() : void
      {
         var _loc1_:ICharacter = null;
         this._info = this._controller.currentcivilInfo;
         if(this._info != null)
         {
            _loc1_ = this._player;
            this._player = CharactoryFactory.createCharacter(this._info.info,"room") as RoomCharacter;
            this._player.show(true,-1);
            this._player.setShowLight(true);
            PositionUtils.setPos(this._player,"civil.playerPos");
            addChild(this._player as DisplayObject);
            if(_loc1_)
            {
               _loc1_.dispose();
            }
         }
         else if(this._player)
         {
            this._player.dispose();
            this._player = null;
         }
      }
   }
}
