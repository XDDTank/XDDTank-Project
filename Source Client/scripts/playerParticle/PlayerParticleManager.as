package playerParticle
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.GameModeType;
   import game.objects.GamePlayer;
   import vip.VipController;
   
   public class PlayerParticleManager extends EventDispatcher
   {
      
      public static var SHOW_NUM:int = 5;
      
      private static var _instance:PlayerParticleManager;
       
      
      private var _model:PlayerParticleModel;
      
      private var _start:Array;
      
      private var _particlePoolVec:Vector.<PlayerParticlePool>;
      
      private var _IDArr:Array;
      
      private var _alphaArr:Array;
      
      private var _tempCount:int = 0;
      
      private var _pos1:Point;
      
      private var _pos2:Point;
      
      public function PlayerParticleManager()
      {
         super();
         this._model = new PlayerParticleModel();
         this._particlePoolVec = new Vector.<PlayerParticlePool>();
         this._IDArr = new Array();
         this._start = new Array();
         this._alphaArr = new Array();
         var _loc1_:int = 1;
         while(_loc1_ <= SHOW_NUM)
         {
            this._alphaArr.push(_loc1_ * 0.1);
            _loc1_++;
         }
         this._pos1 = ComponentFactory.Instance.creatCustomObject("plaerparticleManager.point1");
         this._pos2 = ComponentFactory.Instance.creatCustomObject("plaerparticleManager.point2");
      }
      
      public static function get instance() : PlayerParticleManager
      {
         if(!_instance)
         {
            _instance = new PlayerParticleManager();
         }
         return _instance;
      }
      
      public function get model() : PlayerParticleModel
      {
         return this._model;
      }
      
      public function startParticle(param1:Function, param2:Function, param3:GamePlayer) : void
      {
         var _loc4_:GameInfo = GameManager.Instance.Current;
         var _loc5_:int = param3.Id;
         var _loc6_:int = 0;
         if(param3.player.playerInfo.IsVIP)
         {
            _loc6_ = param3.player.playerInfo.VIPLevel;
         }
         if(this._start[this.getNumByID(_loc5_)] || !VipController.instance.getPrivilegeByIndexAndLevel(8,_loc6_) || _loc4_.gameMode != GameModeType.SINGLE_DUNGOEN && _loc4_.gameMode != GameModeType.SIMPLE_DUNGOEN && _loc4_.gameMode != GameModeType.MULTI_DUNGEON)
         {
            return;
         }
         if(!this.checkID(_loc5_))
         {
            this._IDArr.push(_loc5_);
            this._particlePoolVec.push(new PlayerParticlePool());
            this._particlePoolVec[this.getNumByID(_loc5_)].creatPlayerParticle(param1,param2,SHOW_NUM);
            this.model.posArray.push(new Array());
            this._start.push(true);
         }
         this._start[this.getNumByID(_loc5_)] = true;
         this.model.posArray[this.getNumByID(_loc5_)] = new Array();
      }
      
      public function stopParticle(param1:GamePlayer) : void
      {
         this._start[this.getNumByID(param1.Id)] = false;
      }
      
      public function saveParticlePos(param1:Point, param2:int, param3:int) : void
      {
         if(!this._start[this.getNumByID(param3)])
         {
            return;
         }
         param1.x -= this._pos1.x;
         param1.y -= this._pos1.y;
         if(param2 == -1)
         {
            param1.x += this._pos2.x;
         }
         if(this._start[this.getNumByID(param3)])
         {
            ++this._tempCount;
            if(this._tempCount % 3 == 0)
            {
               this.model.posArray[this.getNumByID(param3)].push(param1);
               if(this.model.posArray[this.getNumByID(param3)].length > SHOW_NUM)
               {
                  this.model.posArray[this.getNumByID(param3)].shift();
               }
               this.model.direction = param2;
               this._tempCount = 0;
            }
         }
      }
      
      public function showParticle(param1:int) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         var _loc4_:PlayerParticle = null;
         if(!this.checkID(param1))
         {
            return;
         }
         if(this._particlePoolVec[this.getNumByID(param1)])
         {
            this._particlePoolVec[this.getNumByID(param1)].clear();
         }
         var _loc5_:int = this.model.posArray[this.getNumByID(param1)].length - 1;
         while(_loc5_ >= 0)
         {
            _loc2_ = this.model.posArray[this.getNumByID(param1)][_loc5_];
            _loc3_ = this._alphaArr[_loc5_];
            _loc4_ = this._particlePoolVec[this.getNumByID(param1)].checkOut();
            _loc4_.direction = this.model.direction;
            _loc4_.x = _loc2_.x - _loc4_.player.x;
            _loc4_.y = _loc2_.y - _loc4_.player.y;
            _loc4_.visible = true;
            _loc4_.alpha = _loc3_;
            _loc5_--;
         }
         if(!this._start[this.getNumByID(param1)])
         {
            if(this.model.posArray[this.getNumByID(param1)].length > 0)
            {
               this.model.posArray[this.getNumByID(param1)].shift();
            }
         }
      }
      
      public function checkID(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         for each(_loc2_ in this._IDArr)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getNumByID(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._IDArr.length)
         {
            if(param1 == this._IDArr[_loc2_])
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function dispose() : void
      {
         var _loc1_:PlayerParticlePool = null;
         this.model.reset();
         for each(_loc1_ in this._particlePoolVec)
         {
            _loc1_.dispose();
            _loc1_ = null;
         }
         this._start = new Array();
         this._IDArr = new Array();
         this._particlePoolVec = new Vector.<PlayerParticlePool>();
      }
   }
}
