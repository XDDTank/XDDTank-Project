package game.view.control
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.GraphicsUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.objects.BossLocalPlayer;
   import game.objects.GameLocalPlayer;
   import game.objects.GameTurnedLiving;
   import game.view.MouseStateTxtDegree;
   import game.view.MouseStateTxtPower;
   import game.view.map.MapView;
   
   public class MouseStateView extends Sprite implements Disposeable
   {
       
      
      private var _self:GameTurnedLiving;
      
      private var _mouseDownLeft:Boolean = false;
      
      private var _mouseDownRight:Boolean = false;
      
      private var _dragMouse:Boolean = false;
      
      private var _lineAndPoint:Sprite;
      
      private var _lastLineAndPoint:Sprite;
      
      private var _shootSprite:Sprite;
      
      private var _circleRight:Bitmap;
      
      private var _circleLeft:Bitmap;
      
      private var _circleSmall:Bitmap;
      
      private var _currentPower:Sprite;
      
      private var _textBgPower:Bitmap;
      
      private var _textBgDegree:Bitmap;
      
      private var _textPower:Bitmap;
      
      private var _textDegree:Bitmap;
      
      private var _textpowerMC:MouseStateTxtPower;
      
      private var _textdegreeMC:MouseStateTxtDegree;
      
      private var _powerLine:Bitmap;
      
      private var _triangle:Bitmap;
      
      private var _middlePoint:Bitmap;
      
      private var _sector:Sprite;
      
      private var _powerLineSector:Bitmap;
      
      private var _minDegree:Number;
      
      private var _maxDegree:Number;
      
      private var _point:Point;
      
      private var _showShoot:Boolean;
      
      private var _currentPowerBig:Sprite;
      
      private var _fightLead:MovieClip;
      
      private var _lastPowerLead:Bitmap;
      
      private var _map:MapView;
      
      private var _lastPowerLine:Bitmap;
      
      private var _lastPower:Sprite;
      
      private var _lastPowerLineSector:Bitmap;
      
      private var _lastAngle:Number;
      
      public function MouseStateView(param1:GameTurnedLiving, param2:MapView)
      {
         super();
         this._self = param1 as GameLocalPlayer;
         this._map = param2;
         if(!this._self)
         {
            this._self = param1 as BossLocalPlayer;
         }
         this.initView();
         this.initEvent();
      }
      
      public function get info() : Living
      {
         return this._self.info;
      }
      
      public function get localPlayer() : LocalPlayer
      {
         return this._self["localPlayer"];
      }
      
      public function turnLeft() : void
      {
         this._circleRight.scaleX = -1;
         this._circleRight.x = this._circleRight.width;
         this._sector.scaleX = -1;
         this._lastLineAndPoint.rotation = Math.abs(this._lastLineAndPoint.rotation) - 180;
         this.setTxtPos();
         this.setCircleDirection();
         this.setPos();
         this.changeDegree();
      }
      
      public function turnRight() : void
      {
         this._circleRight.scaleX = 1;
         this._circleRight.x = 0;
         this._sector.scaleX = 1;
         this._lastLineAndPoint.rotation = Math.abs(this._lastLineAndPoint.rotation) - 180;
         this.setTxtPos();
         this.setCircleDirection();
         this.setPos();
         this.changeDegree();
      }
      
      public function changeDegree() : void
      {
         var _loc1_:Number = this.info.playerAngle;
         this._lineAndPoint.rotation = this.localPlayer.arrowRotation + _loc1_;
         this._sector.rotation = _loc1_;
         this._textdegreeMC.setNum(this.localPlayer.gunAngle + _loc1_ * -1 * this.localPlayer.direction);
      }
      
      public function changeForce() : void
      {
         this._textpowerMC.setNum(this.localPlayer.force / 2000 * 100);
         var _loc1_:Number = this._lineAndPoint.rotation;
         this._lineAndPoint.rotation = 0;
         this._currentPower.x = this.localPlayer.force / 2000 * this._powerLine.width - this._currentPower.width;
         this._powerLineSector.width = this.localPlayer.force / 2000 * this._powerLine.width;
         this._lineAndPoint.rotation = _loc1_;
      }
      
      public function setLastAngleAndForce() : void
      {
         var _loc1_:Point = null;
         if(isNaN(this._lastAngle))
         {
            return;
         }
         this._lastLineAndPoint.visible = true;
         this._lastLineAndPoint.rotation = 0;
         this._lastPower.x = this.localPlayer.force / 2000 * this._lastPowerLine.width - this._lastPower.width;
         if(this.localPlayer.force > 0)
         {
            this._lastPowerLineSector.width = this.localPlayer.force / 2000 * this._lastPowerLine.width - 3;
         }
         else
         {
            this._lastPowerLineSector.width = 1;
         }
         this._lastLineAndPoint.rotation = this._lastAngle;
         if(SharedManager.Instance.showLastPowerPointTips && !this._lastPowerLead)
         {
            this._lastPowerLead = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.lastPowerPointTips.png");
            _loc1_ = this._lastLineAndPoint.localToGlobal(new Point(this._lastPower.x,this._lastPower.y));
            this._lastPowerLead.x = _loc1_.x + 31;
            this._lastPowerLead.y = _loc1_.y - 62;
            LayerManager.Instance.addToLayer(this._lastPowerLead,LayerManager.GAME_TOP_LAYER);
         }
      }
      
      public function attactionChange() : void
      {
         if(!this._self.turnedLiving.isAttacking)
         {
            this._lastAngle = this._lineAndPoint.rotation;
         }
         this.setCurrentPowerPos();
         this._currentPowerBig.visible = true;
         this._powerLineSector.width = 0;
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      private function __changeBall(param1:LivingEvent) : void
      {
         if(this.localPlayer.currentBomb == 3)
         {
            this.carrayAngle();
         }
         else
         {
            this.resetAngle();
         }
      }
      
      private function __changeDir(param1:LivingEvent) : void
      {
         if(this.localPlayer.direction == 1)
         {
            this.turnRight();
         }
         else
         {
            this.turnLeft();
         }
      }
      
      private function carrayAngle() : void
      {
         GraphicsUtils.changeSectorAngle(this._sector,0,0,310,0,90);
      }
      
      private function resetAngle() : void
      {
         GraphicsUtils.changeSectorAngle(this._sector,0,0,310,this._minDegree,this._maxDegree);
      }
      
      private function initView() : void
      {
         this._shootSprite = new Sprite();
         this._circleRight = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.circleRight.png");
         this._circleRight.smoothing = true;
         this._shootSprite.addChild(this._circleRight);
         this._circleLeft = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.circleLeft.png");
         this._circleLeft.smoothing = true;
         this._shootSprite.addChild(this._circleLeft);
         this._circleSmall = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.circleSmall.png");
         this._shootSprite.addChild(this._circleSmall);
         this._point = new Point(this._circleRight.width / 2,this._circleRight.height / 2);
         this._circleSmall.x = this._point.x - this._circleSmall.width / 2;
         this._circleSmall.y = this._point.y - this._circleSmall.height / 2;
         this._middlePoint = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.middlePoint.png");
         this._middlePoint.x = this._point.x - this._middlePoint.width / 2;
         this._middlePoint.y = this._point.x - 3;
         this._sector = new Sprite();
         this._sector.x = this._point.x;
         this._sector.y = this._point.y;
         this._sector.scaleX = this.info.direction == 1 ? Number(1) : Number(-1);
         this._minDegree = this.localPlayer.currentWeapInfo.armMinAngle - 1;
         this._maxDegree = this.localPlayer.currentWeapInfo.armMaxAngle - this.localPlayer.currentWeapInfo.armMinAngle + 1;
         this.resetAngle();
         this._shootSprite.mask = this._sector;
         this._textBgPower = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.textBg.png");
         this._textPower = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.textPower.png");
         this._textDegree = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.textAngle.png");
         this._textBgDegree = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.textBg.png");
         this._textpowerMC = new MouseStateTxtPower();
         this._textpowerMC.x = this._textPower.x + 46;
         this._textpowerMC.y = this._textPower.y - 2;
         this._textpowerMC.setNum(0);
         this._textdegreeMC = new MouseStateTxtDegree();
         this._textdegreeMC.x = this._textDegree.x + 46;
         this._textdegreeMC.y = this._textDegree.y - 2;
         this._powerLine = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.powLine.png");
         this._powerLineSector = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.powLine.png");
         this._powerLine.mask = this._powerLineSector;
         this._powerLine.smoothing = true;
         this._lastPowerLine = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.lastPowLine.png");
         this._lastPowerLineSector = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.lastPowLine.png");
         this._lastPowerLine.mask = this._lastPowerLineSector;
         this._lastPowerLine.smoothing = true;
         this._currentPower = new Sprite();
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.currentPowerPoint.png");
         _loc1_.smoothing = true;
         this._currentPower.addChild(_loc1_);
         this._currentPower.buttonMode = true;
         this._lastPower = new Sprite();
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.lastPowerPoint.png");
         _loc2_.smoothing = true;
         this._lastPower.addChild(_loc2_);
         this._lastPower.buttonMode = false;
         this._triangle = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.triangle.png");
         this._triangle.smoothing = true;
         this._lineAndPoint = new Sprite();
         this._lineAndPoint.addChild(this._powerLine);
         this._lineAndPoint.addChild(this._powerLineSector);
         this._lineAndPoint.addChild(this._currentPower);
         this._lineAndPoint.addChild(this._triangle);
         this._lineAndPoint.x = this._point.x - 2;
         this._lineAndPoint.y = this._point.y;
         this._lastLineAndPoint = new Sprite();
         this._lastLineAndPoint.addChild(this._lastPowerLine);
         this._lastLineAndPoint.addChild(this._lastPowerLineSector);
         this._lastLineAndPoint.addChild(this._lastPower);
         this._lastLineAndPoint.x = this._point.x - 2;
         this._lastLineAndPoint.y = this._point.y;
         this._lastLineAndPoint.visible = false;
         this._shootSprite.addChild(this._lastLineAndPoint);
         this._currentPowerBig = new Sprite();
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.mouseState.currentPowerPoint.png");
         _loc3_.width *= 2;
         _loc3_.height *= 2;
         _loc3_.smoothing = true;
         this._currentPowerBig.addChild(_loc3_);
         this._currentPowerBig.x = this._point.x - _loc3_.width / 2;
         this._currentPowerBig.y = this._point.y - _loc3_.height / 2;
         this._currentPowerBig.buttonMode = true;
         this._triangle.x = this._powerLine.x + this._powerLine.width + 12;
         this._triangle.y = this._powerLine.y - 13;
         this._triangle.rotation = 30;
         addChild(this._middlePoint);
         addChild(this._sector);
         addChild(this._shootSprite);
         addChild(this._lineAndPoint);
         addChild(this._currentPowerBig);
         addChild(this._textBgDegree);
         addChild(this._textBgPower);
         addChild(this._textPower);
         addChild(this._textDegree);
         addChild(this._textpowerMC);
         addChild(this._textdegreeMC);
         this.setTxtPos();
         this.setCurrentPowerPos();
         this.setCircleDirection();
         this.setPos();
         this.changeDegree();
         this.hide();
      }
      
      private function initEvent() : void
      {
         this.localPlayer.addEventListener(GameEvent.MOUSE_MODEL_UP,this.__stopDrag);
         this.localPlayer.addEventListener(LivingEvent.BOMB_CHANGED,this.__changeBall);
         this.localPlayer.addEventListener(LivingEvent.DIR_CHANGED,this.__changeDir);
         this._currentPowerBig.addEventListener(MouseEvent.MOUSE_DOWN,this.__startDrag);
      }
      
      public function showLead() : void
      {
         if(!this._fightLead)
         {
            this._fightLead = ComponentFactory.Instance.creat("asset.game.mouseState.lead.fight") as MovieClip;
            this._fightLead.mouseEnabled = false;
            this._fightLead.mouseChildren = false;
            this._fightLead.x = this._lineAndPoint.x - 14;
            this._fightLead.y = this._lineAndPoint.y - 30;
            addChild(this._fightLead);
         }
      }
      
      private function setTxtPos() : void
      {
         if(this.localPlayer.direction == 1)
         {
            PositionUtils.setPos(this._textBgPower,"asset.game.mouseState.textBg.powerPosRight");
            PositionUtils.setPos(this._textBgDegree,"asset.game.mouseState.textBg.degreePosRight");
            PositionUtils.setPos(this._textPower,"asset.game.mouseState.text.powerPosRight");
            PositionUtils.setPos(this._textDegree,"asset.game.mouseState.text.degreePosRight");
            this._textpowerMC.x = this._textPower.x + 46;
            this._textpowerMC.y = this._textPower.y - 2;
            this._textdegreeMC.x = this._textDegree.x + 46;
            this._textdegreeMC.y = this._textDegree.y - 2;
         }
         else
         {
            PositionUtils.setPos(this._textBgPower,"asset.game.mouseState.textBg.powerPosLeft");
            PositionUtils.setPos(this._textBgDegree,"asset.game.mouseState.textBg.degreePosLeft");
            PositionUtils.setPos(this._textPower,"asset.game.mouseState.text.powerPosLeft");
            PositionUtils.setPos(this._textDegree,"asset.game.mouseState.text.degreePosLeft");
            this._textpowerMC.x = this._textPower.x + 46;
            this._textpowerMC.y = this._textPower.y - 2;
            this._textdegreeMC.x = this._textDegree.x + 46;
            this._textdegreeMC.y = this._textDegree.y - 2;
         }
      }
      
      private function setCircleDirection() : void
      {
         this._circleRight.visible = this.localPlayer.direction == 1;
         this._circleLeft.visible = this.localPlayer.direction == -1;
      }
      
      private function setCurrentPowerPos() : void
      {
         this._currentPower.x = -this._currentPower.width / 2 - 1;
         this._currentPower.y = -3;
         this._lastPower.x = -this._lastPower.width / 2 + 7;
         this._lastPower.y = -3;
      }
      
      public function get mouseDown() : Boolean
      {
         return this._mouseDownLeft || this._mouseDownRight;
      }
      
      public function setPos() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         if(!this._self.map)
         {
            return;
         }
         var _loc1_:Point = new Point();
         if(this._self as GameLocalPlayer)
         {
            if(this.info.direction == 1)
            {
               _loc2_ = 8;
            }
            else
            {
               _loc2_ = -18;
            }
            _loc3_ = new Point((this._self as GameLocalPlayer).aim.x,(this._self as GameLocalPlayer).aim.y);
            _loc3_ = this._self.movie.localToGlobal(_loc3_);
            _loc1_.x = _loc3_.x - this._middlePoint.x + _loc2_;
            _loc1_.y = _loc3_.y - this._middlePoint.y;
         }
         else if(this._self as BossLocalPlayer)
         {
            _loc1_.x = this.info.shootPos.x - this._point.x;
            _loc1_.y = this.info.shootPos.y - this._point.y;
            _loc1_ = this._self.localToGlobal(_loc1_);
         }
         PositionUtils.setPos(this,this._map.globalToLocal(_loc1_));
         this.removeLastPowerLead();
      }
      
      private function __startDrag(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this.localPlayer.canNormalShoot)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.bossplayer.cannotusespace"));
            return;
         }
         this._currentPowerBig.visible = false;
         this._dragMouse = true;
         this.localPlayer.dispatchEvent(new GameEvent(GameEvent.MOUSE_MODEL_DOWN));
         this._self["localPlayer"].dispatchEvent(new LivingEvent(LivingEvent.BEGIN_SHOOT));
         if(this._fightLead)
         {
            ObjectUtils.disposeObject(this._fightLead);
            this._fightLead = null;
         }
         this.removeLastPowerLead();
      }
      
      public function removeLastPowerLead() : void
      {
         if(SharedManager.Instance.showLastPowerPointTips && this._lastPowerLead)
         {
            SharedManager.Instance.showLastPowerPointTips = false;
            SharedManager.Instance.save();
            ObjectUtils.disposeObject(this._lastPowerLead);
            this._lastPowerLead = null;
         }
      }
      
      private function __stopDrag(param1:GameEvent) : void
      {
         this._dragMouse = false;
      }
      
      private function removeEvent() : void
      {
         this.localPlayer.removeEventListener(GameEvent.MOUSE_MODEL_UP,this.__stopDrag);
         this.localPlayer.removeEventListener(LivingEvent.BOMB_CHANGED,this.__changeBall);
         this.localPlayer.removeEventListener(LivingEvent.DIR_CHANGED,this.__changeDir);
         this._currentPowerBig.removeEventListener(MouseEvent.MOUSE_DOWN,this.__startDrag);
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._middlePoint);
         this._middlePoint = null;
         ObjectUtils.disposeObject(this._sector);
         this._sector = null;
         ObjectUtils.disposeObject(this._circleRight);
         this._circleRight = null;
         ObjectUtils.disposeObject(this._circleLeft);
         this._circleLeft = null;
         ObjectUtils.disposeObject(this._circleSmall);
         this._circleSmall = null;
         ObjectUtils.disposeObject(this._shootSprite);
         this._shootSprite = null;
         ObjectUtils.disposeObject(this._powerLine);
         this._powerLine = null;
         ObjectUtils.disposeObject(this._powerLineSector);
         this._powerLineSector = null;
         ObjectUtils.disposeObject(this._triangle);
         this._triangle = null;
         ObjectUtils.disposeObject(this._textBgDegree);
         this._textBgDegree = null;
         ObjectUtils.disposeObject(this._textBgPower);
         this._textBgPower = null;
         ObjectUtils.disposeObject(this._currentPower);
         this._currentPower = null;
         ObjectUtils.disposeObject(this._lineAndPoint);
         this._lineAndPoint = null;
         ObjectUtils.disposeObject(this._currentPowerBig);
         this._currentPowerBig = null;
         ObjectUtils.disposeObject(this._textPower);
         this._textPower = null;
         ObjectUtils.disposeObject(this._textDegree);
         this._textDegree = null;
         ObjectUtils.disposeObject(this._textpowerMC);
         this._textpowerMC = null;
         ObjectUtils.disposeObject(this._textdegreeMC);
         this._textdegreeMC = null;
         ObjectUtils.disposeObject(this._fightLead);
         this._fightLead = null;
         ObjectUtils.disposeObject(this._lastPowerLead);
         this._lastPowerLead = null;
         ObjectUtils.disposeObject(this._lastPowerLine);
         this._lastPowerLine = null;
         ObjectUtils.disposeObject(this._lastPower);
         this._lastPower = null;
         ObjectUtils.disposeObject(this._lastPowerLineSector);
         this._lastPowerLineSector = null;
         this._point = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}
