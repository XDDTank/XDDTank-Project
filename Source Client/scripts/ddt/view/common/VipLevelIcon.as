package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.VipConfigInfo;
   import ddt.data.player.BasePlayer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class VipLevelIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const SIZE_BIG:int = 0;
      
      public static const SIZE_SMALL:int = 1;
      
      private static const LEVEL_ICON_CLASSPATH:String = "asset.vipIcon.vipLevel_";
       
      
      private var _seniorIcon:ScaleFrameImage;
      
      private var _level:int = 1;
      
      private var _type:int = 0;
      
      private var _isVip:Boolean = false;
      
      private var _vipExp:int = 0;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _tipData:String;
      
      private var _size:int;
      
      public function VipLevelIcon()
      {
         super();
         this._tipStyle = "ddt.view.tips.OneLineTip";
         this._tipGapV = 10;
         this._tipGapH = 10;
         this._tipDirctions = "7,4,6,5";
         this._size = SIZE_SMALL;
         this._seniorIcon = ComponentFactory.Instance.creatComponentByStylename("core.SeniorVipLevelIcon");
         buttonMode = true;
         ShowTipManager.Instance.addTip(this);
      }
      
      public function setInfo(param1:BasePlayer, param2:Boolean = true, param3:Boolean = false) : void
      {
         var _loc4_:VipConfigInfo = null;
         var _loc5_:int = 0;
         if(param1.ID == PlayerManager.Instance.Self.ID)
         {
            this._level = PlayerManager.Instance.Self.VIPLevel;
            this._isVip = PlayerManager.Instance.Self.IsVIP;
            this._vipExp = PlayerManager.Instance.Self.VIPExp;
         }
         else
         {
            this._level = param1.VIPLevel;
            this._isVip = param1.IsVIP;
            this._vipExp = param1.VIPExp;
         }
         _loc4_ = VipPrivilegeConfigManager.Instance.getById(0);
         if(param1.ID == PlayerManager.Instance.Self.ID)
         {
            if(param2)
            {
               buttonMode = !param3;
               if(this._isVip && _loc4_)
               {
                  if(param1.VIPLevel < 10)
                  {
                     _loc5_ = _loc4_["Level" + (this._level + 1)] - param1.VIPExp;
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradDays",_loc5_,this._level + 1);
                  }
                  else
                  {
                     this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradFull");
                  }
               }
               else if(param1.VIPLevel > 0 && param1.VIPtype == 0)
               {
                  this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue");
               }
               else
               {
                  this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.youarenovip");
               }
            }
            else
            {
               mouseEnabled = false;
               mouseChildren = false;
            }
            if(!param3)
            {
               addEventListener(MouseEvent.CLICK,this.__showVipFrame);
            }
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,this.__showVipFrame);
            if(param2)
            {
               if(this._isVip)
               {
                  this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.otherVipTip",param1.VIPLevel);
               }
               else
               {
                  this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.otherNoVipTip");
               }
            }
            else
            {
               mouseEnabled = false;
               mouseChildren = false;
            }
         }
         this._type = param1.VIPtype;
         this.updateIcon();
      }
      
      private function __showVipFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(StateManager.isInFight)
         {
            return;
         }
         VipController.instance.show();
      }
      
      private function updateIcon() : void
      {
         DisplayUtils.removeDisplay(this._seniorIcon);
         if(this._size == SIZE_SMALL)
         {
            if(this._isVip || this._level > 0)
            {
               this._seniorIcon.setFrame(this._level + 14);
               addChild(this._seniorIcon);
            }
            else
            {
               this._seniorIcon.setFrame(14);
               addChild(this._seniorIcon);
            }
         }
         else if(this._size == SIZE_BIG)
         {
            if(this._isVip || this._level > 0)
            {
               this._seniorIcon.setFrame(this._level + 1);
               addChild(this._seniorIcon);
            }
            else
            {
               this._seniorIcon.setFrame(1);
               addChild(this._seniorIcon);
            }
         }
      }
      
      public function setSize(param1:int) : void
      {
         this._size = param1;
         this.updateIcon();
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as String;
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.CLICK,this.__showVipFrame);
         ObjectUtils.disposeObject(this._seniorIcon);
         this._seniorIcon = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
