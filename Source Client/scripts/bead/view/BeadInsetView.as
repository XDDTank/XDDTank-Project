package bead.view
{
   import baglocked.BaglockedManager;
   import bead.BeadManager;
   import bead.events.BeadEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class BeadInsetView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _combineBg:Bitmap;
      
      private var _rightBottomBG:Scale9CornerImage;
      
      private var _rightMidBG3:Bitmap;
      
      private var _rightMidBG4:Scale9CornerImage;
      
      private var _beadPower:Bitmap;
      
      private var _combineOneKeyBtn:BaseButton;
      
      private var _buyOneKeyBtn:BaseButton;
      
      private var _lockBtn:BeadLockBtn;
      
      private var _beadBagList:BeadBagList;
      
      private var _acceptDragSprite:BeadAcceptDragSprite;
      
      private var _getBeadView:BeadGetBeadFrame;
      
      private var _isBuyOneKey:Boolean;
      
      private var _character:RoomCharacter;
      
      private var _combinePlay:BaseButton;
      
      private var _combineStop:BaseButton;
      
      private var _grayFilter:Array;
      
      private var _combineTimer:Timer;
      
      private var _isContinPlay:Boolean;
      
      private var _timeoutId:uint;
      
      private var _movie:MovieClip;
      
      public function BeadInsetView()
      {
         super();
         this.initView();
         this.initEvent();
         this.mouseEnabled = false;
      }
      
      private function initView() : void
      {
         this._combineTimer = new Timer(1000);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.bg");
         this._combineBg = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.combineBg");
         this._rightBottomBG = ComponentFactory.Instance.creatComponentByStylename("beadInsetView.rightBottomBG");
         this._rightMidBG3 = ComponentFactory.Instance.creatBitmap("asset.beadSystem.rightDownBg");
         this._rightMidBG4 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.rightMidBG4");
         this._beadPower = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.beadPower");
         this._combineOneKeyBtn = ComponentFactory.Instance.creatComponentByStylename("beadInsetView.combineOnekeyBtn");
         this._combineOneKeyBtn.tipData = LanguageMgr.GetTranslation("beadSystem.bead.beadInsetView.combineOneKeyBtn.tip");
         this._buyOneKeyBtn = ComponentFactory.Instance.creatComponentByStylename("beadInsetView.buyOnekeyBtn");
         this._buyOneKeyBtn.tipData = LanguageMgr.GetTranslation("beadSystem.bead.beadInsetView.buyOneKeyBtn.tip");
         this._lockBtn = ComponentFactory.Instance.creatCustomObject("beadInsetView.lockBtn");
         this._lockBtn.tipData = LanguageMgr.GetTranslation("beadSystem.bead.beadInsetView.lockBtn.tip");
         this._combinePlay = ComponentFactory.Instance.creatComponentByStylename("beadSystem.playBtn");
         this._combineStop = ComponentFactory.Instance.creatComponentByStylename("beadSystem.stopBtn");
         this._combineStop.visible = false;
         this._beadBagList = ComponentFactory.Instance.creatCustomObject("beadBagList");
         this._getBeadView = ComponentFactory.Instance.creatCustomObject("beadGetBeadFrame");
         this._grayFilter = ComponentFactory.Instance.creatFilters("grayFilter");
         addChild(this._bg);
         addChild(this._beadPower);
         addChild(this._combineBg);
         addChild(this._rightBottomBG);
         addChild(this._rightMidBG4);
         addChild(this._rightMidBG3);
         addChild(this._combineOneKeyBtn);
         addChild(this._buyOneKeyBtn);
         addChild(this._combinePlay);
         addChild(this._combineStop);
         this.createAcceptDragSprite();
         addChild(this._lockBtn);
         this.createPlayer();
         addChild(this._getBeadView);
         addChild(this._beadBagList);
      }
      
      private function createPlayer() : void
      {
         this._character = CharactoryFactory.createCharacter(PlayerManager.Instance.Self,"room") as RoomCharacter;
         this._character.showGun = false;
         this._character.showWing = false;
         this._character.LightVible = false;
         this._character.show(false,-1);
         this._character.x = 260;
         this._character.y = 142;
         addChild(this._character);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         super.visible = param1;
         if(param1)
         {
            this._acceptDragSprite.x = -(this.x + this.parent.x);
            this._acceptDragSprite.y = -(this.y + this.parent.y);
            _loc2_ = this.parent.parent.width;
            _loc3_ = this.parent.parent.height;
            this._acceptDragSprite.graphics.beginFill(0,0);
            this._acceptDragSprite.graphics.drawRect(0,0,_loc2_,_loc3_);
            this._acceptDragSprite.graphics.endFill();
            if(SavePointManager.Instance.isInSavePoint(21) && !TaskManager.instance.isNewHandTaskCompleted(17))
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD,0,"trainer.beadClick1","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            }
         }
         else
         {
            this._beadBagList.hideCombineOnekeyCellLight();
         }
      }
      
      private function createAcceptDragSprite() : void
      {
         this._acceptDragSprite = new BeadAcceptDragSprite();
         this._acceptDragSprite.mouseEnabled = false;
         this._acceptDragSprite.mouseChildren = false;
         addChild(this._acceptDragSprite);
      }
      
      private function initEvent() : void
      {
         this._lockBtn.addEventListener(MouseEvent.CLICK,this.__lockBead,false,0,true);
         this._combineOneKeyBtn.addEventListener(MouseEvent.CLICK,this.__combineOneKey,false,0,true);
         this._buyOneKeyBtn.addEventListener(MouseEvent.CLICK,this.__buyOneKey,false,0,true);
         this._combinePlay.addEventListener(MouseEvent.CLICK,this.continOpen);
         this._combineStop.addEventListener(MouseEvent.CLICK,this.continOpen);
         this._combineTimer.addEventListener(TimerEvent.TIMER,this.__timerOpen);
         BeadManager.instance.addEventListener(BeadEvent.SHOW_ConfirmFrme,this.__beadLock);
         BeadManager.instance.addEventListener(BeadEvent.BEAD_LOCK,this.__beadLock);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BEAD_COMBINE_ONEKEY_TIP,this.__combineOneKeyAlert,false,0,true);
      }
      
      private function continOpen(param1:Event) : void
      {
         if(param1 != null)
         {
            SoundManager.instance.play("008");
         }
         if(param1 == null || param1.target == this._combineStop)
         {
            this._beadBagList.isLock = false;
            this._getBeadView.mouseChildren = true;
            this._combineTimer.reset();
            this._isContinPlay = false;
            this._combinePlay.visible = true;
            this._combineStop.visible = false;
            this.oneKeyStyle(false);
         }
         else if(param1.target == this._combinePlay)
         {
            if(!PlayerManager.Instance.Self.IsVIP || !BeadManager.instance.canVIPOpen(9))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.buyOneKey.tip",BeadManager.instance.needVIPLevel(9)));
            }
            else
            {
               this._beadBagList.isLock = true;
               this._getBeadView.mouseChildren = false;
               this._combinePlay.visible = false;
               this._combineStop.visible = true;
               this._combineTimer.start();
               this._isContinPlay = false;
               this.oneKeyStyle(true);
               this.__timerOpen(null);
            }
         }
      }
      
      private function __timerOpen(param1:TimerEvent) : void
      {
         this._timeoutId = setTimeout(this.combineOneKey,400);
         this.doBuyOneKey();
      }
      
      private function __buyOneKey(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.doBuyOneKey();
      }
      
      private function __combineOneKey(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.combineOneKey();
      }
      
      private function __beadLock(param1:BeadEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:InventoryItemInfo = null;
         if(param1.type == BeadEvent.BEAD_LOCK)
         {
            _loc2_ = param1.data as int;
            _loc3_ = BeadManager.instance.beadBag.items[_loc2_] as InventoryItemInfo;
            _loc3_.beadIsLock = 1;
            this._beadBagList.beadList[_loc2_].info = _loc3_;
            this._beadBagList.beadList[_loc2_].changeLockStatus();
            if(this._beadBagList.getBeadBagLockCount() == 15)
            {
               this.continOpen(null);
            }
         }
         else if(param1.type == BeadEvent.SHOW_ConfirmFrme)
         {
            this._combineTimer.stop();
            this._isContinPlay = true;
         }
      }
      
      private function oneKeyStyle(param1:Boolean) : void
      {
         if(param1)
         {
            this._combineOneKeyBtn.filters = this._grayFilter;
            this._buyOneKeyBtn.filters = this._grayFilter;
            this._lockBtn.filters = this._grayFilter;
            this._combineOneKeyBtn.mouseEnabled = false;
            this._buyOneKeyBtn.mouseEnabled = false;
            this._lockBtn.mouseEnabled = false;
         }
         else
         {
            this._combineOneKeyBtn.mouseEnabled = true;
            this._buyOneKeyBtn.mouseEnabled = true;
            this._lockBtn.mouseEnabled = true;
            this._combineOneKeyBtn.filters = null;
            this._buyOneKeyBtn.filters = null;
            this._lockBtn.filters = null;
         }
      }
      
      private function doBuyOneKey() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            clearTimeout(this._timeoutId);
            this.continOpen(null);
            return;
         }
         if(!PlayerManager.Instance.Self.IsVIP || !BeadManager.instance.canVIPOpen(9))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.buyOneKey.tip",BeadManager.instance.needVIPLevel(9)));
            return;
         }
         if(PlayerManager.Instance.Self.Gold < this._getBeadView.getlightRequestBeadMoney())
         {
            BeadManager.instance.buyGoldFrame();
            this.continOpen(null);
         }
         this._getBeadView.isBuyOneKey = true;
         PlayerManager.Instance.Self.isBeadUpdate = true;
         if(!(this._beadBagList.getBeadBagBeadCount() == 15 && this._combineStop.visible))
         {
            clearTimeout(this._timeoutId);
            if(PlayerManager.Instance.Self.Gold >= this._getBeadView.getlightRequestBeadMoney())
            {
               SocketManager.Instance.out.sendBeadBuyOneKey(2);
            }
         }
         else if(this._beadBagList.getBeadBagBeadCount() == 15 && this._beadBagList.getBeadBagLockCount() == 15)
         {
            clearTimeout(this._timeoutId);
            SocketManager.Instance.out.sendBeadBuyOneKey(2);
            this.continOpen(null);
         }
      }
      
      private function combineOneKey() : void
      {
         clearTimeout(this._timeoutId);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            this.continOpen(null);
            return;
         }
         var _loc1_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.BEADBAG);
         if(_loc1_.items[12])
         {
            if(_loc1_.items[12].beadLevel < 30)
            {
               if(SavePointManager.Instance.isInSavePoint(71))
               {
                  if(BeadManager.instance.guildeStepI)
                  {
                     NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD,180,"trainer.beadClick4","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                  }
               }
               PlayerManager.Instance.Self.isBeadUpdate = true;
               BeadManager.instance.combineConfirm(-1,this.doCombineOnekey);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.combine.tip3"));
               this.continOpen(null);
            }
         }
         else
         {
            this._beadBagList.showCombineOnekeyCellLight();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.combineOneKey.cannot"));
            this.continOpen(null);
         }
      }
      
      private function __combineOneKeyAlert(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.BEADBAG);
         var _loc7_:InventoryItemInfo = _loc6_.items[_loc3_] as InventoryItemInfo;
         var _loc8_:String = BeadManager.instance.getBeadColorName(_loc7_,true,true);
         var _loc9_:String = LanguageMgr.GetTranslation("beadSystem.bead.combineOneKey.tip",_loc8_,_loc4_);
         if(_loc5_ > _loc7_.beadLevel)
         {
            _loc9_ += LanguageMgr.GetTranslation("beadSystem.bead.combine.tip2",_loc5_);
         }
         var _loc10_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc9_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc10_.addEventListener(FrameEvent.RESPONSE,this.onStack);
      }
      
      protected function onStack(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.onStack);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            BeadManager.instance.combineConfirm(-1,this.doCombineOnekey);
         }
      }
      
      private function doCombineOnekey() : void
      {
         if(BeadManager.instance._combinePlaceList.length != 0)
         {
            this.combineAnima();
            BeadManager.instance.doWhatHandle = 2;
            BeadManager.instance.recordCombineOnekey();
         }
         if(BeadManager.instance._confirmFrameList.length == 0 && BeadManager.instance.comineCount == 1)
         {
            SocketManager.Instance.out.sendBeadCombineOneKey(1);
         }
         if(this._isContinPlay && this._combineStop.visible)
         {
            this._combineTimer.start();
         }
      }
      
      private function __lockBead(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._lockBtn.dragStart(param1.stageX,param1.stageY);
      }
      
      private function combineAnima() : void
      {
         if(this._movie == null)
         {
            this._movie = ComponentFactory.Instance.creat("asset.beadSystem.combineAnima");
            this._movie.mouseEnabled = false;
            this._movie.mouseChildren = false;
            PositionUtils.setPos(this._movie,"beadInset.combineAnima.pos");
            this._movie.scaleX = this._movie.scaleY = 0.8;
         }
         this._movie.gotoAndPlay(1);
         addChild(this._movie);
         this._movie.addEventListener(Event.COMPLETE,this.__comHandler);
      }
      
      protected function __comHandler(param1:Event) : void
      {
         removeChild(this._movie);
      }
      
      public function leving() : void
      {
         this.continOpen(null);
         PlayerManager.Instance.Self.isBeadUpdate = false;
      }
      
      private function removeEvent() : void
      {
         this._lockBtn.removeEventListener(MouseEvent.CLICK,this.__lockBead);
         this._combineOneKeyBtn.removeEventListener(MouseEvent.CLICK,this.__combineOneKey);
         this._buyOneKeyBtn.removeEventListener(MouseEvent.CLICK,this.__buyOneKey);
         this._combineTimer.removeEventListener(TimerEvent.TIMER,this.__timerOpen);
         this._combinePlay.removeEventListener(MouseEvent.CLICK,this.continOpen);
         this._combineStop.removeEventListener(MouseEvent.CLICK,this.continOpen);
         BeadManager.instance.removeEventListener(BeadEvent.SHOW_ConfirmFrme,this.__beadLock);
         BeadManager.instance.removeEventListener(BeadEvent.BEAD_LOCK,this.__beadLock);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BEAD_COMBINE_ONEKEY_TIP,this.__combineOneKeyAlert);
      }
      
      public function dispose() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
         this.removeEvent();
         this._combineTimer.stop();
         this._combineTimer = null;
         clearTimeout(this._timeoutId);
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._combineBg)
         {
            ObjectUtils.disposeObject(this._combineBg);
         }
         this._combineBg = null;
         if(this._rightBottomBG)
         {
            ObjectUtils.disposeObject(this._rightBottomBG);
         }
         this._rightBottomBG = null;
         if(this._rightMidBG3)
         {
            ObjectUtils.disposeObject(this._rightMidBG3);
         }
         this._rightMidBG3 = null;
         if(this._rightMidBG4)
         {
            ObjectUtils.disposeObject(this._rightMidBG4);
         }
         this._rightMidBG4 = null;
         if(this._character)
         {
            ObjectUtils.disposeObject(this._character);
         }
         this._character = null;
         if(this._beadPower)
         {
            ObjectUtils.disposeObject(this._beadPower);
         }
         this._beadPower = null;
         if(this._combineOneKeyBtn)
         {
            ObjectUtils.disposeObject(this._combineOneKeyBtn);
         }
         this._combineOneKeyBtn = null;
         if(this._buyOneKeyBtn)
         {
            ObjectUtils.disposeObject(this._buyOneKeyBtn);
         }
         this._buyOneKeyBtn = null;
         if(this._lockBtn)
         {
            ObjectUtils.disposeObject(this._lockBtn);
         }
         this._lockBtn = null;
         if(this._movie)
         {
            ObjectUtils.disposeObject(this._movie);
         }
         this._movie = null;
         if(this._combinePlay)
         {
            ObjectUtils.disposeObject(this._combinePlay);
         }
         this._combinePlay = null;
         if(this._combineStop)
         {
            ObjectUtils.disposeObject(this._combineStop);
         }
         this._combineStop = null;
         if(this._beadBagList)
         {
            ObjectUtils.disposeObject(this._beadBagList);
         }
         this._beadBagList = null;
         if(this._acceptDragSprite)
         {
            ObjectUtils.disposeObject(this._acceptDragSprite);
         }
         this._acceptDragSprite = null;
         if(this._getBeadView)
         {
            ObjectUtils.disposeObject(this._getBeadView);
         }
         this._getBeadView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
