package game.view.playerThumbnail
{
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.BitmapManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.MarriedTip;
   import ddt.view.tips.PetTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import game.model.Player;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   [Event(name="playerThumbnailEvent",type="flash.events.Event")]
   public class PlayerThumbnail extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _info:Player;
      
      private var _headFigure:HeadFigure;
      
      private var _blood:BloodItem;
      
      private var _bg:Bitmap;
      
      private var _fore:Bitmap;
      
      private var _shiner:IEffect;
      
      private var _selectShiner:IEffect;
      
      private var _digitalbg:Bitmap;
      
      private var _smallPlayerFP:FilterFrameText;
      
      private var lightingFilter:BitmapFilter;
      
      private var _marryTip:MarriedTip;
      
      private var _dirct:int;
      
      private var _vip:DisplayObject;
      
      private var _consotion:DisplayObject;
      
      private var _bitmapMgr:BitmapManager;
      
      private var _routeBtn:BaseButton;
      
      private var _effectTarget:Shape;
      
      private var _petTip:PetTip;
      
      private var _isConsortionType:Boolean;
      
      private var _tipData:Object;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      public function PlayerThumbnail(param1:Player, param2:int, param3:Boolean)
      {
         super();
         this._info = param1;
         this._dirct = param2;
         this._isConsortionType = param3;
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back");
         addChild(this._bg);
         this._effectTarget = new Shape();
         addChild(this._effectTarget);
         PositionUtils.setPos(this._effectTarget,"asset.game.smallplayer.effectPos");
         this._headFigure = new HeadFigure(36,36,this._info);
         this._headFigure.y = 3;
         addChild(this._headFigure);
         this._blood = new BloodItem(this._info.maxBlood);
         this._blood.y = 43;
         addChild(this._blood);
         this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
         this._fore.x = this._fore.y = 1;
         addChild(this._fore);
         this._digitalbg = ComponentFactory.Instance.creatBitmap("asset.game.digitalbg");
         this._digitalbg.visible = false;
         addChild(this._digitalbg);
         PositionUtils.setPos(this._digitalbg,"asset.game.smallplayer.digitalbgPos");
         this._smallPlayerFP = ComponentFactory.Instance.creatComponentByStylename("wishView.smallplayerFightPower");
         this._smallPlayerFP.visible = false;
         addChild(this._smallPlayerFP);
         this._routeBtn = ComponentFactory.Instance.creatComponentByStylename("core.thumbnail.selectBtn");
         this._routeBtn.visible = false;
         addChild(this._routeBtn);
         if(this._isConsortionType)
         {
            this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
            this._consotion = this._bitmapMgr.creatBitmapShape("asset.game.smallplayer.consortion");
            addChild(this._consotion);
         }
         else if(this._info.playerInfo.IsVIP)
         {
            this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
            this._vip = this._bitmapMgr.creatBitmapShape("asset.game.smallplayer.vip");
            addChild(this._vip);
         }
         if(this._dirct == -1)
         {
            this._headFigure.scaleX = -this._headFigure.scaleX;
            this._headFigure.x = 42;
            if(this._vip)
            {
               PositionUtils.setPos(this._vip,"asset.game.smallplayer.vipPos1");
            }
            if(this._consotion)
            {
               PositionUtils.setPos(this._consotion,"asset.game.smallplayer.vipPos1");
            }
         }
         else
         {
            this._headFigure.x = 4;
            if(this._vip)
            {
               PositionUtils.setPos(this._vip,"asset.game.smallplayer.vipPos2");
            }
            if(this._consotion)
            {
               PositionUtils.setPos(this._consotion,"asset.game.smallplayer.consortionPos");
            }
         }
         this._shiner = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this,"asset.gameII.thumbnailShineAsset");
         this._selectShiner = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._effectTarget,"asset.gameIII.thumbnailShineSelect");
         if(this._info.playerInfo.SpouseName)
         {
            this._marryTip = new MarriedTip();
            this._marryTip.tipData = {
               "nickName":this._info.playerInfo.SpouseName,
               "gender":this._info.playerInfo.Sex
            };
         }
         this.createLevelTip();
         buttonMode = true;
         this.setUpLintingFilter();
      }
      
      public function get info() : PlayerInfo
      {
         return this._info.playerInfo;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      private function createLevelTip() : void
      {
         this.tipStyle = "core.SmallPlayerDetailTips";
         this.tipData = this._info;
         this.tipDirctions = "7";
         this.tipGapH = this.tipGapV = 10;
         ShowTipManager.Instance.addTip(this);
      }
      
      protected function overHandler(param1:MouseEvent) : void
      {
         var _loc2_:ITip = null;
         var _loc3_:ITip = null;
         this.filters = [this.lightingFilter];
         if(this._marryTip)
         {
            this._marryTip.visible = true;
            LayerManager.Instance.addToLayer(this._marryTip,LayerManager.GAME_DYNAMIC_LAYER);
            _loc2_ = ShowTipManager.Instance.getTipInstanceByStylename(this.tipStyle);
            this._marryTip.x = _loc2_.x;
            this._marryTip.y = _loc2_.y + _loc2_.height;
         }
         if(this._petTip)
         {
            this._petTip.visible = true;
            LayerManager.Instance.addToLayer(this._petTip,LayerManager.GAME_DYNAMIC_LAYER);
            _loc3_ = ShowTipManager.Instance.getTipInstanceByStylename(this.tipStyle);
            this._petTip.x = _loc3_.x + _loc3_.width - 8;
            this._petTip.y = _loc3_.y;
         }
      }
      
      protected function outHandler(param1:MouseEvent) : void
      {
         this.filters = null;
         if(this._marryTip)
         {
            this._marryTip.visible = false;
         }
         if(this._petTip)
         {
            this._petTip.visible = false;
         }
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._info.playerInfo.ZoneID != PlayerManager.Instance.Self.ZoneID || RoomManager.Instance.current.type == RoomInfo.FIGHT_ROBOT)
         {
            param1.stopImmediatePropagation();
            return;
         }
         this.removeTipTemp();
         dispatchEvent(new Event("playerThumbnailEvent"));
      }
      
      private function removeTipTemp() : void
      {
         if(this._marryTip)
         {
            this._marryTip.visible = false;
         }
         if(this._petTip)
         {
            this._petTip.visible = false;
         }
         ShowTipManager.Instance.removeTip(this);
         removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      public function recoverTip() : void
      {
         SoundManager.instance.play("008");
         ShowTipManager.Instance.removeTip(this);
         ShowTipManager.Instance.addTip(this);
         addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
      }
      
      private function initEvents() : void
      {
         this._info.addEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
         this._info.addEventListener(LivingEvent.MAX_HP_CHANGED,this.__updateBlood);
         this._info.addEventListener(LivingEvent.DIE,this.__die);
         this._info.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__shineChange);
         this._info.addEventListener(LivingEvent.FIGHTPOWER_CHANGE,this.__setSmallFP);
         this._info.addEventListener(LivingEvent.WISHSELECT_CHANGE,this.__setShiner);
         this._routeBtn.addEventListener(MouseEvent.CLICK,this.__routeLine);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
         addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      private function __playerChange(param1:CrazyTankSocketEvent) : void
      {
         this._routeBtn.visible = false;
         this._smallPlayerFP.visible = false;
         this._digitalbg.visible = false;
         this._selectShiner.stop();
      }
      
      private function __upVip(param1:Event) : void
      {
         if(PlayerManager.Instance.Self.VIPtype == 0)
         {
            if(this._vip)
            {
               this._vip.visible = false;
            }
         }
      }
      
      private function __routeLine(param1:MouseEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.WISH_SELECT,this._info.LivingID));
      }
      
      private function setUpLintingFilter() : void
      {
         var _loc1_:Array = new Array();
         _loc1_ = _loc1_.concat([1,0,0,0,25]);
         _loc1_ = _loc1_.concat([0,1,0,0,25]);
         _loc1_ = _loc1_.concat([0,0,1,0,25]);
         _loc1_ = _loc1_.concat([0,0,0,1,0]);
         this.lightingFilter = new ColorMatrixFilter(_loc1_);
      }
      
      private function __setSmallFP(param1:LivingEvent) : void
      {
         this._routeBtn.visible = true;
         if(this._info.fightPower < 100 && this._info.fightPower > 0)
         {
            this._smallPlayerFP.text = String(this._info.fightPower);
            this._digitalbg.visible = true;
            this._smallPlayerFP.visible = true;
         }
         else
         {
            this._smallPlayerFP.text = "";
            this._digitalbg.visible = false;
            this._smallPlayerFP.visible = false;
         }
      }
      
      private function __setShiner(param1:LivingEvent) : void
      {
         if(this._info.currentSelectId == this._info.LivingID)
         {
            this._selectShiner.play();
         }
         else
         {
            this._selectShiner.stop();
         }
      }
      
      private function __shineChange(param1:LivingEvent) : void
      {
         if(this._info && this._info.isAttacking)
         {
            this._shiner.play();
         }
         else
         {
            this._shiner.stop();
         }
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this.__shineChange(null);
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this.__shineChange(null);
      }
      
      private function __die(param1:LivingEvent) : void
      {
         if(this._headFigure)
         {
            this._headFigure.gray();
         }
         if(this._blood && this._blood.parent)
         {
            this._blood.parent.removeChild(this._blood);
         }
      }
      
      private function removeEvents() : void
      {
         if(this._info)
         {
            this._info.removeEventListener(LivingEvent.FIGHTPOWER_CHANGE,this.__setSmallFP);
            this._info.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
            this._info.removeEventListener(LivingEvent.MAX_HP_CHANGED,this.__updateBlood);
            this._info.removeEventListener(LivingEvent.DIE,this.__die);
            this._info.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__shineChange);
            this._info.removeEventListener(LivingEvent.WISHSELECT_CHANGE,this.__setShiner);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
         removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this._routeBtn.removeEventListener(MouseEvent.CLICK,this.__routeLine);
      }
      
      private function __updateBlood(param1:LivingEvent) : void
      {
         this._blood.setProgress(this._info.blood,this._info.maxBlood);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ShowTipManager.Instance.removeTip(this);
         if(this._marryTip && this._marryTip.parent)
         {
            this._marryTip.parent.removeChild(this._marryTip);
         }
         ObjectUtils.disposeObject(this._marryTip);
         this._marryTip = null;
         ObjectUtils.disposeObject(this._routeBtn);
         this._routeBtn = null;
         ObjectUtils.disposeObject(this._petTip);
         this._petTip = null;
         EffectManager.Instance.removeEffect(this._shiner);
         this._shiner = null;
         EffectManager.Instance.removeEffect(this._selectShiner);
         this._selectShiner = null;
         if(this._headFigure)
         {
            this._headFigure.dispose();
         }
         this._headFigure = null;
         if(this._blood)
         {
            this._blood.dispose();
         }
         this._blood = null;
         ObjectUtils.disposeObject(this._effectTarget);
         this._effectTarget = null;
         ObjectUtils.disposeObject(this._vip);
         this._vip = null;
         ObjectUtils.disposeObject(this._consotion);
         this._consotion = null;
         ObjectUtils.disposeObject(this._bitmapMgr);
         this._bitmapMgr = null;
         ObjectUtils.disposeObject(this._digitalbg);
         this._digitalbg = null;
         ObjectUtils.disposeObject(this._smallPlayerFP);
         this._smallPlayerFP = null;
         this.lightingFilter = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(this._fore)
         {
            ObjectUtils.disposeObject(this._fore);
            this._fore = null;
         }
         this._info = null;
         this._tipData = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
