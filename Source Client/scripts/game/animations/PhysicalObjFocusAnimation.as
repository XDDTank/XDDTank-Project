package game.animations
{
   import game.objects.SimpleBomb;
   import phy.object.PhysicalObj;
   
   public class PhysicalObjFocusAnimation extends BaseSetCenterAnimation
   {
       
      
      private var _phy:PhysicalObj;
      
      public function PhysicalObjFocusAnimation(param1:PhysicalObj, param2:int = 100, param3:int = 0, param4:int = 1, param5:int = -1)
      {
         super(param1.x,param1.y + param3,param2,false,param4,param5);
         this._phy = param1;
      }
      
      override public function canReplace(param1:IAnimate) : Boolean
      {
         var _loc2_:PhysicalObjFocusAnimation = param1 as PhysicalObjFocusAnimation;
         if(_loc2_ && _loc2_._phy != this._phy)
         {
            if(this._phy is SimpleBomb && _loc2_._phy is SimpleBomb)
            {
               if(!this._phy.isLiving || SimpleBomb(this._phy).info.Id > SimpleBomb(_loc2_._phy).info.Id)
               {
                  return true;
               }
               return false;
            }
         }
         return true;
      }
   }
}
