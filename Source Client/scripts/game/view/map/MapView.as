package game.view.map
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PathInfo;
   import ddt.data.map.MapInfo;
   import ddt.loader.MapLoader;
   import ddt.manager.ChatManager;
   import ddt.manager.IMEManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.view.FaceContainer;
   import ddt.view.chat.ChatEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Transform;
   import flash.system.IME;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import game.GameManager;
   import game.actions.ActionManager;
   import game.actions.BaseAction;
   import game.animations.AnimationLevel;
   import game.animations.AnimationSet;
   import game.animations.BaseSetCenterAnimation;
   import game.animations.IAnimate;
   import game.animations.MultiSpellSkillAnimation;
   import game.animations.NewHandAnimation;
   import game.animations.ShockingSetCenterAnimation;
   import game.animations.SpellSkillAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.model.TurnedLiving;
   import game.objects.GameLiving;
   import game.objects.GamePlayer;
   import game.view.GameViewBase;
   import game.view.smallMap.SmallMapView;
   import im.IMController;
   import phy.maps.Ground;
   import phy.maps.Map;
   import phy.object.PhysicalObj;
   import phy.object.Physics;
   
   public class MapView extends Map
   {
      
      public static const ADD_BOX:String = "addBox";
      
      public static const FRAMERATE_OVER_COUNT:int = 25;
      
      public static const OVER_FRAME_GAPE:int = 46;
       
      
      private var _game:GameInfo;
      
      private var _info:MapInfo;
      
      private var _animateSet:AnimationSet;
      
      private var _minX:Number;
      
      private var _minY:Number;
      
      private var _minScaleX:Number;
      
      private var _minScaleY:Number;
      
      private var _minSkyScaleX:Number;
      
      private var _minScale:Number;
      
      private var _smallMap:SmallMapView;
      
      private var _actionManager:ActionManager;
      
      public var gameView:GameViewBase;
      
      public var currentFocusedLiving:GameLiving;
      
      private var _circle:Shape;
      
      private var _y:Number;
      
      private var _x:Number;
      
      private var _screenRect:Rectangle;
      
      public var isMultiShootMap:Boolean;
      
      private var _lockPositon:Boolean;
      
      private var _currentFocusedLiving:GameLiving;
      
      private var _currentFocusLevel:int;
      
      private var _currentPlayer:TurnedLiving;
      
      private var _smallObjs:Array;
      
      private var _scale:Number = 1;
      
      private var _frameRateCounter:int;
      
      private var _currentFrameRateOverCount:int = 0;
      
      private var _frameRateAlert:BaseAlerFrame;
      
      private var _objects:Dictionary;
      
      public var _gamePlayerList:Vector.<GamePlayer>;
      
      private var expName:Vector.<String>;
      
      private var expDic:Dictionary;
      
      private var _currentTopLiving:GameLiving;
      
      private var _container:Sprite;
      
      public function MapView(param1:GameInfo, param2:MapLoader)
      {
         this._objects = new Dictionary();
         this._gamePlayerList = new Vector.<GamePlayer>();
         this.expName = new Vector.<String>();
         this.expDic = new Dictionary();
         GameManager.Instance.Current.selfGamePlayer.currentMap = this;
         this._game = param1;
         var _loc3_:Bitmap = new Bitmap(param2.backBmp.bitmapData);
         var _loc4_:Ground = Boolean(param2.foreBmp) ? new Ground(param2.foreBmp.bitmapData.clone(),true) : null;
         var _loc5_:Ground = Boolean(param2.deadBmp) ? new Ground(param2.deadBmp.bitmapData.clone(),false) : null;
         var _loc6_:MapInfo = param2.info;
         _loc3_.cacheAsBitmap = true;
         super(_loc3_,_loc4_,_loc5_,param2.middle);
         airResistance = _loc6_.DragIndex;
         gravity = _loc6_.Weight;
         this._info = _loc6_;
         this._animateSet = new AnimationSet(this,PathInfo.GAME_WIDTH,PathInfo.GAME_HEIGHT);
         this._smallMap = new SmallMapView(this,GameManager.Instance.Current.missionInfo);
         this._smallMap.update();
         this._smallObjs = new Array();
         this._minX = -bound.width + PathInfo.GAME_WIDTH;
         this._minY = -bound.height + PathInfo.GAME_HEIGHT;
         this._minScaleX = PathInfo.GAME_WIDTH / bound.width;
         this._minScaleY = PathInfo.GAME_HEIGHT / bound.height;
         this._minSkyScaleX = PathInfo.GAME_WIDTH / _sky.width;
         if(this._minScaleX < this._minScaleY)
         {
            this._minScale = this._minScaleY;
         }
         else
         {
            this._minScale = this._minScaleX;
         }
         if(this._minScaleX < this._minSkyScaleX)
         {
            this._minScale = this._minSkyScaleX;
         }
         else
         {
            this._minScale = this._minScaleX;
         }
         this._actionManager = new ActionManager();
         this.setCenter(this._info.ForegroundWidth / 2,this._info.ForegroundHeight / 2,false,AnimationLevel.MIDDLE,AnimationSet.PUBLIC_OWNER);
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         ChatManager.Instance.addEventListener(ChatEvent.SET_FACECONTIANER_LOCTION,this.__setFacecontainLoctionAction);
      }
      
      public function get lockPositon() : Boolean
      {
         return this._lockPositon;
      }
      
      public function set lockPositon(param1:Boolean) : void
      {
         this._lockPositon = param1;
      }
      
      public function requestForFocus(param1:GameLiving, param2:int = 0) : void
      {
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         var _loc3_:int = GameManager.Instance.Current.selfGamePlayer.pos.x;
         var _loc4_:int = GameManager.Instance.Current.selfGamePlayer.pos.y;
         if(this._currentFocusedLiving)
         {
            if(Math.abs(param1.pos.x - _loc3_) > Math.abs(this._currentFocusedLiving.x - _loc3_))
            {
               return;
            }
         }
         if(param2 < this._currentFocusLevel)
         {
            return;
         }
         this._currentFocusedLiving = param1;
         this._currentFocusLevel = param2;
         this._currentFocusedLiving.needFocus(0,0,{
            "strategy":"directly",
            "priority":param2
         });
      }
      
      public function cancelFocus(param1:GameLiving = null) : void
      {
         if(param1 == null)
         {
            this._currentFocusedLiving = null;
            this._currentFocusLevel = 0;
         }
         if(param1 == this._currentFocusedLiving)
         {
            this._currentFocusedLiving = null;
            this._currentFocusLevel = 0;
         }
      }
      
      public function get currentPlayer() : TurnedLiving
      {
         return this._currentPlayer;
      }
      
      public function set currentPlayer(param1:TurnedLiving) : void
      {
         this._currentPlayer = param1;
      }
      
      public function get game() : GameInfo
      {
         return this._game;
      }
      
      public function get info() : MapInfo
      {
         return this._info;
      }
      
      public function get smallMap() : SmallMapView
      {
         return this._smallMap;
      }
      
      public function get animateSet() : AnimationSet
      {
         return this._animateSet;
      }
      
      private function __setFacecontainLoctionAction(param1:Event) : void
      {
         this.setExpressionLoction();
      }
      
      private function get minX() : Number
      {
         return -bound.width * this.scale + PathInfo.GAME_WIDTH;
      }
      
      private function get minY() : Number
      {
         return -bound.height * this.scale + PathInfo.GAME_HEIGHT;
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         stage.focus = this;
         if(ChatManager.Instance.input.parent)
         {
            SoundManager.instance.play("008");
            ChatManager.Instance.switchVisible();
         }
      }
      
      public function spellKill(param1:GamePlayer) : IAnimate
      {
         var _loc2_:SpellSkillAnimation = new SpellSkillAnimation(param1.x,param1.y,PathInfo.GAME_WIDTH,PathInfo.GAME_HEIGHT,this._info.ForegroundWidth,this._info.ForegroundHeight,param1,this.gameView);
         this.animateSet.addAnimation(_loc2_);
         SoundManager.instance.play("097");
         return _loc2_;
      }
      
      public function playMultiSpellkill(param1:Vector.<GamePlayer>) : IAnimate
      {
         var _loc2_:Player = this._game.findLiving(this._animateSet.lockOwnerID) as Player;
         if(!_loc2_)
         {
            _loc2_ = param1[0].player;
         }
         var _loc3_:MultiSpellSkillAnimation = new MultiSpellSkillAnimation(_loc2_.pos.x,_loc2_.pos.y,PathInfo.GAME_WIDTH,PathInfo.GAME_HEIGHT,this._info.ForegroundWidth,this._info.ForegroundHeight,param1,this.gameView);
         this.animateSet.addAnimation(_loc3_);
         SoundManager.instance.play("097");
         return _loc3_;
      }
      
      public function get isPlayingMovie() : Boolean
      {
         return this._animateSet.current is SpellSkillAnimation || this._animateSet.current is MultiSpellSkillAnimation;
      }
      
      override public function set x(param1:Number) : void
      {
         param1 = param1 < this.minX ? Number(this.minX) : (param1 > 0 ? Number(0) : Number(param1));
         this._x = param1;
         super.x = this._x;
      }
      
      override public function set y(param1:Number) : void
      {
         param1 = param1 < this.minY ? Number(this.minY) : (param1 > 0 ? Number(0) : Number(param1));
         this._y = param1;
         super.y = this._y;
      }
      
      override public function get x() : Number
      {
         return this._x;
      }
      
      override public function get y() : Number
      {
         return this._y;
      }
      
      override public function set transform(param1:Transform) : void
      {
         super.transform = param1;
      }
      
      public function set scale(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 < this._minScale)
         {
            param1 = this._minScale;
         }
         this._scale = param1;
         var _loc2_:Matrix = new Matrix();
         _loc2_.scale(this._scale,this._scale);
         transform.matrix = _loc2_;
         _sky.scaleX = _sky.scaleY = Math.pow(this._scale,-1 / 2);
         this.updateSky();
      }
      
      public function get minScale() : Number
      {
         return this._minScale;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function setCenter(param1:Number, param2:Number, param3:Boolean, param4:int = 1, param5:int = -1) : void
      {
         this._animateSet.addAnimation(new BaseSetCenterAnimation(param1,param2,50,!param3,AnimationLevel.MIDDLE,param5));
      }
      
      public function scenarioSetCenter(param1:Number, param2:Number, param3:int) : void
      {
         switch(param3)
         {
            case 3:
               this._animateSet.addAnimation(new ShockingSetCenterAnimation(param1,param2,50,false,AnimationLevel.HIGHT,9,AnimationSet.PUBLIC_OWNER));
               break;
            case 2:
               this._animateSet.addAnimation(new ShockingSetCenterAnimation(param1,param2,165,false,AnimationLevel.HIGHT,9,AnimationSet.PUBLIC_OWNER));
               break;
            default:
               this._animateSet.addAnimation(new BaseSetCenterAnimation(param1,param2,100,false,AnimationLevel.HIGHT,AnimationSet.PUBLIC_OWNER,4));
         }
      }
      
      public function addAnimation(param1:IAnimate, param2:*) : void
      {
         this._animateSet.addAnimation(param1);
      }
      
      public function livingSetCenter(param1:Number, param2:Number, param3:Boolean, param4:int = 2, param5:int = 0, param6:Object = null) : void
      {
         if(param6 is Living)
         {
            param6 = null;
         }
         if(this._animateSet)
         {
            this._animateSet.addAnimation(new BaseSetCenterAnimation(param1,param2,25,!param3,param4,param5,0,param6));
         }
      }
      
      public function setSelfCenter(param1:Boolean, param2:int = 2, param3:Object = null) : void
      {
         var _loc4_:Living = this._game.livings[this._game.selfGamePlayer.LivingID];
         if(_loc4_ == null)
         {
            return;
         }
         this._animateSet.addAnimation(new BaseSetCenterAnimation(_loc4_.pos.x - 50,_loc4_.pos.y - 150,25,!param1,param2,_loc4_.LivingID,0,param3));
      }
      
      public function act(param1:BaseAction) : void
      {
         this._actionManager.act(param1);
      }
      
      public function showShoot(param1:Number, param2:Number) : void
      {
         this._circle = new Shape();
         this._circle.graphics.beginFill(16711680);
         this._circle.graphics.drawCircle(param1,param2,3);
         this._circle.graphics.drawCircle(param1,param2,1);
         this._circle.graphics.endFill();
         addChild(this._circle);
      }
      
      override protected function update(param1:Boolean = true) : void
      {
         super.update(param1);
         if(!IMController.Instance.privateChatFocus)
         {
            if(ChatManager.Instance.input.parent == null)
            {
               if(IME.enabled)
               {
                  IMEManager.disable();
               }
               if(stage && stage.focus == null)
               {
                  stage.focus = this;
               }
            }
            if(StageReferance.stage.focus is TextField && TextField(StageReferance.stage.focus).type == TextFieldType.INPUT)
            {
               if(!IME.enabled)
               {
                  IMEManager.enable();
               }
            }
            else if(IME.enabled)
            {
               IMEManager.disable();
            }
         }
         else if(!IME.enabled)
         {
            IMEManager.enable();
         }
         this._actionManager.execute();
         if(this._animateSet.update())
         {
            this.updateSky();
         }
         this.checkOverFrameRate();
         if(!this._lockPositon)
         {
            this.x = this.x;
            this.y = this.y;
         }
      }
      
      private function checkOverFrameRate() : void
      {
         if(SharedManager.Instance.hasCheckedOverFrameRate)
         {
            return;
         }
         if(this._game == null)
         {
            return;
         }
         if(this._game.PlayerCount <= 4)
         {
            return;
         }
         if(this._currentPlayer && this._currentPlayer.LivingID == this._game.selfGamePlayer.LivingID)
         {
            return;
         }
         var _loc1_:int = getTimer();
         if(_loc1_ - this._frameRateCounter > OVER_FRAME_GAPE && this._frameRateCounter != 0)
         {
            ++this._currentFrameRateOverCount;
            if(this._currentFrameRateOverCount > FRAMERATE_OVER_COUNT)
            {
               if(this._frameRateAlert == null && SharedManager.Instance.showParticle)
               {
                  this._frameRateAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.game.map.smallMapView.slow"),"",LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  this._frameRateAlert.addEventListener(FrameEvent.RESPONSE,this.__onRespose);
                  SharedManager.Instance.hasCheckedOverFrameRate = true;
                  SharedManager.Instance.save();
               }
            }
         }
         else
         {
            this._currentFrameRateOverCount = 0;
         }
         this._frameRateCounter = _loc1_;
      }
      
      private function __onRespose(param1:FrameEvent) : void
      {
         this._frameRateAlert.removeEventListener(FrameEvent.RESPONSE,this.__onRespose);
         this._frameRateAlert.dispose();
         SharedManager.Instance.showParticle = false;
      }
      
      private function overFrameOk() : void
      {
         SharedManager.Instance.showParticle = false;
      }
      
      public function get mapBitmap() : Bitmap
      {
         var _loc1_:BitmapData = new BitmapData(StageReferance.stageWidth,StageReferance.stageHeight);
         var _loc2_:Point = globalToLocal(new Point(0,0));
         _loc1_.draw(this,new Matrix(1,0,0,1,-_loc2_.x,-_loc2_.y),null,null);
         return new Bitmap(_loc1_,"auto",true);
      }
      
      private function updateSky() : void
      {
         if(this._scale < 1)
         {
         }
         var _loc1_:Number = (_sky.width - PathInfo.GAME_WIDTH) / (bound.width - PathInfo.GAME_WIDTH);
         var _loc2_:Number = (_sky.height - PathInfo.GAME_HEIGHT) / (bound.height - PathInfo.GAME_HEIGHT);
         if(!isNaN(_loc1_))
         {
            _sky.x = -this.x + this.x * _loc1_;
         }
         if(!isNaN(_loc2_))
         {
            _sky.y = -this.y / scaleY + this.y * _loc2_ / scaleY;
         }
         this._smallMap.setScreenPos(this.x,this.y);
      }
      
      public function getPhysical(param1:int) : PhysicalObj
      {
         return this._objects[param1];
      }
      
      public function getPhysicalAll() : Dictionary
      {
         return this._objects;
      }
      
      override public function addPhysical(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         super.addPhysical(param1);
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            this._objects[_loc2_.Id] = _loc2_;
            if(_loc2_.smallView)
            {
               this._smallMap.addObj(_loc2_.smallView);
               this._smallMap.updatePos(_loc2_.smallView,_loc2_.pos);
            }
         }
         if(param1 is GamePlayer)
         {
            this._gamePlayerList.push(param1);
         }
      }
      
      private function controlExpNum(param1:GamePlayer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:FaceContainer = null;
         if(this.expName.length < 2)
         {
            if(this.expName.indexOf(param1.facecontainer.nickName.text) < 0)
            {
               this.expName.push(param1.facecontainer.nickName.text);
               this.expDic[param1.facecontainer.nickName.text] = param1.facecontainer;
            }
         }
         else if(this.expName.indexOf(param1.facecontainer.nickName.text) < 0)
         {
            _loc2_ = int(Math.random() * 2);
            _loc3_ = this.expName[_loc2_];
            _loc4_ = this.expDic[_loc3_] as FaceContainer;
            if(_loc4_.isActingExpression)
            {
               _loc4_.doClearFace();
            }
            this.expName[_loc2_] = param1.facecontainer.nickName.text;
            delete this.expDic[_loc3_];
            this.expDic[param1.facecontainer.nickName.text] = param1.facecontainer;
         }
      }
      
      private function resetDicAndVec(param1:GamePlayer) : void
      {
         var _loc2_:int = this.expName.indexOf(param1.facecontainer.nickName.text);
         if(_loc2_ >= 0)
         {
            delete this.expDic[this.expName[_loc2_]];
            this.expName.splice(_loc2_,1);
         }
      }
      
      public function setExpressionLoction() : void
      {
         var _loc2_:GamePlayer = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         if(this._gamePlayerList.length == 0)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._gamePlayerList.length)
         {
            _loc2_ = this._gamePlayerList[_loc1_];
            if(_loc2_ == null || !_loc2_.isLiving || _loc2_.facecontainer == null)
            {
               this._gamePlayerList.splice(_loc1_,1);
            }
            else if(_loc2_.facecontainer.isActingExpression)
            {
               if(!(_loc2_.facecontainer.expressionID >= 49 || _loc2_.facecontainer.expressionID <= 0))
               {
                  _loc3_ = this.localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  _loc4_ = this.onStageFlg(_loc3_);
                  if(_loc4_ == 0)
                  {
                     _loc2_.facecontainer.x = 0;
                     _loc2_.facecontainer.y = -100;
                     this.resetDicAndVec(_loc2_);
                     _loc2_.facecontainer.isShowNickName = false;
                  }
                  else if(_loc4_ == 1)
                  {
                     _loc2_.facecontainer.x = _loc2_.facecontainer.width / 2 + 30 - _loc3_.x;
                     _loc2_.facecontainer.y = 270 + _loc2_.facecontainer.height / 2 - _loc3_.y;
                     this.controlExpNum(_loc2_);
                     _loc2_.facecontainer.isShowNickName = true;
                  }
                  if(this.expName.length == 2)
                  {
                     (this.expDic[this.expName[1]] as FaceContainer).x += 80;
                  }
               }
            }
            else
            {
               _loc2_.facecontainer.x = 0;
               _loc2_.facecontainer.y = -100;
               _loc2_.facecontainer.isShowNickName = false;
               this.resetDicAndVec(_loc2_);
            }
            _loc1_++;
         }
      }
      
      private function onStageFlg(param1:Point) : int
      {
         if(param1 == null)
         {
            return 100;
         }
         if(param1.x >= 0 && param1.x <= 1000 && param1.y >= 0 && param1.y <= 600)
         {
            return 0;
         }
         return 1;
      }
      
      public function addObject(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            this._objects[_loc2_.Id] = _loc2_;
         }
      }
      
      public function bringToFront(param1:Living) : void
      {
         var _loc3_:GamePlayer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc2_:Physics = this._objects[param1.LivingID] as Physics;
         if(_loc2_)
         {
            super.addPhysical(_loc2_);
            if(_loc2_ is GamePlayer)
            {
               _loc3_ = _loc2_ as GamePlayer;
               if(_loc3_ && _livingLayer.contains(_loc3_) && _loc3_.gamePet && _livingLayer.contains(_loc3_.gamePet))
               {
                  _loc4_ = _livingLayer.getChildIndex(_loc3_.gamePet);
                  _loc5_ = _livingLayer.getChildIndex(_loc3_);
                  if(_loc3_.gamePet.isDefence)
                  {
                     _livingLayer.addChildAt(_loc3_.gamePet,Math.max(_loc4_,_loc5_));
                  }
                  else
                  {
                     _livingLayer.addChildAt(_loc3_.gamePet,Math.min(_loc4_,_loc5_));
                  }
               }
            }
         }
      }
      
      public function phyBringToFront(param1:PhysicalObj) : void
      {
         if(param1)
         {
            super.addChild(param1);
         }
      }
      
      override public function removePhysical(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         super.removePhysical(param1);
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            if(this._objects && this._objects[_loc2_.Id])
            {
               delete this._objects[_loc2_.Id];
            }
            if(this._smallMap && _loc2_.smallView)
            {
               this._smallMap.removeObj(_loc2_.smallView);
            }
         }
      }
      
      override public function addMapThing(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         super.addMapThing(param1);
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            this._objects[_loc2_.Id] = _loc2_;
            if(_loc2_.smallView)
            {
               this._smallMap.addObj(_loc2_.smallView);
               this._smallMap.updatePos(_loc2_.smallView,_loc2_.pos);
            }
         }
      }
      
      override public function removeMapThing(param1:Physics) : void
      {
         var _loc2_:PhysicalObj = null;
         super.removeMapThing(param1);
         if(param1 is PhysicalObj)
         {
            _loc2_ = param1 as PhysicalObj;
            if(this._objects[_loc2_.Id])
            {
               delete this._objects[_loc2_.Id];
            }
            if(_loc2_.smallView)
            {
               this._smallMap.removeObj(_loc2_.smallView);
            }
         }
      }
      
      public function get actionCount() : int
      {
         return this._actionManager.actionCount;
      }
      
      public function lockFocusAt(param1:Point) : void
      {
         this.animateSet.addAnimation(new NewHandAnimation(param1.x,param1.y - 150,int.MAX_VALUE,false,AnimationLevel.HIGHEST));
      }
      
      public function releaseFocus() : void
      {
         this.animateSet.clear();
      }
      
      public function executeAtOnce() : void
      {
         this._actionManager.executeAtOnce();
         this._animateSet.clear();
      }
      
      public function bringToStageTop(param1:PhysicalObj) : void
      {
         if(this._currentTopLiving)
         {
            this.addPhysical(this._currentTopLiving);
         }
         if(this._container && this._container.parent)
         {
            this._container.parent.removeChild(this._container);
         }
         this._currentTopLiving = this._objects[param1.Id] as GameLiving;
         if(this._container == null)
         {
            this._container = new Sprite();
            this._container.x = this.x;
            this._container.y = this.y;
         }
         if(this._currentTopLiving)
         {
            this._container.addChild(this._currentTopLiving);
         }
         LayerManager.Instance.addToLayer(this._container,LayerManager.GAME_BASE_LAYER,false,0,false);
      }
      
      public function restoreStageTopLiving() : void
      {
         if(this._currentTopLiving && this._currentTopLiving.isExist)
         {
            this.addPhysical(this._currentTopLiving);
         }
         if(this._container && this._container.parent)
         {
            this._container.parent.removeChild(this._container);
         }
         this._currentTopLiving = null;
      }
      
      public function setMatrx(param1:Matrix) : void
      {
         transform.matrix = param1;
         if(this._container)
         {
            this._container.transform.matrix = param1;
         }
      }
      
      public function getContains(param1:Number, param2:Number, param3:Number = 1000, param4:Number = 600) : Boolean
      {
         var _loc5_:Number = -this._x + (PathInfo.GAME_WIDTH - param3) / 2;
         var _loc6_:Number = -this._y + (PathInfo.GAME_HEIGHT - param4) / 2;
         this._screenRect = new Rectangle(_loc5_,_loc6_,param3,param4);
         return this._screenRect.contains(param1,param2);
      }
      
      public function getMarginal(param1:Number, param2:Number, param3:Number = 1000, param4:Number = 600, param5:Number = 0, param6:Number = 0) : Boolean
      {
         var _loc7_:Number = -this._x + param5;
         var _loc8_:Number = -this._y + param6;
         var _loc9_:Rectangle = new Rectangle(_loc7_,_loc8_,param3,param4);
         return _loc9_.contains(param1,param2);
      }
      
      public function hasScreen(param1:Number = 1000, param2:Number = 600) : Boolean
      {
         var _loc3_:Number = GameManager.Instance.Current.selfGamePlayer.pos.x;
         var _loc4_:Number = GameManager.Instance.Current.selfGamePlayer.pos.y;
         var _loc5_:Living = GameManager.Instance.getMinDistanceLiving(GameManager.Instance.Current.selfGamePlayer);
         if(!_loc5_)
         {
            return false;
         }
         return this.getContains(_loc3_,_loc4_,param1,param2) && this.getContains(_loc5_.pos.x,_loc5_.pos.y,param1,param2);
      }
      
      public function hasScreenCentre(param1:Number = 1000, param2:Number = 600, param3:Number = 0, param4:Number = 0) : Boolean
      {
         var _loc5_:Number = GameManager.Instance.Current.selfGamePlayer.pos.x;
         var _loc6_:Number = GameManager.Instance.Current.selfGamePlayer.pos.y;
         var _loc7_:Living = GameManager.Instance.getMinDistanceLiving(GameManager.Instance.Current.selfGamePlayer);
         if(!_loc7_)
         {
            return false;
         }
         return this.getMarginal(_loc5_,_loc6_,param1,param2,param3,param4) && this.getMarginal(_loc7_.pos.x,_loc7_.pos.y,param1,param2,param3,param4);
      }
      
      public function set lockOwner(param1:int) : void
      {
         this._animateSet.lockOwnerID = param1;
      }
      
      public function get lockOwner() : int
      {
         return this._animateSet.lockOwnerID;
      }
      
      override public function dispose() : void
      {
         var _loc1_:PhysicalObj = null;
         super.dispose();
         this._currentTopLiving = null;
         ChatManager.Instance.removeEventListener(ChatEvent.SET_FACECONTIANER_LOCTION,this.__setFacecontainLoctionAction);
         ObjectUtils.disposeObject(this._container);
         this._container = null;
         if(this._frameRateAlert != null)
         {
            this._frameRateAlert.removeEventListener(FrameEvent.RESPONSE,this.__onRespose);
            this._frameRateAlert.dispose();
            this._frameRateAlert = null;
         }
         for each(_loc1_ in this._objects)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._objects = null;
         this._game = null;
         this._info = null;
         this._currentFocusedLiving = null;
         this.currentFocusedLiving = null;
         this._currentPlayer = null;
         this._smallMap.dispose();
         this._smallMap = null;
         this._animateSet.dispose();
         this._animateSet = null;
         this._actionManager.clear();
         this._actionManager = null;
         this.gameView = null;
         this._gamePlayerList = null;
      }
   }
}
