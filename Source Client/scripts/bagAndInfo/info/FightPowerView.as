package bagAndInfo.info
{
   import bagAndInfo.fightPower.FightPowerController;
   import bagAndInfo.fightPower.FightPowerUpFrame;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class FightPowerView extends Sprite implements Disposeable
   {
       
      
      private var _fightPowerArr:Array;
      
      private var _fightPowerTxt:FilterFrameText;
      
      private var _info:PlayerInfo;
      
      private var _bitWidth:int;
      
      private var _powerUpBtn:BaseButton;
      
      private var _upBmp:Bitmap;
      
      private var _fightPowerProgress:MovieClip;
      
      private var _fightPowerProgressMask:Shape;
      
      private var _saveFightPower:int;
      
      public function FightPowerView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewFightPowerText");
         this._powerUpBtn = ComponentFactory.Instance.creatComponentByStylename("fightPowerUpButton");
         this._upBmp = ComponentFactory.Instance.creatBitmap("asset.hall.upBmp");
         this._fightPowerProgress = ComponentFactory.Instance.creat("asset.hall.fightPowerProgress");
         this._fightPowerProgressMask = new Shape();
         this._fightPowerProgressMask.graphics.beginFill(0,0);
         this._fightPowerProgressMask.graphics.drawRect(0,0,this._fightPowerProgress.width * this.getFightPowerProgress(),this._fightPowerProgress.height);
         this._fightPowerProgressMask.graphics.endFill();
         PositionUtils.setPos(this._fightPowerProgress,"ddtbagAndInfo.fightPowerProgress.Pos");
         PositionUtils.setPos(this._fightPowerProgressMask,"ddtbagAndInfo.fightPowerProgress.Pos");
         addChild(this._powerUpBtn);
         this._powerUpBtn.addChild(this._fightPowerTxt);
         this._powerUpBtn.addChild(this._upBmp);
         this._powerUpBtn.addChild(this._fightPowerProgress);
         this._powerUpBtn.addChild(this._fightPowerProgressMask);
         this._fightPowerProgress.mask = this._fightPowerProgressMask;
         this._saveFightPower = PlayerManager.Instance.Self.FightPower;
      }
      
      private function initEvent() : void
      {
         this._powerUpBtn.addEventListener(MouseEvent.CLICK,this.__clickPowerUpBtn);
      }
      
      private function removeEvent() : void
      {
         this._powerUpBtn.removeEventListener(MouseEvent.CLICK,this.__clickPowerUpBtn);
      }
      
      private function __clickPowerUpBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:FightPowerUpFrame = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpFrame");
         _loc2_.show();
      }
      
      public function setInfo(param1:PlayerInfo) : void
      {
         this._info = param1;
         if(this._info == null)
         {
            return;
         }
         if(this._info.FightPower != this._saveFightPower)
         {
            this.showFightPowerProgressAnima();
         }
         this._fightPowerTxt.text = String(this._info.FightPower);
      }
      
      private function showFightPowerProgressAnima() : void
      {
         TweenLite.killTweensOf(this._fightPowerProgressMask);
         var _loc1_:Number = this.getFightPowerProgress();
         if(_loc1_ < 1)
         {
            this._fightPowerProgress.gotoAndPlay(2);
         }
         TweenLite.to(this._fightPowerProgressMask,1,{
            "width":int(this._fightPowerProgress.width * _loc1_),
            "onComplete":this.animaEnd
         });
         this._saveFightPower = this._info.FightPower;
      }
      
      private function getFightPowerProgress() : Number
      {
         var _loc1_:int = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.TOTAL_FIGHT_POWER).StandFigting;
         var _loc2_:Number = PlayerManager.Instance.Self.FightPower / _loc1_;
         return Number(_loc2_ > 1 ? Number(1) : Number(_loc2_));
      }
      
      private function animaEnd() : void
      {
         TweenLite.killTweensOf(this._fightPowerProgressMask);
         this._fightPowerProgress.gotoAndStop(1);
      }
      
      private function updatefightPower() : void
      {
         var _loc4_:Bitmap = null;
         var _loc5_:int = 0;
         if(this._fightPowerArr)
         {
            _loc5_ = 0;
            while(_loc5_ < this._fightPowerArr.length)
            {
               ObjectUtils.disposeObject(this._fightPowerArr[_loc5_]);
               this._fightPowerArr[_loc5_] = null;
               _loc5_++;
            }
         }
         var _loc1_:int = Boolean(this._info) ? int(this._info.FightPower) : int(0);
         if(_loc1_ < 1)
         {
            return;
         }
         var _loc2_:String = _loc1_.toString();
         var _loc3_:int = 0;
         this._fightPowerArr = new Array();
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = ComponentFactory.Instance.creatBitmap("bagAndInfo.fightingpower" + _loc2_.charAt(_loc3_) + "Num");
            addChild(_loc4_);
            this._fightPowerArr.push(_loc4_);
            _loc3_++;
         }
         this._bitWidth = _loc4_.width - 4;
         this.updatePosition();
      }
      
      private function updatePosition() : void
      {
         var _loc3_:Bitmap = null;
         var _loc1_:int = this._fightPowerArr.length * this._bitWidth;
         var _loc2_:int = -_loc1_ / 2;
         for each(_loc3_ in this._fightPowerArr)
         {
            _loc3_.x = _loc2_;
            _loc2_ += this._bitWidth;
         }
      }
      
      public function setFightPowerEnable(param1:Boolean) : void
      {
         this._powerUpBtn.enable = param1;
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         TweenLite.killTweensOf(this._fightPowerProgressMask);
         if(this._fightPowerArr)
         {
            _loc1_ = 0;
            while(_loc1_ < this._fightPowerArr.length)
            {
               ObjectUtils.disposeObject(this._fightPowerArr[_loc1_]);
               this._fightPowerArr[_loc1_] = null;
               _loc1_++;
            }
         }
         ObjectUtils.disposeObject(this._fightPowerTxt);
         this._fightPowerTxt = null;
         ObjectUtils.disposeObject(this._upBmp);
         this._upBmp = null;
         ObjectUtils.disposeObject(this._fightPowerProgress);
         this._fightPowerProgress = null;
         ObjectUtils.disposeObject(this._fightPowerProgressMask);
         this._fightPowerProgressMask = null;
         ObjectUtils.disposeObject(this._powerUpBtn);
         this._powerUpBtn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
