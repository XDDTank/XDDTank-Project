package game.view.buff
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import game.model.Living;
   
   public class SelfBuffBar extends Sprite implements Disposeable
   {
       
      
      private var _buffCells:Vector.<BuffCell>;
      
      private var _living:Living;
      
      private var _container:DisplayObjectContainer;
      
      public function SelfBuffBar(param1:DisplayObjectContainer)
      {
         this._buffCells = new Vector.<BuffCell>();
         super();
         this._container = param1;
      }
      
      public function dispose() : void
      {
         if(this._living)
         {
            this._living.removeEventListener(LivingEvent.BUFF_CHANGED,this.__updateCell);
         }
         var _loc1_:BuffCell = this._buffCells.shift();
         while(_loc1_)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._buffCells.shift();
         }
         this._buffCells = null;
      }
      
      private function __updateCell(param1:LivingEvent) : void
      {
         var _loc4_:BuffCell = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.clearBuff();
         var _loc2_:int = this._living == null ? int(0) : int(this._living.localBuffs.length);
         var _loc3_:int = this._living == null ? int(0) : int(this._living.petBuffs.length);
         if(_loc2_ + _loc3_ > 0 && this._buffCells)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               if(_loc5_ + 1 > this._buffCells.length)
               {
                  _loc4_ = new BuffCell(null,null,false,true);
                  this._buffCells.push(_loc4_);
               }
               else
               {
                  _loc4_ = this._buffCells[_loc5_];
               }
               _loc4_.x = _loc5_ % 10 * 36 + 8;
               _loc4_.y = -Math.floor(_loc5_ / 10) * 36 + 6;
               _loc4_.setInfo(this._living.localBuffs[_loc5_]);
               addChild(_loc4_);
               if(this._living.localBuffs[_loc5_].type != 3)
               {
                  _loc4_.width = _loc4_.height = 32;
               }
               _loc5_++;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc3_)
            {
               if(_loc6_ + 1 + _loc2_ > this._buffCells.length)
               {
                  _loc4_ = new BuffCell(null,null,false,true);
                  this._buffCells.push(_loc4_);
               }
               else
               {
                  _loc4_ = this._buffCells[_loc6_ + _loc2_];
               }
               if(_loc2_ > 0)
               {
                  _loc4_.x = (_loc6_ + _loc2_ > 3 ? _loc6_ + _loc2_ : _loc6_ + 3) % 10 * 36 + 15;
               }
               else
               {
                  _loc4_.x = (_loc6_ + _loc2_) % 10 * 36;
               }
               _loc4_.y = -Math.floor((_loc6_ + _loc2_) / 10) * 36 + 6;
               _loc4_.setInfo(this._living.petBuffs[_loc6_]);
               addChild(_loc4_);
               _loc6_++;
            }
            if(parent == null)
            {
               this._container.addChild(this);
            }
         }
         else if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function drawBuff(param1:Living) : void
      {
         if(this._living)
         {
            this._living.removeEventListener(LivingEvent.BUFF_CHANGED,this.__updateCell);
         }
         this._living = param1;
         if(this._living)
         {
            this._living.addEventListener(LivingEvent.BUFF_CHANGED,this.__updateCell);
         }
         this.__updateCell(null);
      }
      
      public function get right() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._living == null || this._living.localBuffs.length == 0)
         {
            _loc1_ = this._living == null ? int(0) : int(this._living.petBuffs.length);
            _loc2_ = _loc1_ > 8 ? int(8) : int(_loc1_);
            return x + _loc2_ * 44 + 40;
         }
         _loc3_ = this._living == null ? int(0) : int(this._living.localBuffs.length);
         _loc4_ = this._living == null ? int(0) : int(this._living.petBuffs.length);
         _loc5_ = _loc3_ + _loc4_ > 8 ? int(8) : int(_loc3_ + _loc4_);
         return x + _loc5_ * 44 + 40;
      }
      
      private function clearBuff() : void
      {
         var _loc1_:BuffCell = null;
         for each(_loc1_ in this._buffCells)
         {
            _loc1_.dispose();
         }
         this._buffCells = new Vector.<BuffCell>();
      }
   }
}
