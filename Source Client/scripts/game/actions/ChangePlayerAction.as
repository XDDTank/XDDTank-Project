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
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.TurnedLiving;
   import game.objects.GameLiving;
   import game.objects.SimpleBox;
   import game.view.map.MapView;
   import org.aswing.KeyboardManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   
   public class ChangePlayerAction extends BaseAction
   {
       
      
      private var _map:MapView;
      
      private var _info:Living;
      
      private var _count:int;
      
      private var _changed:Boolean;
      
      private var _pkg:PackageIn;
      
      private var _event:CrazyTankSocketEvent;
      
      public function ChangePlayerAction(param1:MapView, param2:Living, param3:CrazyTankSocketEvent, param4:PackageIn, param5:Number = 200)
      {
         super();
         this._event = param3;
         this._event.executed = false;
         this._pkg = param4;
         this._map = param1;
         this._info = param2;
         this._count = param5 / 40;
      }
      
      private function syncMap() : void
      {
         var _loc7_:LocalPlayer = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:SimpleBox = null;
         var _loc17_:int = 0;
         var _loc18_:Boolean = false;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:Boolean = false;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:Living = null;
         GameManager.Instance.Current.currentTurn = this._pkg.readInt();
         var _loc1_:Boolean = this._pkg.readBoolean();
         var _loc2_:int = this._pkg.readByte();
         var _loc3_:int = this._pkg.readByte();
         var _loc4_:int = this._pkg.readByte();
         var _loc5_:Array = new Array();
         _loc5_ = [_loc1_,_loc2_,_loc3_,_loc4_];
         GameManager.Instance.Current.setWind(GameManager.Instance.Current.wind,this._info.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID,_loc5_);
         this._info.isHidden = this._pkg.readBoolean();
         var _loc6_:int = this._pkg.readInt();
         if(this._info is LocalPlayer)
         {
            _loc7_ = LocalPlayer(this._info);
            if(_loc6_ > 0)
            {
               _loc7_.turnTime = _loc6_;
            }
            else
            {
               _loc7_.turnTime = RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType);
            }
            if(_loc6_ != RoomManager.getTurnTimeByType(RoomManager.Instance.current.timeType))
            {
            }
         }
         var _loc8_:int = this._pkg.readInt();
         var _loc9_:uint = 0;
         while(_loc9_ < _loc8_)
         {
            _loc12_ = this._pkg.readInt();
            _loc13_ = this._pkg.readInt();
            _loc14_ = this._pkg.readInt();
            _loc15_ = this._pkg.readInt();
            _loc16_ = new SimpleBox(_loc12_,String(PathInfo.GAME_BOXPIC),_loc15_);
            _loc16_.x = _loc13_;
            _loc16_.y = _loc14_;
            this._map.addPhysical(_loc16_);
            _loc9_++;
         }
         var _loc10_:int = this._pkg.readInt();
         var _loc11_:int = 0;
         while(_loc11_ < _loc10_)
         {
            _loc17_ = this._pkg.readInt();
            _loc18_ = this._pkg.readBoolean();
            _loc19_ = this._pkg.readInt();
            _loc20_ = this._pkg.readInt();
            _loc21_ = this._pkg.readInt();
            _loc22_ = this._pkg.readBoolean();
            _loc23_ = this._pkg.readInt();
            _loc24_ = this._pkg.readInt();
            _loc25_ = this._pkg.readInt();
            _loc26_ = this._pkg.readInt();
            _loc27_ = this._pkg.readInt();
            _loc28_ = this._pkg.readInt();
            _loc29_ = GameManager.Instance.Current.livings[_loc17_];
            if(_loc29_)
            {
               _loc29_.updateBlood(_loc21_,5);
               _loc29_.isNoNole = _loc22_;
               _loc29_.maxEnergy = _loc23_;
               _loc29_.psychic = _loc24_;
               if(_loc29_.isSelf)
               {
                  _loc7_ = LocalPlayer(_loc29_);
                  _loc7_.energy = _loc29_.maxEnergy;
                  _loc7_.shootCount = _loc28_;
                  _loc7_.dander = _loc25_;
                  if(_loc7_.currentPet)
                  {
                     _loc7_.currentPet.MaxMP = _loc26_;
                     _loc7_.currentPet.MP = _loc27_;
                  }
                  _loc7_.soulPropCount = 0;
               }
               if(!_loc18_)
               {
                  _loc29_.die();
               }
               else
               {
                  _loc29_.onChange = false;
                  _loc29_.pos = new Point(_loc19_,_loc20_);
                  _loc29_.onChange = true;
               }
            }
            _loc11_++;
         }
      }
      
      override public function execute() : void
      {
         if(!this._changed)
         {
            this._map.lockOwner = -1;
            this._map.animateSet.lockLevel = AnimationLevel.LOW;
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
         var _loc1_:Living = null;
         for each(_loc1_ in GameManager.Instance.Current.livings)
         {
            _loc1_.lastBombIndex = -1;
         }
         if(this._info is TurnedLiving)
         {
            TurnedLiving(this._info).isAttacking = true;
         }
         this._info.isReady = false;
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
         var _loc4_:MovieClipWrapper = null;
         if(!this._info.isExist)
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
            _loc2_ = GameManager.Instance.Current.livings;
            for each(_loc3_ in GameManager.Instance.Current.livings)
            {
               _loc3_.beginNewTurn();
            }
            this._map.gameView.setCurrentPlayer(this._info);
            if(this._info.playerInfo && this._info.playerInfo.isSelf)
            {
               (this._map.getPhysical(this._info.LivingID) as GameLiving).needFocus(0,0,{"priority":3},true);
            }
            this._info.gemDefense = false;
            if(this._info.isLiving && this._info is LocalPlayer && !param1)
            {
               KeyboardManager.getInstance().reset();
               SoundManager.instance.play("016");
               _loc4_ = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.TurnAsset")),true,true);
               _loc4_.repeat = false;
               _loc4_.movie.mouseChildren = _loc4_.movie.mouseEnabled = false;
               _loc4_.movie.x = 440;
               _loc4_.movie.y = 180;
               this._map.gameView.addChild(_loc4_.movie);
            }
            else
            {
               SoundManager.instance.play("038");
               this.changePlayer();
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
