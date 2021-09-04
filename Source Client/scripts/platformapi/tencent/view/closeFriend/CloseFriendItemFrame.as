package platformapi.tencent.view.closeFriend
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CloseFriendItemFrame extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _info:PlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _selectEffect:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _sexIcon:SexIcon;
      
      private var _stateIcon:ScaleFrameImage;
      
      private var _selected:Boolean = false;
      
      public function CloseFriendItemFrame()
      {
         buttonMode = true;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.IM.CloseFriend.selectBgAsset");
         addChild(this._bg);
         this._selectEffect = ComponentFactory.Instance.creatBitmap("asset.IM.CloseFriend.listSelected");
         addChild(this._selectEffect);
         this._selectEffect.visible = false;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.playerItem.txt");
         addChild(this._nameTxt);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("IM.CloseFriend.levelIcon_list");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = new SexIcon(false);
         PositionUtils.setPos(this._sexIcon,"IM.CloseFriend.sexPos");
         addChild(this._sexIcon);
         this._stateIcon = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.state_icon");
         addChild(this._stateIcon);
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         this._info = param1;
         this.upView();
         this.addEvent();
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandle);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outHandle);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandle);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandle);
      }
      
      private function __clickHandle(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __overHandle(param1:MouseEvent) : void
      {
         if(!this._selected)
         {
            this._selectEffect.visible = true;
         }
      }
      
      private function __outHandle(param1:MouseEvent) : void
      {
         if(!this._selected)
         {
            this._selectEffect.visible = false;
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected != param1)
         {
            this._selected = param1;
            this._selectEffect.visible = this._selected;
         }
      }
      
      private function upView() : void
      {
         this._nameTxt.text = this._info.NickName;
         this._sexIcon.setSex(this._info.Sex);
         this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
         if(this._info.Sex)
         {
            this._stateIcon.setFrame(Boolean(this._info.playerState.StateID) ? int(1) : int(3));
         }
         else
         {
            this._stateIcon.setFrame(Boolean(this._info.playerState.StateID) ? int(2) : int(3));
         }
      }
      
      override public function get height() : Number
      {
         if(this._bg == null)
         {
            return 0;
         }
         return this._bg.x + this._bg.height;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._info = null;
         if(this._levelIcon)
         {
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._selectEffect);
         this._selectEffect = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         if(this._sexIcon)
         {
            this._sexIcon.dispose();
         }
         this._sexIcon = null;
         ObjectUtils.disposeObject(this._stateIcon);
         this._stateIcon = null;
         this.removeEvent();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
