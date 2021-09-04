package game.view.buff
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightBuffInfo;
   import flash.display.Sprite;
   
   public class FightBuffBar extends Sprite implements Disposeable
   {
       
      
      private var _buffCells:Vector.<BuffCell>;
      
      public function FightBuffBar()
      {
         this._buffCells = new Vector.<BuffCell>();
         super();
         mouseChildren = mouseEnabled = false;
      }
      
      private function clearBuff() : void
      {
         var _loc1_:BuffCell = null;
         for each(_loc1_ in this._buffCells)
         {
            _loc1_.clearSelf();
         }
      }
      
      private function drawBuff() : void
      {
      }
      
      public function update(param1:Vector.<FightBuffInfo>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:BuffCell = null;
         this.clearBuff();
         var _loc2_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].id == 72)
            {
               param1.splice(_loc3_,1);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc3_ + 1 > this._buffCells.length)
            {
               _loc4_ = new BuffCell();
               this._buffCells.push(_loc4_);
            }
            else
            {
               _loc4_ = this._buffCells[_loc3_];
            }
            _loc4_.setInfo(param1[_loc3_]);
            _loc4_.x = (_loc3_ & 3) * 24;
            _loc4_.y = -(_loc3_ >> 2) * 24;
            addChild(_loc4_);
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:BuffCell = this._buffCells.shift();
         while(_loc1_)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._buffCells.shift();
         }
         this._buffCells = null;
      }
   }
}
