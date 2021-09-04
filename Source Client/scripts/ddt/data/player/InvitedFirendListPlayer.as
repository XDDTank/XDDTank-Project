package ddt.data.player
{
   public class InvitedFirendListPlayer extends FriendListPlayer
   {
       
      
      public var awardStep:int;
      
      public var UserID:Number;
      
      public function InvitedFirendListPlayer()
      {
         super();
         canBeRemoved = false;
      }
      
      override public function get ID() : Number
      {
         return this.UserID;
      }
   }
}
