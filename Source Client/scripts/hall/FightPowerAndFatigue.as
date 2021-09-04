package hall
{
   import bagAndInfo.fightPower.FightPowerController;
   import bagAndInfo.fightPower.FightPowerUpFrame;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TimeEvents;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.PlayerPortraitView;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class FightPowerAndFatigue extends Sprite implements Disposeable
   {
      
      private static var _instance:FightPowerAndFatigue;
       
      
      private var _bg:Bitmap;
      
      private var _fightPowerProgress:MovieClip;
      
      private var _fatigueProgress:Bitmap;
      
      private var _addFatigueBtn:BaseButton;
      
      private var _portrait:PlayerPortraitView;
      
      private var _fatigueTips:OneLineTip;
      
      private var _fightPowerTxt:FilterFrameText;
      
      private var _fatigueTxt:FilterFrameText;
      
      private var _fatigueProgressMask:Shape;
      
      private var _fightPowerProgressMask:Shape;
      
      private var _tipsHitArea:Sprite;
      
      private var _fightPowerBtn:BaseButton;
      
      private var _upBmp:Bitmap;
      
      private var _saveFightPower:int;
      
      private var _fightPowerMovie:MovieClip;
      
      private var _fightPowerTimeout:Number;
      
      public function FightPowerAndFatigue()
      {
         super();
      }
      
      public static function get Instance() : FightPowerAndFatigue
      {
         if(!_instance)
         {
            _instance = new FightPowerAndFatigue();
         }
         return _instance;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.fightPowerBG");
         this._fightPowerBtn = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpButton");
         this._upBmp = ComponentFactory.Instance.creatBitmap("asset.hall.upBmp");
         this._fightPowerProgress = ComponentFactory.Instance.creat("asset.hall.fightPowerProgress");
         this._fatigueProgress = ComponentFactory.Instance.creatBitmap("asset.hall.fatigueProgress");
         this._addFatigueBtn = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerAndFatigue.buyFatigueBtn");
         this._portrait = ComponentFactory.Instance.creatCustomObject("hall.fightPowerAndFatigue.selfPortrait",["right"]);
         this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerAndFatigue.fightPowerTxt");
         this._fatigueTxt = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerAndFatigue.fatigueTxt");
         PositionUtils.setPos(this._upBmp,"hall.fightPowerUpBmp.Pos");
         PositionUtils.setPos(this._fightPowerProgress,"hall.fightPowerProgress.Pos");
         this._portrait.info = PlayerManager.Instance.Self;
         this._portrait.isShowFrame = false;
         var _loc1_:int = PlayerManager.Instance.Self.FightPower;
         this._fightPowerTxt.text = String(_loc1_);
         this._saveFightPower = _loc1_;
         if(PlayerManager.Instance.Self.Fatigue > 100)
         {
            this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightPowerAndFatigue.fatigueVal.red",PlayerManager.Instance.Self.Fatigue);
            this._addFatigueBtn.enable = false;
         }
         else
         {
            this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightPowerAndFatigue.fatigueVal.white",PlayerManager.Instance.Self.Fatigue);
            if(PlayerManager.Instance.Self.Fatigue == 100)
            {
               this._addFatigueBtn.enable = false;
            }
            else
            {
               this._addFatigueBtn.enable = true;
            }
         }
         this._fatigueProgressMask = new Shape();
         this._fatigueProgressMask.graphics.beginFill(0,0);
         this._fatigueProgressMask.graphics.drawRect(0,0,this._fatigueProgress.width,this._fatigueProgress.height);
         this._fatigueProgressMask.graphics.endFill();
         PositionUtils.setPos(this._fatigueProgressMask,new Point(this._fatigueProgress.x,this._fatigueProgress.y));
         this._fatigueProgressMask.width = int(this._fatigueProgress.width * PlayerManager.Instance.Self.Fatigue / 100);
         this._tipsHitArea = new Sprite();
         this._tipsHitArea.graphics.beginFill(0,0);
         this._tipsHitArea.graphics.drawRect(0,0,this._fatigueProgress.width,this._fatigueProgress.height);
         this._tipsHitArea.graphics.endFill();
         PositionUtils.setPos(this._tipsHitArea,new Point(this._fatigueProgress.x,this._fatigueProgress.y));
         this._fightPowerProgressMask = new Shape();
         this._fightPowerProgressMask.graphics.beginFill(0,0);
         this._fightPowerProgressMask.graphics.drawRect(0,0,this._fightPowerProgress.width,this._fightPowerProgress.height);
         this._fightPowerProgressMask.graphics.endFill();
         PositionUtils.setPos(this._fightPowerProgressMask,new Point(this._fightPowerProgress.x,this._fightPowerProgress.y));
         this.reflashFightPower();
         addChild(this._bg);
         addChild(this._fightPowerBtn);
         this._fightPowerBtn.addChild(this._fightPowerProgress);
         this._fightPowerBtn.addChild(this._fightPowerProgressMask);
         this._fightPowerBtn.addChild(this._upBmp);
         this._fightPowerBtn.addChild(this._fightPowerTxt);
         this._fightPowerProgress.mask = this._fightPowerProgressMask;
         addChild(this._fatigueProgress);
         addChild(this._fatigueProgressMask);
         this._fatigueProgress.mask = this._fatigueProgressMask;
         addChild(this._portrait);
         addChild(this._addFatigueBtn);
         addChild(this._fatigueTxt);
         addChild(this._tipsHitArea);
         this._fatigueTips = new OneLineTip();
         this._fatigueTips.tipData = LanguageMgr.GetTranslation("ddthall.fatigue.tips");
         this._fatigueTips.visible = false;
         addChild(this._fatigueTips);
      }
      
      private function addEvent() : void
      {
         this._tipsHitArea.addEventListener(MouseEvent.ROLL_OVER,this.__onFatigueMouseOver);
         this._tipsHitArea.addEventListener(MouseEvent.ROLL_OUT,this.__onFatigueMouseOut);
         this._addFatigueBtn.addEventListener(MouseEvent.CLICK,this.__onBuyFatigueClick);
         PlayerManager.Instance.addEventListener(PlayerManager.BUY_FATIUE,this.__FatigueChange);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__FatigueChange);
         TimeManager.addEventListener(TimeEvents.MINUTES,this.__FatigueChange);
         this._fightPowerBtn.addEventListener(MouseEvent.CLICK,this.__showFightPowerFrame);
      }
      
      private function removeEvent() : void
      {
         this._tipsHitArea.removeEventListener(MouseEvent.ROLL_OVER,this.__onFatigueMouseOver);
         this._tipsHitArea.removeEventListener(MouseEvent.ROLL_OUT,this.__onFatigueMouseOut);
         this._addFatigueBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyFatigueClick);
         PlayerManager.Instance.removeEventListener(PlayerManager.BUY_FATIUE,this.__FatigueChange);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__FatigueChange);
         TimeManager.removeEventListener(TimeEvents.MINUTES,this.__FatigueChange);
         this._fightPowerBtn.removeEventListener(MouseEvent.CLICK,this.__showFightPowerFrame);
         if(this._fightPowerMovie)
         {
            this._fightPowerMovie.removeEventListener(Event.COMPLETE,this.__pointMovieEnd);
         }
      }
      
      private function __onFatigueMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._fatigueTips)
         {
            this._fatigueTips.visible = true;
            LayerManager.Instance.addToLayer(this._fatigueTips,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this._fatigueProgress.localToGlobal(new Point(0,0));
            this._fatigueTips.x = _loc2_.x + this._fatigueProgress.width - 70;
            this._fatigueTips.y = _loc2_.y + this._fatigueProgress.height + 5;
         }
      }
      
      private function __onFatigueMouseOut(param1:MouseEvent) : void
      {
         if(this._fatigueTips)
         {
            this._fatigueTips.visible = false;
         }
      }
      
      private function __onBuyFatigueClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.getRestBuyFatigueCount > 0)
         {
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo",PlayerManager.Instance.Self.getBuyFatigueMoney()),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fatigue.maxCountTip"));
         }
      }
      
      private function __FatigueChange(param1:Event) : void
      {
         if(!this._fatigueTxt)
         {
            return;
         }
         var _loc2_:int = PlayerManager.Instance.Self.Fatigue;
         if(_loc2_ > 100)
         {
            this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightPowerAndFatigue.fatigueVal.red",_loc2_);
            this._addFatigueBtn.enable = false;
         }
         else
         {
            this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightPowerAndFatigue.fatigueVal.white",_loc2_);
            if(_loc2_ == 100)
            {
               this._addFatigueBtn.enable = false;
            }
            else
            {
               this._addFatigueBtn.enable = true;
            }
         }
         this._fatigueProgressMask.width = int(this._fatigueProgress.width * _loc2_ / 100);
         if(param1 is PlayerPropertyEvent)
         {
            if((param1 as PlayerPropertyEvent).changedProperties["FightPower"])
            {
               this.reflashFightPower();
            }
         }
      }
      
      private function reflashFightPower() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.FightPower;
         if(_loc1_ > this._saveFightPower)
         {
            this.showAnima();
         }
         else
         {
            this._fightPowerProgressMask.width = this._fightPowerProgress.width * this.getFightPowerProgress();
            this._fightPowerTxt.text = String(PlayerManager.Instance.Self.FightPower);
         }
         this._saveFightPower = _loc1_;
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:BaseAlerFrame = null;
         var _loc5_:BaseAlerFrame = null;
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc3_ = PlayerManager.Instance.Self.getBuyFatigueMoney();
            if(PlayerManager.Instance.Self.DDTMoney == 0 && _loc3_ > PlayerManager.Instance.Self.Money)
            {
               _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc4_.moveEnable = false;
               _loc4_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            }
            else if(PlayerManager.Instance.Self.DDTMoney + PlayerManager.Instance.Self.Money < _loc3_)
            {
               _loc5_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc5_.moveEnable = false;
               _loc5_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            }
            else
            {
               SocketManager.Instance.out.sendBuyFatigue();
            }
         }
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __showFightPowerFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:FightPowerUpFrame = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpFrame");
         _loc2_.show();
      }
      
      public function show() : void
      {
         if(this.parent)
         {
            return;
         }
         this.initView();
         this.addEvent();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      public function hide() : void
      {
         if(!this.parent)
         {
            return;
         }
         this.dispose();
      }
      
      public function reflashFatigue() : void
      {
         if(!this.parent)
         {
            return;
         }
         this.__FatigueChange(new Event(Event.CHANGE));
      }
      
      private function showAnima() : void
      {
         TweenLite.killTweensOf(this._fightPowerProgressMask);
         if(SoundManager.instance.isPlaying("201"))
         {
            SoundManager.instance.stop("201");
         }
         if(this.parent != LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER))
         {
            this.parent.removeChild(this);
            LayerManager.Instance.addToLayer(this,LayerManager.STAGE_TOP_LAYER);
         }
         if(this._fightPowerMovie)
         {
            this._fightPowerMovie.removeEventListener(Event.COMPLETE,this.__pointMovieEnd);
            ObjectUtils.disposeObject(this._fightPowerMovie);
         }
         this._fightPowerMovie = ComponentFactory.Instance.creat("asset.hall.fightPowerPointMovie");
         PositionUtils.setPos(this._fightPowerMovie,"hall.fightPowerPointMovie.Pos");
         LayerManager.Instance.addToLayer(this._fightPowerMovie,LayerManager.STAGE_TOP_LAYER);
         this._fightPowerMovie.addEventListener(Event.COMPLETE,this.__pointMovieEnd);
         SoundManager.instance.play("201");
      }
      
      private function __pointMovieEnd(param1:Event) : void
      {
         this._fightPowerMovie.removeEventListener(Event.COMPLETE,this.__pointMovieEnd);
         ObjectUtils.disposeObject(this._fightPowerMovie);
         this._fightPowerMovie = null;
         this.showFightPowerProgressAnima();
      }
      
      private function showFightPowerProgressAnima() : void
      {
         var _loc1_:Number = this.getFightPowerProgress();
         if(_loc1_ < 1)
         {
            this._fightPowerProgress.gotoAndPlay(2);
         }
         TweenLite.to(this._fightPowerProgressMask,1,{
            "width":int(this._fightPowerProgress.width * _loc1_),
            "onUpdate":this.numMove,
            "onComplete":this.animaEnd
         });
      }
      
      private function animaEnd() : void
      {
         TweenLite.killTweensOf(this._fightPowerProgressMask);
         this._fightPowerProgress.gotoAndStop(1);
         this._fightPowerTimeout = setTimeout(this.moveBack,1000);
         this._fightPowerTxt.text = String(PlayerManager.Instance.Self.FightPower);
      }
      
      private function moveBack() : void
      {
         this.parent.removeChild(this);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER);
      }
      
      private function getFightPowerProgress() : Number
      {
         var _loc1_:int = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.TOTAL_FIGHT_POWER).StandFigting;
         var _loc2_:Number = PlayerManager.Instance.Self.FightPower / _loc1_;
         return Number(_loc2_ > 1 ? Number(1) : Number(_loc2_));
      }
      
      private function numMove() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.FightPower;
         var _loc2_:int = int(this._fightPowerTxt.text);
         if(_loc2_ < _loc1_)
         {
            this._fightPowerTxt.text = String(_loc2_ + int((_loc1_ - _loc2_) / 5) + Math.round(Math.random() * 5));
         }
         else
         {
            this._fightPowerTxt.text = String(PlayerManager.Instance.Self.FightPower);
         }
      }
      
      public function set fightPowerBtnEnable(param1:Boolean) : void
      {
         this._fightPowerBtn.enable = param1;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         clearTimeout(this._fightPowerTimeout);
         TweenLite.killTweensOf(this._fightPowerProgressMask);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._fightPowerProgress);
         this._fightPowerProgress = null;
         ObjectUtils.disposeObject(this._fatigueProgress);
         this._fatigueProgress = null;
         ObjectUtils.disposeObject(this._addFatigueBtn);
         this._addFatigueBtn = null;
         ObjectUtils.disposeObject(this._portrait);
         this._portrait = null;
         ObjectUtils.disposeObject(this._fightPowerTxt);
         this._fightPowerTxt = null;
         ObjectUtils.disposeObject(this._fatigueTxt);
         this._fatigueTxt = null;
         ObjectUtils.disposeObject(this._fightPowerProgressMask);
         this._fightPowerProgressMask = null;
         ObjectUtils.disposeObject(this._fatigueProgressMask);
         this._fatigueProgressMask = null;
         ObjectUtils.disposeObject(this._tipsHitArea);
         this._tipsHitArea = null;
         ObjectUtils.disposeObject(this._upBmp);
         this._upBmp = null;
         ObjectUtils.disposeObject(this._fightPowerBtn);
         this._fightPowerBtn = null;
         ObjectUtils.disposeObject(this._fightPowerMovie);
         this._fightPowerMovie = null;
         ObjectUtils.disposeObject(this._fatigueTips);
         this._fatigueTips = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
