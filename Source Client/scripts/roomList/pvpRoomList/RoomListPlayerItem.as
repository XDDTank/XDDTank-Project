package roomList.pvpRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerTipManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import platformapi.tencent.DiamondManager;
   import platformapi.tencent.view.DiamondIcon;
   import vip.VipController;
   
   public class RoomListPlayerItem extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _info:PlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _name:FilterFrameText;
      
      private var _BG:ScaleLeftRightImage;
      
      private var _isSelected:Boolean;
      
      private var _vipName:GradientText;
      
      private var _diamondIcon:DiamondIcon;
      
      private var _bunIcon:DiamondIcon;
      
      public function RoomListPlayerItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.playerItemBG");
         this._BG.visible = false;
         this._BG.x = 0;
         this._BG.y = 1;
         this._BG.width = 166;
         this._BG.height = 30;
         addChild(this._BG);
         this._name = ComponentFactory.Instance.creat("asset.ddtroomList.pvp.playerItem.Name");
         addChild(this._name);
         this._levelIcon = new LevelIcon();
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.PlayerItem.SexIcon");
         addChild(this._sexIcon);
         addEventListener(MouseEvent.CLICK,this.itemClick);
         this._diamondIcon = new DiamondIcon(0);
         addChild(this._diamondIcon);
         this._bunIcon = new DiamondIcon(1);
         addChild(this._bunIcon);
      }
      
      private function itemClick(param1:MouseEvent) : void
      {
         PlayerTipManager.show(this._info,localToGlobal(new Point(0,0)).y);
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
         this._isSelected = param2;
         if(this._BG)
         {
            this._BG.visible = this._isSelected;
         }
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      private function update() : void
      {
         ObjectUtils.disposeObject(this._vipName);
         if(this._info.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(120,this._info.VIPtype);
            this._vipName.x = this._name.x;
            this._vipName.y = this._name.y;
            this._vipName.text = this._info.NickName;
            addChild(this._vipName);
         }
         this._name.text = this._info.NickName;
         PositionUtils.adaptNameStyle(this._info,this._name,this._vipName);
         this._sexIcon.setSex(this._info.Sex);
         this._bunIcon.visible = this._diamondIcon.visible = false;
         if(DiamondManager.instance.isInTencent)
         {
            if(DiamondManager.instance.pfType == 2)
            {
               this._bunIcon.level = this._info.Level3366;
               this._bunIcon.visible = true;
               PositionUtils.setPos(this._bunIcon,"asset.ddtroomList.diamondIconPos");
            }
            if(this._info.isYellowVip)
            {
               this._diamondIcon.level = this._info.MemberDiamondLevel;
               this._diamondIcon.visible = true;
               if(this._bunIcon.visible)
               {
                  this._diamondIcon.x = this._bunIcon.x - 20;
                  this._diamondIcon.y = this._bunIcon.y;
               }
               else
               {
                  PositionUtils.setPos(this._diamondIcon,"asset.ddtroomList.diamondIconPos");
               }
            }
         }
         this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.itemClick);
         if(this._vipName)
         {
            this._vipName.dispose();
         }
         this._vipName = null;
         if(this._name)
         {
            this._name.dispose();
            this._name = null;
         }
         if(this._levelIcon)
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(this._sexIcon)
         {
            this._sexIcon.dispose();
            this._sexIcon = null;
         }
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
            this._BG = null;
         }
         ObjectUtils.disposeObject(this._diamondIcon);
         this._diamondIcon = null;
         ObjectUtils.disposeObject(this._bunIcon);
         this._bunIcon = null;
      }
   }
}
