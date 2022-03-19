// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.player.InvitedFirendListPlayer

package ddt.data.player
{
    public class InvitedFirendListPlayer extends FriendListPlayer 
    {

        public var awardStep:int;
        public var UserID:Number;

        public function InvitedFirendListPlayer()
        {
            canBeRemoved = false;
        }

        override public function get ID():Number
        {
            return (this.UserID);
        }


    }
}//package ddt.data.player

