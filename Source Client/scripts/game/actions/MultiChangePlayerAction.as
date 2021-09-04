package game.actions
{
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.PathInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import game.GameManager;
   import game.animations.AnimationLevel;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.model.TurnedLiving;
   import game.objects.GameLiving;
   import game.objects.SimpleBox;
   import game.view.map.MapView;
   import org.aswing.KeyboardManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   
   public class MultiChangePlayerAction extends BaseAction
   {
       
      
      private var _gameInfo:GameInfo;
      
      private var _map:MapView;
      
      private var _info:Living;
      
      private var _count:int;
      
      private var _changed:Boolean;
      
      private var _pkg:PackageIn;
      
      private var _event:CrazyTankSocketEvent;
      
      private var _isFirstExecute:Boolean = true;
      
      private var _isNewTurn:Boolean;
      
      public function MultiChangePlayerAction(param1:MapView, param2:Living, param3:CrazyTankSocketEvent, param4:PackageIn, param5:Number = 200)
      {
         super();
         this._event = param3;
         this._event.executed = false;
         this._pkg = param4;
         this._map = param1;
         this._info = param2;
         this._count = param5 / 40;
         this._gameInfo = GameManager.Instance.Current;
      }
      
      private function syncMap() : void
      {
         var _loc9_:LocalPlayer = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:SimpleBox = null;
         var _loc19_:int = 0;
         var _loc20_:Boolean = false;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:Boolean = false;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:Living = null;
         GameManager.Instance.Current.currentTurn = this._pkg.readInt();
         this._isNewTurn = GameManager.Instance.Current.isTurnChanged();
         var _loc1_:Boolean = this._pkg.readBoolean();
         var _loc2_:int = this._pkg.readByte();
         var _loc3_:int = this._pkg.readByte();
         var _loc4_:int = this._pkg.readByte();
         var _loc5_:Array = [_loc1_,_loc2_,_loc3_,_loc4_];
         GameManager.Instance.Current.setWind(GameManager.Instance.Current.wind,this._info.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID,_loc5_);
         var _loc6_:Living = this._gameInfo.findLiving(this._pkg.extend2);
         var _loc7_:Boolean = this._pkg.readBoolean();
         if(_loc6_)
         {
            _loc6_.isHidden = _loc7_;
         }
         var _loc8_:int = this._pkg.readInt();
         if(this._info is LocalPlayer)
         {
            _loc9_ = LocalPlayer(this._info);
            if(_loc8_ > 0)
            {
               _loc9_.turnTime = _loc8_;
            }
            else
            {
               _loc9_.turnTime = RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType);
            }
            if(_loc8_ != RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType))
            {
            }
         }
         var _loc10_:int = this._pkg.readInt();
         var _loc11_:uint = 0;
         while(_loc11_ < _loc10_)
         {
            _loc14_ = this._pkg.readInt();
            _loc15_ = this._pkg.readInt();
            _loc16_ = this._pkg.readInt();
            _loc17_ = this._pkg.readInt();
            if(this._isNewTurn)
            {
               _loc18_ = new SimpleBox(_loc14_,String(PathInfo.GAME_BOXPIC),_loc17_);
               _loc18_.x = _loc15_;
               _loc18_.y = _loc16_;
               this._map.addPhysical(_loc18_);
            }
            _loc11_++;
         }
         var _loc12_:int = this._pkg.readInt();
         var _loc13_:int = 0;
         while(_loc13_ < _loc12_)
         {
            _loc19_ = this._pkg.readInt();
            _loc20_ = this._pkg.readBoolean();
            _loc21_ = this._pkg.readBoolean();
            _loc22_ = this._pkg.readBoolean();
            _loc23_ = this._pkg.readInt();
            _loc24_ = this._pkg.readInt();
            _loc25_ = this._pkg.readInt();
            _loc26_ = this._pkg.readInt();
            _loc27_ = this._pkg.readBoolean();
            _loc28_ = this._pkg.readInt();
            _loc29_ = this._pkg.readInt();
            _loc30_ = this._pkg.readInt();
            _loc31_ = this._pkg.readInt();
            _loc32_ = this._pkg.readInt();
            _loc33_ = this._pkg.readInt();
            _loc34_ = GameManager.Instance.Current.livings[_loc19_];
            if(_loc34_)
            {
               _loc34_.isHidden = _loc21_;
               _loc34_.isFrozen = _loc22_;
               _loc34_.updateBlood(_loc26_,5);
               _loc34_.isNoNole = _loc27_;
               _loc34_.maxEnergy = _loc28_;
               _loc34_.psychic = _loc29_;
               if(_loc34_.isSelf)
               {
                  _loc9_ = LocalPlayer(_loc34_);
                  _loc9_.turnTime = _loc23_;
                  _loc9_.energy = _loc34_.maxEnergy;
                  _loc9_.shootCount = _loc33_;
                  _loc9_.dander = _loc30_;
                  if(_loc9_.currentPet)
                  {
                     _loc9_.currentPet.MaxMP = _loc31_;
                     _loc9_.currentPet.MP = _loc32_;
                  }
               }
               if(!_loc20_)
               {
                  _loc34_.die();
               }
               else
               {
                  _loc34_.onChange = false;
                  _loc34_.pos = new Point(_loc24_,_loc25_);
                  _loc34_.onChange = true;
               }
            }
            _loc13_++;
         }
         if(!this._isNewTurn)
         {
            this.changePlayer();
         }
      }
      
      override public function execute() : void
      {
         if(this._isFirstExecute)
         {
            this._map.lockOwner = -1;
            this._map.animateSet.lockLevel = AnimationLevel.LOW;
            this._isFirstExecute = false;
         }
         if(!this._changed)
         {
            if(this._map.hasSomethingMoving() == false && (this._map.currentPlayer == null || this._map.currentPlayer.actionCount == 0))
            {
               this.executeImp(false);
            }
         }
         else
         {
            --this._count;
            if(this._count <= 0)
            {
               this.changePlayer();
            }
         }
      }
      
      private function changePlayer() : void
      {
         var _loc2_:Living = null;
         var _loc1_:int = this._pkg.extend1;
         if(this._isNewTurn && this._info is TurnedLiving)
         {
            for each(_loc2_ in GameManager.Instance.Current.livings)
            {
               _loc2_.lastBombIndex = -1;
               if(_loc2_ is Player && _loc2_.team == _loc1_)
               {
                  TurnedLiving(_loc2_).isAttacking = _loc2_.isLiving && !_loc2_.isFrozen;
                  TurnedLiving(_loc2_).isReady = false;
               }
            }
         }
         this._gameInfo.selfGamePlayer.soulPropCount = 0;
         this._map.gameView.updateControlBarState(this._info);
         _isFinished = true;
      }
      
      override public function cancel() : void
      {
         this._event.executed = true;
      }
      
      private function executeImp(param1:Boolean) : void
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:Living = null;
         var _loc4_:LocalPlayer = null;
         var _loc5_:Living = null;
         var _loc6_:GameLiving = null;
         var _loc7_:MovieClipWrapper = null;
         if(!this._info || !this._info.isExist)
         {
            _isFinished = true;
            this._map.gameView.updateControlBarState(null);
            return;
         }
         if(!this._changed)
         {
            this._event.executed = true;
            this._changed = true;
            if(this._pkg)
            {
               this.syncMap();
            }
            if(this._isNewTurn)
            {
               _loc2_ = GameManager.Instance.Current.livings;
               for each(_loc3_ in _loc2_)
               {
                  _loc3_.beginNewTurn();
               }
               this._map.gameView.setCurrentPlayer(this._info);
               if(this._info is Player)
               {
                  if(this._info.playerInfo && this._info.playerInfo.isSelf && !this._info.isFrozen && this._info.isLiving)
                  {
                     (this._map.getPhysical(this._info.LivingID) as GameLiving).needFocus(0,0,{"priority":3},true);
                     this._map.lockOwner = this._gameInfo.self.LivingID;
                  }
                  else
                  {
                     _loc5_ = this._gameInfo.getNearestPlayer(this._gameInfo.teams[this._gameInfo.currentTeam]);
                     if(_loc5_)
                     {
                        _loc6_ = this._map.getPhysical(_loc5_.LivingID) as GameLiving;
                        if(_loc6_)
                        {
                           if(_loc6_ is Player)
                           {
                              this._map.lockOwner = _loc6_.info.LivingID;
                           }
                           _loc6_.needFocus(0,0,{"priority":3},true);
                        }
                     }
                  }
               }
               else
               {
                  (this._map.getPhysical(this._info.LivingID) as GameLiving).needFocus(0,0,{"priority":3},true);
               }
               this._info.gemDefense = false;
               if(!param1 && this._info.isLiving && this._info is LocalPlayer && this._info.isLiving && !this._info.isFrozen)
               {
                  KeyboardManager.getInstance().reset();
                  SoundManager.instance.play("016");
                  _loc7_ = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.TurnAsset")),true,true);
                  _loc7_.repeat = false;
                  _loc7_.movie.mouseChildren = _loc7_.movie.mouseEnabled = false;
                  _loc7_.movie.x = 440;
                  _loc7_.movie.y = 180;
                  this._map.gameView.addChild(_loc7_.movie);
               }
               else
               {
                  SoundManager.instance.play("038");
                  this.changePlayer();
               }
               _loc4_ = GameManager.Instance.Current.selfGamePlayer;
               if(this._map.currentPlayer)
               {
                  if(_loc4_)
                  {
                     _loc4_.soulPropEnabled = !_loc4_.isLiving && this._map.currentPlayer.team == _loc4_.team;
                  }
               }
               else if(_loc4_)
               {
                  _loc4_.soulPropEnabled = false;
               }
               PrepareShootAction.hasDoSkillAnimation = false;
            }
         }
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this.executeImp(true);
      }
   }
}
