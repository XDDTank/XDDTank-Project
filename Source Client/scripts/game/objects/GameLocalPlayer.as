package game.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PetSkillManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import game.GameManager;
   import game.actions.PlayerBeatAction;
   import game.actions.SelfPlayerWalkAction;
   import game.actions.SelfSkipAction;
   import game.animations.AnimationLevel;
   import game.animations.BaseSetCenterAnimation;
   import game.animations.DragMapAnimation;
   import game.model.LocalPlayer;
   import game.view.map.MapView;
   import game.view.prop.FightModelPropBar;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import pet.date.PetSkillInfo;
   import playerParticle.PlayerParticleManager;
   
   public class GameLocalPlayer extends GamePlayer
   {
      
      private static var MCframeNum:int = 33;
      
      private static const MAX_MOVE_TIME:int = 10;
       
      
      private var _takeAim:MovieClip;
      
      private var _moveStripContainer:Sprite;
      
      private var _moveStrip:Bitmap;
      
      private var _ballpos:Point;
      
      protected var _shootTimer:Timer;
      
      private var mouseAsset:MovieClip;
      
      private var _fightModelType:int = 0;
      
      private var _leadMC:MovieClip;
      
      private var _powerMC:MovieClip;
      
      private var _normalMC:MovieClip;
      
      private var _mouseDownLeft:Boolean = false;
      
      private var _mouseDownRight:Boolean = false;
      
      private var _dragMouse:Boolean = false;
      
      private var _showShoot:Boolean;
      
      private var _turned:Boolean;
      
      private var _keyDownTime:int;
      
      protected var _isShooting:Boolean = false;
      
      protected var _shootCount:int = 0;
      
      protected var _shootPoint:Point;
      
      private var _shootOverCount:int = 0;
      
      public function GameLocalPlayer(param1:LocalPlayer, param2:ShowCharacter, param3:GameCharacter = null)
      {
         super(param1,param2,param3);
      }
      
      public function get localPlayer() : LocalPlayer
      {
         return info as LocalPlayer;
      }
      
      public function get aim() : MovieClip
      {
         return this._takeAim;
      }
      
      public function get ballPos() : Point
      {
         return this._ballpos;
      }
      
      override public function set pos(param1:Point) : void
      {
         if(param1.x < 1000)
         {
         }
         this.x = param1.x;
         y = param1.y;
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
      }
      
      override protected function initView() : void
      {
         super.initView();
         body.mouseEnabled = true;
         body.mouseChildren = true;
         this._ballpos = new Point(30,-20);
         this._takeAim = ClassUtils.CreatInstance("asset.game.TakeAimAsset");
         this._takeAim.x = this._ballpos.x * -1;
         this._takeAim.y = this._ballpos.y;
         this._takeAim["hand"].rotation = this.localPlayer.currentWeapInfo.armMinAngle;
         this._takeAim.mouseChildren = this._takeAim.mouseEnabled = false;
         this._takeAim.visible = false;
         _player.addChild(this._takeAim);
         this._moveStripContainer = new Sprite();
         this._moveStripContainer.addChild(ComponentFactory.Instance.creatBitmap("asset.game.moveStripBgAsset"));
         this._moveStrip = ComponentFactory.Instance.creatBitmap("asset.game.moveStripAsset");
         this._moveStripContainer.addChild(this._moveStrip);
         this._moveStripContainer.mouseChildren = this._moveStripContainer.mouseEnabled = false;
         if(_consortiaName)
         {
            this._moveStripContainer.x = 0;
            this._moveStripContainer.y = _consortiaName.y + 22;
         }
         else
         {
            this._moveStripContainer.x = 0;
            this._moveStripContainer.y = _nickName.y + 22;
         }
         this.localPlayer.energy = this.localPlayer.maxEnergy;
         this.mouseAsset = ClassUtils.CreatInstance("asset.game.MouseShape") as MovieClip;
         this.mouseAsset.visible = false;
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("tian.shootSpeed2");
         this._shootTimer = new Timer(_loc1_.y);
         this._leadMC = ComponentFactory.Instance.creat("asset.game.fightModel.leadMC") as MovieClip;
         this._leadMC.addFrameScript(MCframeNum,this.__leadMCComplete);
         this._leadMC.gotoAndStop(1);
         this._leadMC.visible = false;
         this._powerMC = ComponentFactory.Instance.creat("asset.game.fightModel.powerMC") as MovieClip;
         this._powerMC.addFrameScript(MCframeNum,this.__powerMCComplete);
         this._powerMC.gotoAndStop(1);
         this._powerMC.visible = false;
         this._normalMC = ComponentFactory.Instance.creat("asset.game.fightModel.normalMC") as MovieClip;
         this._normalMC.addFrameScript(MCframeNum,this.__normalMCComplete);
         this._normalMC.gotoAndStop(1);
         this._normalMC.visible = false;
      }
      
      public function set showShoot(param1:Boolean) : void
      {
         if(this._showShoot == param1)
         {
            return;
         }
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         this.localPlayer.addEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShoot);
         this.localPlayer.addEventListener(LivingEvent.USE_SKILL_DIRECTLY,this.__useSkillDirectly);
         this.localPlayer.addEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChanged);
         this.localPlayer.addEventListener(LivingEvent.GUNANGLE_CHANGED,this.__gunangleChanged);
         this.localPlayer.addEventListener(LivingEvent.BEGIN_SHOOT,this.__beginShoot);
         this.localPlayer.addEventListener(LivingEvent.SKIP,this.__skip);
         this.localPlayer.addEventListener(LivingEvent.SETCENTER,this.__setCenter);
         this._shootTimer.addEventListener(TimerEvent.TIMER,this.__shootTimer);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_LEFT,this.__turnLeft);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_A,this.__turnLeft);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_RIGHT,this.__turnRight);
         KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_D,this.__turnRight);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_UP,this.__keyUp);
         GameManager.Instance.addEventListener(GameEvent.FIGHT_MODEL,this.__fightModelSocket);
         this.initMouseStateEvent();
      }
      
      private function initMouseStateEvent() : void
      {
         this.localPlayer.addEventListener(GameEvent.MOUSE_MODEL_UP,this.__stopDrag);
         this.localPlayer.addEventListener(GameEvent.MOUSE_UP_LEFT,this.__resetMouse);
         this.localPlayer.addEventListener(GameEvent.MOUSE_DOWN_LEFT,this.__mouseDownLeft);
         this.localPlayer.addEventListener(GameEvent.MOUSE_UP_Right,this.__resetMouse);
         this.localPlayer.addEventListener(GameEvent.MOUSE_DOWN_Right,this.__mouseDownRight);
         addEventListener(Event.ENTER_FRAME,this.__mouseStateEnterFrame);
      }
      
      private function __leadMCComplete() : void
      {
         this._leadMC.gotoAndStop(1);
         this._leadMC.visible = false;
      }
      
      private function __powerMCComplete() : void
      {
         this._powerMC.gotoAndStop(1);
         this._powerMC.visible = false;
      }
      
      private function __normalMCComplete() : void
      {
         this._normalMC.gotoAndStop(1);
         this._normalMC.visible = false;
      }
      
      private function __fightModelSocket(param1:GameEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:String = SharedManager.Instance.fightModelPropCellSave;
         if(_loc2_ == "N")
         {
            _loc3_ = this._normalMC;
            return;
         }
         if(_loc2_ == "E")
         {
            _loc3_ = this._leadMC;
         }
         else if(_loc2_ == "Q")
         {
            _loc3_ = this._powerMC;
         }
         var _loc4_:Point = ComponentFactory.Instance.creatCustomObject("FightModelPropBar.mc.point");
         addChild(_loc3_);
         _loc3_.play();
         PositionUtils.setPos(_loc3_,_loc4_);
         _loc3_.visible = true;
      }
      
      private function __setCenter(param1:LivingEvent) : void
      {
         var _loc2_:Array = param1.paras;
         map.animateSet.addAnimation(new DragMapAnimation(_loc2_[0],_loc2_[1],true,100,AnimationLevel.MIDDLE,_info.LivingID));
      }
      
      private function removeMouseStateEvent() : void
      {
         this.localPlayer.removeEventListener(GameEvent.MOUSE_MODEL_UP,this.__stopDrag);
         this.localPlayer.removeEventListener(GameEvent.MOUSE_UP_LEFT,this.__resetMouse);
         this.localPlayer.removeEventListener(GameEvent.MOUSE_DOWN_LEFT,this.__mouseDownLeft);
         this.localPlayer.removeEventListener(GameEvent.MOUSE_UP_Right,this.__resetMouse);
         this.localPlayer.removeEventListener(GameEvent.MOUSE_DOWN_Right,this.__mouseDownRight);
         removeEventListener(Event.ENTER_FRAME,this.__mouseStateEnterFrame);
      }
      
      override public function dispose() : void
      {
         GameManager.Instance.removeEventListener(GameEvent.FIGHT_MODEL,this.__fightModelSocket);
         this._shootTimer.removeEventListener(TimerEvent.TIMER,this.__shootTimer);
         this.localPlayer.removeEventListener(LivingEvent.SEND_SHOOT_ACTION,this.__sendShoot);
         this.localPlayer.removeEventListener(LivingEvent.USE_SKILL_DIRECTLY,this.__useSkillDirectly);
         this.localPlayer.removeEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChanged);
         this.localPlayer.removeEventListener(LivingEvent.GUNANGLE_CHANGED,this.__gunangleChanged);
         this.localPlayer.removeEventListener(LivingEvent.BEGIN_SHOOT,this.__beginShoot);
         this.localPlayer.removeEventListener(LivingEvent.SKIP,this.__skip);
         this.localPlayer.removeEventListener(LivingEvent.SETCENTER,this.__setCenter);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_LEFT,this.__turnLeft);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_A,this.__turnLeft);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_RIGHT,this.__turnRight);
         KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_D,this.__turnRight);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_UP,this.__keyUp);
         _map.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         this.removeMouseStateEvent();
         if(this._takeAim && this._takeAim.parent)
         {
            this._takeAim.parent.removeChild(this._takeAim);
         }
         this._takeAim.stop();
         this._takeAim = null;
         this._moveStripContainer.removeChild(this._moveStrip);
         this._moveStrip.bitmapData.dispose();
         this._moveStrip = null;
         if(this._moveStripContainer && this._moveStripContainer.parent)
         {
            this._moveStripContainer.parent.removeChild(this._moveStripContainer);
         }
         this._moveStripContainer = null;
         this._shootTimer.stop();
         this._shootTimer = null;
         this.mouseAsset.stop();
         if(this.mouseAsset.parent)
         {
            this.mouseAsset.parent.removeChild(this.mouseAsset);
         }
         this.mouseAsset = null;
         this._powerMC.stop();
         if(this._powerMC.parent)
         {
            this._powerMC.parent.removeChild(this._powerMC);
         }
         this._powerMC.addFrameScript(MCframeNum,this.__leadMCComplete);
         this._powerMC = null;
         this._leadMC.stop();
         if(this._leadMC.parent)
         {
            this._leadMC.parent.removeChild(this._leadMC);
         }
         this._leadMC.addFrameScript(MCframeNum,this.__leadMCComplete);
         this._leadMC = null;
         this._normalMC.stop();
         if(this._normalMC.parent)
         {
            this._normalMC.parent.removeChild(this._normalMC);
         }
         this._normalMC.addFrameScript(MCframeNum,this.__normalMCComplete);
         this._normalMC = null;
         super.dispose();
      }
      
      protected function __skip(param1:LivingEvent) : void
      {
         act(new SelfSkipAction(this.localPlayer));
      }
      
      private function __keyUp(param1:KeyboardEvent) : void
      {
         this._keyDownTime = 0;
      }
      
      private function __turnLeft() : void
      {
         if(!this._isShooting && !this._dragMouse)
         {
            if(info.direction == 1)
            {
               info.direction = -1;
               if(this._keyDownTime == 0)
               {
                  this._keyDownTime = getTimer();
               }
            }
            dispatchEvent(new GameEvent(GameEvent.TURN_LEFT));
            this.walk();
         }
      }
      
      private function __turnRight() : void
      {
         if(!this._isShooting && !this._dragMouse)
         {
            if(info.direction == -1)
            {
               info.direction = 1;
               if(this._keyDownTime == 0)
               {
                  this._keyDownTime = getTimer();
               }
            }
            dispatchEvent(new GameEvent(GameEvent.TURN_RIGHT));
            this.walk();
         }
      }
      
      protected function walk() : void
      {
         if(!_isMoving && this.localPlayer.isAttacking && (this._keyDownTime == 0 || getTimer() - this._keyDownTime > MAX_MOVE_TIME || this._mouseDownLeft || this._mouseDownRight) && !this.localPlayer.forbidMoving)
         {
            act(new SelfPlayerWalkAction(this));
         }
      }
      
      override public function startMoving() : void
      {
         _isMoving = true;
         PlayerParticleManager.instance.startParticle(creatParticle,cleanParticle,this);
      }
      
      override public function stopMoving() : void
      {
         _vx.clearMotion();
         _vy.clearMotion();
         _isMoving = false;
         PlayerParticleManager.instance.stopParticle(this);
      }
      
      override protected function __attackingChanged(param1:LivingEvent) : void
      {
         super.__attackingChanged(param1);
         if(this.localPlayer.isAttacking && this.localPlayer.isLiving)
         {
            act(new SelfPlayerWalkAction(this));
         }
         this.localPlayer.clearPropArr();
      }
      
      override protected function attackingViewChanged() : void
      {
         super.attackingViewChanged();
         if(this.localPlayer.isAttacking && this.localPlayer.isLiving)
         {
            this._takeAim.visible = !this.localPlayer.mouseState;
            addChild(this._moveStripContainer);
         }
         else
         {
            this._takeAim.visible = false;
            if(this._moveStripContainer.parent)
            {
               removeChild(this._moveStripContainer);
            }
         }
      }
      
      override public function die() : void
      {
         this.localPlayer.dander = 0;
         if(_player.contains(this._takeAim))
         {
            _player.removeChild(this._takeAim);
         }
         if(this._moveStripContainer && this._moveStripContainer.parent)
         {
            this._moveStripContainer.parent.removeChild(this._moveStripContainer);
         }
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,50,false,AnimationLevel.MIDDLE,_info.LivingID));
         map.addEventListener(MouseEvent.CLICK,this.__mouseClick);
         this._shootTimer.removeEventListener(TimerEvent.TIMER,this.__shootTimer);
         setCollideRect(-8,-8,16,16);
         super.die();
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         _loc2_ = _map.globalToLocal(new Point(param1.stageX,param1.stageY));
         _map.addChild(this.mouseAsset);
         SoundManager.instance.play("041");
         this.mouseAsset.x = _loc2_.x;
         this.mouseAsset.y = _loc2_.y;
         this.mouseAsset.visible = true;
         GameInSocketOut.sendGhostTarget(_loc2_);
      }
      
      public function hideTargetMouseTip() : void
      {
         this.mouseAsset.visible = false;
      }
      
      override protected function __usingItem(param1:LivingEvent) : void
      {
         super.__usingItem(param1);
         if(param1.paras[0] is ItemTemplateInfo)
         {
            this.localPlayer.energy -= int(param1.paras[0].Property4);
         }
      }
      
      protected function __sendShoot(param1:LivingEvent) : void
      {
         this._shootPoint = shootPoint();
         this.shootOverCount = this._shootCount = 0;
         this.localPlayer.isAttacking = false;
         this._isShooting = true;
         var _loc2_:String = SharedManager.Instance.fightModelPropCellSave;
         this._fightModelType = _loc2_ == FightModelPropBar.POWER ? int(2) : int(1);
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT,_info.LivingID));
         GameInSocketOut.sendGameCMDDirection(info.direction);
         GameInSocketOut.sendGameStartMove(0,this.x,this.y,this.info.direction,this.isLiving,GameManager.Instance.Current.currentTurn);
         GameInSocketOut.sendShootTag(true,this.localPlayer.shootTime);
         if(this.localPlayer.shootType == 0)
         {
            this.localPlayer.force = param1.paras[0];
            this._shootTimer.start();
            this.__shootTimer(null);
         }
         else
         {
            act(new PlayerBeatAction(this));
         }
      }
      
      protected function __useSkillDirectly(param1:LivingEvent) : void
      {
         SocketManager.Instance.out.sendPetSkill(param1.paras[0],param1.paras[1]);
      }
      
      private function __shootTimer(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(this.localPlayer && this.localPlayer.isLiving && this._shootCount < this.localPlayer.shootCount)
         {
            _loc2_ = this.localPlayer.calcBombAngle();
            _loc3_ = this.localPlayer.force;
            ++this._shootCount;
            GameInSocketOut.sendGameCMDShoot(this._shootPoint.x,this._shootPoint.y,_loc3_,_loc2_,this._fightModelType,this._shootCount >= this.localPlayer.shootCount);
            MapView(_map).gameView.setRecordRotation();
         }
      }
      
      override protected function __shoot(param1:LivingEvent) : void
      {
         super.__shoot(param1);
         this.localPlayer.lastFireBombs = param1.paras[0];
      }
      
      override protected function __beginNewTurn(param1:LivingEvent) : void
      {
         super.__beginNewTurn(param1);
         this.shootOverCount = this._shootCount = 0;
         this._shootTimer.reset();
         this._takeAim.visible = false;
         this._isShooting = false;
      }
      
      public function get shootOverCount() : int
      {
         return this._shootOverCount;
      }
      
      public function set shootOverCount(param1:int) : void
      {
         this._shootOverCount = param1;
         if(this._shootOverCount == this._shootCount)
         {
            this._isShooting = false;
         }
      }
      
      protected function __gunangleChanged(param1:LivingEvent) : void
      {
         this._takeAim["hand"].rotation = this.localPlayer.gunAngle;
      }
      
      protected function __beginShoot(param1:LivingEvent) : void
      {
         if(gamePet)
         {
            gamePet.prepareForShow();
         }
      }
      
      protected function __energyChanged(param1:LivingEvent) : void
      {
         if(this.localPlayer.isLiving)
         {
            this._moveStrip.scaleX = this.localPlayer.energy / this.localPlayer.maxEnergy;
         }
      }
      
      override protected function __usePetSkill(param1:LivingEvent) : void
      {
         super.__usePetSkill(param1);
         var _loc2_:PetSkillInfo = PetSkillManager.instance.getSkillByID(param1.value);
         if(_loc2_.isActiveSkill)
         {
            switch(_loc2_.BallType)
            {
               case 0:
               case 3:
                  this.localPlayer.spellKillEnabled = false;
                  break;
               case 1:
               case 2:
                  this.localPlayer.soulPropEnabled = this.localPlayer.propEnabled = this.localPlayer.flyEnabled = this.localPlayer.deputyWeaponEnabled = this.localPlayer.rightPropEnabled = this.localPlayer.spellKillEnabled = false;
            }
         }
      }
      
      public function get mouseDown() : Boolean
      {
         return this._mouseDownLeft || this._mouseDownRight;
      }
      
      private function __startDrag(param1:MouseEvent) : void
      {
         this._dragMouse = true;
      }
      
      private function __stopDrag(param1:GameEvent) : void
      {
         this._dragMouse = false;
      }
      
      private function __mouseDownLeft(param1:GameEvent) : void
      {
         this._mouseDownLeft = true;
      }
      
      private function __mouseDownRight(param1:GameEvent) : void
      {
         this._mouseDownRight = true;
      }
      
      private function __resetMouse(param1:GameEvent) : void
      {
         this._mouseDownLeft = false;
         this._mouseDownRight = false;
         this._keyDownTime = 0;
      }
      
      private function __mouseStateEnterFrame(param1:Event) : void
      {
         if(this._mouseDownLeft)
         {
            this.__turnLeft();
         }
         if(this._mouseDownRight)
         {
            this.__turnRight();
         }
      }
   }
}
