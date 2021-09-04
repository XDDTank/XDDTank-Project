package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import vip.VipController;
   
   public class ViceChairmanItem extends Sprite implements Disposeable
   {
       
      
      private var _itemBg:Bitmap;
      
      private var _light:Bitmap;
      
      private var _name:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _levelIcon:LevelIcon;
      
      private var _SexIcon:SexIcon;
      
      private var _playerInfo:ConsortiaPlayerInfo;
      
      private var _isSelected:Boolean = false;
      
      public function ViceChairmanItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._itemBg = ComponentFactory.Instance.creatBitmap("consortionTrasfer.itemBg");
         this._light = ComponentFactory.Instance.creatBitmap("consortionTrasfer.light");
         this._light.visible = false;
         this._name = ComponentFactory.Instance.creatComponentByStylename("memberItem.commonName");
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("memberItem.level");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         this._SexIcon = ComponentFactory.Instance.creatCustomObject("consortionTrasfer.itemSexIcon");
         PositionUtils.setPos(this._name,"asset.viceChairmanItemNameTxt.pos");
         PositionUtils.setPos(this._levelIcon,"asset.viceChairmanItemlevelIcon.pos");
         PositionUtils.setPos(this._SexIcon,"asset.viceChairmanItemSexIcon.pos");
         addChild(this._itemBg);
         addChild(this._light);
      }
      
      public function get info() : ConsortiaPlayerInfo
      {
         return this._playerInfo;
      }
      
      public function set info(param1:ConsortiaPlayerInfo) : void
      {
         this._playerInfo = param1;
         if(this._playerInfo == null)
         {
            this.isSelelct = false;
            mouseEnabled = false;
            mouseChildren = false;
         }
         else
         {
            mouseEnabled = true;
            mouseChildren = true;
            this.setName();
            ObjectUtils.disposeObject(this._levelIcon);
            ObjectUtils.disposeObject(this._SexIcon);
            this._levelIcon = ComponentFactory.Instance.creatCustomObject("memberItem.level");
            this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
            this._SexIcon = ComponentFactory.Instance.creatCustomObject("consortionTrasfer.itemSexIcon");
            PositionUtils.setPos(this._levelIcon,"asset.viceChairmanItemlevelIcon.pos");
            PositionUtils.setPos(this._SexIcon,"asset.viceChairmanItemSexIcon.pos");
            addChild(this._levelIcon);
            addChild(this._SexIcon);
            this._levelIcon.setInfo(this._playerInfo.Grade,this._playerInfo.Repute,this._playerInfo.WinCount,this._playerInfo.TotalCount,this._playerInfo.FightPower,this._playerInfo.Offer);
            this._SexIcon.setSex(this._playerInfo.Sex);
         }
      }
      
      private function setName() : void
      {
         var _loc1_:BasePlayer = null;
         var _loc2_:TextFormat = null;
         if(this._playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            _loc1_ = PlayerManager.Instance.Self;
         }
         else
         {
            _loc1_ = this._playerInfo;
         }
         ObjectUtils.disposeObject(this._name);
         this._name = ComponentFactory.Instance.creatComponentByStylename("memberItem.commonName");
         this._name.text = _loc1_.NickName;
         PositionUtils.setPos(this._name,"asset.viceChairmanItemNameTxt.pos");
         addChild(this._name);
         if(_loc1_.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(149,_loc1_.VIPtype);
            _loc2_ = new TextFormat();
            _loc2_.align = "center";
            _loc2_.bold = true;
            this._vipName.textField.defaultTextFormat = _loc2_;
            this._vipName.textSize = 16;
            PositionUtils.setPos(this._vipName,"asset.viceChairmanItemNameTxt.pos");
            this._vipName.text = _loc1_.NickName;
            addChild(this._vipName);
         }
         PositionUtils.adaptNameStyle(_loc1_,this._name,this._vipName);
      }
      
      public function get isSelelct() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelelct(param1:Boolean) : void
      {
         if(this._isSelected == param1)
         {
            return;
         }
         this._isSelected = param1;
         this._light.visible = this._isSelected;
      }
      
      public function set light(param1:Boolean) : void
      {
         if(this._isSelected)
         {
            return;
         }
         this._light.visible = param1;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._itemBg = null;
         this._light = null;
         this._name = null;
         this._levelIcon = null;
         this._vipName = null;
         this._SexIcon = null;
         this._playerInfo = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
