package ddt.data.player
{
   public class LikeFriendInfo extends BasePlayer
   {
       
      
      public var isSelected:Boolean;
      
      public function LikeFriendInfo()
      {
         super();
      }
      
      public function set typeVIP(param1:int) : void
      {
         VIPtype = param1;
      }
   }
}
