package church.view.invite
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import invite.data.InvitePlayerInfo;
   import vip.VipController;
   
   public class ChurchInvitePlayerItem extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _playerInfo:InvitePlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _inviteItemInfo:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _inviteBtn:TextButton;
      
      private var _isInvite:Boolean;
      
      private var _isSelected:Boolean;
      
      private var _data:Object;
      
      private var _index:int;
      
      public function ChurchInvitePlayerItem()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomInviteItemLevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomInviteItemSexIcon");
         addChild(this._sexIcon);
         this._inviteItemInfo = ComponentFactory.Instance.creat("church.room.inviteItemInfoAsset");
         addChild(this._inviteItemInfo);
         this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("church.room.inviteItemInviteBtnAsset");
         this._inviteBtn.text = LanguageMgr.GetTranslation("im.InviteDialogFrame.Title");
         addChild(this._inviteBtn);
      }
      
      private function initEvent() : void
      {
         this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__mouseClick);
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         if(this._playerInfo.invited)
         {
            return;
         }
         SoundManager.instance.play("008");
         this._inviteBtn.enable = false;
         this._inviteBtn.filters = [ComponentFactory.Instance.model.getSet("church.room.inviteItemInviteBtnAssetGF1")];
         this._playerInfo.invited = true;
         var _loc2_:ChurchRoomInfo = ChurchManager.instance.currentRoom;
         if(this._playerInfo.Grade < 13)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.churchNotInvite"));
            return;
         }
         if(this._playerInfo is ConsortiaPlayerInfo)
         {
            SocketManager.Instance.out.sendChurchInvite(this._playerInfo.ID);
         }
         else
         {
            SocketManager.Instance.out.sendChurchInvite(this._playerInfo.ID);
         }
         this._playerInfo.invited = true;
      }
      
      public function set isInvite(param1:Boolean) : void
      {
         this._isInvite = param1;
         if(this._playerInfo.invited)
         {
            this._inviteBtn.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         }
         else
         {
            this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__mouseClick);
         }
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         this._isSelected = param2;
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1;
         this._playerInfo = param1.playerInfo;
         this._index = param1.index;
         this.update();
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      private function update() : void
      {
         if(!this._playerInfo.invited)
         {
            this._inviteBtn.enable = true;
            this._inviteBtn.filters = null;
         }
         this._inviteItemInfo.text = this._playerInfo.NickName;
         if(this._playerInfo.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(115,this._playerInfo.VIPtype);
            this._vipName.x = this._inviteItemInfo.x;
            this._vipName.y = this._inviteItemInfo.y;
            this._vipName.text = this._inviteItemInfo.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._inviteItemInfo);
         }
         else
         {
            addChild(this._inviteItemInfo);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._sexIcon.setSex(this._playerInfo.Sex);
         this._levelIcon.setInfo(this._playerInfo.Grade,this._playerInfo.Repute,this._playerInfo.WinCount,this._playerInfo.TotalCount,this._playerInfo.FightPower,this._playerInfo.Offer,true,false);
         this.initEvent();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this._inviteBtn.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         this._playerInfo = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._sexIcon);
         this._sexIcon = null;
         ObjectUtils.disposeObject(this._inviteItemInfo);
         this._inviteItemInfo = null;
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         ObjectUtils.disposeObject(this._inviteBtn);
         this._inviteBtn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
